# ISR-LLM: Iterative Self-Refined Large Language Model for Long-Horizon Sequential Task Planning

**Authors:** Zhehua Zhou, Jiayang Song, Kunpeng Yao, Zhan Shu, Lei Ma  
**Year:** 2023  
**Citation Key:** zhouISRLLMIterativeSelfRefined2023  
**Venue:** Preprint (arXiv:2308.12742)  
**Institution:** University of Alberta, EPFL, University of Tokyo

## Abstract / Overview
This paper introduces ISR-LLM, a framework that enhances LLM-based task planning through iterative self-refinement. The framework converts natural language inputs to PDDL, generates initial plans with an LLM planner, then uses validators (LLM-based or external) to iteratively identify and correct errors, significantly improving success rates in long-horizon sequential task planning.

## Key Research Questions
- How can we improve the feasibility and correctness of LLM-generated action plans for long-horizon sequential tasks?
- What role can validators play in enabling pre-execution error correction through iterative refinement?
- How do different LLMs (GPT-3.5 vs GPT-4) and validator types (self-validator vs external) impact planning performance?

## Methodology

### Framework Architecture
The ISR-LLM framework operates in three sequential steps:

1. **Preprocessing with LLM Translator**
   - Converts natural language instructions to PDDL (Planning Domain Definition Language)
   - Uses few-shot in-context learning with domain-specific examples
   - Generates both domain file (predicates, actions) and problem file (objects, initial state, goals)

2. **Planning with LLM Planner**
   - Takes PDDL files as input
   - Employs Chain-of-Thought (CoT) prompting to decompose complex problems
   - Generates initial action sequence using few-shot examples

3. **Iterative Self-Refinement Loop**
   - **Validator** examines generated action sequence
   - Stops at first detected error and provides feedback
   - LLM planner revises plan based on feedback
   - Process repeats until no errors found or max iterations reached

### Validator Types
- **LLM-based Self-Validator**: Uses the LLM itself to assess plan correctness (low effort, potential for errors)
- **External Validator**: Uses auxiliary verification tools or custom validators (high accuracy, requires implementation effort)

### Experimental Domains
Three PDDL-based planning domains with n=3 and n=4 objects:

1. **Cooking Domain**
   - n pots, 6 ingredients
   - Actions: pick, put down, add to pot
   - Constraint: Each ingredient can only be picked once
   - Recipe specifies 2-4 ingredients per pot

2. **Blocksworld Domain**
   - n blocks on a table
   - Actions: pickup, putdown, stack, unstack
   - Goal: Stack blocks in prescribed order
   - Constraint: Only one block at a time, no moving blocks with others on top

3. **Ball Moving Domain**
   - n balls across 4 rooms
   - Actions: pick, drop, move between rooms
   - Constraint: Robot holds max 1 ball at a time

### Baseline
- **LLM-direct**: Direct PDDL-to-plan generation without refinement (based on prior work)
- Comparison methods: ISR-LLM-self (LLM validator), ISR-LLM-external (external validator)
- 30 randomly generated cases per task
- LLMs tested: GPT-3.5 and GPT-4

## Key Findings

### Success Rate Improvements (GPT-3.5)

| Domain | LLM-direct | ISR-LLM-self | ISR-LLM-external |
|--------|-----------|--------------|------------------|
| **Cooking (n=3)** | 47% | 67% (+20%) | 100% (+53%) |
| **Cooking (n=4)** | 40% | 53% (+13%) | 63% (+23%) |
| **Blocksworld (n=3)** | 20% | 37% (+17%) | 70% (+50%) |
| **Blocksworld (n=4)** | 10% | 17% (+7%) | 53% (+43%) |
| **Ball Moving (n=3)** | 33% | 50% (+17%) | 70% (+37%) |
| **Ball Moving (n=4)** | 17% | 27% (+10%) | 57% (+40%) |

### Success Rate Improvements (GPT-4)

| Domain | LLM-direct | ISR-LLM-self | ISR-LLM-external |
|--------|-----------|--------------|------------------|
| **Cooking (n=3)** | 100% | 100% | 100% |
| **Cooking (n=4)** | 100% | 100% | 100% |
| **Blocksworld (n=3)** | 43% | 60% (+17%) | 97% (+54%) |
| **Blocksworld (n=4)** | 40% | 60% (+20%) | 80% (+40%) |
| **Ball Moving (n=3)** | 93% | 100% (+7%) | 100% (+7%) |
| **Ball Moving (n=4)** | 90% | 93% (+3%) | 97% (+7%) |

