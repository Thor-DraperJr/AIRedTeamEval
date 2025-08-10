@description('Role assignments array: each { principalId, roleDefinitionId, scope }')
param assignments array = []

// Deployment of role assignments; ensure idempotency via deterministic GUID
resource roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for a in assignments: {
  name: guid(a.scope, a.roleDefinitionId, a.principalId)
  scope: a.scope
  properties: {
    principalId: a.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: a.roleDefinitionId
  }
}]

output count int = length(assignments)
