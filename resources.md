# ThorLabs AI Red Team Evaluation – Resource Inventory (dev)

Environment: dev  
Subscription: e440a65b-7418-4865-9821-88e411ffdd5b  
Resource Group: rg-thorlabs-redteam-dev-eastus2  
Location: East US 2

This is the authoritative, current-state inventory. Keep synchronized after any change (names, identities, permissions, networking). Historical/legacy models have been removed from this document to reduce ambiguity.

## Architecture (Current)

```text
┌────────────────────────────────────┐           ┌──────────────────────────────────────────┐
│ Compute (Azure ML Workspace)      │           │ Target (Azure AI Foundry Project)        │
│ thorlabs-mlws-redteam-dev         │  PyRIT /  │ Account: thorlabs-aisvc-redteam-dev       │
│  └─ Compute Instance:             ├─Eval/API─▶│ Project: thorlabs-aisvcproj-redteam-dev   │
│     thorlabs-redteam-e4s          │  calls    │   └─ invokes Azure OpenAI                 │
│     (remote kernel only)          │           │       thorlabs-openai-redteam-dev         │
└────────────────────────────────────┘           └──────────────────────────────────────────┘
    │ AAD (no keys)                                 ▲
    ▼                                                │ Run metadata + artifacts
  ┌──────────────────────────────────────────┐             │
  │ Storage (Artifacts & Results)            │             │
  │ thorlabsredteamdev001                    │             │
  │ allowSharedKeyAccess: false (AAD only)   │             │
  │ publicNetworkAccess: Enabled (TEMP)      │             │
  └──────────────────────────────────────────┘             │
    │                                                │
    ▼                                                │
  ┌──────────────────────────────────────────┐             │
  │ Key Vault (Secrets)                      │◀────────────┘
  │ thorlabs-kv-redteam-dev                  │
  │ RBAC auth only (no access policies)      │
  └──────────────────────────────────────────┘
```

Legend:
- All execution happens on the remote compute instance kernel; never local.
- Managed identities (system or user-assigned) perform all auth flows (no keys, no shared access keys).
- Notebook targets the AIServices project directly; evaluation results surface in the AI Foundry UI and blobs in Storage.

## Target & Compute
- Target Project: thorlabs-aisvcproj-redteam-dev (AIServices)
- Target Account: thorlabs-aisvc-redteam-dev
- Compute Workspace: thorlabs-mlws-redteam-dev
- Active Compute Instance: thorlabsredteamci2 (Standard_E4s_v3)
  - Jupyter: https://thorlabsredteamci2.eastus2.instances.azureml.ms/tree/
  - JupyterLab: https://thorlabsredteamci2.eastus2.instances.azureml.ms/lab
  - Identity Type: user_assigned (thorlabs-redteam-uami-dev)
  - Current State: Starting (Start operation InProgress since 2025-08-10T18:19:22Z) – remediation pending
  - Issue: Start operation appears hung (stop denied: startoperationInProgress). Next step options: (1) Wait additional 15–30m; (2) Delete & recreate with same UAMI; (3) Open support ticket if repeated hangs.
  - Previous Instance (DECOMMISSIONED): thorlabs-redteam-e4s (removed 2025-08-10) – stale references purged.

## Resource Inventory
- Azure ML Workspace (Compute): thorlabs-mlws-redteam-dev
  - Id: /subscriptions/e440a65b-7418-4865-9821-88e411ffdd5b/resourceGroups/rg-thorlabs-redteam-dev-eastus2/providers/Microsoft.MachineLearningServices/workspaces/thorlabs-mlws-redteam-dev
  - Managed identity (system-assigned) principalId: 5197eaed-4b08-45d6-ab77-ec452b9b6e2c
  - Additional RBAC (2025-08-09): AzureML Data Scientist role granted to user-assigned MI principalId 64588509-4298-478a-afbf-30c64a06bc57 for RedTeam service discovery.
  - system_datastores_auth_mode: identity (updated from accesskey on 2025-08-09 to enable AAD-based artifact/datastore access and align with allowSharedKeyAccess=false storage setting)
- Azure Container Registry (workspace dependency): thorlabsredteamdev001
  - Id: /subscriptions/e440a65b-7418-4865-9821-88e411ffdd5b/resourceGroups/rg-thorlabs-redteam-dev-eastus2/providers/Microsoft.ContainerRegistry/registries/thorlabsredteamdev001
  - Provisioning: Created 2025-08-09 after being absent (missing ACR blocked compute recreation)
