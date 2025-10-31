# Agentic Context Engineering: Evolving Contexts for Self-Improving Language Models

**Authors:** Qizheng Zhang, Changran Hu, Vamsidhar Kamanuru, Urmish Thakker, James Zou, Kunle Olukotun, Shubhangi Upasani, Boyuan Ma, Fenglu Hong, Jay Rainton, Chen Wu, Mengmeng Ji, Hanchen Li

**Year:** 2025

**Citation Key:** zhangAgenticContextEngineering2025

**Affiliations:** Stanford University, SambaNova Systems, UC Berkeley

## Abstract / Overview

ACE (Agentic Context Engineering) is a framework that treats LLM contexts as evolving playbooks rather than static prompts. Unlike existing methods that suffer from brevity bias and context collapse, ACE uses a modular process of generation, reflection, and curation to accumulate and refine domain-specific strategies. It achieves +10.6% on agent tasks and +8.6% on financial benchmarks while reducing adaptation latency by 86.9%.

## Key Research Questions

- How can LLM contexts be adapted to improve performance without modifying model weights?
- What causes existing context optimization methods to lose detailed knowledge over time?
- Can contexts serve as comprehensive playbooks that scale with long-context models while remaining interpretable?
- How can agents self-improve using only execution feedback, without labeled supervision?

## Methodology

### Framework Architecture
ACE employs an agentic architecture with three specialized components:

1. **Generator**: Produces reasoning trajectories for queries, surfacing effective strategies and pitfalls
2. **Reflector**: Critiques traces to extract lessons, with optional multi-iteration refinement
3. **Curator**: Synthesizes lessons into compact delta entries, merged deterministically into existing context

### Key Innovations

1. **Incremental Delta Updates**: Contexts represented as structured bullets with metadata (unique ID, helpful/harmful counters) and content (strategies, concepts, failure modes). Only relevant bullets updated, avoiding full rewrites.

2. **Grow-and-Refine Mechanism**: 
   - New bullets appended with unique IDs
   - Existing bullets updated in place
   - De-duplication via semantic embeddings
   - Can be proactive (after each delta) or lazy (when context limit exceeded)

3. **Multi-Epoch Adaptation**: Same queries revisited to progressively strengthen context

### Evaluation Setup

**Agent Benchmark:**
- AppWorld: Multi-turn reasoning, tool use, API interaction
- Splits: test-normal and test-challenge
- Metrics: Task Goal Completion (TGC), Scenario Goal Completion (SGC)

**Domain-Specific Benchmarks:**
- FiNER: Financial entity recognition (139 entity types) in XBRL documents
- Formula: XBRL value extraction and computation
- Metric: Exact match accuracy

**Baselines:**
- Base LLM (ReAct for agents)
- In-Context Learning (ICL)
- MIPROv2: Joint optimization of instructions and demonstrations
- GEPA: Genetic-Pareto prompt optimizer with reflection
- Dynamic Cheatsheet (DC): Test-time adaptive memory

## Key Findings

### Performance Gains

1. **Agent Tasks (AppWorld)**:
   - Offline: +12.3% over ICL, +11.9% over GEPA
   - Online: +7.6% over Dynamic Cheatsheet
   - Without GT labels: +14.8% over baseline (59.4% vs 42.4%)

2. **Financial Analysis**:
   - Average improvement: +12.8% with GT labels
   - FiNER: 78.3% (+7.6% over baseline)
   - Formula: 85.5% (+18.0% over baseline)

3. **Leaderboard Performance**:
   - Matches IBM CUGA (top-ranked, GPT-4.1-based) on average
   - Surpasses by +8.4% TGC on test-challenge split
   - Uses smaller open-source model (DeepSeek-V3.1)

### Efficiency Improvements

**Offline Adaptation (AppWorld):**
- Latency: -82.3% vs GEPA
- Rollouts: -75.1% vs GEPA

**Online Adaptation (FiNER):**
- Latency: -91.5% vs Dynamic Cheatsheet
- Token Cost: -83.6% vs Dynamic Cheatsheet

### Ablation Study Results

