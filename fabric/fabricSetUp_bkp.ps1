function RefreshTokens()
{
    #Copy external blob content
    $global:powerbitoken = ((az account get-access-token --resource https://analysis.windows.net/powerbi/api) | ConvertFrom-Json).accessToken
    $global:synapseToken = ((az account get-access-token --resource https://dev.azuresynapse.net) | ConvertFrom-Json).accessToken
    $global:graphToken = ((az account get-access-token --resource https://graph.microsoft.com) | ConvertFrom-Json).accessToken
    $global:managementToken = ((az account get-access-token --resource https://management.azure.com) | ConvertFrom-Json).accessToken
    $global:purviewToken = ((az account get-access-token --resource https://purview.azure.net) | ConvertFrom-Json).accessToken
}

function Check-HttpRedirect($uri) {
    $httpReq = [system.net.HttpWebRequest]::Create($uri)
    $httpReq.Accept = "text/html, application/xhtml+xml, */*"
    $httpReq.method = "GET"   
    $httpReq.AllowAutoRedirect = $false;

    #use them all...
    #[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Ssl3 -bor [System.Net.SecurityProtocolType]::Tls;

    $global:httpCode = -1;

    $response = "";            

    try {
        $res = $httpReq.GetResponse();

        $statusCode = $res.StatusCode.ToString();
        $global:httpCode = [int]$res.StatusCode;
        $cookieC = $res.Cookies;
        $resHeaders = $res.Headers;  
        $global:rescontentLength = $res.ContentLength;
        $global:location = $null;
                            
        try {
            $global:location = $res.Headers["Location"].ToString();
            return $global:location;
        }
        catch {
        }

        return $null;

    }
    catch {
        $res2 = $_.Exception.InnerException.Response;
        $global:httpCode = $_.Exception.InnerException.HResult;
        $global:httperror = $_.exception.message;

        try {
            $global:location = $res2.Headers["Location"].ToString();
            return $global:location;
        }
        catch {
        }
    } 

    return $null;
}

function ReplaceTokensInFile($ht, $filePath) {
    $template = Get-Content -Raw -Path $filePath
    
    foreach ($paramName in $ht.Keys) {
        $template = $template.Replace($paramName, $ht[$paramName])
    }

    return $template;
}

az login

#for powershell...
Connect-AzAccount -DeviceCode

$starttime=get-date

$subs = Get-AzSubscription | Select-Object -ExpandProperty Name
if($subs.GetType().IsArray -and $subs.length -gt 1)
{
   $subOptions = [System.Collections.ArrayList]::new()
    for($subIdx=0; $subIdx -lt $subs.length; $subIdx++)
    {
        $opt = New-Object System.Management.Automation.Host.ChoiceDescription "$($subs[$subIdx])", "Selects the $($subs[$subIdx]) subscription."   
        $subOptions.Add($opt)
    }
    $selectedSubIdx = $host.ui.PromptForChoice('Enter the desired Azure Subscription for this lab','Copy and paste the name of the subscription to make your choice.', $subOptions.ToArray(),0)
    $selectedSubName = $subs[$selectedSubIdx]
    Write-Host "Selecting the subscription : $selectedSubName "
	$title    = 'Subscription selection'
	$question = 'Are you sure you want to select this subscription for this lab?'
	$choices  = '&Yes', '&No'
	$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
	if($decision -eq 0)
	{
    Select-AzSubscription -SubscriptionName $selectedSubName
    az account set --subscription $selectedSubName
	}
	else
	{
	$selectedSubIdx = $host.ui.PromptForChoice('Enter the desired Azure Subscription for this lab','Copy and paste the name of the subscription to make your choice.', $subOptions.ToArray(),0)
    $selectedSubName = $subs[$selectedSubIdx]
    Write-Host "Selecting the subscription : $selectedSubName "
	Select-AzSubscription -SubscriptionName $selectedSubName
    az account set --subscription $selectedSubName
	}
}

[string]$suffix =  -join ((48..57) + (97..122) | Get-Random -Count 7 | % {[char]$_})
$rgName = "fabric-dpoc-$suffix"
# $preferred_list = "australiaeast","centralus","southcentralus","eastus2","northeurope","southeastasia","uksouth","westeurope","westus","westus2"
# $locations = Get-AzLocation | Where-Object {
#     $_.Providers -contains "Microsoft.Synapse" -and
#     $_.Providers -contains "Microsoft.Sql" -and
#     $_.Providers -contains "Microsoft.Storage" -and
#     $_.Providers -contains "Microsoft.Compute" -and
#     $_.Location -in $preferred_list
# }
# $max_index = $locations.Count - 1
# $rand = (0..$max_index) | Get-Random
$Region = read-host "Enter the region for deployment"
$namespaces_adx_thermostat_occupancy_name = "adx-thermostat-occupancy-$suffix"
$sites_adx_thermostat_realtime_name = "app-realtime-kpi-analytics-$suffix"
$serverfarm_adx_thermostat_realtime_name = "asp-realtime-kpi-analytics-$suffix"
$subscriptionId = (Get-AzContext).Subscription.Id
$tenantId = (Get-AzContext).Tenant.Id
$storage_account_name = "storage$suffix"
$mssql_server_name = "mssql$suffix"
$mssql_database_name = "SalesDb"
$mssql_administrator_login = "labsqladmin"
$serverfarm_asp_fabric_name = "asp-fabric-$suffix"
$app_fabric_name = "app-fabric-$suffix"
$complexPassword = 0
$sql_administrator_login_password=""
while ($complexPassword -ne 1)
{
    $sql_administrator_login_password = Read-Host "Enter a password to use for the $mssql_administrator_login login.
    `The password must meet complexity requirements:
    ` - Minimum 8 characters. 
    ` - At least one upper case English letter [A-Z]
    ` - At least one lower case English letter [a-z]
    ` - At least one digit [0-9]
    ` - At least one special character (!,@,#,%,^,&,$)
    ` "

    if(($sql_administrator_login_password -cmatch '[a-z]') -and ($sql_administrator_login_password -cmatch '[A-Z]') -and ($sql_administrator_login_password -match '\d') -and ($sql_administrator_login_password.length -ge 8) -and ($sql_administrator_login_password -match '!|@|#|%|^|&|$'))
    {
        $complexPassword = 1
	  Write-Output "Password $sql_administrator_login_password accepted. Make sure you remember this!"
    }
    else
    {
        Write-Output "$sql_administrator_login_password does not meet the compexity requirements."
    }
}

$wsIdContosoSales =  Read-Host "Enter your 'contosoSales' PowerBI workspace Id "
$wsIdContosoFinance =  Read-Host "Enter your 'contosoFinance' PowerBI workspace Id "
RefreshTokens
$url = "https://api.powerbi.com/v1.0/myorg/groups/$wsIdContosoSales";
$contosoSalesWsName = Invoke-RestMethod -Uri $url -Method GET -Headers @{ Authorization="Bearer $powerbitoken" };
$contosoSalesWsName = $contosoSalesWsName.name
$url = "https://api.powerbi.com/v1.0/myorg/groups/$wsIdContosoFinance"
$contosoFinanceWsName = Invoke-RestMethod -Uri $url -Method GET -Headers @{ Authorization="Bearer $powerbitoken" };
$contosoFinanceWsName = $contosoFinanceWsName.name

$lakehouseBronze =  Read-Host "Enter your Bronze Lakehouse name "
$lakehouseSilver =  Read-Host "Enter your Silver Lakehouse name "
$lakehouseGold =  Read-Host "Enter your Gold Lakehouse name "
$lakehouseFinance= Read-Host "Enter your Finance Lakehouse name "
Add-Content log.txt "------Uploading assets to Lakehouses------"
Write-Host "------------Uploading assets to Lakehouses------------"
$tenantId = (Get-AzContext).Tenant.Id
azcopy login --tenant-id $tenantId

azcopy copy "https://fabricddib.blob.core.windows.net/bronzelakehousefiles/*" "https://onelake.blob.fabric.microsoft.com/$contosoSalesWsName/$lakehouseBronze.Lakehouse/Files/" --overwrite=prompt --from-to=BlobBlob --s2s-preserve-access-tier=false --check-length=true --include-directory-stub=false --s2s-preserve-blob-tags=false --recursive --trusted-microsoft-suffixes=onelake.blob.fabric.microsoft.com --log-level=INFO;
azcopy copy "https://fabricddib.blob.core.windows.net/silverlakehousetables/*" "https://onelake.blob.fabric.microsoft.com/$contosoSalesWsName/$lakehouseSilver.Lakehouse/Tables/" --overwrite=prompt --from-to=BlobBlob --s2s-preserve-access-tier=false --check-length=true --include-directory-stub=false --s2s-preserve-blob-tags=false --recursive --trusted-microsoft-suffixes=onelake.blob.fabric.microsoft.com --log-level=INFO;
azcopy copy "https://fabricddib.blob.core.windows.net/silverlakehousefiles/*" "https://onelake.blob.fabric.microsoft.com/$contosoSalesWsName/$lakehouseSilver.Lakehouse/Files/" --overwrite=prompt --from-to=BlobBlob --s2s-preserve-access-tier=false --check-length=true --include-directory-stub=false --s2s-preserve-blob-tags=false --recursive --trusted-microsoft-suffixes=onelake.blob.fabric.microsoft.com --log-level=INFO;
azcopy copy "https://fabricddib.blob.core.windows.net/financedata/*" "https://onelake.blob.fabric.microsoft.com/$contosoFinanceWsName/$lakehouseFinance.Lakehouse/Files/" --overwrite=prompt --from-to=BlobBlob --s2s-preserve-access-tier=false --check-length=true --include-directory-stub=false --s2s-preserve-blob-tags=false --recursive --trusted-microsoft-suffixes=onelake.blob.fabric.microsoft.com --log-level=INFO;

#azcopy copy "https://fabricddib.blob.core.windows.net/goldlakehousetables/*" "https://onelake.blob.fabric.microsoft.com/$contosoSalesWsName/$lakehouseGold.Lakehouse/Tables/" --overwrite=prompt --from-to=BlobBlob --s2s-preserve-access-tier=false --check-length=true --include-directory-stub=false --s2s-preserve-blob-tags=false --recursive --trusted-microsoft-suffixes=onelake.blob.fabric.microsoft.com --log-level=INFO;

Add-Content log.txt "------Uploading assets to Lakehouses COMPLETE------"
Write-Host "------------Uploading assets to Lakehouses COMPLETE------------"

# & $azCopyCommand copy "https://fabricddib.blob.core.windows.net/bronzelakehousefiles/*" "https://onelake.blob.fabric.microsoft.com/$contosoSalesWsName/$lakehouseBronze.Lakehouse/Files/" --overwrite=prompt --from-to=BlobBlob --s2s-preserve-access-tier=false --check-length=true --include-directory-stub=false --s2s-preserve-blob-tags=false --recursive --trusted-microsoft-suffixes=onelake.blob.fabric.microsoft.com --log-level=INFO;

RefreshTokens
Add-Content log.txt "------uploading powerbi reports------"
Write-Host "------------Uploading Powerbi Reports------------"
#Connect-PowerBIServiceAccount
$reportList = New-Object System.Collections.ArrayList
$reports=Get-ChildItem "./artifacts/reports" | Select BaseName 
foreach($name in $reports)
{
        $FilePath="./artifacts/reports/$($name.BaseName)"+".pbix"
        #New-PowerBIReport -Path $FilePath -Name $name -WorkspaceId $wsId
        
        write-host "Uploading PowerBI Report : $($name.BaseName)";
        $url = "https://api.powerbi.com/v1.0/myorg/groups/$wsIdContosoSales/imports?datasetDisplayName=$($name.BaseName)&nameConflict=CreateOrOverwrite";
		$fullyQualifiedPath=Resolve-Path -path $FilePath
        $fileBytes = [System.IO.File]::ReadAllBytes($fullyQualifiedPath);
        $fileEnc = [system.text.encoding]::GetEncoding("ISO-8859-1").GetString($fileBytes);
        $boundary = [System.Guid]::NewGuid().ToString();
        $LF = "`r`n";
        $bodyLines = (
            "--$boundary",
            "Content-Disposition: form-data",
            "",
            $fileEnc,
            "--$boundary--$LF"
        ) -join $LF

        $result = Invoke-RestMethod -Uri $url -Method POST -Body $bodyLines -ContentType "multipart/form-data; boundary=`"--$boundary`"" -Headers @{ Authorization="Bearer $powerbitoken" }
		Start-Sleep -s 5 
		
        Add-Content log.txt $result
        $reportId = $result.id;

        $temp = "" | select-object @{Name = "FileName"; Expression = {"$($name.BaseName)"}}, 
		@{Name = "Name"; Expression = {"$($name.BaseName)"}}, 
        @{Name = "PowerBIDataSetId"; Expression = {""}},
        @{Name = "ReportId"; Expression = {""}},
        @{Name = "SourceServer"; Expression = {""}}, 
        @{Name = "SourceDatabase"; Expression = {""}}
		                        
        # get dataset                         
        $url = "https://api.powerbi.com/v1.0/myorg/groups/$wsIdContosoSales/datasets";
        $dataSets = Invoke-RestMethod -Uri $url -Method GET -Headers @{ Authorization="Bearer $powerbitoken" };
		
        Add-Content log.txt $dataSets
        
        $temp.ReportId = $reportId;

        foreach($res in $dataSets.value)
        {
            if($res.name -eq $name.BaseName)
            {
                $temp.PowerBIDataSetId = $res.id;
            }
       }
                
      $list = $reportList.Add($temp)
}
Start-Sleep -s 10

Write-Host "Creating $rgName resource group in $Region ..."
New-AzResourceGroup -Name $rgName -Location $Region | Out-Null
Write-Host "Resource group $rgName creation COMPLETE"

Write-Host "Creating resources in $rgName..."
New-AzResourceGroupDeployment -ResourceGroupName $rgName `
  -TemplateFile "mainTemplate.json" `
  -Mode Complete `
  -location $Region `
  -sites_adx_thermostat_realtime_name $sites_adx_thermostat_realtime_name `
  -serverfarm_adx_thermostat_realtime_name $serverfarm_adx_thermostat_realtime_name `
  -namespaces_adx_thermostat_occupancy_name $namespaces_adx_thermostat_occupancy_name `
  -storage_account_name $storage_account_name `
  -mssql_server_name $mssql_server_name `
  -mssql_database_name $mssql_database_name `
  -mssql_administrator_login $mssql_administrator_login `
  -sql_administrator_login_password $sql_administrator_login_password `
  -serverfarm_asp_fabric_name $serverfarm_asp_fabric_name `
  -app_fabric_name $app_fabric_name `
  -Force

Write-Host "Resource creation $rgName COMPLETE"

$thermostat_telemetry_Realtime_URL =  ""
$occupancy_data_Realtime_URL =  ""

#download azcopy command
if ([System.Environment]::OSVersion.Platform -eq "Unix") {
    $azCopyLink = Check-HttpRedirect "https://aka.ms/downloadazcopy-v10-linux"

    if (!$azCopyLink) {
        $azCopyLink = "https://azcopyvnext.azureedge.net/release20200709/azcopy_linux_amd64_10.5.0.tar.gz"
    }

    Invoke-WebRequest $azCopyLink -OutFile "azCopy.tar.gz"
    tar -xf "azCopy.tar.gz"
    $azCopyCommand = (Get-ChildItem -Path ".\" -Recurse azcopy).Directory.FullName

    if ($azCopyCommand.count -gt 1) {
        $azCopyCommand = $azCopyCommand[0];
    }

    cd $azCopyCommand
    chmod +x azcopy
    cd ..
    $azCopyCommand += "\azcopy"
} else {
    $azCopyLink = Check-HttpRedirect "https://aka.ms/downloadazcopy-v10-windows"

    if (!$azCopyLink) {
        $azCopyLink = "https://azcopyvnext.azureedge.net/release20200501/azcopy_windows_amd64_10.4.3.zip"
    }

    Invoke-WebRequest $azCopyLink -OutFile "azCopy.zip"
    Expand-Archive "azCopy.zip" -DestinationPath ".\" -Force
    $azCopyCommand = (Get-ChildItem -Path ".\" -Recurse azcopy.exe).Directory.FullName

    if ($azCopyCommand.count -gt 1) {
        $azCopyCommand = $azCopyCommand[0];
    }

    $azCopyCommand += "\azcopy"
}

## storage AZ Copy
$storage_account_key = (Get-AzStorageAccountKey -ResourceGroupName $rgName -AccountName $storage_account_name)[0].Value
$dataLakeContext = New-AzStorageContext -StorageAccountName $storage_account_name -StorageAccountKey $storage_account_key

$destinationSasKey = New-AzStorageContainerSASToken -Container "bronzeshortcutdata" -Context $dataLakeContext -Permission rwdl
$destinationUri = "https://$($storage_account_name).blob.core.windows.net/bronzeshortcutdata$($destinationSasKey)"
& $azCopyCommand copy "https://fabricddib.blob.core.windows.net/bronzeshortcutdata/" $destinationUri --recursive

$destinationSasKey = New-AzStorageContainerSASToken -Container "data-source" -Context $dataLakeContext -Permission rwdl
$destinationUri = "https://$($storage_account_name).blob.core.windows.net/data-source$($destinationSasKey)"
& $azCopyCommand copy "https://fabricddib.blob.core.windows.net/data-source/" $destinationUri --recursive

$destinationSasKey = New-AzStorageContainerSASToken -Container "webappassets" -Context $dataLakeContext -Permission rwdl
$destinationUri = "https://$($storage_account_name).blob.core.windows.net/webappassets$($destinationSasKey)"
& $azCopyCommand copy "https://fabricddib.blob.core.windows.net/webappassets/" $destinationUri --recursive

## mssql
Add-Content log.txt "-----Ms Sql-----"
Write-Host "----Ms Sql----"
$SQLScriptsPath="./artifacts/sqlscripts"
$sqlQuery = Get-Content -Raw -Path "$($SQLScriptsPath)/salesSqlDbScript.sql"
$sqlEndpoint="$($mssql_server_name).database.windows.net"
$result=Invoke-SqlCmd -Query $sqlQuery -ServerInstance $sqlEndpoint -Database $mssql_database_name -Username $mssql_administrator_login -Password $sql_administrator_login_password
Add-Content log.txt $result

## notebooks
Add-Content log.txt "-----Configuring Fabric Notebooks w.r.t. current workspace and lakehouses-----"
Write-Host "----Configuring Fabric Notebooks w.r.t. current workspace and lakehouses----"

(Get-Content -path "artifacts/fabricnotebooks/01 Marketing Data to Lakehouse (Bronze) - Code-First Experience.ipynb" -Raw) | Foreach-Object { $_ `
    -replace '#SALES_WORKSPACE_NAME#', $contosoSalesWsName `
    -replace '#LAKEHOUSE_BRONZE#', $lakehouseBronze `
} | Set-Content -Path "artifacts/fabricnotebooks/01 Marketing Data to Lakehouse (Bronze) - Code-First Experience.ipynb"

(Get-Content -path "artifacts/fabricnotebooks/02 Bronze to Silver layer_ Medallion Architecture.ipynb" -Raw) | Foreach-Object { $_ `
    -replace '#SALES_WORKSPACE_NAME#', $contosoSalesWsName `
    -replace '#LAKEHOUSE_BRONZE#', $lakehouseBronze `
    -replace '#LAKEHOUSE_SILVER#', $lakehouseSilver `
} | Set-Content -Path "artifacts/fabricnotebooks/02 Bronze to Silver layer_ Medallion Architecture.ipynb"

(Get-Content -path "artifacts/fabricnotebooks/03 Silver to Gold layer_ Medallion Architecture.ipynb" -Raw) | Foreach-Object { $_ `
    -replace '#LAKEHOUSE_GOLD#', $lakehouseGold `
    -replace '_LAKEHOUSE_GOLD_', $lakehouseGold `
} | Set-Content -Path "artifacts/fabricnotebooks/03 Silver to Gold layer_ Medallion Architecture.ipynb"

(Get-Content -path "artifacts/fabricnotebooks/04 Churn Prediction Using MLFlow From Silver To Gold Layer.ipynb" -Raw) | Foreach-Object { $_ `
    -replace '#LAKEHOUSE_SILVER#', $lakehouseSilver `
    -replace '#LAKEHOUSE_GOLD#', $lakehouseGold `
} | Set-Content -Path "artifacts/fabricnotebooks/04 Churn Prediction Using MLFlow From Silver To Gold Layer.ipynb"

(Get-Content -path "artifacts/fabricnotebooks/05 Sales Forecasting for Store items in Gold Layer.ipynb" -Raw) | Foreach-Object { $_ `
    -replace '#LAKEHOUSE_SILVER#', $lakehouseSilver `
    -replace '#LAKEHOUSE_GOLD#', $lakehouseGold `
} | Set-Content -Path "artifacts/fabricnotebooks/05 Sales Forecasting for Store items in Gold Layer.ipynb"

Add-Content log.txt "-----Fabric Notebook Configuration COMPLETE-----"
Write-Host "----Fabric Notebook Configuration COMPLETE----"


#Web app
Add-Content log.txt "------deploy poc web app------"
Write-Host  "-----------------Deploy web app---------------"
RefreshTokens

$zips = @("app-adx-thermostat-realtime", "app-fabric")
foreach($zip in $zips)
{
    expand-archive -path "./artifacts/binaries/$($zip).zip" -destinationpath "./$($zip)" -force
}

$spname = "Fabric Demo $suffix"

$app = az ad app create --display-name $spname | ConvertFrom-Json
$appId = $app.appId

$mainAppCredential = az ad app credential reset --id $appId | ConvertFrom-Json
$clientsecpwdapp = $mainAppCredential.password

az ad sp create --id $appId | Out-Null    
$sp = az ad sp show --id $appId --query "id" -o tsv
start-sleep -s 15

#https://docs.microsoft.com/en-us/power-bi/developer/embedded/embed-service-principal
#Allow service principals to user PowerBI APIS must be enabled - https://app.powerbi.com/admin-portal/tenantSettings?language=en-U
#add PowerBI App to workspace as an admin to group
RefreshTokens
$url = "https://api.powerbi.com/v1.0/myorg/groups";
$result = Invoke-WebRequest -Uri $url -Method GET -ContentType "application/json" -Headers @{ Authorization = "Bearer $powerbitoken" } -ea SilentlyContinue;
$homeCluster = $result.Headers["home-cluster-uri"]
#$homeCluser = "https://wabi-west-us-redirect.analysis.windows.net";

RefreshTokens
$url = "$homeCluster/metadata/tenantsettings"
$post = "{`"featureSwitches`":[{`"switchId`":306,`"switchName`":`"ServicePrincipalAccess`",`"isEnabled`":true,`"isGranular`":true,`"allowedSecurityGroups`":[],`"deniedSecurityGroups`":[]}],`"properties`":[{`"tenantSettingName`":`"ServicePrincipalAccess`",`"properties`":{`"HideServicePrincipalsNotification`":`"false`"}}]}"
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Bearer $powerbiToken")
$headers.Add("X-PowerBI-User-Admin", "true")
#$result = Invoke-RestMethod -Uri $url -Method PUT -body $post -ContentType "application/json" -Headers $headers -ea SilentlyContinue;

#add PowerBI App to workspace as an admin to group
RefreshTokens
$url = "https://api.powerbi.com/v1.0/myorg/groups/$wsIdContosoSales/users";
$post = "{
`"identifier`":`"$($sp)`",
`"groupUserAccessRight`":`"Admin`",
`"principalType`":`"App`"
}";

$result = Invoke-RestMethod -Uri $url -Method POST -body $post -ContentType "application/json" -Headers @{ Authorization = "Bearer $powerbitoken" } -ea SilentlyContinue;

#get the power bi app...
$powerBIApp = Get-AzADServicePrincipal -DisplayNameBeginsWith "Power BI Service"
$powerBiAppId = $powerBIApp.Id;

#setup powerBI app...
RefreshTokens
$url = "https://graph.microsoft.com/beta/OAuth2PermissionGrants";
$post = "{
`"clientId`":`"$appId`",
`"consentType`":`"AllPrincipals`",
`"resourceId`":`"$powerBiAppId`",
`"scope`":`"Dataset.ReadWrite.All Dashboard.Read.All Report.Read.All Group.Read Group.Read.All Content.Create Metadata.View_Any Dataset.Read.All Data.Alter_Any`",
`"expiryTime`":`"2021-03-29T14:35:32.4943409+03:00`",
`"startTime`":`"2020-03-29T14:35:32.4933413+03:00`"
}";

$result = Invoke-RestMethod -Uri $url -Method GET -ContentType "application/json" -Headers @{ Authorization = "Bearer $graphtoken" } -ea SilentlyContinue;

#setup powerBI app...
RefreshTokens
$url = "https://graph.microsoft.com/beta/OAuth2PermissionGrants";
$post = "{
`"clientId`":`"$appId`",
`"consentType`":`"AllPrincipals`",
`"resourceId`":`"$powerBiAppId`",
`"scope`":`"User.Read Directory.AccessAsUser.All`",
`"expiryTime`":`"2021-03-29T14:35:32.4943409+03:00`",
`"startTime`":`"2020-03-29T14:35:32.4933413+03:00`"
}";

$result = Invoke-RestMethod -Uri $url -Method GET -ContentType "application/json" -Headers @{ Authorization = "Bearer $graphtoken" } -ea SilentlyContinue;

(Get-Content -path app-fabric/appsettings.json -Raw) | Foreach-Object { $_ `
        -replace '#WORKSPACE_ID#', $wsIdContosoSales`
        -replace '#APP_ID#', $appId`
        -replace '#APP_SECRET#', $clientsecpwdapp`
        -replace '#TENANT_ID#', $tenantId`
} | Set-Content -Path app-fabric/appsettings.json

$filepath = "./app-fabric/wwwroot/config.js"
$itemTemplate = Get-Content -Path $filepath
$item = $itemTemplate.Replace("#STORAGE_ACCOUNT#", $storage_account_name).Replace("#SERVER_NAME#", $app_fabric_name)
Set-Content -Path $filepath -Value $item

RefreshTokens
$url = "https://api.powerbi.com/v1.0/myorg/groups/$wsIdContosoSales/reports";
$reportList = Invoke-RestMethod -Uri $url -Method GET -Headers @{ Authorization = "Bearer $powerbitoken" };
$reportList = $reportList.Value

#update all th report ids in the poc web app...
$ht = new-object system.collections.hashtable   
# $ht.add("#Bing_Map_Key#", "AhBNZSn-fKVSNUE5xYFbW_qajVAZwWYc8OoSHlH8nmchGuDI6ykzYjrtbwuNSrR8")
$ht.add("#07_Campaign_Analytics_Report_with_Lakehouse#", $($reportList | where { $_.name -eq "07 Campaign Analytics Report with Lakehouse" }).id)
$ht.add("#09_Sales_Analytics_Report_with_Warehouse#", $($reportList | where { $_.name -eq "09 Sales Analytics Report with Warehouse" }).id)
$ht.add("#Contoso_Finance_Report#", $($reportList | where { $_.name -eq "Contoso Finance Report" }).id)
$ht.add("#HR_Analytics_Report_Lakehouse#", $($reportList | where { $_.name -eq "HR Analytics Report Lakehouse" }).id)
$ht.add("#IT_Report#", $($reportList | where { $_.name -eq "IT Report" }).id)
$ht.add("#Marketing_Report#", $($reportList | where { $_.name -eq "Marketing Report" }).id)
$ht.add("#Operations_Report#", $($reportList | where { $_.name -eq "Operations Report" }).id)
$ht.add("#Retail_Group_CEO_KPI_(Trident)#", $($reportList | where { $_.name -eq "Retail Group CEO KPI" }).id)
$ht.add("#Score_Cards_Report#", $($reportList | where { $_.name -eq "Score Cards Report" }).id)
$ht.add("#World_Map_(Trident)#", $($reportList | where { $_.name -eq "World Map" }).id)

$filePath = "./app-fabric/wwwroot/config.js";
Set-Content $filePath $(ReplaceTokensInFile $ht $filePath)

Compress-Archive -Path "./app-fabric/*" -DestinationPath "./app-fabric.zip" -Update

az webapp stop --name $app_fabric_name --resource-group $rgName
try {
    az webapp deployment source config-zip --resource-group $rgName --name $app_fabric_name --src "./app-fabric.zip"
}
catch {
}

az webapp start --name $app_fabric_name --resource-group $rgName

# ADX Thermostat Realtime
$occupancy_endpoint = az eventhubs eventhub authorization-rule keys list --resource-group $rgName --namespace-name $namespaces_adx_thermostat_occupancy_name --eventhub-name occupancy --name occupancy | ConvertFrom-Json
$occupancy_endpoint = $occupancy_endpoint.primaryConnectionString
$thermostat_endpoint = az eventhubs eventhub authorization-rule keys list --resource-group $rgName --namespace-name $namespaces_adx_thermostat_occupancy_name --eventhub-name thermostat --name thermostat | ConvertFrom-Json
$thermostat_endpoint = $thermostat_endpoint.primaryConnectionString

(Get-Content -path adx-config-appsetting.json -Raw) | Foreach-Object { $_ `
    -replace '#NAMESPACES_ADX_THERMOSTAT_OCCUPANCY_THERMOSTAT_ENDPOINT#', $thermostat_endpoint`
    -replace '#NAMESPACES_ADX_THERMOSTAT_OCCUPANCY_OCCUPANCY_ENDPOINT#', $occupancy_endpoint`
   -replace '#THERMOSTATTELEMETRY_URL#', $thermostat_telemetry_Realtime_URL`
   -replace '#OCCUPANCYDATA_URL#', $occupancy_data_Realtime_URL`
} | Set-Content -Path adx-config-appsetting-with-replacement.json

$config = az webapp config appsettings set -g $rgName -n $sites_adx_thermostat_realtime_name --settings @adx-config-appsetting-with-replacement.json

# Publish-AzWebApp -ResourceGroupName $rgName -Name $sites_adx_thermostat_realtime_name -ArchivePath ./artifacts/binaries/app-adx-thermostat-realtime.zip -Force

Write-Information "Deploying ADX Thermostat Realtime App"
cd app-adx-thermostat-realtime
az webapp up --resource-group $rgName --name $sites_adx_thermostat_realtime_name --plan $serverfarm_adx_thermostat_realtime_name --location $Region
cd ..
Start-Sleep -s 10

az webapp start --name $sites_adx_thermostat_realtime_name --resource-group $rgName

$endtime=get-date
$executiontime=$endtime-$starttime
Write-Host "Execution Time"$executiontime.TotalMinutes
Add-Content log.txt "-----------------Execution Complete---------------"

Write-Host  "-----------------Execution Complete----------------"
