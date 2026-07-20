"""
Terrafrom plan Analyzer -- diagnoses terraform plan and return what would change.
Run: python3 terraform_plan_analyzer.py
"""

import subprocess
from langchain_ollama import ChatOllama
from langchain_core.tools import tool
from langchain.agents import create_agent as create_react_agent

@tool
def terraform_plan(project_path: str = ".") -> str:
    """Run terraform plan and return the output showing what would change."""
    result = subprocess.run(
        ["terraform","plan","-no-color"],
        capture_output=True, text=True,
        cwd=project_path
    )
    output = result.stdout + result.stderr
    if len(output) > 5000:
        output = output[:5000] + "\n[...truncated]"
    return output

llm = ChatOllama(model="gemma4",temperature=0)
tools = [terraform_plan]
agent = create_react_agent(llm, tools)

print("\nTeraaform Plan Analyzer")
print("-" * 40)
print("I analyze Terraform Plan.")
print("Run this inside a terraform init folder.")
print("Type 'quit' to exit.\n")

while True:
    question = input("> ").strip()
    if question.lower() in ("quit", "exit", "q"):
        break
    if not question:
        continue

    print("\nThinking...\n")
    result = agent.invoke({"messages": [("user", question)]})
    print(result["messages"][-1].content)
    print()