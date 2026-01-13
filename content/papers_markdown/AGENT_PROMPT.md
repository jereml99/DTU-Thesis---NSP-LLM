# Agent Prompt: Process Next Paper from Queue

Copy this prompt to give to a Copilot agent (or use directly in chat):

---

## Task: Process Next Academic Paper to Markdown Summary

Please help me process the next paper from the bibliography queue:

### Step 1: Claim the Next Paper
Run this command to atomically claim the next available paper:
```bash
cd /home/ledwo/DTU-Thesis---NSP-LLM/content/papers_markdown
./process_next_paper.sh agent_$(date +%s)
```

### Step 2: Convert PDF to Markdown
The script will display the paper details. Use the **markitdown MCP server** to convert:
- Tool: `mcp_microsoft_mar_convert_to_markdown`
- URI: Use the `file://` path shown in `$CURRENT_PDF_PATH`

### Step 3: Create Structured Summary
Create a comprehensive markdown file at `$CURRENT_OUTPUT_FILE` with this structure:

```markdown
# [Paper Title]

**Authors:** [Author list]
**Year:** [Year]
**Citation Key:** [BibTeX key]

## Abstract / Overview
[Brief 2-3 sentence overview of the paper's main contribution]

## Key Research Questions
- [Question 1]
- [Question 2]

## Methodology
[Describe the research approach, experiments, datasets, etc.]

## Key Findings
1. **[Finding 1]**: [Description]
2. **[Finding 2]**: [Description]
3. **[Finding 3]**: [Description]

## Important Concepts & Definitions
- **[Concept 1]**: [Definition]
- **[Concept 2]**: [Definition]

## Formulas & Metrics
[If applicable, include key equations, evaluation metrics, algorithms]

Example:
- Believability score: β = ⟨AT, PT, ET, L, SR, ϒ, δ, Aw⟩
- Evaluation metric: F1 = 2 × (precision × recall) / (precision + recall)

## Results & Statistics
[Key quantitative results, performance metrics, statistical significance]

Example:
- Accuracy: 87.3% (p < 0.01)
- Sample size: n = 500 participants
- Cohen's d = 0.45 (medium effect)

## Limitations
[Acknowledged limitations from the paper]

## Relevance to Thesis
[3-5 sentences explaining how this paper relates to the thesis on believable agents and LLMs]

**Key connections:**
- [Connection to research question]
- [Methodological relevance]
- [Theoretical contribution]

## Notable Quotes
> "[Significant quote 1]" (p. X)

> "[Significant quote 2]" (p. Y)

## References to Follow Up
[List 2-3 important papers cited that might be worth reviewing]

## Tags
`#believability` `#llm` `#agents` `#evaluation` [add relevant tags]
```

### Step 4: Mark as Complete
After saving the summary file, mark the paper as processed:
```bash
./process_next_paper.sh agent_$(date +%s) --complete $CURRENT_PAPER_ID
```

Or integrate this into a single command workflow.

### Step 5: Process Next Paper (Optional)
If running in a loop, repeat from Step 1 until the queue is empty.

---

## Quality Guidelines

### Summary Length
- **Minimum**: 2KB (short papers, focused topics)
- **Target**: 4-6KB (most papers)
- **Maximum**: 8KB (comprehensive review papers)

### Focus Areas
Prioritize information relevant to:
1. **Believability** in agents/characters/NPCs
2. **LLM-based agent architectures**
3. **Evaluation methodologies** for agents
4. **Planning and reasoning** in AI systems
5. **Personalization and adaptation**
6. **Simulation of human behavior**

### Extraction Priorities
1. **Metrics & formulas** - exact notation
2. **Statistical results** - with significance values
3. **Architectural diagrams** - describe in text if visual
4. **Evaluation frameworks** - methods and benchmarks
5. **Datasets used** - names, sizes, sources
6. **Limitations** - acknowledged by authors

### Citation Integration
- Reference using BibTeX key from `bibliography.bib`
- Format: `[@batesRoleEmotionBelievable1994]` for inline
- Connect to other processed papers when relevant

---

## Error Handling

### If PDF Not Found
```bash
# Check if path needs conversion
ls -la /home/ledwo/Zotero/storage/[STORAGE_ID]/
# Or check the symlink
ls -la /home/ledwo/DTU-Thesis---NSP-LLM/content/papers/
```

### If Conversion Fails
- Try smaller chunks if PDF is very large
- Check if PDF is corrupted or password-protected
- Mark as failed in queue and move to next paper

### If Lock Times Out
- Wait and retry - another agent may be claiming papers
- Check `.processing_queue.json.lock` doesn't exist (remove if stale)

---

## Parallel Processing Tips

### Running Multiple Agents
Each agent should use unique ID:
```bash
# Agent 1
./process_next_paper.sh agent1

# Agent 2  
./process_next_paper.sh agent2

# Agent 3
./process_next_paper.sh agent3
```

### Coordination
- Lock file prevents double-processing
- Each agent gets unique paper atomically
- Status updates are synchronized via queue file

### Monitoring Progress
```bash
# Check remaining papers
jq '.remaining' .processing_queue.json

# See what's being processed
jq '.papers[] | select(.status == "processing")' .processing_queue.json

# List completed
jq '.completed_papers[].title' .processing_queue.json
```

---

## Example Session

```bash
# Terminal output:
🤖 Agent: agent_1730332800
📄 Processing: Evolving to be Your Soulmate: Personalized Dialogue Agents with Dynamically Adapted Personas
   ID: chengEvolvingBeYour2024
   PDF: /home/ledwo/Zotero/storage/DSP8PDYR/Cheng et al. - 2024 - Evolving to be Your Soulmate.pdf
   Output: Cheng_2024_Evolving_Soulmate.md
   Resolved: /home/ledwo/Zotero/storage/DSP8PDYR/Cheng et al. - 2024 - Evolving to be Your Soulmate.pdf

🚀 Ready for Copilot to process this paper!

# Now you would:
# 1. Convert using markitdown MCP
# 2. Create Cheng_2024_Evolving_Soulmate.md with structured summary
# 3. Run: ./process_next_paper.sh agent_1730332800 --complete chengEvolvingBeYour2024
```

---

## Ready to Start?

Simply run:
```bash
cd /home/ledwo/DTU-Thesis---NSP-LLM/content/papers_markdown
./process_next_paper.sh
```

And I'll process the paper that gets claimed!
