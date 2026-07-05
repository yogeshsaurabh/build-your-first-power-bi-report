using namespace System.Net

# Note: $sub (subscription id) and $DID (deployment id) are injected by the platform.
$rg = "rg-powerbi-retail-$DID"
$count = 0
$found = $false
$lastFailure = "Report screenshot/export evidence was not validated."

$remoteScript = @'
$evidencePath = 'C:\LabFiles\PowerBI-Retail\Evidence'
$allowedExtensions = @('.png', '.jpg', '.jpeg', '.pdf')
$result = [ordered]@{
    Found    = $false
    Path     = $evidencePath
    FileName = ''
    Length   = 0
    Message  = ''
}

if (-not (Test-Path -LiteralPath $evidencePath -PathType Container)) {
    $result.Message = "Evidence folder '$evidencePath' was not found."
    $result | ConvertTo-Json -Compress
    exit 0
}

$file = Get-ChildItem -LiteralPath $evidencePath -File -ErrorAction SilentlyContinue |
    Where-Object {
        $_.BaseName -ieq 'StorePerformanceReport' -and
        ($allowedExtensions -contains $_.Extension.ToLowerInvariant()) -and
        $_.Length -gt 0
    } |
    Sort-Object -Property Length -Descending |
    Select-Object -First 1

if ($null -ne $file) {
    $result.Found = $true
    $result.FileName = $file.Name
    $result.Length = $file.Length
    $result.Message = "Found non-empty report screenshot/export '$($file.FullName)' with size $($file.Length) bytes."
}
else {
    $candidateFiles = Get-ChildItem -LiteralPath $evidencePath -File -ErrorAction SilentlyContinue |
        Where-Object {
            $_.BaseName -ieq 'StorePerformanceReport' -and
            ($allowedExtensions -contains $_.Extension.ToLowerInvariant())
        } |
        Select-Object -ExpandProperty Name

    if ($candidateFiles) {
        $result.Message = "Report screenshot/export exists but every matching StorePerformanceReport image/PDF file is empty. Matching files: $($candidateFiles -join ', ')."
    }
    else {
        $result.Message = "No non-empty StorePerformanceReport.png, .jpg, .jpeg, or .pdf file was found in '$evidencePath'."
    }
}

$result | ConvertTo-Json -Compress
'@

do {
    $count = $count + 1
    try {
        Set-AzContext -Subscription $sub -ErrorAction Stop

        $resourceGroup = Get-AzResourceGroup -Name $rg -ErrorAction SilentlyContinue
        if (-not $resourceGroup) {
            $resourceGroup = Get-AzResourceGroup -ErrorAction Stop |
                Where-Object { $_.ResourceGroupName -like "*$DID*" -and $_.ResourceGroupName -like "*powerbi*" } |
                Select-Object -First 1
            if ($resourceGroup) {
                $rg = $resourceGroup.ResourceGroupName
            }
        }

        if (-not $resourceGroup) {
            $lastFailure = "Resource group '$rg' was not found for deployment '$DID'."
        }
        else {
            $vm = Get-AzVM -ResourceGroupName $rg -ErrorAction Stop |
                Where-Object { $_.StorageProfile.OsDisk.OsType -eq 'Windows' } |
                Select-Object -First 1

            if (-not $vm) {
                $lastFailure = "No Windows Lab VM was found in resource group '$rg'."
            }
            else {
                $runCommandResult = Invoke-AzVMRunCommand -ResourceGroupName $rg -VMName $vm.Name -CommandId 'RunPowerShellScript' -ScriptString $remoteScript -ErrorAction Stop
                $rawOutput = ($runCommandResult.Value | ForEach-Object { $_.Message }) -join "`n"
                $jsonLine = ($rawOutput -split "`r?`n" | Where-Object { $_ -match '^\s*\{' } | Select-Object -Last 1)

                if (-not $jsonLine) {
                    $lastFailure = "Run Command completed on VM '$($vm.Name)' in RG '$rg', but no JSON validation output was returned. Raw output: $rawOutput"
                }
                else {
                    $check = $jsonLine | ConvertFrom-Json -ErrorAction Stop
                    if ($check.Found -eq $true -and [int64]$check.Length -gt 0) {
                        $found = $true
                        $message = @{
                            Status  = "Succeeded"
                            Message = "Report screenshot/export validation passed on VM '$($vm.Name)' in RG '$rg'. Found '$($check.FileName)' in 'C:\LabFiles\PowerBI-Retail\Evidence' with size $($check.Length) bytes."
                        } | ConvertTo-Json
                    }
                    else {
                        $lastFailure = "Report screenshot/export validation failed on VM '$($vm.Name)' in RG '$rg'. $($check.Message)"
                    }
                }
            }
        }

        if ($found) {
            Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
                StatusCode = [HttpStatusCode]::OK
                Body       = $message
            })
        }
        else {
            $message = @{
                Status  = "Failed"
                Message = $lastFailure
            } | ConvertTo-Json
            Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
                StatusCode = [HttpStatusCode]::OK
                Body       = $message
            })
            Start-Sleep -Seconds 10
        }
    }
    catch {
        $lastFailure = "Error during report screenshot/export check. Attempt $count of 3. Error: $($_.Exception.Message)"
        $message = @{
            Status  = "Failed"
            Message = $lastFailure
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
        Message = "Report screenshot/export evidence not found in RG '$rg' after 3 attempts. $lastFailure"
    } | ConvertTo-Json
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $message
    })
}
