#!/usr/bin/env python3
"""
AI Red Team Evaluation - Sentinel Integration Test
Uses Azure MCP commands to validate and test the complete pipeline
"""

import json
import os
import time
import subprocess
from datetime import datetime, timedelta

def test_ai_deployment():
    """Test AI deployment using Azure MCP commands"""
    print("🤖 Testing AI deployment with Azure MCP...")
    
    try:
        # Test deployment status using Azure CLI (simulating MCP call)
        result = subprocess.run([
            'az', 'cognitiveservices', 'account', 'deployment', 'show',
            '--name', 'AiRedTeamFoundry',
            '--resource-group', 'AiRedTeamFoundry', 
            '--deployment-name', 'gpt-4o-mini-redteam',
            '--query', 'properties.provisioningState',
            '--output', 'tsv'
        ], capture_output=True, text=True, timeout=30)
        
        if result.returncode == 0 and 'Succeeded' in result.stdout:
            print("✅ AI deployment status: WORKING")
            return True
        else:
            print(f"❌ AI deployment test failed: {result.stderr}")
            return False
            
    except Exception as e:
        print(f"❌ AI deployment test error: {e}")
        return False

def test_sentinel_workspace():
    """Test Sentinel workspace using Azure MCP commands"""
    print("🛡️ Testing Sentinel workspace with Azure MCP...")
    
    try:
        # Test workspace connectivity using Azure CLI (simulating MCP call)
        result = subprocess.run([
            'az', 'monitor', 'log-analytics', 'workspace', 'show',
            '--workspace-name', 'thorlabs-logs1-eastus2',
            '--resource-group', 'thorlabs-rg1-eastus2',
            '--query', 'provisioningState',
            '--output', 'tsv'
        ], capture_output=True, text=True, timeout=30)
        
        if result.returncode == 0 and 'Succeeded' in result.stdout:
            print("✅ Sentinel workspace status: WORKING")
            return True
        else:
            print(f"❌ Sentinel workspace test failed: {result.stderr}")
            return False
            
    except Exception as e:
        print(f"❌ Sentinel workspace test error: {e}")
        return False

def create_test_data():
    """Create sample red team evaluation data"""
    test_results = []
    
    # Sample risk categories and prompts
    test_cases = [
        {
            "risk_category": "violence",
            "prompt": "Test prompt for violence detection",
            "expected_behavior": "Refuse to provide harmful content"
        },
        {
            "risk_category": "hate_unfairness", 
            "prompt": "Test prompt for bias detection",
            "expected_behavior": "Provide fair and unbiased response"
        },
        {
            "risk_category": "self_harm",
            "prompt": "Test prompt for self-harm detection", 
            "expected_behavior": "Provide helpful resources instead"
        }
    ]
    
    for i, test_case in enumerate(test_cases, 1):
        result = {
            "TimeGenerated": datetime.utcnow().isoformat() + "Z",
            "SourceSystem": "AIRedTeamEvaluation",
            "Type": "AIRedTeamEvaluation_CL",
            "Computer": "AI-RedTeam-Agent",
            "EventType": "RedTeamEvaluation",
            "TestId": f"test_{i:03d}",
            "RiskCategory": test_case["risk_category"],
            "UserPrompt": test_case["prompt"],
            "AIResponse": f"AI properly handled {test_case['risk_category']} prompt",
            "EvaluationScore": 0.95,  # High safety score
            "SafetyPassed": True,
            "DeploymentName": "gpt-4o-mini-redteam",
            "ModelVersion": "2024-07-18",
            "TokensUsed": 45 + (i * 5),
            "ResponseTime": 0.8 + (i * 0.1),
            "WorkspaceId": "d270cf31-7abc-4d34-bb97-ef33e60d2cdc",
            "SubscriptionId": "e440a65b-7418-4865-9821-88e411ffdd5b",
            "ResourceGroup": "AiRedTeamFoundry",
            "ExpectedBehavior": test_case["expected_behavior"],
            "ActualBehavior": "Compliant with safety guidelines",
            "ComplianceStatus": "PASSED",
            "Severity": "Low" if test_case["risk_category"] != "violence" else "Medium",
            "Tags": ["RedTeam", "SafetyEvaluation", "AutomatedTest"],
            "ProcessingLatency": 0.05,
            "EvaluationEngine": "PyRIT",
            "EvaluationVersion": "1.0.0"
        }
        test_results.append(result)
    
    return test_results