- Azure AI Foundry Account (AIServices): thorlabs-aisvc-redteam-dev
  - Id: /subscriptions/e440a65b-7418-4865-9821-88e411ffdd5b/resourceGroups/rg-thorlabs-redteam-dev-eastus2/providers/Microsoft.CognitiveServices/accounts/thorlabs-aisvc-redteam-dev
  - customSubDomainName: thorlabsredteamdev
  - Managed identity (system-assigned) principalId: cab5c704-5608-4852-a680-8f869e1bb185
  - allowProjectManagement: true
  - Notes: Created 2025-08-10; customSubDomain and allowProjectManagement enabled via PATCH; serves as new target scope.
- Azure AI Foundry Project (AIServices Target): thorlabs-aisvcproj-redteam-dev
  - Id: /subscriptions/e440a65b-7418-4865-9821-88e411ffdd5b/resourceGroups/rg-thorlabs-redteam-dev-eastus2/providers/Microsoft.CognitiveServices/accounts/thorlabs-aisvc-redteam-dev/projects/thorlabs-aisvcproj-redteam-dev
  - Managed identity (system-assigned) principalId: 31f091e2-5b96-41d2-9514-85dad22ffd05
  - Endpoints: AI Foundry API: https://thorlabsredteamdev.services.ai.azure.com/api/projects/thorlabs-aisvcproj-redteam-dev
  - Provisioning: Succeeded 2025-08-10 (created via REST after setting identity + customSubDomainName)
- Azure OpenAI: thorlabs-openai-redteam-dev
  - Id: /subscriptions/e440a65b-7418-4865-9821-88e411ffdd5b/resourceGroups/rg-thorlabs-redteam-dev-eastus2/providers/Microsoft.CognitiveServices/accounts/thorlabs-openai-redteam-dev
  - Managed identity (system-assigned) principalId: 033e4829-3029-4d85-909c-87e0d4e02387
  - UAMI access: thorlabs-redteam-uami-dev (principalId 64588509-4298-478a-afbf-30c64a06bc57) granted Cognitive Services OpenAI User (date: 2025-08-09) for model invocation during scans.
- Key Vault (secrets): thorlabs-kv-redteam-dev
  - Id: /subscriptions/e440a65b-7418-4865-9821-88e411ffdd5b/resourceGroups/rg-thorlabs-redteam-dev-eastus2/providers/Microsoft.KeyVault/vaults/thorlabs-kv-redteam-dev
  - Vault URI: https://thorlabs-kv-redteam-dev.vault.azure.net/
  - RBAC authorization: Enabled
  - Soft delete retention: 90 days (recovered)
  - publicNetworkAccess: Enabled
- Storage Account (results & artifacts): thorlabsredteamdev001
  - Id: /subscriptions/e440a65b-7418-4865-9821-88e411ffdd5b/resourceGroups/rg-thorlabs-redteam-dev-eastus2/providers/Microsoft.Storage/storageAccounts/thorlabsredteamdev001
  - Endpoints: 
    - Blob: https://thorlabsredteamdev001.blob.core.windows.net/
    - DFS:  https://thorlabsredteamdev001.dfs.core.windows.net/
  - Networking:
    - publicNetworkAccess: Enabled  <!-- TEMPORARY: opened for troubleshooting on 2025-08-09; revert to Disabled after validation -->
    - networkRuleSet.defaultAction: Allow
    - networkRuleSet.bypass: AzureServices
  - Auth:
    - allowSharedKeyAccess: false (AAD recommended)
    - UAMI (thorlabs-redteam-uami-dev, principalId 64588509-4298-478a-afbf-30c64a06bc57) role: Storage Blob Data Contributor (2025-08-09) enabling keyless artifact writes when UAMI is used by the compute kernel.

## User-Assigned Managed Identity (UAMI)
- Name: thorlabs-redteam-uami-dev
  - ClientId: 95aedfd4-301c-4105-a6db-0a83c9fd5ddd
  - PrincipalId: 64588509-4298-478a-afbf-30c64a06bc57
  - Purpose: Stable managed identity for notebook execution when system-assigned MI on compute instance was returning IMDS 400 errors.
  - Key RBAC:
    - Azure ML Workspace (scope: thorlabs-mlws-redteam-dev): AzureML Data Scientist (b78c5d69-af96-48a3-bf8d-a8b4d589de94) – required for RedTeam instantiation (service discovery) – added 2025-08-09 (assignment id 517ce844-9abc-4a0d-a408-130946bc9e92).
    - Storage Account: Storage Blob Data Contributor (unconditioned) – enables artifact & log uploads.
  - Storage Account: Storage Account Contributor (unconditioned) – added 2025-08-09 (assignment id 181f855a-dd2e-4df5-984b-5cc64ed3469c) to supply management-plane listAccountSas/action for artifact upload troubleshooting (user approved permanent assignment).
    - Azure OpenAI account: Cognitive Services OpenAI User – enables model inference via AAD token.
  - Notes: Prefer UAMI explicitly via ManagedIdentityCredential(client_id=<UAMI ClientId>) to avoid fallback to user principal tokens.

