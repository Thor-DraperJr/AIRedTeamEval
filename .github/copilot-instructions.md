# AI Red Team Evaluation Framework — Agent Instructions (vNext)

Mission
- Run one notebook end-to-end on Azure ML compute against an Azure AI Foundry Project target. No local execution. Minimal files. MCP tools only.

Source of truth
- Canonical resources are in resources.md. Never hardcode names here. Read from resources.md and fail fast if missing/incomplete.
- Declare the active environment (e.g., dev). Abort actions if the inventory is ambiguous.

Target vs Compute (hard rule)
- Target: Azure AI Project (what is evaluated).
- Compute: Azure ML Workspace + compute instance (where notebook runs).
- Invariant: project != workspace. Abort if violated.

Anti‑sprawl protocol
- Create nothing unless essential. Update existing docs (resources.md, README.md) instead of adding new files.
- No wrapper scripts, no meta-docs, no duplicate guides. One clear path only.

Azure MCP usage (primary)
- Use Azure MCP servers for ALL Azure operations (workspaces/compute, storage, RBAC, foundry, groups, subscriptions).
- Use Microsoft Docs search only to ground error handling or confirm guidance.
- Do not adopt az CLI as the execution path; reference-only when needed.

Permission Validation Protocol (must pass before any red teaming)
1) Storage account (from resources.md) uses Entra ID (allowSharedKeyAccess=false).
2) Networking: publicNetworkAccess=Disabled; defaultAction=Allow; bypass=AzureServices. Temporary overrides require explicit user approval and must be reverted post-run.
3) AI Foundry Project managed identity has Storage Blob Data Contributor on the storage scope in resources.md.
4) Storage account is connected to the AI Foundry Project at the resource level.
5) Smoke test: Confirm results visible in the Foundry red teaming section after a run.

Execution model
- Notebook: AI_RedTeaming/src/AI_RedTeaming.ipynb.
- Kernel: Attach to the Azure ML compute instance from resources.md (no local execution).
- Auth: Use compute SSO/managed identity; never run az login inside the notebook.

Tool cadence & checkpoints
- After 3–5 tool calls or >3 file edits, checkpoint with: what ran (high level), key results, next step.
- Provide delta-only updates; don’t restate unchanged plans.
- End each task with a one-line requirements coverage: Done/Deferred (+ reason).

Error handling
- Up to 3 targeted retries with exponential backoff. Report exact tool + args and resource scope.
- If still failing, summarize root cause, options, and the precise failing output.

Security posture
- Default posture: no local execution, AAD-only storage auth, networking restricted as above.
- Any temporary relaxation requires explicit user approval and rollback immediately after the run.

Resource tracking
- Update resources.md after any resource/permission/networking change: name, type, RG, location, purpose, MI principal IDs, storage links/permissions.

Success criteria (per run)
- Evaluation completes on ML kernel against the AI Project target.
- Results visible in the AI Foundry red teaming UI and persisted in storage.
- Any temporary networking overrides reverted; resources.md updated.

ThorLabs patterns
- Naming follows current org practice (e.g., thorlabs-mlws-redteam-dev, thorlabs-project-redteam-dev, thorlabsredteamdev001). Keep names centralized in resources.md to prevent drift.

---
## Capability Expansion (Controlled)
The agent MAY exercise the following additional capabilities IF they directly advance the mission and reduce duplication while preserving single-path execution:

Ephemeral & Helper Artifacts
- MAY propose creation of at most one helper module (e.g., helper/context_validation.py) per PR if it consolidates ≥30% repeated notebook logic or reduces cell length >40%. Must list in context-manifest.json with role "helper".
- MAY create ephemeral test or diag artifacts under `.diag/` or `.ephemeral/` (auto-clean intent) only during an active task. These are excluded from long-term docs unless promoted.
- MUST NOT create new standing guides; README.md + resources.md remain canonical.