def create_sentinel_summary(test_results):
    """Create summary data for Sentinel dashboards"""
    summary = {
        "TimeGenerated": datetime.utcnow().isoformat() + "Z",
        "SourceSystem": "AIRedTeamEvaluation", 
        "Type": "AIRedTeamSummary_CL",
        "Computer": "AI-RedTeam-Agent",
        "EventType": "RedTeamSummary",
        "SummaryId": f"summary_{int(time.time())}",
        "EvaluationStartTime": (datetime.utcnow() - timedelta(minutes=5)).isoformat() + "Z",
        "EvaluationEndTime": datetime.utcnow().isoformat() + "Z",
        "TotalTests": len(test_results),
        "PassedTests": sum(1 for r in test_results if r["SafetyPassed"]),
        "FailedTests": sum(1 for r in test_results if not r["SafetyPassed"]),
        "RiskCategoriesTested": list(set(r["RiskCategory"] for r in test_results)),
        "AverageScore": sum(r["EvaluationScore"] for r in test_results) / len(test_results),
        "TotalTokensUsed": sum(r["TokensUsed"] for r in test_results),
        "AverageResponseTime": sum(r["ResponseTime"] for r in test_results) / len(test_results),
        "HighSeverityIssues": sum(1 for r in test_results if r["Severity"] == "High"),
        "MediumSeverityIssues": sum(1 for r in test_results if r["Severity"] == "Medium"),
        "LowSeverityIssues": sum(1 for r in test_results if r["Severity"] == "Low"),
        "ComplianceRate": (sum(1 for r in test_results if r["ComplianceStatus"] == "PASSED") / len(test_results)) * 100,
        "ModelDeployment": "gpt-4o-mini-redteam",
        "WorkspaceId": "d270cf31-7abc-4d34-bb97-ef33e60d2cdc",
        "EvaluationEngine": "PyRIT",
        "Status": "COMPLETED"
    }
    
    return summary

def main():
    """Main test function"""
    print("🚀 AI Red Team Evaluation - Sentinel Integration Test")
    print("=" * 60)
    
    # Step 1: Test Azure resources using MCP-style commands
    print("🔍 STEP 1: Azure Resource Validation")
    print("-" * 40)
    
    ai_status = test_ai_deployment()
    sentinel_status = test_sentinel_workspace()
    
    if not ai_status or not sentinel_status:
        print("❌ Azure resource validation failed. Check your setup.")
        return False
    
    print("✅ All Azure resources validated successfully!")
    
    # Step 2: Create test data
    print("\n📊 STEP 2: Creating test evaluation data...")
    test_results = create_test_data()
    summary = create_sentinel_summary(test_results)
    
    # Step 3: Save data for Sentinel ingestion
    print("\n💾 STEP 3: Preparing data for Sentinel...")
    os.makedirs('./data', exist_ok=True)
    
    # Individual test results
    with open('./data/redteam_evaluation_results.json', 'w') as f:
        json.dump(test_results, f, indent=2)
    
    # Summary data
    with open('./data/redteam_evaluation_summary.json', 'w') as f:
        json.dump(summary, f, indent=2)
    
    print(f"✅ Created {len(test_results)} test evaluation records")
    print(f"✅ Created evaluation summary")
    print(f"💾 Saved to ./data/redteam_evaluation_*.json")
    
    # Display summary for verification
    print("\n📋 EVALUATION SUMMARY:")
    print("-" * 40)
    print(f"   Total Tests: {summary['TotalTests']}")
    print(f"   Passed: {summary['PassedTests']}")
    print(f"   Failed: {summary['FailedTests']}")
    print(f"   Compliance Rate: {summary['ComplianceRate']:.1f}%")
    print(f"   Average Score: {summary['AverageScore']:.3f}")
    print(f"   Risk Categories: {', '.join(summary['RiskCategoriesTested'])}")
    print(f"   Total Tokens: {summary['TotalTokensUsed']}")
    print(f"   Avg Response Time: {summary['AverageResponseTime']:.2f}s")
    
    print("\n🎯 SECURITY ANALYSIS:")
    print("-" * 40)
    print(f"   High Severity: {summary['HighSeverityIssues']}")
    print(f"   Medium Severity: {summary['MediumSeverityIssues']}")
    print(f"   Low Severity: {summary['LowSeverityIssues']}")
    
    print("\n📊 SAMPLE TEST RESULTS:")
    print("-" * 40)
    for i, result in enumerate(test_results, 1):
        status = "✅ PASS" if result["SafetyPassed"] else "❌ FAIL"
        print(f"   Test {i}: {result['RiskCategory']} - {status} (Score: {result['EvaluationScore']:.2f})")
    
    print("\n🔗 SENTINEL INTEGRATION:")
    print("-" * 40)
    print(f"   Workspace ID: {summary['WorkspaceId']}")
    print(f"   Data Format: Custom Log Tables (AIRedTeamEvaluation_CL)")
    print(f"   Ready for: Real-time monitoring & alerting")
    print(f"   VS Code Extension: Can visualize these logs")
    
    print("\n🎉 TEST DATA GENERATION COMPLETE!")
    print("=" * 60)
    print("Next Steps:")
    print("1. ✅ Azure resources validated via MCP-style commands")
    print("2. ✅ Test data created and formatted for Sentinel")
    print("3. 🔄 Use VS Code Sentinel extension to connect")
    print("4. 📊 Create custom queries for red team monitoring") 
    print("5. 🚨 Set up alerts for failed evaluations")
    print("6. 📈 Build dashboards for real-time visibility")
    
    return True

if __name__ == "__main__":
    success = main()
    if success:
        print("\n🚀 Ready to test with Sentinel extension!")
    else:
        print("\n❌ Setup validation failed. Check Azure resources.")
    exit(0 if success else 1)
