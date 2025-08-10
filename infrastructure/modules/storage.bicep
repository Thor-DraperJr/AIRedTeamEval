@description('Location')
param location string
@description('Storage account name')
param name string
@description('Create storage account (if false reference existing)')
param create bool = false
@description('Enable public network access (temporary)')
param publicNetworkAccess bool = false

resource stg 'Microsoft.Storage/storageAccounts@2024-01-01' = if (create) {
  name: name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    allowSharedKeyAccess: false
    publicNetworkAccess: publicNetworkAccess ? 'Enabled' : 'Disabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
}

resource stgExisting 'Microsoft.Storage/storageAccounts@2024-01-01' existing = if (!create) {
  name: name
}

output storageAccountId string = (create ? stg.id : stgExisting.id)