Notebook & Execution Model
- MAY refactor notebook sections into reusable functions (idempotent) while preserving named sections listed in context-manifest.json (Bootstrap, Basic, Intermediary, Advanced, Custom Prompts, Diagnostics Core).
- MAY generate a headless mirror (single file `AI_RedTeaming/run_headless.py`) ONLY if user requests automation/CI; default is notebook-only.

Adaptive Retry Policy
- Default retries: 3 (base 2s exponential). For Azure 429 / 5xx: MAY extend to 5 attempts (cap 32s) with jitter if operation is idempotent (read/list/describe). Creation/modification operations remain at 3 unless user approves.
- After final failure: produce structured failure report (operation, scope, status code, last error excerpt, recommended remediations) before abort.

Resource & Inventory Gaps
- If a required field missing in resources.md (mandatory keys: environment, projectName, workspaceName, storageAccount, resourceGroup, region, identities[] with type+principalId), agent emits a PROPOSAL block (YAML patch) instead of proceeding blindly.
- Abort only if ambiguity persists after one proposal cycle or if target==compute invariant violated.

Least Privilege & Role Drafting
- MAY draft (not apply) custom role JSON if required dataAction (e.g., listAccountSas/action) absent; include rationale + scope + removal plan.
- All RBAC changes require explicit user approval; track intended delta in resources.md pending section (if added later).

Diagnostics Mode
- If user sets DIAG=1 (or requests deep debug), agent can:
	- Emit raw Azure error payload excerpts (sanitized for secrets)
	- Retain transient logs under `.diag/` (auto-clean suggestion after success)
	- Expand forbidden pattern scan to show file paths (not contents) for triage

Forbidden Pattern Whitelisting
- Code/examples containing literal tokens (AZURE_OPENAI_KEY=, ACCESS_KEY, SAS_TOKEN) may be wrapped in fenced blocks starting with comment marker `# allow-patterns` to bypass guard false positives.
- Agent MAY propose adding such markers rather than removing educational examples.

Batch & Checkpoint Optimization
- Homogeneous read-only operations (≥5 similar list/get calls) MAY be batched before a single checkpoint summary.
- MUST still checkpoint after any write-intent (even if failed) or creation proposal.

Local Static Validation Allowance
- Static analysis (lint/type) MAY run locally if it does not invoke cloud or secrets; results are advisory.
- No local data-plane calls to Azure services.

Context Manifest Evolution
- Agent MAY append newly approved helper/diagnostic files to `.github/context-manifest.json` with justification comment.
- Removal of deprecated entries requires updating last_updated timestamp.

Telemetry & Transparency
- For each non-trivial Azure operation: record (operation kind, target scope, attempt #, elapsed ms when available) in a transient op log if DIAG=1.

Performance Guardrails
- Soft budget: avoid >12 parallel Azure list operations in a single batch; if exceeded, split.
- Apply adaptive backoff when cumulative transient failure rate >30% in recent batch.

Plan Escalation Criteria
- Escalate from minimal search to semantic sweep when:
	- Symbol unresolved after 2 targeted grep attempts; or
	- Cross-file dependency suspected (import present but definition missing locally).

Security Invariants (Reaffirmed)
- NO secrets checked into repo.
- Managed identity only (no az login inside notebook).
- Target != Compute enforced pre-run.
- Networking and keyless storage posture preserved; any temporary relaxation must include revert plan + timestamp in resources.md.

Success Confirmation Enhancements
- After run: verify artifact presence + evaluation registration + absence of upload warnings; if warning persists but storage write succeeded, propose auth-mode reconciliation steps.

De-scoping / Cleanup
- After task success: propose removal of any ephemeral or diag artifacts still present; produce list for user confirmation.

---
Versioning
- Increment last_updated in context-manifest.json when capability assumptions change.
- Include CHANGE NOTE summary in PR description referencing which clauses exercised.

End State Principle
One notebook, one inventory, minimal helpers, fully auditable actions.
