# Long-Horizon Planning for Multi-Agent Robots in Partially Observable Environments

**Authors:** Siddharth Nayak, Adelmo Morrison Orozco, Marina Ten Have, Vittal Thirumalai, Jackson Zhang, Darren Chen, Aditya Kapoor, Eric Robinson, Karthik Gopalakrishnan, James Harrison, Brian Ichter, Anuj Mahajan, Hamsa Balakrishnan

**Year:** 2024

**Citation Key:** nayakLongHorizonPlanningMultiAgent

**Venue:** NeurIPS 2024

## Abstract / Overview

This paper introduces LLaMAR (LM-based Long-Horizon Planner for Multi-Agent Robotics), a cognitive architecture that enables multiple robots to collaborate on long-horizon household and rescue tasks in partially observable environments. The system achieves a 30% higher success rate than state-of-the-art LM-based multi-agent planners by employing a plan-act-correct-verify framework that self-corrects from execution feedback without relying on oracles or simulators.

## Key Research Questions

- How can language models effectively coordinate multiple agents in long-horizon tasks within partially observable environments?
- Can LM-based planners operate without privileged simulator information while maintaining high success rates?
- What architectural design enables effective failure correction and subtask verification in multi-agent robotics?

## Methodology

### Architecture: LLaMAR Framework
The system uses four specialized LM modules in an iterative cycle:

1. **Planner Module**: Decomposes high-level instructions into feasible subtasks based on observations and memory
2. **Actor Module**: Determines high-level actions for each agent considering corrective feedback
3. **Corrector Module**: Self-corrects failed actions by reasoning about failures from execution feedback
4. **Verifier Module**: Validates subtask completion based on observations and executed actions

### Technical Approach
- **Model**: GPT-4V as underlying Vision-Language Model
- **Problem Formulation**: Partially Observable Markov Decision Process (POMDP)
- **Action Space**: Navigation actions (Move, Rotate, NavigateTo), Interaction actions (Pickup, Put, Open, Close, Slice, Clean, Toggle), Exploration actions
- **Exploration Strategy**: CLIP-based semantic guidance - agents rotate to 4 cardinal directions, compute cosine similarity between CLIP image embeddings and text embeddings of open subtasks, explore in highest-scoring direction
- **Action Parsing**: SentenceBERT fine-tuned to map free-form natural language outputs to executable actions (96.7% accuracy)

### Experimental Environments

**MAP-THOR (Multi-Agent Planning in THOR)**: 45 household tasks across 5 floor plans, categorized by instruction ambiguity:
- Explicit item type, quantity, and target
- Explicit item type and target, implicit quantity
- Explicit target, implicit item types and quantity  
- Implicit target, item type, and quantity

**SAR (Search & Rescue)**: Grid-world environment with:
- Fire extinguishing (Class A: water, Class B: sand)
- Human rescue (requires 2 agents to carry)
- Multiple fire sources with spread dynamics
- Unknown personnel locations

### Baselines Compared
- Act (direct LLM action selection)
- Chain-of-Thought
- ReAct
- SmartLLM (plan-and-execute paradigm)
- CoELA (decentralized multi-agent system)

## Key Findings

1. **Performance on MAP-THOR (2 agents)**:
   - Success Rate: 66% (vs. 34% for ReAct, 11% for SmartLLM)
   - Transport Rate: 91%
   - Coverage: 97%
   - Balance: 82%
   - 30% improvement over best baseline

2. **Scalability**: Performance improvements with 2-3 agents, though balance decreases with more agents (from 82% with 2 agents to 54% with 5 agents due to congestion and coordination complexity)

3. **Module Importance (Ablation Study)**:
   - Actor only: 33% SR, 67% TR
   - Planner + Actor + Verifier: 45% SR, 78% TR
   - Planner + Actor + Corrector (with oracle): 67% SR, 91% TR
   - Full LLaMAR (without oracle): 66% SR, 91% TR - nearly matching oracle performance

4. **Key Advantage**: Corrector module enables learning from failures - prevents repeated actions and timeout failures. Critical for self-correction without privileged information.

