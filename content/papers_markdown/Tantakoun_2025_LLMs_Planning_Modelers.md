# LLMs as Planning Modelers: A Survey for Leveraging Large Language Models to Construct Automated Planning Models

**Authors:** Marcus Tantakoun, Xiaodan Zhu, Christian Muise  
**Year:** 2025  
**Citation Key:** tantakounLLMsPlanningModelers2025

## Abstract / Overview
This comprehensive survey examines how Large Language Models (LLMs) can be leveraged to construct and refine Automated Planning (AP) models rather than directly perform planning. The authors position LLMs as tools for extracting planning models to support reliable AP planners, addressing the critical limitation that LLMs struggle with long-horizon planning requiring structured reasoning. The survey reviews ~80 papers and introduces L2P (Language-to-Plan), an open-source Python library implementing landmark approaches.

## Key Research Questions
- **RQ1**: How can LLMs accurately align with human goals, ensuring these models correctly represent desired specifications and objectives?
- **RQ2**: To what extent and granularity of detail can human-level instructions be effectively translated into accurate model definitions?

## Methodology

### Survey Approach
- **Scope**: Approximately 80 papers and technical reports focusing on LLMs-as-Modelers (not LLMs-as-Planners or LLMs-as-Heuristics)
- **Taxonomy**: Organized into three key areas:
  1. **Model Generation**: Task Generation, Domain Generation, Hybrid Generation
  2. **Model Editing**: Refinement and repair of planning models
  3. **Model Benchmarks**: Evaluation frameworks for LLM-driven AP
- **Venues**: ACL, ACM, AAAI, NeurIPS, ICAPS, COLING, ICML, ICRA, EMNLP, arXiv
- **Contributions**: Open-source L2P library with paper reconstructions

### Categorization Framework
Three paradigms of LLM+AP integration:
1. **LLMs-as-Heuristics**: Enhance search efficiency via heuristic guidance
2. **LLMs-as-Planners**: Directly generate action sequences or propose plans for refinement
3. **LLMs-as-Modelers**: Construct planners or planning models (survey focus)

## Key Findings

### 1. Model Generation (Three Categories)

#### Task Modeling (~30 papers)
- **Goal-only specification**: Few-shot prompting (Collins et al. 2022), Chain-of-Thought (Faithful CoT - Lyu et al. 2023)
- **Multi-agent collaboration**: DaTAPlan (Singh et al. 2024), PlanCollabNL (Izquierdo-Badiola et al. 2024)
- **Open-loop approaches**: LLM+P (Liu et al. 2023a) - uses in-context examples for same-domain problems
- **Closed-loop approaches**: Auto-GPT+P (Birr et al. 2024) - visual perception + error self-correction; PDDLEGO (Zhang et al. 2024a) - recursive task decomposition
- **Finding**: Task modeling is well-explored but relies on explicit NL-to-PDDL mapping requiring detailed predicate specification

#### Domain Modeling (~15 papers)
- **One-shot generation**: CLLaMP (Oates et al. 2024) - extracts action models from CVE descriptions
- **Generate-test-critique**: LLM+DM (Guan et al. 2023) - incrementally builds components with dynamic predicate list
- **Closed-loop frameworks**: ADA (Wong et al. 2023) - iterative symbolic task decomposition; COWP (Ding et al. 2023a) - augments action models when planning fails
- **Finding**: Domain construction is inherently more challenging than task specification; single-domain generation risks misalignment with human expectations

#### Hybrid Modeling (~15 papers)
- **Iterative refinement**: Kelly et al. 2023 - uses planner error messages for feedback; Smirnov et al. 2024 - JSON markup + consistency checks
- **Domain-agnostic systems**: NL2Plan (Gestrin, Kuhlmann, and Seipp 2024) - first offline end-to-end NL planning requiring minimal description
- **Open-world settings**: MORPHeus (Ye et al. 2024) - human-in-the-loop with anomaly detection; InterPret (Han et al. 2024) - interactive language feedback
- **Finding**: Coordination between domain and problem introduces complexity; linear pipelines risk cascading errors