### Key Observations

1. **External Validator Superiority**: External validators consistently outperform self-validators by 30-50% in GPT-3.5 tasks
2. **GPT-4 Dominance**: GPT-4 achieves 90-100% success in Cooking and Ball Moving domains even without refinement
3. **Task Complexity Impact**: 
   - Increasing objects (n=3 → n=4) decreases success rates across all methods
   - Blocksworld (logical reasoning) shows lower performance than Cooking/Ball Moving
4. **LLM Translator Impact**: Using PDDL representation improves self-validator performance by ~20% (Blocksworld n=3)
5. **Grounding Feasibility**: Generated PDDL actions can be directly grounded to robot motions (demonstrated in Isaac Sim)

## Important Concepts & Definitions

### Planning Domain Definition Language (PDDL)
Standardized encoding format consisting of:
- **Domain file**: Predicates (state space), action preconditions and effects (transition function)
- **Problem file**: Objects, initial state, goal conditions

### Task Planning Problem
Formal representation: P = ⟨S, A, T, s_init, G⟩
- **S**: Discrete set of states
- **A**: Finite set of actions
- **T**: Deterministic transition function T: S × A → S
- **s_init**: Initial state
- **G**: Set of goal states

### Chain-of-Thought (CoT) Prompting
Technique that decomposes complex problems into intermediate reasoning steps, enabling LLMs to solve tasks requiring multi-step logical thinking.

### Few-Shot In-Context Learning
Embedding illustrative examples within prompts to guide LLM responses without parameter fine-tuning.

### Iterative Self-Refinement
Process where validator identifies errors in generated plans, provides feedback, and LLM planner revises the plan—repeated until error-free or iteration limit reached.

## Formulas & Metrics

### Success Rate Calculation
**Success rate** = (Number of tasks accomplished correctly) / (Total number of tasks) × 100%

Evaluated across 30 randomly generated cases per domain configuration.

### Action Plan Correctness
A plan π = (a₁, a₂, ..., aₙ) is correct if:
- All action preconditions are satisfied at execution time
- Sequential application leads to goal state: sₙ₊₁ ∈ G
- s_{i+1} = T(sᵢ, aᵢ) for all 0 ≤ i ≤ n

### Validator Stopping Criterion
Validator stops at **first identified error** rather than analyzing entire sequence, since initial errors invalidate subsequent actions.

## Results & Statistics

### Performance by Domain Type
- **Instruction-following tasks** (Cooking): LLMs excel (GPT-4: 100% success)
- **Pattern-based tasks** (Ball Moving): High performance (GPT-4: 90-100%)
- **Logical reasoning tasks** (Blocksworld): Lower performance, benefits most from refinement (+40-54% with external validator)

### Complexity Scaling
Average success rate decrease when increasing objects (n=3 → n=4):
- **LLM-direct**: -7% to -16%
- **ISR-LLM-self**: -10% to -23%
- **ISR-LLM-external**: -13% to -37%

Blocksworld shows steepest degradation due to increased logical complexity.

### Translator Impact (Blocksworld n=3, GPT-3.5)
| Method | With Translator | Without Translator | Δ |
|--------|----------------|-------------------|---|
| LLM-direct | 20% | 13% | +7% |
| ISR-LLM-self | 36% | 16% | **+20%** |
| ISR-LLM-external | 70% | 63% | +7% |

Self-validator benefits most from PDDL's symbolic representation (+20% vs +7% for others).

## Limitations

### Acknowledged by Authors
1. **Lower than Traditional Planners**: Overall success rates don't yet exceed classical search-based PDDL planners (though offers greater generalizability)
2. **Inherent LLM Randomness**: Non-deterministic generation complicates formal correctness guarantees
3. **Safety-Critical Unsuitability**: Lack of hard guarantees makes framework inappropriate for safety-critical applications
4. **Reasoning Capability Bottleneck**: Performance limited by underlying LLM's logical reasoning abilities
5. **External Validator Cost**: High implementation effort for custom validators, though off-the-shelf PDDL validators exist (VAL, PDDL.jl)
6. **No Motion Planning**: Framework focuses on task planning; grounding to executable robot motions shown but not integrated

