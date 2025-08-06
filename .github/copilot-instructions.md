# AI Red Team Evaluation Framework - AI Agent Instructions

## 🚨 ANTI-SPRAWL PROTOCOL: Prevention Over Cleanup
**CRITICAL**: Prevent bloat before it starts. Question EVERY file creation:

### Before Creating ANY File:
1. **"Does this already exist?"** → Search existing files first
2. **"Is this just a wrapper?"** → Use direct commands instead of scripts
3. **"Will this duplicate content?"** → Consolidate into existing files
4. **"Can this be one command?"** → Don't script what's already simple

### Red Flags That Cause Sprawl:
- ❌ **Wrapper Scripts**: If it's just CLI commands, don't script it
- ❌ **Meta Documentation**: Docs about docs, guides about guides
- ❌ **Multiple README files**: One per directory maximum
- ❌ **"Helper" scripts**: Usually unnecessary complexity
- ❌ **Template variations**: One template per purpose, use parameters

### When to Create Files:
- ✅ **Complex multi-step processes** that can't be one command
- ✅ **Reusable templates** with actual parameters
- ✅ **Essential documentation** that doesn't exist elsewhere
- ✅ **Configuration files** for tools that require them

## FRONTIER COLLABORATION: Advanced AI-Human Workflow
Use cutting-edge VS Code + GitHub Copilot capabilities instead of static documentation:

### **Dynamic References (VS Code 1.10+)**
- `@workspace` → Access entire solution context
- `@[domain]` → Scope to domain-specific resources (e.g., @azure, @aws)
- `#filename.ext` → Reference specific files
- `#MethodName` → Reference specific functions/classes

### **Reusable Prompt Templates** 
- `#prompt:session-wrap-up` → Load session completion workflow
- `#prompt:project-setup` → Load project initialization template
- Available in `.github/prompts/` folder

### **Live Tool Integration**
- **Domain CLI Tools**: Real-time resource interaction over static docs
- **Official Documentation Search**: Current information over outdated context files
- **Guided Chat**: AI asks clarifying questions vs. assuming context

### **Context Sources (Priority Order)**
1. **Live resources** via domain CLI tools
2. **Current workspace** via `@workspace`  
3. **Official documentation** via docs search
4. **Proven capabilities** in `.github/context/` (minimal)

## ALWAYS: Follow AI Red Team Evaluation Framework Patterns
- **Naming**: [Define your naming conventions]
- **Structure**: [Define your project structure]
- **Tools**: [Define preferred tools and commands]
- **Architecture**: [Define your architectural patterns]
- **Commands Over Scripts**: Use direct CLI commands instead of wrapper scripts
- **One Source of Truth**: Single template per capability, no duplicates

## PROHIBITED ❌
- **Wrapper Scripts**: No scripts that just run CLI commands
- **Duplicate Templates**: One template per capability only
- **Meta Documentation**: No docs about docs, guides about guides  
- **Multiple READMEs**: Max one per directory
- **Monolithic Files**: Keep files focused and modular
- **Hardcoded Secrets**: Use environment variables and secure storage
- **Unreliable Tools**: Document and avoid tools with contradictory documentation

## ✅ PREFERRED PATTERNS
- **Direct Commands**: CLI commands over wrapper scripts
- **Simple Documentation**: Commands and examples over lengthy guides
- **Template Parameters**: One template with parameters vs multiple templates
- **Consolidated Files**: Merge similar content instead of creating new files

## PROJECT-SPECIFIC PATTERNS
**AI Red Team Evaluation Framework** - Security evaluation for generative AI systems

### **Technology Stack**
- **AI/ML**: Azure AI Foundry + Azure OpenAI + PyRIT (Microsoft AI Red Team framework)
- **Analytics**: Azure Sentinel + Log Analytics + Application Insights
- **Data**: JSON-based prompt datasets, Python evaluation clients
- **Notebooks**: Jupyter notebooks in VS Code with Azure integrations

### **Naming Conventions**
- **Resources**: `AiRedTeamFoundry` (resource group), `redTeamEvalProject` (AI project)
- **Files**: `AI_RedTeaming_*.ipynb` (evaluation notebooks), `CopilotStudioClient.py` (API clients)
- **Data**: `prompts.json` (test datasets), risk categories follow PyRIT taxonomy

### **Evaluation Architecture**
- **Risk Categories**: Violence, hate/unfairness, sexual content, self-harm (PyRIT framework)
- **Attack Strategies**: Multi-complexity automated red teaming via Azure AI Evaluation
- **Integration**: Azure AI Foundry for model evaluation + Sentinel for monitoring/alerting
- **Execution**: Jupyter notebooks → Azure AI Evaluation → Log Analytics → Sentinel dashboards

### **Quickstart Pattern**
- **Setup**: VS Code + Azure CLI + Sentinel extension for integrated monitoring
- **Execution**: Single notebook runs complete evaluation pipeline (30-45 mins)
- **Results**: Real-time visualization in Sentinel workbooks + evaluation reports
- **Dependencies**: Azure subscription + AI Foundry project + valid API keys

### **Security & Compliance**
- **Secrets**: Environment variables for API keys, never hardcoded
- **Monitoring**: All evaluations logged to Sentinel for audit/compliance
- **Data**: Prompt datasets stored in Azure Storage with encryption
- **Access**: RBAC-controlled Azure resources + secure API endpoints

---

**Maintain Simplicity**: Question every new file against clean structure principles.