### 2. Model Editing
- **Repair capabilities**: Gragera and Pozanco (2023) - LLM limitations in repairing unsolvable tasks
- **Error detection**: Patil (2024) - LLMs excel at syntactic errors but struggle with semantic inconsistencies
- **Semantic equivalence**: Sikes et al. 2024a - addresses heterogeneous information sources
- **Finding**: Current research shows promise for syntactic correction but semantic errors remain challenging

### 3. Model Benchmarks
- **Planning evaluation**: PlanBench (Valmeekam et al. 2023) - cost-optimal planning + verification; ACPBench (Kokel et al. 2024) - 13 domains, 22 SOTA models
- **NL conversion**: AutoPlanBench (Stein and Koller 2023) - converts PDDL to NL via LLMs
- **Contamination testing**: Mystery Blocksworld (Kambhampati et al. 2024) - obfuscates classic problems to detect data leakage
- **Task specification**: Planetarium (Zuo et al. 2024) - evaluates LLM-generated PDDL across abstraction levels
- **Domain extraction**: Text2World (Hu et al. 2025) - multi-criteria metrics (executability, structural similarity, F1 scores)
- **Finding**: Data leakage to LLM training remains a major challenge; need for routinely changing benchmark standards

## Important Concepts & Definitions

- **Automated Planning (AP)**: Synthesizes action sequences to transition from initial to goal states within environmental constraints
- **Classical Planning Problem**: Tuple M = ⟨S, sI, sG, A, T⟩ where S = state space, sI = initial state, sG = goal states, A = actions, T = transition function
- **PDDL (Planning Domain Definition Language)**: Standard encoding with two files:
  - **Domain (DF)**: Universal aspects - predicates defining state space S and actions A with parameters, preconditions, effects
  - **Problem (PF)**: Instance-specific - objects, initial state sI, goal state sG
- **LLM-Modulo Framework** (Kambhampati et al. 2024): Emphasizes soundness guarantees through iterative plan refinement via external verifiers
- **System I vs. System II**: LLMs excel at System I tasks (distributed learning) but struggle with System II cognition (planning, structured reasoning)
- **Operational Equivalence**: Reconstructed domains behave identically to original by agreeing on validity of action sequences

## Formulas & Metrics

### Planning Model Definition
- **State space**: S = finite, discrete set of states
- **Initial state**: sI ∈ S
- **Goal states**: sG ⊆ S
- **Actions**: A = set of symbolic actions
- **Transition function**: T(si, a) = si+1
- **Plan solution**: ϕ = ⟨a1, a2, ..., an⟩ where preconditions hold sequentially

### PDDL Action Schema
```
(:action action-name
  :parameters (?var1 - type1 ?var2 - type2)
  :precondition (and (predicate1 ?var1) (predicate2 ?var2))
  :effect (and (predicate3 ?var1) (not (predicate1 ?var1))))
```

### Evaluation Metrics (Text2World)
- **Executability**: Can generated PDDL be parsed and executed?
- **Structural Similarity**: Comparison to ground truth structure
- **Component-wise F1 scores**: Precision/recall for predicates, actions, effects
- **F1 = 2 × (precision × recall) / (precision + recall)**

### Believability Score (Referenced Context)
- β = ⟨AT, PT, ET, L, SR, ϒ, δ, Aw⟩ (from related agent research)

## Results & Statistics

### Survey Coverage
- **Total papers**: ~80 papers and technical reports
- **Distribution**: 
  - Task modeling: ~30 papers
  - Domain modeling: ~15 papers  
  - Hybrid modeling: ~15 papers
  - Model editing: ~5 papers
  - Benchmarks: ~10 papers

### Key Performance Findings
- **TIC** (Agarwal and Sreepathy 2024): Nearly 100% accuracy with GPT-3.5 Turbo across LLM+P planning domains using intermediate representations
- **LLM+P** (Liu et al. 2023a): Demonstrated that highly explicit descriptions improve translation accuracy
- **Contamination**: Text2World (Hu et al. 2025) reported high contamination rates in evaluation domains from prior work

### L2P Library
- **Implementations**: Reconstructs landmark papers (LLM+DM, LLM+P, NL2Plan, and others)
- **Components**: Builder classes for types, predicates, actions, task specifications
- **Validation**: Syntax validation tools with feedback integration
- **Availability**: Open-source, pip-installable