### Implicit Limitations
- Assumes domain knowledge available for few-shot examples
- Limited to fully observable, deterministic environments
- No comparison with fine-tuned LLMs or specialized planning models
- Evaluation limited to 3-4 objects; scalability to larger problems unclear
- No analysis of iteration count or computational cost
- Self-validator accuracy not quantified (only success rate impact measured)

## Relevance to Thesis

**Key connections:**
- **Planning as Core Competency**: Demonstrates LLMs' potential and limitations in sequential decision-making—critical for believable agent behavior
- **Self-Refinement for Believability**: Iterative error correction mirrors human-like learning and adaptation, potentially enhancing perceived agent intelligence
- **Evaluation Methodology**: Provides concrete metrics (success rate across domains) for assessing planning capabilities—applicable to evaluating NSP agents
- **Hybrid Architectures**: Shows value of combining LLMs with structured representations (PDDL) and external validators—relevant to multi-component agent design
- **Task Complexity Sensitivity**: Finding that logical reasoning tasks degrade more than instruction-following informs choice of agent tasks and evaluation scenarios

**Methodological relevance:**
- Few-shot prompting techniques directly applicable to NSP agent prompt engineering
- Validator-based refinement could improve believability through reduced errors
- Domain-specific evaluation (Cooking, Blocksworld, Ball Moving) provides templates for designing agent evaluation tasks

**Theoretical contribution:**
- Evidence that current LLMs struggle with long-horizon planning requiring complex logical reasoning
- Self-refinement as a mechanism to partially compensate for inherent LLM limitations
- Trade-offs between generalizability (natural language input) and performance (structured representations)

## Notable Quotes

> "LLMs are essentially engineered to generate word sequences that align with human-like context, yet the assurance of their planning capabilities is not guaranteed" (p. 2)

> "The efficacy and reliability of such LLM-based planners are often not satisfying due to the inherent design and training methodologies of LLMs" (p. 2)

> "While the external validator is capable of providing feedback to a degree of precision that identifies the exact action in which an error resides... the self-validator usually only provides an overarching estimation regarding the correctness of the entire generated action plan" (p. 10)

> "LLMs appear to excel in planning tasks that focus on adhering to specific instructions, such as Cooking, or performing repeated actions with identifiable patterns, e.g., Ball Moving. Conversely, when the planning tasks demand more complex logical thinking, as seen in the Blocksworld domain, their planning performance tends to diminish" (p. 10)

> "One limitation of the current LLM-based planners - even with the proposed ISR-LLM framework - is that the overall success rate often fails to exceed that of traditional search-based planners. However, as an initial exploratory work, we demonstrate the potential of utilizing LLM as a versatile and task-agnostic planner" (p. 10)

## References to Follow Up

### Highly Relevant to Thesis
1. **Huang et al. (2022c)** - "Inner monologue: Embodied reasoning through planning with language models" (arXiv:2207.05608)
   - Environmental feedback for online plan adjustment
   
2. **Valmeekam et al. (2022)** - "Large Language Models Still Can't Plan" (arXiv:2206.10498)
   - Blocksworld benchmark for evaluating LLM planning capabilities
   
3. **Madaan et al. (2023)** - "Self-refine: Iterative refinement with self-feedback" (arXiv:2303.17651)
   - General self-refinement framework for LLMs

### Classical Planning Background
4. **Haslum et al. (2019)** - "An introduction to the planning domain definition language"
   - PDDL reference guide

5. **Silver et al. (2023)** - "Generalized Planning in PDDL Domains with Pretrained Large Language Models" (arXiv:2305.11014)
   - Recent LLM+PDDL planning work

### Grounding and Execution
6. **Ahn et al. (2022)** - "Do as i can, not as i say: Grounding language in robotic affordances" (arXiv:2204.01691)
   - Language-to-action grounding

7. **Garrett et al. (2021)** - "Integrated task and motion planning"
   - TAMP overview (task + motion planning hierarchy)

## Tags
`#llm` `#planning` `#task-planning` `#pddl` `#self-refinement` `#evaluation` `#long-horizon` `#chain-of-thought` `#robotics` `#sequential-decision-making` `#validators` `#gpt3.5` `#gpt4` `#blocksworld` `#few-shot-learning`