## Storage RBAC – Key Assignments
Scope: Storage Account thorlabsredteamdev001
- thorlabs-mlws-redteam-dev (principalId 5197eaed-4b08-45d6-ab77-ec452b9b6e2c)
  - Storage Blob Data Contributor
  - Storage File Data Privileged Contributor
- thorlabs-openai-redteam-dev (principalId 033e4829-3029-4d85-909c-87e0d4e02387)
  - Storage Blob Data Contributor
- thorlabs-foundry-redteam-dev (principalId a4d1d3ca-82e2-472d-97b6-3da29d0c6904)
  - Storage Blob Data Contributor (conditioned to a container prefix)
  - Storage Blob Data Owner (unconditioned) – added 2025-08-09 to unblock evaluation artifact remote tracking (temporary; to be replaced with least‑privilege after validation)
  - Storage Account Contributor (unconditioned) – added 2025-08-09 to supply management-plane listAccountSas/action needed by remote tracking (temporary; remove after confirming if a narrower custom role suffices)
  - Storage File Data Privileged Contributor
- thorlabs-project-redteam-dev (principalId a8553acb-5810-4170-92b8-ec38e95368fd)
  - Reader
  - Storage Account Contributor (unconditioned) – discovered via verification 2025-08-09 (role assignment id c8d7bb36-20be-4f99-9471-4423637c44bd) – provides management-plane actions incl. listAccountSas/action
  - Storage File Data Privileged Contributor
  - Storage Blob Data Contributor (conditioned to a container prefix)
  - Storage Blob Data Contributor (unconditioned; added 2025-08-09 remediation for artifact uploads; assignment id 77a89d29-a2c4-4443-a6d0-ec0de2a98979)
  - Storage Blob Data Contributor (conditioned to a container prefix – pre‑remediation)
  - Storage Blob Data Owner (unconditioned) – added 2025-08-09 to unblock evaluation artifact remote tracking (temporary; consider downgrading to unconditioned Blob Data Contributor once confirmed) – assignment id 40261d2c-254b-4bda-bb7f-dc7ccb8c910a

Note: Conditioned assignments indicate data-plane scoping to specific container name prefixes created by the service.

## Key Vault RBAC – Key assignments
Scope: Key Vault thorlabs-kv-redteam-dev
- thorlabs-project-redteam-dev (principalId a8553acb-5810-4170-92b8-ec38e95368fd)
  - Role: Key Vault Secrets Officer
- thorlabs-mlws-redteam-dev (principalId 5197eaed-4b08-45d6-ab77-ec452b9b6e2c)
  - Role: Key Vault Secrets Officer

## Sources and commands used (authoritative)
- az resource list -g rg-thorlabs-redteam-dev-eastus2
- az ml compute show -g rg-thorlabs-redteam-dev-eastus2 -w thorlabs-mlws-redteam-dev -n thorlabs-redteam-e4s
- az storage account show -g rg-thorlabs-redteam-dev-eastus2 -n thorlabsredteamdev001
- az role assignment list --scope "/subscriptions/e440a65b-7418-4865-9821-88e411ffdd5b/resourceGroups/rg-thorlabs-redteam-dev-eastus2/providers/Microsoft.Storage/storageAccounts/thorlabsredteamdev001"
- az keyvault show-deleted -n thorlabs-kv-redteam-dev
- az keyvault recover -n thorlabs-kv-redteam-dev
- az role assignment create --assignee-object-id <principalId> --assignee-principal-type ServicePrincipal --role "Key Vault Secrets Officer" --scope "/subscriptions/e440a65b-7418-4865-9821-88e411ffdd5b/resourceGroups/rg-thorlabs-redteam-dev-eastus2/providers/Microsoft.KeyVault/vaults/thorlabs-kv-redteam-dev"

## Operational Notes
- Attach VS Code to the remote Azure ML kernel on thorlabs-redteam-e4s; do not run locally.
- Notebook target confirmation: use AIServices project name (thorlabs-aisvcproj-redteam-dev) in all evaluation SDK calls.
- If results don’t appear in Foundry, verify: (1) project MI has Storage Blob Data Contributor (or custom role) (2) storage is linked to the project (3) allowSharedKeyAccess remains false.
- TEMPORARY (2025-08-09/10): Storage publicNetworkAccess=Enabled for troubleshooting – revert to Disabled after artifact upload validation under AIServices project flows.

### Artifact Upload State (Current)
Status: Warnings persisted pre-migration; validating under AIServices project. Hypothesis centers on management-plane SAS generation (listAccountSas/action) when allowSharedKeyAccess=false and evaluation SDK fallback logic. Custom minimal role (below) prepared to scope permissions precisely to required actions + blob DataActions. Apply only after confirming baseline requirement.

