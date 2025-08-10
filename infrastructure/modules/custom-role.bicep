@description('Create custom role for artifact upload (listAccountSas + blob data actions). If false, skip.')
param create bool = false
@description('Scope for role definition (e.g., storage account resource ID)')
param scope string
@description('Role name')
param roleName string = 'RedTeamArtifactUpload'

var roleGuid = guid(scope, roleName)

resource roleDef 'Microsoft.Authorization/roleDefinitions@2022-04-01' = if (create) {
  name: roleGuid
  properties: {
    roleName: roleName
    description: 'Least-privilege role for red team artifact upload (SAS generation + blob operations)'
    type: 'CustomRole'
    assignableScopes: [ scope ]
    permissions: [
      {
        actions: [
          'Microsoft.Storage/storageAccounts/listAccountSas/action'
        ]
        notActions: []
  dataActions: [ 'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read', 'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write', 'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add', 'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete' ]
        notDataActions: []
      }
    ]
  }
}

output roleDefinitionId string = create ? roleDef.id : ''
