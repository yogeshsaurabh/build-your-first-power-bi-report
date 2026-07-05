Param(
    [string] $AzureUserName,
    [string] $AzurePassword,
    [string] $AzureTenantID,
    [string] $AzureSubscriptionID,
    [string] $ODLID,
    [string] $InstallCloudLabsShadow,
    [string] $DeploymentID,
    [string] $vmAdminUsername,
    [string] $vmAdminPassword,
    [string] $trainerUserName,
    [string] $trainerUserPassword
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$logRoot = 'C:\WindowsAzure\Logs'
New-Item -ItemType Directory -Path $logRoot -Force | Out-Null
Start-Transcript -Path (Join-Path $logRoot 'CloudLabsCustomScriptExtension.txt') -Append

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $LabFilesRoot = 'C:\LabFiles'
    $LabRoot = Join-Path $LabFilesRoot 'PowerBI-Retail'
    $EvidenceRoot = Join-Path $LabRoot 'Evidence'
    $CommonUri = 'https://experienceazure.blob.core.windows.net/templates/cloudlabs-common'

    function Write-Log {
        param([string]$Message)
        Write-Host "[$((Get-Date).ToString('s'))] $Message"
    }

    function Invoke-DownloadFile {
        param(
            [Parameter(Mandatory = $true)][string]$Uri,
            [Parameter(Mandatory = $true)][string]$OutFile
        )
        $parent = Split-Path -Path $OutFile -Parent
        if ($parent) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        Write-Log "Downloading $Uri to $OutFile"
        Invoke-WebRequest -Uri $Uri -OutFile $OutFile -UseBasicParsing
        if (-not (Test-Path $OutFile) -or ((Get-Item $OutFile).Length -le 0)) {
            throw "Downloaded file $OutFile is missing or empty."
        }
    }

    function Update-TokenizedFile {
        param(
            [Parameter(Mandatory = $true)][string]$Path,
            [Parameter(Mandatory = $true)][hashtable]$Tokens
        )
        if (-not (Test-Path $Path)) { return }
        $content = Get-Content -Path $Path -Raw
        foreach ($key in $Tokens.Keys) {
            $value = [string]$Tokens[$key]
            $patterns = @(
                "<$key>",
                "{$key}",
                "[$key]",
                "__$key__",
                "##$key##",
                "`$$key",
                "$key`Value"
            )
            foreach ($pattern in $patterns) {
                $content = $content.Replace($pattern, $value)
            }
        }
        Set-Content -Path $Path -Value $content -Encoding UTF8
    }

    function CreateCredFile {
        Write-Log 'Creating CloudLabs credential helper files.'
        New-Item -ItemType Directory -Path $LabFilesRoot -Force | Out-Null
        $publicDesktop = 'C:\Users\Public\Desktop'
        New-Item -ItemType Directory -Path $publicDesktop -Force | Out-Null

        $downloadTargets = @(
            @{ Name = 'AzureCreds.txt'; Destination = (Join-Path $LabFilesRoot 'AzureCreds.txt') },
            @{ Name = 'AzureCreds.ps1'; Destination = (Join-Path $LabFilesRoot 'AzureCreds.ps1') }
        )

        foreach ($target in $downloadTargets) {
            $uri = "$CommonUri/$($target.Name)"
            try {
                Invoke-DownloadFile -Uri $uri -OutFile $target.Destination
            }
            catch {
                Write-Log "Unable to download $($target.Name) from CloudLabs common storage. Creating local fallback. Error: $($_.Exception.Message)"
                if ($target.Name -eq 'AzureCreds.txt') {
                    @"
Azure Credentials
=================
Azure user name: <AzureUserName>
Azure password: <AzurePassword>
Tenant ID: <AzureTenantID>
Subscription ID: <AzureSubscriptionID>
Deployment ID: <DeploymentID>
ODL ID: <ODLID>

This lab primarily uses local CSV files and Power BI Desktop. Azure credentials are provided for CloudLabs access if needed.
"@ | Set-Content -Path $target.Destination -Encoding UTF8
                }
                else {
                    @"
`$AzureUserName = '<AzureUserName>'
`$AzurePassword = '<AzurePassword>'
`$AzureTenantID = '<AzureTenantID>'
`$AzureSubscriptionID = '<AzureSubscriptionID>'
`$DeploymentID = '<DeploymentID>'
`$ODLID = '<ODLID>'
"@ | Set-Content -Path $target.Destination -Encoding UTF8
                }
            }
        }

        $tokens = @{
            AzureUserName = $AzureUserName
            AzurePassword = $AzurePassword
            AzureTenantID = $AzureTenantID
            AzureSubscriptionID = $AzureSubscriptionID
            ODLID = $ODLID
            DeploymentID = $DeploymentID
            vmAdminUsername = $vmAdminUsername
            vmAdminPassword = $vmAdminPassword
            trainerUserName = $trainerUserName
            trainerUserPassword = $trainerUserPassword
        }

        foreach ($target in $downloadTargets) {
            Update-TokenizedFile -Path $target.Destination -Tokens $tokens
            Copy-Item -Path $target.Destination -Destination (Join-Path $publicDesktop $target.Name) -Force
        }
    }

    function Test-WebView2Installed {
        $paths = @(
            'C:\Program Files (x86)\Microsoft\EdgeWebView\Application\msedgewebview2.exe',
            'C:\Program Files\Microsoft\EdgeWebView\Application\msedgewebview2.exe'
        )
        foreach ($path in $paths) {
            if (Test-Path $path) { return $true }
        }
        return $false
    }

    function Install-WebView2Runtime {
        if (Test-WebView2Installed) {
            Write-Log 'Microsoft Edge WebView2 Runtime is already installed.'
            return
        }

        Write-Log 'Installing Microsoft Edge WebView2 Runtime, required by Power BI Desktop when not already present.'
        $installer = Join-Path $env:TEMP 'MicrosoftEdgeWebView2Setup.exe'
        Invoke-DownloadFile -Uri 'https://go.microsoft.com/fwlink/p/?LinkId=2124703' -OutFile $installer
        $process = Start-Process -FilePath $installer -ArgumentList '/silent /install' -Wait -PassThru
        Write-Log "WebView2 installer exit code: $($process.ExitCode)"
    }

    function Get-PowerBIExecutablePath {
        $candidatePaths = @(
            'C:\Program Files\Microsoft Power BI Desktop\bin\PBIDesktop.exe',
            'C:\Program Files (x86)\Microsoft Power BI Desktop\bin\PBIDesktop.exe'
        )
        foreach ($path in $candidatePaths) {
            if (Test-Path $path) { return $path }
        }

        $uninstallRoots = @(
            'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
            'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
        )
        foreach ($root in $uninstallRoots) {
            $items = Get-ItemProperty -Path $root -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like 'Microsoft Power BI Desktop*' }
            foreach ($item in $items) {
                if ($item.InstallLocation) {
                    $exe = Join-Path $item.InstallLocation 'bin\PBIDesktop.exe'
                    if (Test-Path $exe) { return $exe }
                }
            }
        }

        return $null
    }

    function Test-PowerBIDesktopInstalled {
        if (Get-PowerBIExecutablePath) { return $true }

        $startMenuShortcuts = @(
            'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Power BI Desktop.lnk',
            'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Power BI Desktop.lnk'
        )
        foreach ($shortcut in $startMenuShortcuts) {
            if (Test-Path $shortcut) { return $true }
        }

        $package = Get-AppxPackage -AllUsers -Name 'Microsoft.MicrosoftPowerBIDesktop' -ErrorAction SilentlyContinue
        return ($null -ne $package)
    }

    function Install-PowerBIDesktop {
        # Microsoft Learn documents two supported acquisition paths: Microsoft Store or the direct executable.
        # For unattended VM provisioning, use the x64 executable with documented silent install switches:
        # -quiet ACCEPT_EULA=1 INSTALLDESKTOPSHORTCUT=1 DISABLE_UPDATE_NOTIFICATION=1.
        if (Test-PowerBIDesktopInstalled) {
            Write-Log 'Power BI Desktop is already installed.'
            return
        }

        Install-WebView2Runtime

        $installer = Join-Path $env:TEMP 'PBIDesktopSetup_x64.exe'
        $installerUrls = @(
            'https://aka.ms/pbiSingleInstaller',
            'https://download.microsoft.com/download/9/8/4/984e4a5d-0e2d-4d03-8f94-8b99302f4b69/PBIDesktopSetup_x64.exe'
        )

        $downloaded = $false
        foreach ($url in $installerUrls) {
            try {
                Invoke-DownloadFile -Uri $url -OutFile $installer
                $downloaded = $true
                break
            }
            catch {
                Write-Log "Power BI Desktop download attempt failed from $url. Error: $($_.Exception.Message)"
            }
        }

        if ($downloaded) {
            $installLog = Join-Path $logRoot 'PBIDesktopSetup.log'
            $arguments = @(
                '-quiet',
                'ACCEPT_EULA=1',
                'INSTALLDESKTOPSHORTCUT=1',
                'DISABLE_UPDATE_NOTIFICATION=1',
                '-norestart',
                "-log `"$installLog`""
            )
            Write-Log 'Installing Power BI Desktop using the Microsoft executable installer.'
            $process = Start-Process -FilePath $installer -ArgumentList $arguments -Wait -PassThru
            Write-Log "Power BI Desktop installer exit code: $($process.ExitCode)"
        }

        if (-not (Test-PowerBIDesktopInstalled)) {
            Write-Log 'Power BI Desktop was not detected after direct installer attempt. Trying winget Microsoft Store/package source if available.'
            $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
            if ($winget) {
                $wingetArgs = @('install', '--id', 'Microsoft.PowerBI.Desktop', '--exact', '--silent', '--accept-package-agreements', '--accept-source-agreements')
                $process = Start-Process -FilePath $winget.Source -ArgumentList $wingetArgs -Wait -PassThru
                Write-Log "winget Power BI Desktop install exit code: $($process.ExitCode)"
            }
        }

        if (-not (Test-PowerBIDesktopInstalled)) {
            throw 'Power BI Desktop installation could not be verified. Review C:\WindowsAzure\Logs\CloudLabsCustomScriptExtension.txt and PBIDesktopSetup.log.'
        }

        Write-Log 'Power BI Desktop installation verified.'
    }

    function New-LabDataset {
        Write-Log 'Creating Power BI retail lab folders and CSV data files.'
        New-Item -ItemType Directory -Path $LabRoot -Force | Out-Null
        New-Item -ItemType Directory -Path $EvidenceRoot -Force | Out-Null

        $stores = @(
            [pscustomobject]@{ StoreID='STR001'; StoreName='Contoso Downtown'; Region='North'; City='Seattle'; State='WA'; Country='USA'; Latitude=47.6062; Longitude=-122.3321; StoreType='Urban'; OpenDate='2020-01-15' },
            [pscustomobject]@{ StoreID='STR002'; StoreName='Contoso Lakeside'; Region='north'; City='Chicago'; State='IL'; Country='USA'; Latitude=41.8781; Longitude=-87.6298; StoreType='Mall'; OpenDate='2019-05-03' },
            [pscustomobject]@{ StoreID='STR003'; StoreName='Contoso Midtown'; Region='East'; City='New York'; State='NY'; Country='USA'; Latitude=40.7128; Longitude=-74.0060; StoreType='Urban'; OpenDate='2018-08-21' },
            [pscustomobject]@{ StoreID='STR004'; StoreName='Contoso Harbor'; Region='East'; City='Boston'; State='MA'; Country='USA'; Latitude=42.3601; Longitude=-71.0589; StoreType='Urban'; OpenDate='2021-03-12' },
            [pscustomobject]@{ StoreID='STR005'; StoreName='Contoso Plaza'; Region='South'; City='Austin'; State='TX'; Country='USA'; Latitude=30.2672; Longitude=-97.7431; StoreType='Mall'; OpenDate='2020-11-02' },
            [pscustomobject]@{ StoreID='STR006'; StoreName='Contoso Gateway'; Region='South'; City='Atlanta'; State='GA'; Country='USA'; Latitude=33.7490; Longitude=-84.3880; StoreType='Suburban'; OpenDate='2019-09-18' },
            [pscustomobject]@{ StoreID='STR007'; StoreName='Contoso Sunset'; Region='West'; City='Los Angeles'; State='CA'; Country='USA'; Latitude=34.0522; Longitude=-118.2437; StoreType='Urban'; OpenDate='2017-06-30' },
            [pscustomobject]@{ StoreID='STR008'; StoreName='Contoso Bay'; Region='West'; City='San Francisco'; State='CA'; Country='USA'; Latitude=37.7749; Longitude=-122.4194; StoreType='Flagship'; OpenDate='2016-02-14' }
        )

        $products = @(
            [pscustomobject]@{ ProductID='PRD001'; ProductName='Trail Backpack'; Category='Outdoor'; Subcategory='Bags'; Brand='Northwind'; UnitPrice=64.99 },
            [pscustomobject]@{ ProductID='PRD002'; ProductName='Insulated Bottle'; Category='Outdoor'; Subcategory='Drinkware'; Brand='Fabrikam'; UnitPrice=24.99 },
            [pscustomobject]@{ ProductID='PRD003'; ProductName='Running Shoes'; Category='Footwear'; Subcategory='Athletic'; Brand='AdventureWorks'; UnitPrice=89.99 },
            [pscustomobject]@{ ProductID='PRD004'; ProductName='Casual Sneakers'; Category='Footwear'; Subcategory='Casual'; Brand='Contoso'; UnitPrice=54.99 },
            [pscustomobject]@{ ProductID='PRD005'; ProductName='Coffee Maker'; Category='Home & Kitchen'; Subcategory='Appliances'; Brand='Litware'; UnitPrice=79.99 },
            [pscustomobject]@{ ProductID='PRD006'; ProductName='Ceramic Dinner Set'; Category='Home and Kitchen'; Subcategory='Dining'; Brand='Proseware'; UnitPrice=49.99 },
            [pscustomobject]@{ ProductID='PRD007'; ProductName='Bluetooth Speaker'; Category='Electronics'; Subcategory='Audio'; Brand='Contoso'; UnitPrice=39.99 },
            [pscustomobject]@{ ProductID='PRD008'; ProductName='Fitness Watch'; Category='Electronics'; Subcategory='Wearables'; Brand='AdventureWorks'; UnitPrice=119.99 },
            [pscustomobject]@{ ProductID='PRD009'; ProductName='Yoga Mat'; Category='Fitness'; Subcategory='Training'; Brand='Northwind'; UnitPrice=29.99 },
            [pscustomobject]@{ ProductID='PRD010'; ProductName='Resistance Bands'; Category='Fitness'; Subcategory='Training'; Brand='Fabrikam'; UnitPrice=17.99 }
        )

        $startDate = Get-Date '2025-01-01'
        $endDate = Get-Date '2025-06-30'
        $dates = for ($date = $startDate; $date -le $endDate; $date = $date.AddDays(1)) {
            [pscustomobject]@{
                Date = $date.ToString('yyyy-MM-dd')
                Year = $date.Year
                Quarter = 'Q' + [math]::Ceiling($date.Month / 3)
                MonthNumber = $date.Month
                MonthName = $date.ToString('MMMM')
                MonthYear = $date.ToString('MMM yyyy')
                Weekday = $date.DayOfWeek.ToString()
                IsWeekend = ($date.DayOfWeek -in @([DayOfWeek]::Saturday, [DayOfWeek]::Sunday))
            }
        }

        $sales = New-Object System.Collections.Generic.List[object]
        for ($i = 1; $i -le 240; $i++) {
            $store = $stores[($i * 5) % $stores.Count]
            $product = $products[($i * 7) % $products.Count]
            $saleDate = $startDate.AddDays(($i * 3) % (($endDate - $startDate).Days + 1))
            $quantity = (($i * 2) % 9) + 1
            $basePrice = [decimal]$product.UnitPrice
            $seasonalAdjustment = if ($saleDate.Month -in @(5,6)) { 1.05 } elseif ($saleDate.Month -eq 2) { 0.97 } else { 1.00 }
            $unitPrice = [math]::Round(($basePrice * $seasonalAdjustment), 2)
            $discount = if (($i % 11) -eq 0) { 0.15 } elseif (($i % 7) -eq 0) { 0.10 } elseif (($i % 5) -eq 0) { 0.05 } else { 0.00 }
            $channel = if (($i % 4) -eq 0) { 'Online Pickup' } elseif (($i % 3) -eq 0) { 'Curbside' } else { 'In Store' }
            $segment = if (($i % 6) -eq 0) { 'Loyalty' } elseif (($i % 4) -eq 0) { 'Small Business' } else { 'Consumer' }
            $sales.Add([pscustomobject]@{
                SalesID = ('S{0:00000}' -f $i)
                Date = $saleDate.ToString('yyyy-MM-dd')
                StoreID = $store.StoreID
                ProductID = $product.ProductID
                Quantity = $quantity
                UnitPrice = $unitPrice
                DiscountPct = $discount
                Channel = $channel
                TransactionType = 'Sale'
                CustomerSegment = $segment
            })
        }

        $storesPath = Join-Path $LabRoot 'Stores.csv'
        $productsPath = Join-Path $LabRoot 'Products.csv'
        $datesPath = Join-Path $LabRoot 'Dates.csv'
        $salesPath = Join-Path $LabRoot 'Sales.csv'

        $stores | Export-Csv -Path $storesPath -NoTypeInformation -Encoding UTF8
        $products | Export-Csv -Path $productsPath -NoTypeInformation -Encoding UTF8
        $dates | Export-Csv -Path $datesPath -NoTypeInformation -Encoding UTF8
        $sales | Export-Csv -Path $salesPath -NoTypeInformation -Encoding UTF8

        # Add a blank row and one intentionally bad row for beginner Power Query cleanup practice.
        Add-Content -Path $salesPath -Value ',,,,,,,,,' -Encoding UTF8
        Add-Content -Path $salesPath -Value 'ERRORROW,not-a-date,STR999,PRD999,abc,not-price,0.00,In Store,Sale,Consumer' -Encoding UTF8

        @"
Power BI Retail Lab Dataset
===========================

Working folder: $LabRoot
Evidence folder: $EvidenceRoot

CSV files to load in Power BI Desktop:
- Sales.csv: fact table with SalesID, Date, StoreID, ProductID, Quantity, UnitPrice, DiscountPct, Channel, TransactionType, and CustomerSegment.
- Stores.csv: store dimension with StoreID, StoreName, Region, City, State, Country, Latitude, Longitude, StoreType, and OpenDate.
- Products.csv: product dimension with ProductID, ProductName, Category, Subcategory, Brand, and UnitPrice.
- Dates.csv: calendar dimension with Date, Year, Quarter, MonthNumber, MonthName, MonthYear, Weekday, and IsWeekend.

Suggested relationships:
- Sales[StoreID] to Stores[StoreID]
- Sales[ProductID] to Products[ProductID]
- Sales[Date] to Dates[Date]

Cleanup hints:
- Set Date and OpenDate fields to Date.
- Set Quantity to whole number and UnitPrice/DiscountPct to decimal number.
- Remove the blank row and error row in Sales.csv after Power Query detects conversion errors.
- Standardize values such as Stores[Region] = north and Products[Category] = Home and Kitchen.
- Consider adding a helper column for sales amount from Quantity, UnitPrice, and DiscountPct.

Evidence checklist for validation:
- Save your final PBIX file as: $EvidenceRoot\StorePerformanceReport.pbix
- Export or save a report image/PDF as: StorePerformanceReport.png, StorePerformanceReport.jpg, or StorePerformanceReport.pdf in the Evidence folder.
- Copy your DAX measure definitions into: $EvidenceRoot\DAXMeasures.txt
"@ | Set-Content -Path (Join-Path $LabRoot 'README.txt') -Encoding UTF8

        @"
DAX measure evidence instructions
=================================

Do not use this file for validation. When you finish Exercise 3, create a new file named DAXMeasures.txt in the Evidence folder and paste the measures you created.

Required measure names for the validation include:
- Total Sales
- % of Total Sales

Your formulas should use beginner DAX patterns such as SUM for total values and DIVIDE for percentages.
"@ | Set-Content -Path (Join-Path $EvidenceRoot 'README-Evidence.txt') -Encoding UTF8
    }

    function New-Shortcut {
        param(
            [Parameter(Mandatory = $true)][string]$ShortcutPath,
            [Parameter(Mandatory = $true)][string]$TargetPath,
            [string]$Arguments = '',
            [string]$WorkingDirectory = '',
            [string]$Description = '',
            [string]$IconLocation = ''
        )
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($ShortcutPath)
        $shortcut.TargetPath = $TargetPath
        if ($Arguments) { $shortcut.Arguments = $Arguments }
        if ($WorkingDirectory) { $shortcut.WorkingDirectory = $WorkingDirectory }
        if ($Description) { $shortcut.Description = $Description }
        if ($IconLocation) { $shortcut.IconLocation = $IconLocation }
        $shortcut.Save()
    }

    function New-LabShortcuts {
        Write-Log 'Creating desktop shortcuts for the lab.'
        $publicDesktop = 'C:\Users\Public\Desktop'
        New-Item -ItemType Directory -Path $publicDesktop -Force | Out-Null

        New-Shortcut `
            -ShortcutPath (Join-Path $publicDesktop 'Power BI Retail Lab Files.lnk') `
            -TargetPath 'C:\Windows\explorer.exe' `
            -Arguments "`"$LabRoot`"" `
            -WorkingDirectory $LabRoot `
            -Description 'Open the Power BI Retail lab dataset and Evidence folder.' `
            -IconLocation 'C:\Windows\System32\shell32.dll,3'

        New-Shortcut `
            -ShortcutPath (Join-Path $publicDesktop 'Evidence Folder.lnk') `
            -TargetPath 'C:\Windows\explorer.exe' `
            -Arguments "`"$EvidenceRoot`"" `
            -WorkingDirectory $EvidenceRoot `
            -Description 'Open the Evidence folder for PBIX, DAX, and report export files.' `
            -IconLocation 'C:\Windows\System32\shell32.dll,4'

        $powerBiExe = Get-PowerBIExecutablePath
        if ($powerBiExe) {
            New-Shortcut `
                -ShortcutPath (Join-Path $publicDesktop 'Power BI Desktop.lnk') `
                -TargetPath $powerBiExe `
                -WorkingDirectory (Split-Path $powerBiExe -Parent) `
                -Description 'Launch Power BI Desktop.' `
                -IconLocation $powerBiExe
        }
    }

    function Write-SetupSummary {
        $powerBiExe = Get-PowerBIExecutablePath
        $summaryPath = Join-Path $LabRoot 'SetupSummary.txt'
        @"
CloudLabs setup completed: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Deployment ID: $DeploymentID
ODL ID: $ODLID

Power BI Desktop detected: $(Test-PowerBIDesktopInstalled)
Power BI Desktop path: $powerBiExe
WebView2 detected: $(Test-WebView2Installed)

Lab files:
- $LabRoot\Sales.csv
- $LabRoot\Stores.csv
- $LabRoot\Products.csv
- $LabRoot\Dates.csv
- $EvidenceRoot\

Power BI Desktop installation method follows Microsoft Learn guidance for the direct executable installer and documented command-line options, including silent install and ACCEPT_EULA=1.
"@ | Set-Content -Path $summaryPath -Encoding UTF8
    }

    Write-Log 'Starting Stage 1 bootstrap for Power BI beginner workstation.'
    CreateCredFile
    Install-PowerBIDesktop
    New-LabDataset
    New-LabShortcuts
    Write-SetupSummary
    Write-Log 'Stage 1 bootstrap completed successfully.'
}
catch {
    Write-Error "Stage 1 bootstrap failed: $($_.Exception.Message)"
    throw
}
finally {
    Stop-Transcript
}
