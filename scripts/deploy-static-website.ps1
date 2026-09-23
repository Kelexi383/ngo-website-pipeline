# deploy-static-website.ps1
$resourceGroup = "CloudProject-RG"
$location      = "westcentralus"
$storageName   = "staticweb$(Get-Random -Minimum 1000 -Maximum 9999)"
$sourcePath    = "$PSScriptRoot\src"

Write-Host "Creating resource group..."
az group create --name $resourceGroup --location $location

Write-Host "Creating storage account..."
az storage account create --name $storageName --resource-group $resourceGroup --location $location --sku Standard_LRS --kind StorageV2

Write-Host "Enabling static website..."
az storage blob service-properties update --account-name $storageName --static-website --index-document index.html --404-document 404.html

Write-Host "Uploading files from $sourcePath..."
az storage blob upload-batch --account-name $storageName --destination '$web' --source $sourcePath --overwrite

$webUrl = az storage account show --name $storageName --resource-group $resourceGroup --query "primaryEndpoints.web" --output tsv

Write-Host ""
Write-Host "============================================"
Write-Host "   Deployment Complete!"
Write-Host "   Website URL: $webUrl"
Write-Host "   Storage Account: $storageName"
Write-Host "============================================"