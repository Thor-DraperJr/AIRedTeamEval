// Main orchestrator for ThorLabs AI Red Team dev environment (modular, idempotent)
// Principle: minimal creation by default; treat existing resources as 'existing' unless create* flags enabled.

@description('Environment name (e.g., dev, prod)')
param environment string = 'dev'

@description('Azure location for new resources (ignored for existing)')
param location string = resourceGroup().location

@description('AI Foundry (AIServices) account name')
param aiFoundryName string

@description('AI Project name (child of Foundry account)')
param aiProjectName string

@description('Set true to create (or update) AI Foundry account + project; false = treat as existing')
param createAiFoundry bool = false

@description('Storage account name (results & artifacts)')
param storageAccountName string

@description('Create storage account (if false, reference existing)')
param createStorage bool = false

@description('Enable public network access on storage (temporary troubleshooting)')
param storagePublicNetworkAccess bool = false

@description('Key Vault name')
param keyVaultName string

@description('Create Key Vault (if false, reference existing)')
param createKeyVault bool = false

@description('Azure OpenAI account name')
param openAiAccountName string

@description('Create Azure OpenAI account (if false, reference existing)')
param createOpenAi bool = false


@description('Role assignment objects (applied only when not empty). Each: { principalId, roleDefinitionId, scope }')
param roleAssignments array = []

@description('Create least-privilege custom role for artifact upload (listAccountSas + blob data actions)')
param createCustomRole bool = false

@description('Custom role name (if createCustomRole=true)')
param customRoleName string = 'RedTeamArtifactUpload'

module aiFoundry 'modules/ai-foundry.bicep' = {
  name: 'aiFoundryModule'
  params: {
    location: location
    aiFoundryName: aiFoundryName
    aiProjectName: aiProjectName
    create: createAiFoundry
  }
}

module storage 'modules/storage.bicep' = {
  name: 'storageModule'
  params: {
    location: location
    name: storageAccountName
    create: createStorage
    publicNetworkAccess: storagePublicNetworkAccess
  }
}

module keyvault 'modules/keyvault.bicep' = {
  name: 'keyVaultModule'
  params: {
    location: location
    name: keyVaultName
    create: createKeyVault
  }
}

module openai 'modules/openai.bicep' = {
  name: 'openAiModule'
  params: {
    location: location
    name: openAiAccountName
    create: createOpenAi
  }
}

module roles 'modules/role-assignments.bicep' = if (length(roleAssignments) > 0) {
  name: 'roleAssignmentsModule'
  params: {
    assignments: roleAssignments
  }
}

module customRole 'modules/custom-role.bicep' = if (createCustomRole) {
  name: 'customRoleModule'
  params: {
    create: true
    scope: storage.outputs.storageAccountId
    roleName: customRoleName
  }
}

output aiProjectEndpoint string = aiFoundry.outputs.projectEndpoint
output storageAccountId string = storage.outputs.storageAccountId
output openAiEndpoint string = openai.outputs.endpoint
output customRoleDefinitionId string = createCustomRole ? customRole.outputs.roleDefinitionId : ''
