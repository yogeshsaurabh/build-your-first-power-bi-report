using namespace System.Net

# Note: $sub (subscription id) and $DID (deployment id) are injected by the platform.
$rg = "rg-powerbi-retail-$DID"
$evidenceFile = "C:\LabFiles\PowerBI-Retail\Evidence\DAXMeasures.txt"
$count = 0
$found = $false
$lastDetail = "DAX measure text validation did not complete."

$validationScript = @'
$path = "C:\LabFiles\PowerBI-Retail\Evidence\DAXMeasures.txt"

$result = [ordered]@{
    Status       = "Failed"
    FilePath     = $path
    Exists       = $false
    SizeBytes    = 0
    LastWriteUtc = $null
    Missing      = @()
    Details      = ""
}

try {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        $result.Missing = @("DAXMeasures.txt file")
        $result.Details = "The required DAXMeasures.txt file was not found."
        $result | ConvertTo-Json -Depth 5
        exit 0
    }

    $item = Get-Item -LiteralPath $path -ErrorAction Stop
    $result.Exists = $true
    $result.SizeBytes = $item.Length
    $result.LastWriteUtc = $item.LastWriteTimeUtc.ToString("o")

    if ($item.Length -le 0) {
        $result.Missing = @("non-empty DAX measure definitions")
        $result.Details = "DAXMeasures.txt exists but is empty."
        $result | ConvertTo-Json -Depth 5
        exit 0
    }

    $content = Get-Content -LiteralPath $path -Raw -ErrorAction Stop
    $missing = New-Object System.Collections.Generic.List[string]

    if ($content -notmatch '(?im)^\s*(?:[A-Za-z0-9_'' ]+\s*)?(?:\[)?Total\s+Sales(?:\])?\s*=') {
        $missing.Add("Total Sales measure definition")
    }

    if ($content -notmatch '(?im)^\s*(?:[A-Za-z0-9_'' ]+\s*)?(?:\[)?%\s*of\s*Total\s*Sales(?:\])?\s*=') {
        $missing.Add("% of Total Sales measure definition")
    }

    if ($content -notmatch '(?i)\bSUM\s*\(') {
        $missing.Add("SUM function pattern")
    }

    if ($content -notmatch '(?i)\bDIVIDE\s*\(') {
        $missing.Add("DIVIDE function pattern")
    }

    if ($content -notmatch '(?i)\b(ALL|ALLEXCEPT|ALLSELECTED|ALLNOBLANKROW|REMOVEFILTERS)\s*\(') {
        $missing.Add("ALL/ALLEXCEPT/ALLSELECTED/REMOVEFILTERS total-context pattern")
    }

    if ($missing.Count -eq 0) {
        $result.Status = "Succeeded"
        $result.Details = "DAXMeasures.txt includes Total Sales, % of Total Sales, SUM, DIVIDE, and a recognized total-context pattern."
    }
    else {
        $result.Missing = $missing.ToArray()
        $result.Details = "DAXMeasures.txt is missing one or more required measure names or DAX patterns."
    }

    $result | ConvertTo-Json -Depth 5
}
catch {
    $result.Status = "Failed"
    $result.Details = "Error while checking DAXMeasures.txt on the VM: $($_.Exception.Message)"
    $result | ConvertTo-Json -Depth 5
}
'@

do {
    $count = $count + 1
    try {
        Set-AzContext -Subscription $sub -ErrorAction Stop

        $vm = Get-AzVM -ResourceGroupName $rg -ErrorAction Stop |
            Where-Object { $_.StorageProfile.OsDisk.OsType -eq "Windows" } |
            Select-Object -First 1

        if (-not $vm) {
            $lastDetail = "No Windows VM was found in resource group '$rg' on attempt $count of 3."
        }
        else {
            $runResult = Invoke-AzVMRunCommand -ResourceGroupName $rg -Name $vm.Name -CommandId "RunPowerShellScript" -ScriptString $validationScript -ErrorAction Stop
            $outputText = (($runResult.Value | ForEach-Object { $_.Message }) -join "`n").Trim()
            $jsonMatch = [regex]::Matches($outputText, '\{[\s\S]*\}') | Select-Object -Last 1

            if (-not $jsonMatch) {
                $lastDetail = "Validation command ran on VM '$($vm.Name)' in RG '$rg', but did not return structured JSON. Output: $outputText"
            }
            else {
                $remoteResult = $jsonMatch.Value | ConvertFrom-Json -ErrorAction Stop

                if ($remoteResult.Status -eq "Succeeded") {
                    $found = $true
                    $lastDetail = "DAXMeasures.txt found on VM '$($vm.Name)' at '$evidenceFile' with required measure names and DAX patterns. Size: $($remoteResult.SizeBytes) bytes. Last write UTC: $($remoteResult.LastWriteUtc)."
                }
                else {
                    $missingText = if ($remoteResult.Missing) { ($remoteResult.Missing -join ", ") } else { "required content" }
                    $lastDetail = "DAXMeasures.txt validation failed on VM '$($vm.Name)' at '$evidenceFile'. Missing: $missingText. Detail: $($remoteResult.Details)"
                }
            }
        }

        if ($found) {
            $message = @{
                Status  = "Succeeded"
                Message = $lastDetail
            } | ConvertTo-Json
        }
        else {
            $message = @{
                Status  = "Failed"
                Message = "$lastDetail Attempt $count of 3."
            } | ConvertTo-Json
        }

        Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode = [HttpStatusCode]::OK
            Body       = $message
        })

        if (-not $found -and $count -lt 3) {
            Start-Sleep -Seconds 10
        }
    }
    catch {
        $lastDetail = "Error during DAXMeasures.txt check in RG '$rg'. Attempt $count of 3. Error: $($_.Exception.Message)"
        $message = @{
            Status  = "Failed"
            Message = $lastDetail
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
        Message = "DAX measure text validation failed in RG '$rg' after 3 attempts. Last detail: $lastDetail"
    } | ConvertTo-Json
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $message
    })
}