### Prompting Strategy Distribution
From Table 1 analysis:
- **Heavy (Few-shot)**: ~25% of frameworks
- **Medium (Few-shot/One-shot+)**: ~40% of frameworks
- **Light (CoT/Minimal)**: ~35% of frameworks

### Feedback Mechanisms
- **None**: ~30% of frameworks
- **LLM-based**: ~25% of frameworks
- **Environment-based**: ~20% of frameworks
- **Human-in-the-loop**: ~15% of frameworks
- **External tools**: ~10% of frameworks

## Limitations

### Acknowledged by Authors
1. **Scope limitation**: Focus limited to PDDL construction; techniques for other planning representations remain unexplored
2. **Coverage limitation**: Brief overview per work rather than exhaustive technical analysis
3. **Venue bias**: Primarily draws from ACL, ACM, AAAI, NeurIPS, ICAPS, COLING, ICML, ICRA, EMNLP, arXiv
4. **L2P library**: Currently supports only basic PDDL for fully observable deterministic planning; lacks tools for conditional, temporal, or numeric planning

### Broader Challenges Identified
1. **LLM planning limitations**: Cannot provide soundness guarantees, struggle with correctness and completeness
2. **Long-horizon planning**: Performance degrades with self-iterative feedback
3. **Action scaling**: Fail to account for effects and requirements as actions scale
4. **Semantic correctness**: LLMs better at syntactic than semantic error correction
5. **Data leakage**: Rapid contamination of training data with benchmark domains
6. **Alignment gap**: Generated models may be syntactically valid but semantically misaligned with human intent

## Relevance to Thesis

This survey is **highly relevant** to a thesis on believable agents and LLMs for several key reasons:

### Key Connections

1. **Planning for Agent Behavior**: Believable agents require coherent, goal-directed behavior over long horizons. This survey directly addresses how to construct planning models that can generate such behavior, positioning LLMs as model extractors rather than direct planners—critical for reliability.

2. **Neuro-Symbolic Integration**: The survey extensively covers neuro-symbolic approaches that combine LLM language understanding with formal planning systems. This is essential for believable agents that must translate natural language goals (from users or narratives) into executable action sequences.

3. **Evaluation Frameworks**: The benchmarking section (3.3) provides methodologies for evaluating LLM-generated planning models. For a thesis on believable agents, these evaluation frameworks could be adapted to assess whether agent behaviors align with human expectations.

4. **Multi-Agent Coordination**: Task modeling section covers multi-agent goal collaboration frameworks (DaTAPlan, PlanCollab NL, TwoStep, LaMMA-P), which are directly applicable to multi-agent believability scenarios like NPCs coordinating in games or simulations.

5. **Human-in-the-Loop Methods**: Several frameworks (Kelly et al. 2023, InterPret, MORPHeus, NL2Plan) incorporate human feedback mechanisms to ensure alignment with user expectations—a critical requirement for believable agent systems that must meet human standards of plausibility.

### Methodological Relevance

- **Prompt Engineering**: The survey categorizes prompting strategies (few-shot, CoT, medium/light/heavy) that could be applied to eliciting believable agent behaviors from LLMs
- **Feedback Mechanisms**: Taxonomy of feedback types (LLM, environment, human, external tools) provides design patterns for iteratively refining agent behavior models
- **Domain-Agnostic Modeling**: NL2Plan's minimal description approach aligns with the need for believable agents to operate across diverse scenarios without extensive manual specification

### Theoretical Contribution

- Addresses **RQ1** (alignment with human goals) and **RQ2** (granularity of instruction translation)—both critical for believable agents that must interpret high-level narrative or user intent
- Positions planning as System II cognition, complementing System I language understanding—this distinction is essential for agents exhibiting both reactive and deliberative believability

### Practical Application

- **L2P Library**: Provides ready-to-use tools for converting NL descriptions of agent goals/behaviors into formal PDDL specifications
- **Paper Reconstructions**: Implementation examples (LLM+DM, LLM+P) offer concrete starting points for building believable agent planning systems

### Limitations for Thesis Application

- Survey focuses on classical deterministic planning; believable agents may require probabilistic or temporal planning (acknowledged as L2P limitation)
- Most benchmarks use simplified domains; real believable agent scenarios involve richer state spaces and social constraints
- Limited coverage of affective/emotional components critical to believability (though this could be integrated via extended PDDL predicates)

## Notable Quotes

