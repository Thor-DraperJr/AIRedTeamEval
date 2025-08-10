@description('Location')
param location string
@description('Key Vault name')
param name string
@description('Create Key Vault (if false reference existing)')
param create bool = false

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = if (create) {
  name: name
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    enableRbacAuthorization: true
    enablePurgeProtection: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    publicNetworkAccess: 'Enabled'
  }
}

resource kvExisting 'Microsoft.KeyVault/vaults@2023-07-01' existing = if (!create) {
  name: name
}

output vaultId string = (create ? kv.id : kvExisting.id)