## Important Concepts & Definitions

- **CMAS (Centralized Multi-Agent System)**: All agents' decisions made simultaneously based on shared partial observations
- **DMAS (Decentralized Multi-Agent System)**: Each agent makes independent decisions
- **High-level actions**: Skills agents can perform (e.g., NavigateTo, PickUp)
- **Low-level actions**: Primitive actions executing high-level skills (learned policies or heuristics)
- **Subtasks**: Mid-level objectives that decompose the main task
- **Partial observability**: Agents have limited visibility (1.5m range, 90° FOV) requiring exploration
- **Plan-act-correct-verify cycle**: Iterative framework enabling self-correction from real execution feedback

## Formulas & Metrics

### Exploration Score
For direction $d$:

$$E_d = \sum_{i=1}^{|G_O|} \frac{g_{O,i} \cdot I_d}{\|g_{O,i}\| \|I_d\|}$$

where:
- $I_d$ = CLIP image embedding for direction $d$
- $g_{O,i}$ = CLIP text embedding for open subtask $i$
- Direction chosen: $d^* = \arg\max_d E_d$

### Evaluation Metrics

**Success Rate (SR)**: Fraction of episodes where all subtasks completed

**Transport Rate (TR)**: Fraction of subtasks completed within episode

**Coverage (C)**: Fraction of successful interactions with target objects

**Balance (B)**: Work distribution evenness across agents
$$B := \frac{\min\{s_1, \cdots, s_n\}}{\max\{s_1, \cdots, s_n\} + \epsilon}$$
where $s_i$ = successful tasks by agent $i$, $\epsilon = 10^{-4}$

**Average Steps (L)**: High-level actions taken (capped at L=30)

## Results & Statistics

### MAP-THOR Results (2-agent scenarios)

| Method | SR | TR | Coverage | Balance |
|--------|----|----|----------|---------|
| Act | 0.33 | 0.67 | 0.91 | 0.59 |
| ReAct | 0.34 | 0.72 | 0.92 | 0.67 |
| CoT | 0.14 | 0.59 | 0.87 | 0.62 |
| SmartLLM | 0.11 | 0.23 | 0.91 | 0.45 |
| CoELA | 0.25 | 0.46 | 0.76 | 0.73 |
| **LLaMAR** | **0.66** | **0.91** | **0.97** | **0.82** |

All differences statistically significant with 95% confidence intervals reported.

### SAR Results (2-agent)
- SR: 0.44, TR: 0.86, Coverage: 0.94, Balance: 0.91

### Scaling Analysis
- **1 agent**: SR=0.37, Balance=1.00 (by definition)
- **2 agents**: SR=0.62, Balance=0.82
- **3 agents**: SR=0.70 (peak), Balance=0.66
- **4-5 agents**: SR plateaus ~0.62-0.68, Balance drops to 0.54

Interpretation: Peak performance at 3 agents; beyond this, coordination overhead and physical congestion limit gains.

## Limitations

1. **Higher computational cost**: 4 LM queries per decision step vs. single query for baselines (plan-and-execute)
2. **Limited spatial reasoning**: LMs struggle with navigating around obstacles, shortest path planning, understanding 3D spatial relationships
3. **Performance bounded by VLM capabilities**: 
   - Occasional misunderstanding of environment rules
   - Difficulty determining appropriate abstraction level (e.g., assuming multi-step cleaning vs. single CleanObject action)
   - Hallucination of objects not present
4. **Mutual interference**: Agents sometimes block each other without recognizing it
5. **Unobservability bias**: Tends to under-explore when objects not immediately visible
6. **SentenceBERT mapping errors**: 3.3% failure rate in mapping natural language to executable actions (incorrect object mapping, wrong object enumeration)
7. **Episode length constraints**: L=30 steps may be insufficient for complex tasks under strict partial observability (though metrics plateau around this value)

## Relevance to Thesis

### Direct Relevance to Believable Multi-Agent Systems

**Multi-Agent Coordination Architecture**: LLaMAR demonstrates a centralized planning approach (CMAS) that outperforms decentralized systems (DMAS) by 41 percentage points in success rate. This has direct implications for designing believable agent teams - centralized coordination may be more effective for coherent group behavior.

