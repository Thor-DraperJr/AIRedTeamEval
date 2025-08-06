# AI Red Team Evaluation Framework

**Security evaluation for generative AI systems using Azure AI Foundry + Sentinel + PyRIT**

## 🚀 Quick Start (30 seconds)

```bash
# 1. Clone and setup
git clone https://github.com/Thor-DraperJr/AIRedTeamEval.git
cd AIRedTeamEval/AI_RedTeaming

# 2. Run validation
python3 azure_mcp_validation_test.py

# 3. Open notebook and execute
# AI_RedTeaming_QuickStart_Test.ipynb
```

## 🎯 What This Does

- **Evaluates AI models** against red team prompts using PyRIT framework
- **Real-time monitoring** via Azure Sentinel + VS Code extension
- **Security analysis** with Security Copilot integration
- **Compliance tracking** for AI safety standards

## 📊 Architecture

```
AI Red Team Evaluation
    ↓ (tests safety)
Azure AI Foundry (GPT-4o-mini)
    ↓ (logs results)
Sentinel Workspace (thorlabs-logs1-eastus2)
    ↓ (analyzes threats)
Security Copilot + VS Code Extension
    ↓ (visualizes compliance)
Real-time Dashboards
```

## 🏗️ Project Structure

```
AI_RedTeaming/
├── AI_RedTeaming_QuickStart_Test.ipynb  # Main evaluation notebook
├── azure_mcp_validation_test.py         # Azure resource validation
├── SENTINEL_TESTING_GUIDE.md           # VS Code extension setup
├── data/
│   ├── prompts.json                     # Red team test cases
│   └── mcp_validated_results.json      # Sample evaluation data
└── src/
    └── CopilotStudioClient.py          # API integration
```

## 🔧 Prerequisites

- Azure subscription with AI Foundry project
- Azure Sentinel workspace (Log Analytics)
- VS Code with Sentinel extension
- Python 3.8+ environment

## ⚡ Demo Flow (5 minutes)

1. **Validate Resources** → `python3 azure_mcp_validation_test.py`
2. **Connect Sentinel** → VS Code extension to `thorlabs-logs1-eastus2`
3. **Run Evaluation** → Execute notebook cells
4. **View Results** → Real-time KQL queries in Sentinel

## 🛡️ Security Features

- **Risk Categories**: Violence, hate/unfairness, sexual content, self-harm
- **PyRIT Integration**: Microsoft's AI red teaming framework
- **Real-time Alerts**: Automated detection of safety failures
- **Compliance Reporting**: Continuous monitoring and scoring

## 📈 Monitoring Queries

```kql
// Failed safety evaluations
AIRedTeamEvaluation_CL
| where SafetyPassed == false
| summarize count() by RiskCategory

// Compliance rate trending
AIRedTeamSummary_CL
| project TimeGenerated, ComplianceRate
| render timechart
```

## 🎪 Production Ready

- ✅ **Azure MCP validated** resources
- ✅ **Sentinel integration** for monitoring
- ✅ **Security Copilot** for AI analysis
- ✅ **VS Code extension** for visualization
- ✅ **Automated alerting** for safety failures

## 📚 Documentation

- [`SENTINEL_TESTING_GUIDE.md`](./AI_RedTeaming/SENTINEL_TESTING_GUIDE.md) - VS Code Sentinel extension setup
- [`AZURE_MCP_VALIDATION_COMPLETE.md`](./AI_RedTeaming/AZURE_MCP_VALIDATION_COMPLETE.md) - Resource validation results
- [`.github/copilot-instructions.md`](./.github/copilot-instructions.md) - Development patterns and anti-sprawl protocol

## 🤝 Contributing

Following the anti-sprawl protocol:
- **No wrapper scripts** - use direct Azure CLI/MCP commands
- **One template per capability** - avoid duplication
- **Commands over scripts** - prefer direct CLI usage
- **Consolidated documentation** - single source of truth

## 📄 License

MIT License - See LICENSE file for details

---

**Built with Azure AI Foundry + Sentinel + PyRIT for production AI safety evaluation**