Impact of design choices on AppWorld:
- **Reflector with iterative refinement**: Substantial gains
- **Multi-epoch adaptation**: Progressive improvement (5 epochs used)
- **Offline warmup**: Boosts online adaptation by initializing with curated context

## Important Concepts & Definitions

- **Context Adaptation**: Modifying LLM inputs (instructions, strategies, evidence) rather than weights to improve performance
- **Brevity Bias**: Tendency of optimization to collapse toward short, generic prompts that omit domain-specific details
- **Context Collapse**: Phenomenon where iterative LLM rewriting degrades contexts into shorter, less informative summaries (e.g., 18,282 → 122 tokens with accuracy drop from 66.7% → 57.1%)
- **Bullet**: Structured memory unit with metadata (ID, counters) and content (strategy, concept, or failure mode)
- **Delta Context**: Small set of candidate bullets for incremental update
- **Grow-and-Refine**: Balance between context expansion and redundancy control through de-duplication

## Formulas & Metrics

### Evaluation Metrics

**Agent Tasks:**
- Task Goal Completion (TGC): Proportion of task goals achieved
- Scenario Goal Completion (SGC): Proportion of scenario goals achieved

**Domain-Specific:**
- Accuracy: Exact match proportion with ground truth

### Efficiency Metrics

- **Adaptation Latency Reduction**: (baseline_latency - ACE_latency) / baseline_latency × 100%
- **Token Cost**: Dollar cost for token ingestion and generation
- **Rollout Reduction**: Number of model execution traces needed

## Results & Statistics

### AppWorld Agent Benchmark

| Method | Test-Normal TGC | Test-Challenge TGC | Average |
|--------|----------------|-------------------|---------|
| ReAct baseline | 63.7% | 41.5% | 42.4% |
| ReAct + ICL | 64.3% (+0.6) | 46.0% (+4.5) | 46.0% (+3.6) |
| ReAct + GEPA | 64.9% (+1.2) | 46.4% (+4.0) | 46.4% (+4.0) |
| ReAct + ACE (offline) | 76.2% (+12.5) | 57.3% (+15.8) | 59.4% (+17.0) |
| ReAct + DC (online) | 66.0% (+2.3) | 46.0% (+4.5) | 51.9% (+9.5) |
| ReAct + ACE (online) | 69.6% (+5.9) | 48.9% (+7.4) | 59.5% (+17.1) |

### Financial Analysis Benchmarks

| Method | FiNER | Formula | Average |
|--------|-------|---------|---------|
| Base LLM | 70.7% | 67.5% | 69.1% |
| ICL | 72.3% (+1.6) | 67.0% (-0.5) | 69.6% (+0.5) |
| GEPA | 73.5% (+2.8) | 71.5% (+4.0) | 72.5% (+3.4) |
| ACE (offline) | 78.3% (+7.6) | 85.5% (+18.0) | 81.9% (+12.8) |
| ACE (online) | 76.7% (+6.0) | 76.5% (+9.0) | 76.6% (+7.5) |

### Cost Analysis

**Offline (AppWorld vs GEPA):**
- Latency: 9,517s vs 53,898s (-82.3%)
- Rollouts: 357 vs 1,434 (-75.1%)

**Online (FiNER vs DC):**
- Latency: 5,503s vs 65,104s (-91.5%)
- Token Cost: $2.90 vs $17.70 (-83.6%)

## Limitations

1. **Dependency on Reflector Quality**: If Reflector cannot extract meaningful insights, context becomes noisy/harmful
2. **Feedback Signal Requirement**: Performance degrades without reliable feedback (GT labels or execution signals)
3. **Not Universal**: Tasks with simple strategies (e.g., Game of 24) may not benefit from long contexts
4. **Domain Limitations**: Cannot extract insights domains where no model has knowledge

### When ACE Is Most Beneficial
- Detailed domain knowledge required
- Complex tool use needed
- Environment-specific strategies
- Multi-turn reasoning and planning

### When ACE Is Less Effective
- Simple, fixed-strategy tasks
- Tasks requiring concise high-level instructions only
- Absence of reliable feedback signals