**Key connections:**
- **Cognitive architecture for believability**: The modular plan-act-correct-verify cycle mirrors human-like reasoning processes - planning ahead, attempting actions, learning from failures, verifying outcomes
- **Partial observability and exploration**: Realistic agents must operate under incomplete information and actively explore, not assume omniscience - critical for believable behavior in open-world scenarios
- **Failure recovery and adaptation**: The Corrector module's ability to reason about failures and suggest corrections (e.g., "action failed because agent was too far, must navigate closer first") demonstrates human-like problem-solving

### Methodological Contributions for Thesis Research

1. **Evaluation framework**: MAP-THOR's task taxonomy (explicit to implicit instructions) provides a model for evaluating believable agents across varying levels of instruction clarity
2. **Balance metric**: Measuring work distribution across agents (B score) could be adapted to evaluate believable team dynamics - do agents contribute fairly?
3. **Ablation methodology**: Systematic module removal shows which components are essential for believable planning (planning, acting, correction, verification)

### Limitations Relevant to Believability

- **Spatial reasoning gaps**: Same limitation affects believability - humans have intuitive spatial understanding that current LLMs lack
- **Mis-generalization**: Agents sometimes over-complicate tasks or under-explore - affects believability if agents behave unnaturally
- **VLM-bounded performance**: Believability ceiling constrained by underlying model capabilities

## Notable Quotes

> "The key insight of our work is that integrating a plan-act-correct-verify framework with LMs enables a robust and adaptive approach to multi-agent task planning in dynamic, partially observable environments that allows agents to: (1) plan subtasks required to complete the task, (2) select high-level actions for each agent to complete the proposed subtasks, (3) identify and correct failures after high-level action execution, and (4) self-verify subtask completion based on high-level action execution." (p. 2)

> "Unlike existing methods, our approach uses real-time execution feedback, observations, and agent histories to iteratively refine action planning and execution. This allows agents to adjust strategies based on reasoned insights on action execution, effectively addressing failures without relying on perfect environmental knowledge or oracle feedback." (p. 2)

> "The correction and verification process in our cognitive architecture is grounded in the environment's reality, which sets it apart from LM self-verification methods that lack such grounding." (p. 2)

> "By contrast, LLaMAR does not assume perfect knowledge of the environment, does not rely on oracle feedback, and does not assume perfect execution of low-level primitive policies. This approach moves us closer to enabling real-world robots that operate independently of privileged knowledge." (p. 2)

> "While LMs tasked with reasoning about multiple inputs and providing long outputs perform poorly. We iterate through these four modules at every high-level decision step." (p. 4) - justification for modular architecture

> "Although LMs make correct reasoning most of the time, they still occasionally make mistakes, including misunderstanding the environment rules specified in the prompt. For example, the agent assumes that the cleaning task requires putting soap, drying, and putting it in the sink when all it needs is the action 'CleanObject', and can't figure out the appropriate level of abstraction." (p. 10)

## References to Follow Up

1. **SayCan** (Ichter et al., 2023) - Combining value functions with LLM predictions for long-horizon tasks
2. **ProgPrompt** (Singh et al., 2023) - Generating situated robot task plans using LLMs
3. **Inner Monologue** (Huang et al., 2023) - Embodied reasoning through planning with language models
4. **CoELA** (Zhang et al., 2024) - Building cooperative embodied agents with LLMs (decentralized approach)
5. **SmartLLM** (Kannan et al., 2023) - Multi-agent robot task planning baseline
6. **ALFRED** (Shridhar et al., 2019) - Benchmark for grounded instructions in everyday tasks
7. **BEHAVIOR-1K** (Li et al., 2023) - Embodied AI benchmark with 1,000 everyday activities

## Tags

`#multi-agent` `#llm-planning` `#embodied-ai` `#partial-observability` `#long-horizon-planning` `#cognitive-architecture` `#robotics` `#task-decomposition` `#failure-recovery` `#vision-language-models` `#evaluation-framework` `#coordination` `#exploration`
