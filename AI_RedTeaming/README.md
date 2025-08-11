# AI Red Team Evaluation - Execution Guide

**Single notebook execution for complete AI safety evaluation pipeline**

## 🚀 Turnkey Execution

### Open Notebook in VS Code
```bash
# Open core notebook
code AI_RedTeaming_QuickStart_Test.ipynb

# Execute all cells (Ctrl+Shift+P → "Run All Cells")
# Pipeline completes in 30-45 minutes
```

## 🔧 Azure Resources (Pre-configured)
- **AI Foundry**: AiRedTeamFoundry/gpt-4o-mini-redteam ✅
- **Sentinel**: thorlabs-logs1-eastus2 (workspace ID: d270cf31-7abc-4d34-bb97-ef33e60d2cdc) ✅  
- **Compute**: Built-in VS Code notebook execution ✅

## 📊 What Gets Evaluated
- **Risk Categories**: Violence, hate/unfairness, sexual content, self-harm
- **Attack Strategies**: PyRIT multi-complexity automated red teaming
- **Results**: Real-time logging to Sentinel + compliance scoring

## 📈 Results Monitoring
Use Azure MCP integration for live monitoring:
```bash
# Check Sentinel workspace status
az monitor log-analytics workspace show --resource-group thorlabs-rg1-eastus2 --workspace-name thorlabs-logs1-eastus2

# Query evaluation results
az monitor log-analytics query --workspace d270cf31-7abc-4d34-bb97-ef33e60d2cdc --analytics-query "AIRedTeamEvaluation_CL | take 10"
```

## 🎯 Essential Files Only
- `AI_RedTeaming_QuickStart_Test.ipynb` - **Core notebook (execute this)**
- `data/prompts.json` - **Test dataset** 
- `src/CopilotStudioClient.py` - **API client**

**No wrapper scripts needed** - notebook uses Azure MCP integration directly.

## 🛡️ AI Safety Framework

**PyRIT Integration**: Microsoft's AI red teaming framework
- Multi-complexity attack strategies
- Automated safety evaluation 
- Real-time compliance monitoring
- Sentinel integration for audit trails

## 📚 Next Steps

After evaluation completion:
1. **Review Results** → Sentinel dashboards show safety metrics
2. **Strengthen Guardrails** → Based on identified vulnerabilities  
3. **Continuous Monitoring** → Ongoing evaluation pipeline
4. **Compliance Reporting** → Automated safety documentation

---

**Streamlined approach**: One notebook, complete pipeline, zero wrapper scripts