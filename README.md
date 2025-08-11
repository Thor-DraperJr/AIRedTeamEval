# AI Red Team Evaluation Framework (Dev)

Single-path, managed-identity-only workflow for automated AI safety / red teaming using Azure AI Foundry + Evaluation SDK (RedTeam) on Azure ML compute. No local execution, no shared keys, no parallel scripts.

`resources.md` is the canonical inventory. If anything here disagrees with it, update this file (do not add new docs).

---
## 🔁 Architecture (Conceptual)
Compute (Azure ML Workspace / compute instance) runs the notebook → targets Azure AI Project (hub-based) → invokes Azure OpenAI → writes evaluation artifacts to Storage via AAD. Key Vault provides secrets only through RBAC.

Target vs Compute invariant: AI Project (target) != ML Workspace (compute).

---
## ⚡ Quick Start (Consolidated)
1. Attach VS Code / Jupyter to the Azure ML compute instance listed in `resources.md`.
2. Open `AI_RedTeaming/src/AI_RedTeaming.ipynb`.
3. Run the first bootstrap cell only. It:
  - Installs core packages if missing
  - Builds a managed identity credential
  - Performs a tiny sanity scan (local JSON)
4. Run the Basic Example scan section.
5. If portal shows evaluation + no artifact warning, proceed to advanced/custom scans.
6. If you see: `Failed to upload evaluation run to the cloud ...` → jump to “Diagnostics Core” section in the notebook.

No `az login` inside notebook. No secrets or keys. Managed identity only.

---
## ✅ Success Criteria
| Goal | Evidence |
|------|----------|
| Identity working | Blob write probe succeeds in Diagnostics Core |
| Evaluation registered | Run appears in AI Foundry (Evaluation UI) |
| Artifacts uploaded (resolved state) | Warning absent + scorecard URL accessible |
| Hardened posture | Storage `publicNetworkAccess=Disabled`, unconditioned Blob Data Contributor (least privilege) |

---
## 🧪 Diagnostics (When Needed)
Notebook “Diagnostics Core” includes:
- Storage write probe (container + blob)
- Container sweep write test
- Minimal tracked scan (portal linkage)
- Post-auth-mode warning detector

RBAC / networking triage prompt: see `.github/prompts/diagnostic.md`.

---
## 🔐 Authentication Model
Managed identity exclusively (system or user-assigned per `resources.md`). No shared key (storage has `allowSharedKeyAccess=false`). All credential resolution disables interactive fallback to avoid accidental user tokens.

---
## 📂 Key Repository Artifacts
- `AI_RedTeaming/src/AI_RedTeaming.ipynb` – single execution path (basic → intermediary → advanced → custom prompts + diagnostics)
- `AI_RedTeaming/data/prompts.json` – custom objective prompts
- `resources.md` – authoritative resource names, principal IDs, RBAC, networking

---
## 🛠 Maintenance Rules
| Action | Rule |
|--------|------|
| RBAC / networking change | Record immediately in `resources.md` (timestamp + reason) |
| Adding files | Only if they replace existing content; never duplicate guidance |
| Notebook edits | Keep bootstrap minimal; advanced diagnostics optional & removable once stable |
| Temporary broad roles | Add with explicit expiry plan; revert to least privilege |

---
## 🚩 Artifact Upload Warning Triage
Warning: `Failed to upload evaluation run to the cloud ...`

Likely causes (in order):
1. Auth mode mismatch (project still in accesskey mode while storage forbids shared key).
2. Active execution identity lacks `listAccountSas/action` (SAS generation step failing).
3. Conditional blob role restricting container path.

If storage write probe passes but warning persists: suspect auth mode / SAS generation path. Consider temporary assignment of a minimal custom role (Blob Data Contributor data actions + `Microsoft.Storage/storageAccounts/listAccountSas/action`). Document any temporary role in `resources.md`.

---
## 📉 Least Privilege Goal (End State)
Per identity:
| Identity | Required Permanent Roles |
|----------|--------------------------|
| Project MI | Blob Data Contributor (unconditioned) |
| Hub MI | Blob Data Contributor (unconditioned) |
| Compute / UAMI | Blob Data Contributor (data plane) + custom role if SAS needed |

Eliminate Blob Data Owner / Account Contributor once artifact uploads verified.

---
## 🧪 Scan Profiles (Notebook Sections)
- Basic (fixed callback) – smoke test
- Intermediary (model-backed minimal) – connectivity + token
- Advanced (multi strategy) – coverage
- Custom Prompts – user-provided objectives

Time budget: Basic <2m; Advanced can scale with objectives × strategies.

---
## 🔄 Operational Cycle
1. Bootstrap & smoke
2. Run target scan(s)
3. Verify portal presence & artifacts
4. Harden (remove temp roles, restrict networking)
5. Record changes in `resources.md`

---
## 🤝 Contributing
Open a PR with:
- Rationale
- Impact summary
- `resources.md` deltas (if any)

Do not add new quickstart/guide files. Update this README + `resources.md` only.

---
## 🧾 License
MIT License – see `LICENSE`.

---
**One notebook, one inventory, managed identity only.**

---
### Infrastructure Templates (Temporarily Removed)
Historic Bicep templates (`infrastructure/main.bicep` and related modules) were removed due to non-functional deployment paths and to reduce maintenance overhead. The `infrastructure/` directory is currently a placeholder. When a validated minimal IaC path is ready (single deploy, no drift, managed identity only), new templates will be reintroduced with automated validation steps. Until then, provision or adjust resources manually and record every change in `resources.md`.

---
### Infrastructure Templates (Temporarily Removed)
Historic Bicep templates (`infrastructure/main.bicep` and related module files) were removed due to non-functional deployment paths and to reduce maintenance overhead. The `infrastructure/` directory is currently a placeholder. When a validated minimal IaC path is ready (single deploy, no drift, managed identity only), new templates will be reintroduced with automated validation steps. Until then, provision or adjust resources manually and record every change in `resources.md`.
