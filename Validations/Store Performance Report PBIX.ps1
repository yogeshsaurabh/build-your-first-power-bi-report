using namespace System.Net

# Note: $sub (subscription id) and $DID (deployment id) are injected by the platform.
$rg = "rg-powerbi-retail-$DID"
$count = 0
$found = $false

$filePath = "C:\LabFiles\PowerBI-Retail\Evidence\StorePerformanceReport.pbix"

$remoteCheckScript = @'
$path = 'C:\LabFiles\PowerBI-Retail\Evidence\StorePerformanceReport.pbix'
$result = [ordered]@{
    Found = $false
    Status = 'Failed'
    Detail = ''
    Path = $path
    Length = 0
    LastWriteTime = $null
    AgeHours = $null
}

try {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        $result.Detail = "PBIX file was not found at '$path'."
    }
    else {
        $file = Get-Item -LiteralPath $path -ErrorAction Stop
        $result.Length = [int64]$file.Length
        $result.LastWriteTime = $file.LastWriteTime.ToString('o')
        $result.AgeHours = [math]::Round(((Get-Date) - $file.LastWriteTime).TotalHours, 2)

        if ($file.Length -le 0) {
            $result.Detail = "PBIX file exists at '$path' but is empty."
        }
        elseif ($file.LastWriteTime -lt (Get-Date).AddDays(-7)) {
            $result.Detail = "PBIX file exists at '$path' and is non-empty, but its last saved time '$($file.LastWriteTime)' is older than 7 days."
        }
        else {
            $result.Found = $true
            $result.Status = 'Succeeded'
            $result.Detail = "PBIX file exists at '$path', is $($file.Length) bytes, and was last saved '$($file.LastWriteTime)'."
        }
    }
}
catch {
    $result.Detail = "Error while checking PBIX evidence file at '$path': $($_.Exception.Message)"
}

$result | ConvertTo-Json -Compress
'@

do {
    $count = $count + 1
    try {
        Set-AzContext -Subscription $sub -ErrorAction Stop

        $vm = Get-AzVM -ResourceGroupName $rg -ErrorAction Stop |
            Where-Object { $_.StorageProfile.OSDisk.OSType -eq 'Windows' } |
            Select-Object -First 1

        if (-not $vm) {
            $messageText = "No Windows lab VM was found in resource group '$rg' to inspect '$filePath'."
        }
        else {
            $runResult = Invoke-AzVMRunCommand -ResourceGroupName $rg -VMName $vm.Name -CommandId 'RunPowerShellScript' -ScriptString $remoteCheckScript -ErrorAction Stop
            $stdout = ($runResult.Value | Where-Object { $_.Code -like 'ComponentStatus/StdOut*' } | Select-Object -ExpandProperty Message -ErrorAction SilentlyContinue) -join "`n"

            if ([string]::IsNullOrWhiteSpace($stdout)) {
                $messageText = "Run command completed on VM '$($vm.Name)' in RG '$rg', but no validation output was returned for '$filePath'."
            }
            else {
                $jsonLine = ($stdout -split "`r?`n" | Where-Object { $_.Trim().StartsWith('{') -and $_.Trim().EndsWith('}') } | Select-Object -Last 1)
                if (-not $jsonLine) {
                    $messageText = "Run command output from VM '$($vm.Name)' in RG '$rg' did not contain parseable JSON. Output: $stdout"
                }
                else {
                    $remoteResult = $jsonLine | ConvertFrom-Json -ErrorAction Stop
                    if ($remoteResult.Found -eq $true) {
                        $found = $true
                        $messageText = "StorePerformanceReport.pbix validated on VM '$($vm.Name)' in RG '$rg'. Path '$($remoteResult.Path)' is $($remoteResult.Length) bytes and was last saved '$($remoteResult.LastWriteTime)' ($($remoteResult.AgeHours) hours ago)."
                    }
                    else {
                        $messageText = "StorePerformanceReport.pbix validation failed on VM '$($vm.Name)' in RG '$rg'. $($remoteResult.Detail)"
                    }
                }
            }
        }

        if ($found) {
            $message = @{
                Status  = "Succeeded"
                Message = $messageText
            } | ConvertTo-Json
            Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
                StatusCode = [HttpStatusCode]::OK
                Body       = $message
            })
        }
        else {
            $message = @{
                Status  = "Failed"
                Message = $messageText
            } | ConvertTo-Json
            Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
                StatusCode = [HttpStatusCode]::OK
                Body       = $message
            })
            if ($count -lt 3) {
                Start-Sleep -Seconds 10
            }
        }
    }
    catch {
        $message = @{
            Status  = "Failed"
            Message = "Error during PBIX evidence file check in RG '$rg'. Attempt $count of 3. Error: $($_.Exception.Message)"
        } | ConvertTo-Json
        Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode = [HttpStatusCode]::OK
            Body       = $message
        })
        Start-Sleep -Seconds 10
    }
} while ($count -lt 3 -and -not $found)

# Post-loop: if every attempt failed, emit a final failure JSON so CloudLabs
# always sees a structured result.
if (-not $found) {
    $message = @{
        Status  = "Failed"
        Message = "StorePerformanceReport.pbix was not validated at '$filePath' on the Windows lab VM in RG '$rg' after 3 attempts. Confirm the report was saved to the Evidence folder, is non-empty, and was saved within the last 7 days."
    } | ConvertTo-Json
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $message
    })
}
