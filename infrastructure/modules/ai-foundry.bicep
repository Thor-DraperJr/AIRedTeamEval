@description('Location')
param location string
@description('AI Foundry account (AIServices) name')
param aiFoundryName string
@description('AI Project name')
param aiProjectName string
@description('Create resources (if false, treat as existing)')
param create bool = false

// API version chosen per current docs; adjust if newer stable released.
var cognitiveApiVersion = '2023-05-01'

resource aiFoundry 'Microsoft.CognitiveServices/accounts@2023-05-01' = if (create) {
  name: aiFoundryName
  location: location
  kind: 'AIServices'
  sku: {
    name: 'S0'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
  }
  identity: {
    type: 'SystemAssigned'
  }
}

// Existing reference if not creating
resource aiFoundryExisting 'Microsoft.CognitiveServices/accounts@2023-05-01' existing = if (!create) {
  name: aiFoundryName
}

// Project child resource (create only when create=true)
resource aiProject 'Microsoft.CognitiveServices/accounts/projects@2023-05-01' = if (create) {
  name: '${aiFoundry.name}/${aiProjectName}'
  location: location
  properties: {}
}

// Existing project reference otherwise
resource aiProjectExisting 'Microsoft.CognitiveServices/accounts/projects@2023-05-01' existing = if (!create) {
  parent: aiFoundryExisting
  name: aiProjectName
}

var endpointBase = 'https://${aiFoundryName}.services.ai.azure.com'
var projectEndpoint = '${endpointBase}/api/projects/${aiProjectName}'

output accountId string = (create ? aiFoundry.id : aiFoundryExisting.id)
output projectId string = (create ? aiProject.id : aiProjectExisting.id)
output projectEndpoint string = projectEndpoint
