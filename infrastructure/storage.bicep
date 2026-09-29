@description('The Azure region for resources')
param location string = 'westcentralus'

@description('Storage account name')
param storageAccountName string = 'staticweb8514'

@description('Environment tag')
param environment string = 'learning'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    staticWebsite: {
      enabled: true
      indexDocument: 'index.html'
      errorDocument404Document: '404.html'
    }
  }
  tags: {
    Environment: environment
    Project: 'NGO-website'
  }
}

output webEndpoint string = storageAccount.properties.primaryEndpoints.web