> "Large Language Models (LLMs) excel in various natural language tasks but often struggle with long-horizon planning problems requiring structured reasoning." (Abstract)

> "Acknowledging the challenges of LLMs' direct planning capabilities, Automated Planning (AP), or AI planning, presents a promising alternative to generate robust, optimal plans through logical and computational methods. Meanwhile, LLMs excel at extracting and refining classical planning models from Natural Language (NL), leaving the plan generation to classical planners and heuristics." (Introduction)

> "We consider the research on leveraging powerful LLMs to assist in constructing planning models to be of critical importance and a more promising approach than relying on LLMs to perform planning directly." (Section 3)

> "Note that deploying LLMs themselves in an end-to-end manner to perform planning still falls short of providing soundness guarantees and inherently struggle with correctness and completeness." (Section 3)

> "LLMs have demonstrated that they are significantly sensitive to prompting raising questions about whether they are better off functioning as machine translators or generators." (RQ2 Discussion)

> "The issue of extracting these planning models has long been recognized as a major barrier to the widespread adoption of planning technologies, a topic that has been explored in depth within the knowledge acquisition literature in AP for decades." (Conclusion)

> "Current approaches rely on an explicit mapping between NL and PDDL code, requiring users to specify each state predicate in detail." (Task Modeling Summary)

> "Current methods generate only a single domain, which risks misalignment with human expectations by failing to capture all necessary constraints. Future research should explore methods that generate multiple candidate domains." (Domain Modeling Summary)

## References to Follow Up

### Foundational Planning Papers
1. **McDermott et al. 1998** - PDDL: The Planning Domain Definition Language (foundational PDDL specification)
2. **Russell and Norvig 2020** - Artificial Intelligence: A Modern Approach (classical planning foundations)
3. **Kambhampati et al. 2024** - LLMs Can't Plan, But Can Help Planning in LLM-Modulo Frameworks (key position paper)

### Key LLM+Planning Frameworks
4. **Liu et al. 2023a** - LLM+P: Empowering Large Language Models with Optimal Planning Proficiency
5. **Guan et al. 2023** - Leveraging Pre-trained Large Language Models to Construct and Utilize World Models for Model-based Task Planning
6. **Gestrin, Kuhlmann, and Seipp 2024** - NL2Plan: Robust LLM-Driven Planning from Minimal Text Descriptions

### Evaluation & Benchmarking
7. **Valmeekam et al. 2023** - PlanBench: An Extensible Benchmark for Evaluating Large Language Models on Planning and Reasoning about Change
8. **Zuo et al. 2024** - Planetarium: A Rigorous Benchmark for Translating Text to Structured Planning Languages
9. **Hu et al. 2025** - Text2World: Benchmarking Large Language Models for Symbolic World Model Generation

### Related Surveys
10. **Huang et al. 2024b** - Understanding the planning of LLM agents: A survey
11. **Pallagani et al. 2024** - On the Prospects of Incorporating Large Language Models (LLMs) in Automated Planning and Scheduling (APS)
12. **Zhao et al. 2024** - A Survey of Optimization-based Task and Motion Planning: From Classical To Learning Approaches

### Multi-Agent Planning
13. **Singh et al. 2024** - DaTAPlan: Anticipate & Collab: Data-driven Task Anticipation and Knowledge-driven Planning
14. **Izquierdo-Badiola et al. 2024** - PlanCollabNL: Leveraging Large Language Models for Adaptive Plan Generation in Human-Robot Collaboration

### Interactive & Adaptive Planning
15. **Han et al. 2024** - InterPreT: Interactive Predicate Learning from Language Feedback for Generalizable Task Planning
16. **Ye et al. 2024** - MORPHeus: Multi-modal One-armed Robot-assisted Peeling System with Human Users In-the-loop
17. **Dagan, Keller, and Lascarides 2023** - Dynamic Planning with a LLM

## Tags
`#llm` `#planning` `#pddl` `#automated-planning` `#neuro-symbolic` `#task-planning` `#domain-modeling` `#model-generation` `#model-editing` `#benchmarking` `#survey` `#l2p-library` `#human-in-the-loop` `#multi-agent` `#prompt-engineering` `#believability` `#agents` `#evaluation-frameworks` `#soundness-guarantees` `#symbolic-planning`
