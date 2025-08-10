@description('Location')
param location string
@description('Azure OpenAI account name')
param name string
@description('Create account (if false reference existing)')
param create bool = false

resource openai 'Microsoft.CognitiveServices/accounts@2023-05-01' = if (create) {
  name: name
  location: location
  kind: 'OpenAI'
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

resource openaiExisting 'Microsoft.CognitiveServices/accounts@2023-05-01' existing = if (!create) {
  name: name
}

// Model deployments loop temporarily removed pending validation of API surface; reintroduce once needed.

var endpoint = 'https://${name}.openai.azure.com'

output accountId string = (create ? openai.id : openaiExisting.id)
output endpoint string = endpoint