## Relevance to Thesis

This paper is highly relevant to research on believable LLM-based agents as it addresses fundamental challenges in agent learning and adaptation. ACE demonstrates that agents can self-improve through experience accumulation without weight updates, using only execution feedback—a key requirement for believable autonomous systems.

**Key connections:**

1. **Agent Memory and Learning**: ACE's evolving playbook architecture directly supports agent believability by enabling continuous learning from interactions, similar to how believable characters adapt based on experience.

2. **Practical Deployment**: The efficiency gains (86.9% latency reduction) make context-based adaptation viable for production agents, addressing scalability concerns for believable agent systems.

3. **Interpretability**: Structured bullet-based contexts provide transparency into agent reasoning and learned strategies, supporting the interpretability requirements for believable agent behavior.

4. **Self-Improvement Without Supervision**: ACE's ability to work without labeled data using execution feedback aligns with autonomous believability requirements where agents must learn from environmental interactions.

5. **Methodology for Evaluation**: The comprehensive benchmark approach (agents + domain-specific tasks) and metrics (performance, cost, latency) provides a template for evaluating believable agent frameworks.

## Notable Quotes

> "Contexts should function not as concise summaries, but as comprehensive, evolving playbooks—detailed, inclusive, and rich with domain insights. Unlike humans, who often benefit from concise generalization, LLMs are more effective when provided with long, detailed contexts and can distill relevance autonomously." (p. 2)

> "A recurring limitation of context adaptation methods is brevity bias: the tendency of optimization to collapse toward short, generic prompts... such abstraction can omit domain-specific heuristics, tool-use guidelines, or common failure modes that matter in practice." (p. 2)

> "As applications such as agents and knowledge-intensive reasoning demand greater reliability, recent work has shifted toward saturating contexts with abundant, potentially useful information, enabled by advances in long-context LLMs." (p. 2)

> "On the AppWorld benchmark leaderboard, ACE matches the top-ranked production-level agent IBM-CUGA (powered by GPT-4.1) on average and surpasses it on the harder test-challenge split, while using a smaller open-source model (DeepSeek-V3.1)." (p. 2)

> "ACE is able to construct effective contexts without labeled supervision, instead leveraging execution feedback and environment signals—key ingredients for self-improving LLMs and agents." (p. 2)

> "Modern AI applications based on large language models (LLMs), such as LLM agents and compound AI systems, increasingly depend on context adaptation. Instead of modifying model weights, context adaptation improves performance after model training by incorporating clarified instructions, structured reasoning steps, or domain-specific input formats directly into the model's inputs." (p. 1-2)

## References to Follow Up

1. **Dynamic Cheatsheet** (Suzgun et al., 2025) - arXiv:2504.07952: Test-time learning with adaptive memory, foundational work for ACE
2. **GEPA** (Agrawal et al., 2025) - arXiv:2507.19457: Reflective prompt evolution baseline
3. **A-MEM** (Xu et al., 2025) - arXiv:2502.12110: Agentic memory for LLM agents with Zettelkasten-inspired organization
4. **AppWorld** (Trivedi et al., 2024) - arXiv:2407.18901: Benchmark for interactive coding agents
5. **Agent Workflow Memory (AWM)** (Wang et al., 2024) - arXiv:2409.07429: Reusable workflow extraction from agent trajectories
6. **Reflexion** (Shinn et al., 2023): Verbal reinforcement learning for agents
7. **TextGrad** (Yuksekgonul et al., 2024) - arXiv:2406.07496: Automatic differentiation via text
8. **IBM CUGA** (Marreed et al., 2025) - arXiv:2503.01861: Enterprise-ready computer using generalist agent

## Tags

`#llm-agents` `#context-engineering` `#prompt-optimization` `#self-improvement` `#agent-memory` `#test-time-adaptation` `#financial-analysis` `#incremental-learning` `#agentic-systems` `#compound-ai` `#long-context-llms` `#evaluation-benchmarks` `#efficiency` `#reflection` `#autonomous-agents`
