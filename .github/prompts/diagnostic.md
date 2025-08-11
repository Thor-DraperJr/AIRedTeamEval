# prompt:diagnostic-rbac-network

Single diagnostic prompt for RBAC + storage networking issues in AI red teaming pipeline.

## Usage
Copy everything inside the fenced block into your AI assistant, replacing placeholders.

```
Diagnose Azure AI red teaming environment connectivity.

Context:
  Project (target): <PROJECT_NAME>
  ML Workspace (compute): <ML_WORKSPACE_NAME>
  Resource Group: <RESOURCE_GROUP>
  Storage Account: <STORAGE_ACCOUNT>
  Region: <REGION>
Issue: Evaluation artifacts not appearing OR storage upload warning.

Tasks (read-only unless I explicitly approve changes):
1. Verify storage account posture: allowSharedKeyAccess=false, publicNetworkAccess=Disabled, defaultAction=Allow, bypass=AzureServices.
2. Enumerate role assignments at storage scope for project, hub, workspace identities – each should have only Storage Blob Data Contributor (no Owner/Contributor).
3. Confirm project <-> storage linkage uses AAD (no key fallback).
4. Detect conditional role scoping (container/path restrictions).
5. If upload warning persists but blob write probe would succeed, identify missing dataActions (e.g., Microsoft.Storage/storageAccounts/listAccountSas/action) and DRAFT a minimal custom role JSON (do not apply).
6. Produce remediation plan preserving least privilege (steps separated: read-only vs apply).

Output:
- Findings (bulleted)
- Root cause hypothesis
- Draft custom role JSON (if needed)
- Safe command set (read-only, then apply)
```

Keep this file minimal; expand only if a new repeated diagnostic emerges.
