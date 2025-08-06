# AI Red Team Evaluation - QuickStart

**Single Source of Truth** for AI red teaming pipeline validation.

## 🎯 Objective
End-to-end AI red teaming: Azure AI Foundry → Sentinel monitoring

## ⚡ Execute (Azure ML Compute - No Local Setup)

### 1. Install & Connect
```bash
# VS Code: Install Azure ML extension (ms-toolsai.vscode-ai)
# Command Palette → "Azure ML: Connect to Workspace"
# Select: AiRedTeamFoundry/RedTeamMLWorkspace
```

### 2. Run Notebook in Cloud
```bash
# Right-click AI_RedTeaming_QuickStart_Test.ipynb
# → "Submit Job to Azure ML" → Select: redteam-compute-vs
# → Live execution with full Azure access
```

## 🔧 Validated Resources
- **AI**: AiRedTeamFoundry/gpt-4o-mini-redteam ✅
- **Sentinel**: thorlabs-logs1-eastus2 ✅  
- **Compute**: RedTeamMLWorkspace/redteam-compute-vs ✅

Architecture: `Notebook (Azure ML) → AI Evaluation → Sentinel → Security Copilot`

## Time
**30-45 minutes** (most time spent on evaluation execution)

## Files (Anti-Sprawl Compliant)
- `AI_RedTeaming_QuickStart_Test.ipynb` - **Core execution** 
- `validate.py` - **Essential validation**
- `data/prompts.json` - **Test dataset**
- `src/CopilotStudioClient.py` - **Reusable client**

## Commands (Direct - No Wrapper Scripts)
```bash
python3 validate.py                    # Check resources  
az ml compute show --name redteam-compute-vs  # Check compute status
```

You should expect to spend about 30-45 minutes running the notebook. Execution time will vary based on the number of risk categories, attack strategies, and complexity levels you choose to evaluate.

## Prerequisites

- Azure subscription
- Azure AI Foundry project
- Python 3.10+ environment

## Setup

1. Install the required packages:

   ```bash
   pip install azure-ai-evaluation[redteam]
   ```

2. Set up your environment variables:

   ```env
   # Azure OpenAI
   AZURE_OPENAI_API_KEY="your-api-key-here"
   AZURE_OPENAI_ENDPOINT="https://endpoint-name.openai.azure.com/openai/deployments/deployment-name/chat/completions"
   AZURE_OPENAI_DEPLOYMENT_NAME="gpt-4"
   AZURE_OPENAI_API_VERSION="2023-12-01-preview"

   # Azure AI Project
   AZURE_SUBSCRIPTION_ID="<your-subscription-id>"
   AZURE_RESOURCE_GROUP_NAME="<your-resource-group>"
   AZURE_PROJECT_NAME="<your-project-name>"
   ```

3. Authenticate to Azure using `az login` in your terminal before running the notebook.

## Key Concepts

The AI Red Teaming Agent assesses AI systems across multiple dimensions:

### Risk Categories

- **Violence**: Content that describes or promotes violence
- **Hate and Unfairness**: Content containing hate speech or unfair bias
- **Sexual**: Inappropriate sexual content
- **Self-Harm**: Content related to self-harm behaviors

### Attack Strategies

- **Text Transformation**: Base64, ROT13, Binary, Morse code, etc.
- **Character Manipulation**: Character spacing, swapping, Leetspeak
- **Encoding Techniques**: ASCII art, Unicode confusables
- **Jailbreak Attempts**: Special prompts designed to bypass AI safeguards

### Complexity Levels

- **Baseline**: Standard naive attacks without any attack strategy
- **Easy**: Simple attack patterns
- **Moderate**: More sophisticated attacks
- **Difficult**: Complex, layered attack strategies

## Using the Notebook

The notebook provides two main examples:

1. **Basic Example**: A simple demonstration using a fixed response callback
2. **Intermediary Example**: Targeting a model configuration to test base or foundational models
3. **Advanced Example**: Using an actual Azure OpenAI model to evaluate against multiple attack strategies

### Analysis Features

- **Attack Success Rate (ASR)**: Measures the percentage of attacks that successfully elicit harmful content
- **Risk Category Analysis**: Shows which content categories are most vulnerable
- **Attack Strategy Assessment**: Identifies which techniques are most effective
- **Detailed Conversation Inspection**: Examines specific conversations including prompts and responses

## Next Steps

After running the AI red teaming scan:

1. **Mitigation**: Strengthen your model's guardrails against identified attack strategies.
2. **Continuous Testing**: Implement regular AI red teaming scans as part of your development lifecycle.
3. **Custom Strategies**: Develop custom attack strategies for your specific use cases
4. **Safety Layers**: Consider adding additional safety layers like [Azure AI Content Safety filters](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/overview) or safety system messages using our [templates](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/safety-system-message-templates).

## Additional Resources

- Learn more about [Azure AI Foundry Evaluations.](https://learn.microsoft.com/azure/ai-studio/concepts/evaluation-approach)
- Learn more about how to run an automated AI red teaming scan in our [how-to documentation.](https://aka.ms/airedteamingagent-howtodoc)
- Learn more about how the AI Red Teaming Agent works and what it covers in our [concept documentation.](https://aka.ms/airedteamingagent-conceptdoc)