### Custom Role (Design Ready)
Name: RedTeamArtifactUpload (dev)  
Scope: Storage account (thorlabsredteamdev001)  
Actions: listAccountSas/action  
DataActions: read/write/add/delete (+ optional move/action if required) on blobs only.  
Purpose: Grant precise capability for artifact upload when SAS generation attempted under UAMI while keeping allowSharedKeyAccess=false.

### Pending Validation
Run notebook minimal scan under AIServices project. If artifact warnings persist: assign custom role to UAMI (instead of broad Storage Account Contributor) and retest. On success, remove any temporary expansive roles and set storage publicNetworkAccess=Disabled.

## Compute Instance Managed Identity / Status
Active compute (thorlabsredteamci2) is still provisioning (state=Starting). It uses ONLY the user-assigned managed identity `thorlabs-redteam-uami-dev` (principalId 64588509-4298-478a-afbf-30c64a06bc57) – no system-assigned identity bound.

Observed condition: Start operation has remained InProgress beyond typical boot window (>10m). A stop request returned `startoperationInProgress` (no cancellation). If state persists >30m total, plan:
1. Delete compute instance.
2. Recreate with same size & UAMI.
3. Post-creation, delay 60s then issue explicit start, monitor until Running.
4. If second attempt also hangs, escalate (Azure support) – capture correlation IDs from activity logs.

Note: Prior compute `thorlabs-redteam-e4s` historical identity details removed to avoid ambiguity.

Planned Hardening / Cleanup:
- Evaluate necessity of current expansive roles on project identity (a8553acb-5810-4170-92b8-ec38e95368fd). Consider removing: Storage Blob Data Owner, Storage Account Contributor, Storage Table Data Contributor if not explicitly required for red team artifact logging.
- After successful artifact confirmation using compute MI + project identity baseline, revert storage `publicNetworkAccess` to Disabled (if currently Enabled) retaining `bypass: AzureServices`.

Change Log:
- 2025-08-09: Added system-assigned MI to compute; granted Storage Blob Data Contributor; documented principal and assignment id (initial, superseded after recreation).
- 2025-08-09: Recreated compute instance identity (old principal 08d67f63-... replaced by 4f4a4d9e-...); created missing ACR thorlabsredteamdev001; new role assignment f29c6ace-1aff-4299-9a9b-349b4bfd0f49.
- 2025-08-09: Added user-assigned managed identity (thorlabs-redteam-uami-dev) RBAC: Storage Blob Data Contributor, Cognitive Services OpenAI User, and AzureML Data Scientist (workspace scope) to remediate RedTeam 403 (service discovery) while keeping keyless execution.
 - 2025-08-09: Added unconditioned Storage Blob Data Owner to hub MI (a4d1d3ca-...) to resolve remote artifact upload permission warnings; plan to replace with unconditioned Blob Data Contributor after verification and then remove conditioned assignment if redundant.
 - 2025-08-09: Added Storage Account Contributor to hub MI (a4d1d3ca-...) to provide management-plane permission (listAccountSas/action) after Blob Data Owner alone did not clear artifact upload warning; plan: once confirmed fix, design minimal custom role (Blob Data Contributor dataActions + listAccountSas/action) and remove both Blob Data Owner and Storage Account Contributor.
 - 2025-08-09: Verification revealed project MI already had Storage Account Contributor prior to remediation hypothesis; updated inventory and adjusted root cause analysis (focus shifted to auth mode mismatch: system_datastores_auth_mode=accesskey vs allowSharedKeyAccess=false).
 - 2025-08-09: Added Storage Account Contributor to UAMI (assignment id 181f855a-dd2e-4df5-984b-5cc64ed3469c) per user approval to permanently grant management-plane SAS generation capability for artifact uploads.
 - 2025-08-10: Decommissioned compute `thorlabs-redteam-e4s`; created new compute `thorlabsredteamci2` (user-assigned MI only). Start operation currently hung (state=Starting). Pending remediation per plan above.

## RBAC Mapping to Official Roles (Azure AI Foundry)
Reference (docs search 2025-08-10): Azure AI User role supplies build & develop (data actions) within a project. For automated red teaming scans:
Required Minimal Set:
- Project Scope: Azure AI User (assigned to executing principal OR rely on project managed identity for service operations).
- Model Invocation: Cognitive Services OpenAI User (on Azure OpenAI account) for the identity used to send prompts.
- Storage Persistence: Storage Blob Data Contributor (data plane) on the linked storage (identity performing artifact writes). If SDK requires SAS generation with allowSharedKeyAccess=false, add management-plane action listAccountSas/action (currently satisfied via broad Storage Account Contributor – slated for reduction).

Current vs Minimal:
- Project MI & UAMI currently exceed minimal (have Storage Account Contributor & Blob Data Owner in some cases). Future cleanup: replace broad roles with custom minimal role (design captured earlier) once artifact upload succeeds without warnings using narrower permissions.

