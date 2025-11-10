# Chapter 2 – Theoretical Background

This chapter establishes the conceptual foundations and reviews the relevant prior work motivating this thesis. It first defines the core concepts—large language models (LLMs), agents, and planning paradigms—with particular emphasis on symbolic planning formalisms such as PDDL and how LLMs can be leveraged to generate such formalisms. It then reviews research on LLM-driven generative agents, focusing on the seminal "Generative Agents" paper [Park et al., 2023], and examines hybrid neuro-symbolic approaches that combine LLM flexibility with symbolic planning guarantees [Huang et al., 2024; Tantakoun et al., 2025]. Throughout, we emphasize the challenge of maintaining coherence (adherence to environmental constraints) and believability (human-perceived realism) in LLM-driven agents. A running example—an NPC simulating a university student managing academic and social commitments—illustrates how different planning paradigms address logical inconsistencies and incoherent action sequences.

## 2.2 Core Concepts and Definitions

### 2.2.1 Large Language Models (LLMs)

Large language models are transformer-based sequence predictors trained on large corpora to estimate conditional token distributions [Vaswani et al., 2017; Brown et al., 2020]. Given a context window, an LLM generates text autoregressively by sampling or selecting from the next-token distribution. Self-attention mechanisms enable integration of information across prompts, in-context examples, and tool-augmented inputs, yielding capabilities such as instruction following, few-shot generalization, and approximate commonsense reasoning [Wei et al., 2022; Kojima et al., 2022].

Critically for planning applications, LLMs do not perform deductive logical inference with formal guarantees. They execute pattern-conditioned statistical inference that can be steered via prompting but remains fundamentally non-symbolic. Recent work has shown that LLMs can generate structured outputs such as PDDL action schemas and task specifications when prompted with domain descriptions [Tantakoun et al., 2025; Huang et al., 2024], but these outputs require external validation to ensure logical consistency and adherence to constraints.

In this thesis, the LLM serves two primary functions: (i) generating PDDL schemas from natural language domain descriptions, and (ii) proposing high-level goals and task decompositions grounded in agent memory and social context. The symbolic planning layer then validates these LLM-generated artifacts against environmental constraints and 
<!-- review-Jeremi: We start with a validator only it's still the LLM that dose the plan --> produces executable, coherent action sequences.

### 2.2.2 Agents and Believability

An agent is an entity that perceives its environment through sensors and acts upon it through actuators [Russell and Norvig, 2021]. In simulated environments and games, non-player characters (NPCs) extend this notion: their primary purpose is not numerical reward maximization but producing behavior that human observers find plausible, consistent, and engaging over time [Mateas, 2002; Loyall, 1997].

**Believability** is defined as the human-perceived realism of an agent's behavior—whether actions align with the character's goals, personality, knowledge, and social norms [Loyall, 1997; Mateas, 2002]. Believability is enhanced when agents exhibit behavior that respects physical and environmental boundaries; research has shown that agents constrained by realistic physical limitations (e.g., location constraints, action durations, resource requirements) are perceived as more believable than those that violate such boundaries [Bates, 1994; Loyall, 1997; Bogdanovych et al., 2016]. Recent work has operationalized believability evaluation through human studies using Likert ratings, pairwise preferences, and Turing-style interviews [Park et al., 2023; Xiao et al., 2024]. Park et al. demonstrated that LLM-driven agents with memory, reflection, and planning mechanisms were rated more believable than human crowdworkers in controlled evaluations [Park et al., 2023].

**Coherence** is the causal and temporal consistency of behavior—whether actions are feasible, properly ordered, and do not contradict prior commitments or environmental constraints [Young, 2001; Riedl and Young, 2010]. This can be measured through constraint adherence metrics: violations of environmental invariants, temporal overlaps, resource limit breaches, and unsatisfied action preconditions. In our running example, a coherent agent must not schedule overlapping commitments (e.g., attending two classes simultaneously) or attempt impossible actions (e.g., submitting an assignment before completing it).

This thesis adopts the NPC perspective where believability is the primary objective. We hypothesize that coherence—enforced through symbolic planning—is a necessary but not sufficient condition for believability. The neuro-symbolic approach aims to maintain the naturalistic, context-aware behavior of LLM agents while eliminating the logical inconsistencies that undermine perceived realism.

### 2.2.3 Planning and PDDL

A classical planning problem is formalized as a tuple $\langle S, A, T, I, G \rangle$, where $S$ is a set of states, $A$ a set of actions, $T: S \times A \to S$ a transition function, $I \subseteq S$ the set of initial states, and $G \subseteq S$ the set of goal states [Ghallab et al., 2004]. A plan is a finite sequence of actions $\pi = \langle a_1, \ldots, a_n \rangle$ such that executing $\pi$ from any $s \in I$ via $T$ reaches some $g \in G$. Actions have preconditions (conditions that must hold before execution) and effects (state changes produced by execution), which define the causal structure of how actions transform the world.

**PDDL (Planning Domain Definition Language)** is the standard formalism for encoding planning problems [McDermott et al., 1998; Ghallab et al., 2004]. A PDDL specification consists of two files:

1. **Domain file (DF)**: Defines predicates (representing the state space $S$) and action schemas (representing actions $A$ with typed parameters, preconditions, and effects). This captures universal aspects of the planning problem.

2. **Problem file (PF)**: Defines objects, the initial state $s_I$, and goal conditions $G$ for a specific problem instance.

**Example.** For a student managing coursework, predicates might include `(enrolled ?s - student ?c - course)`, `(completed ?s - student ?a - assignment)`, and `(at-location ?s - student ?l - location)`. An action schema `attend-lecture` would specify preconditions (student must be enrolled, lecture must be scheduled, student must be at the lecture hall) and effects (student gains knowledge of lecture content, updates current location).

PDDL extensions support temporal planning (durative actions with start/end conditions and continuous effects) and resource constraints (numeric fluents tracking quantities like time or energy) [Haslum et al., 2019]. These extensions are particularly relevant for simulated agents whose actions have durations and consume resources (e.g., working a shift at a café consumes several hours, traveling between locations requires time proportional to distance).

### 2.2.4 Symbolic Planning

Symbolic planning uses explicit, compositional representations of states and actions to algorithmically search for valid plans [Fikes and Nilsson, 1971; McDermott et al., 1998]. Key strengths include:

1. **Explainability**: Plans are sequences of named actions with explicit preconditions and effects, enabling causal trace inspection.
2. **Constraint enforcement**: Planners guarantee that generated plans satisfy all preconditions, avoid violated invariants, and respect temporal and resource bounds.
3. **Optimality**: Many planners find optimal or bounded-suboptimal solutions under well-defined cost models.

These properties directly address the coherence challenge in agent simulation: if an agent's behavior is synthesized via a symbolic planner, environmental constraints are satisfied by construction.

The primary limitation is **authoring cost**: PDDL domains require manual specification of predicates, actions, preconditions, and effects, which is brittle and labor-intensive for open-ended or underspecified environments. Symbolic planning also struggles with commonsense reasoning and social nuance unless these are explicitly encoded, increasing complexity [Haslum et al., 2019].

### 2.2.5 LLM-Based Planning

LLM-based (or neural) planning refers to using language models to generate action sequences or subgoal decompositions directly from textual descriptions [Ahn et al., 2022; Huang et al., 2022]. LLMs can draft plausible multi-step procedures via prompting techniques such as chain-of-thought [Wei et al., 2022], propose alternatives, and adapt plans to soft preferences without requiring formal domain models.

However, LLMs lack formal guarantees of correctness. LLM-generated plans can:
- Omit necessary preconditions (e.g., proposing to open a door without first checking if it exists or is accessible from the current location),
- Violate environmental invariants (e.g., scheduling the agent to be in two different locations simultaneously),
- Drift temporally (e.g., forgetting earlier commitments or scheduling conflicting activities when context windows truncate),
- Hallucinate actions or states not grounded in the environment (e.g., interacting with objects or people that do not exist in the current scene) [Xiao et al., 2024].

For believability-centric NPCs, these failure modes manifest as broken commitments, physical impossibilities, and social incoherence. Park et al.'s Generative Agents exhibited emergent social behaviors but lacked mechanisms to enforce hard constraints, relying instead on LLM prompt engineering to maintain temporal coherence heuristically [Park et al., 2023].

### 2.2.6 Hierarchical Planning

<!-- review-Jeremi: Should we acutally talk about HTN? --> Hierarchical task networks (HTN) decompose high-level tasks into ordered or partially ordered subtasks until primitive actions are reached, using methods that encode admissible refinements and constraints [Erol et al., 1994; Nau et al., 2003]. Hierarchy supports abstraction, reuse, and tractable search.

LLMs often approximate hierarchical planning implicitly by proposing outlines, subgoals, and steps in natural language [Wei et al., 2022]. Park et al.'s agents generate daily plans with morning, afternoon, and evening blocks containing embedded tasks, resembling HTN decomposition but without explicit HTN semantics or validation [Park et al., 2023].

A formal HTN or temporal PDDL planner can validate such decompositions, ensuring that high-level commitments refine into feasible, non-overlapping primitive actions. In our running example, a high-level goal "complete coursework this week" might decompose into "attend lectures," "complete assignments," and "study for exam," with temporal constraints ensuring no overlaps and deadlines are met.

### 2.2.7 Neuro-Symbolic Systems for Planning

Neuro-symbolic systems combine learned (sub-symbolic) components with symbolic representations and reasoning to achieve both flexibility and guarantees [Garcez et al., 2015; d'Avila Garcez and Lamb, 2020]. Common integration patterns for planning include:

1. **LLM-propose/symbolic-validate**: The LLM generates candidate schemas or plans; a symbolic component validates them against domain constraints [Huang et al., 2024].
2. **Iterative refinement**: Plans are critiqued by symbolic validators or planners, and feedback is used to improve LLM proposals [Silver et al., 2023; Valmeekam et al., 2023].
3. **Shared world models**: A symbolic state representation is updated from neural perception and queried for decision making.

Recent work has explored these patterns specifically for PDDL generation. Tantakoun et al. survey approaches where LLMs construct PDDL domain and problem files from natural language descriptions, with symbolic planners used for validation and execution [Tantakoun et al., 2025]. Huang et al. propose a pipeline where multiple LLM instances generate diverse PDDL action schemas, which are filtered via semantic coherence checks and validated by symbolic planners to identify solvable schema sets [Huang et al., 2024].

This thesis follows the LLM-propose/symbolic-validate pattern. The LLM generates PDDL schemas from natural language domain descriptions and proposes high-level goals grounded in agent memory. A PDDL-based planner validates these artifacts, enforces environmental constraints (temporal, resource, invariant), and synthesizes executable plans. Failures are diagnosed, and feedback is optionally returned to the LLM for repair. The result aims to preserve the naturalistic, context-aware behavior afforded by LLMs while ensuring the causal and temporal coherence required for believability.

In our running example, the LLM might propose a daily schedule for an agent working at a café, including opening the shop, serving customers, taking a break, and attending a social event in the evening. The PDDL validator checks this schedule against location constraints (the agent cannot be at the café and the park simultaneously), temporal constraints (shift hours, event times), and action preconditions (the café door must exist and be unlocked before opening). Violations such as overlapping commitments or attempts to interact with non-existent objects are flagged, and the validator suggests repairs (e.g., rescheduling the social event to after the shift ends).

## 2.3 Literature Review

This section reviews work relevant to neuro-symbolic planning for LLM-driven agents, focusing on the Generative Agents paper that motivates our system and situating it among hybrid approaches that combine LLMs with symbolic planning.

### 2.3.1 Generative Agents: Interactive Simulacra of Human Behavior (Park et al., 2023)

Park et al. introduced generative agents: LLM-driven NPCs that simulate believable human behavior in a sandbox town environment called Smallville [Park et al., 2023]. The architecture comprises three components:

1. **Memory Stream**: A comprehensive record of time-stamped observations (own actions, others' actions, environment events), retrieved based on a weighted combination of recency (exponential decay), importance (LLM-rated 1 to 10), and relevance (cosine similarity of embeddings).

2. **Reflection**: Periodic synthesis triggered when importance scores exceed a threshold (150 in the implementation). The LLM generates questions about recent experiences, produces insights with citations to source memories, and creates reflection trees (observations → reflections → meta-reflections).

3. **Planning**: Top-down recursive decomposition into day-level plans (5 to 8 chunks), hour-level plans, and 5 to 15 minute action plans. Agents dynamically re-plan when circumstances change, with the LLM deciding whether to continue the current plan or react to new observations.

**Emergent behaviors** observed in a 25-agent, two-day simulation included:
- **Information diffusion**: News of a mayoral candidacy spread from 1 agent to 8 (32%); a Valentine's Day party invitation spread to 13 agents (52%).
- **Relationship formation**: Social network density increased from 0.167 to 0.74.
- **Coordination**: Isabella planned a party, invited agents, decorated the café, and 5 out of 12 invited agents attended at the correct time and location.

**Evaluation** used a controlled study with 100 human participants ranking agents via TrueSkill ratings. The full architecture (memory + reflection + planning) achieved $\mu = 29.89, \sigma = 0.72$, significantly outperforming ablated versions and even human crowdworkers ($\mu = 22.95, \sigma = 0.69$) with an effect size of $d = 8.16$ (p < 0.001). Interview questions assessed self-knowledge, memory recall, future plans, reactive decisions, and reflections.

**Failure modes** included:
- Memory retrieval errors (missing relevant information),
- Hallucination (embellishing details not in memory),
- Overly formal dialogue (artifact of instruction tuning),
- Over-cooperation (agents too agreeable).

**Relevance to this thesis**: Park et al. demonstrated that LLM-driven agents can achieve high believability ratings through memory, reflection, and planning mechanisms. However, the system lacks explicit symbolic grounding: there is no formal model of time, resources, or environmental constraints. Temporal coherence is maintained heuristically through textual schedules that can drift or produce overlaps. Actions are not verified against preconditions and effects beyond ad hoc checks, limiting transparency and reproducibility when context windows shift or prior commitments are forgotten. This motivates our neuro-symbolic approach of integrating PDDL-based validation to detect and repair constraint violations.

### 2.3.2 LLMs as Planning Modelers (Tantakoun et al., 2025)

Tantakoun et al. provide a comprehensive survey of how LLMs can be leveraged to construct and refine automated planning models rather than directly perform planning [Tantakoun et al., 2025]. They review approximately 80 papers and position LLMs as tools for extracting planning models to support reliable planners, addressing the limitation that LLMs struggle with long-horizon planning requiring structured reasoning.

The survey introduces a taxonomy of three paradigms:
1. **LLMs-as-Heuristics**: Enhance planner search efficiency.
2. **LLMs-as-Planners**: Directly generate action sequences or plan proposals.
3. **LLMs-as-Modelers**: Construct PDDL domain and problem files (survey focus).

Within LLMs-as-Modelers, three categories emerge:

**Task Modeling** (approximately 30 papers): LLMs generate PDDL problem files from goal specifications. Approaches range from few-shot prompting [Collins et al., 2022] to chain-of-thought techniques [Lyu et al., 2023] and closed-loop systems with visual perception and error self-correction [Birr et al., 2024]. Task modeling is well-explored but relies on explicit natural language to PDDL mapping requiring detailed predicate specification.

**Domain Modeling** (approximately 15 papers): LLMs generate PDDL domain files (predicates and action schemas). This is inherently more challenging than task specification. Approaches include one-shot generation [Oates et al., 2024], generate-test-critique loops that incrementally build components [Guan et al., 2023], and closed-loop frameworks with iterative symbolic task decomposition [Wong et al., 2023]. Single-domain generation risks misalignment with human expectations due to ambiguity in natural language descriptions.

**Hybrid Modeling** (approximately 15 papers): LLMs generate both domain and problem files. Systems use iterative refinement with planner error messages as feedback [Kelly et al., 2023], domain-agnostic end-to-end natural language planning [Gestrin et al., 2024], and human-in-the-loop approaches with anomaly detection [Ye et al., 2024]. Coordinating domain and problem generation introduces complexity; linear pipelines risk cascading errors.

**Key findings** relevant to this thesis:
1. LLMs can generate syntactically valid PDDL but struggle with semantic consistency.
2. Iterative refinement with symbolic planner feedback improves model quality.

This survey grounds our approach: we position the LLM as a PDDL schema generator (domain modeling) with symbolic validator feedback and iterative refinement.

### 2.3.3 Planning in the Dark: LLM-Symbolic Pipeline without Experts (Huang et al., 2024)

Huang et al. propose an LLM-symbolic planning pipeline that eliminates expert intervention in action schema generation and validation [Huang et al., 2024]. The approach addresses the challenge that natural language task descriptions are inherently ambiguous, and single LLM instances have low probability of generating solvable PDDL schemas <!-- review-Jeremi:  Damn s that true? Let's check. It's very small -->(e.g., 0.00003125% with p=0.05 correctness per action, 5 actions).

**Three-step architecture**:

1. **Diverse Schema Library Construction**: Deploy $N$ LLM instances with high temperature to generate complete sets of action schemas for $M$ actions. Aggregate into a library with approximately $N^M$ possible schema set combinations.

2. **Semantic Coherence Filtering**: Use sentence encoders to compute cosine similarity between natural language descriptions $E(Z(\alpha))$ and generated schemas $E(\hat{\alpha})$. Apply Conformal Prediction (CP) to calculate a threshold $\hat{q}$ at confidence level $1 - \epsilon$, filtering schemas below the threshold. This reduces combinations from $N^M$ to $\prod_{i=1}^{M} m_i$ where $m_i$ is the number of passing schemas per action. Fine-tune the encoder with triplet loss using hard negative samples (manipulated schemas with predicate swaps, negations, removals).

3. **Plan Generation and Ranking**: Feed solvable schema sets into a symbolic planner (DUAL-BWFS). Rank generated plans by cumulative semantic similarity: $\sum_{i=1}^{M} \frac{E(Z(\alpha_i)) \cdot E(\hat{\alpha}_i)}{\|E(Z(\alpha_i))\| \|\hat{\alpha}_i\|}$.

**Key experimental findings**:
- Layman (ambiguous) descriptions yield 2.35 times more distinct solvable schema sets than detailed expert descriptions (8039 vs. 3419 with 10 LLMs, no CP), reflecting diverse valid interpretations.
- With 10 LLM instances, the probability of generating at least one solvable schema set exceeds 95% under reasonable assumptions.
- CP filtering reduces combinations to 3.3% of the original (1051/31,483) while increasing the solvable ratio from 10.9% to 23.0%.
- Human evaluators ranked pipeline-generated plans (mean rank 2.97) significantly higher than Tree-of-Thought baselines (3.58); gold standard ranked 1.79.
- The pipeline successfully solved the Sussman Anomaly (requiring interleaved subgoal handling), while direct LLM approaches (GLM, GPT-3.5, GPT-4o) failed by attempting linear goal ordering.

**Relevance to this thesis**: Huang et al. demonstrate that LLM diversity and semantic validation can produce solvable PDDL schemas without expert intervention. Their pipeline validates the feasibility of LLM-generated schemas via symbolic planners, ensuring coherence. We adapt this insight: rather than generating diverse schema libraries, we use iterative refinement with planner feedback to improve schema quality, prioritizing human-perceived believability alongside solvability.

<!-- review-Jeremi:  In our study we focus on the plan consistency so this paper dosen't seems to be directly relevant. We could do sth smilar but for the plans-->
### 2.3.4 Evaluating Believability in LLM-Driven Agents (Xiao et al., 2024)

Xiao et al. introduce SimulateBench, a benchmark for evaluating believability in LLM-based human behavior simulation [Xiao et al., 2024]. They propose two critical dimensions:

1. **Consistency Ability (CA)**: How well LLMs align behavior with character profiles. Measured via accuracy on multiple-choice questions requiring reasoning from profile information (average profile length: 3,277 tokens vs. 203 tokens in Park et al.).

2. **Robustness Ability (RA)**: How stable LLM behaviors remain under profile perturbations (education, surname, race, age modifications). Measured as standard deviation of CA scores across profile variants.

**Key findings** from evaluating 10 LLMs:
- Best model (GPT-4): CA = 0.77; worst (Vicuna-7B-16K): CA = 0.46.
- Longer context windows do not guarantee better consistency (e.g., LongChat-7B-32K achieved CA = 0.48, worse than GPT-4 with 8k context).
- **Simulation hallucination**: Models perform significantly worse on questions where the profile lacks sufficient information (GPT-4: 1.00 on known questions, 0.47 on unknown), indicating tendency to answer based on training knowledge rather than profile constraints.
- Better consistency does not imply better robustness; some models with lower CA scores exhibited higher robustness to perturbations.

**Relevance to this thesis**: Xiao et al. operationalize believability evaluation through profile-grounded consistency metrics and hallucination detection. Their findings underscore the challenge of maintaining coherence when LLMs improvise beyond available information. This motivates our approach of using symbolic constraints to ground agent behavior: the PDDL domain acts as an explicit "profile" of environmental rules, and planner validation prevents hallucinated actions that violate these rules.

### 2.3.5 Other Neuro-Symbolic Planning Approaches

Several additional lines of work combine LLMs with formal planning:

**Robotics and grounded planning**: SayCan pairs LLM language grounding with value estimates over affordances to select feasible actions in robotic manipulation tasks [Ahn et al., 2022].

**Iterative refinement loops**: LLM+P and related frameworks prompt an LLM to propose high-level plans, check them with a PDDL planner, and iterate until a valid plan is found [Silver et al., 2023; Valmeekam et al., 2023; Lyu et al., 2023]. Critique-and-repair loops such as Reflexion and Tree-of-Thought add self-evaluation and search over candidate plans, while symbolic constraints prune or guide the search [Shinn et al., 2023; Yao et al., 2023].

**Temporal planning integration**: Extensions incorporate duration and resource checks to prevent overlaps and enforce deadlines [Cashmore and Fox, 2019].

Compared to Park et al., these hybrid methods assume an explicit domain model and delegate feasibility checking to a solver, trading authoring cost for guarantees. This thesis follows the hybrid path but investigates PDDL schema generation by LLMs to reduce authoring cost while preserving symbolic validation guarantees.

### 2.3.6 Summary of Insights and Research Focus

The literature suggests three converging insights:

1. **LLM planning produces human-like behavior but lacks long-horizon coherence** due to missing symbolic grounding, context window limitations, and hallucination [Park et al., 2023; Xiao et al., 2024].

2. **Neuro-symbolic methods offer structure and guarantees** by validating or synthesizing plans against explicit models of actions, time, and resources [Huang et al., 2024; Tantakoun et al., 2025].

3. **Believability and coherence should be assessed jointly**: constraint adherence is necessary for plausibility (coherence), but human evaluation is required to confirm perceived realism (believability) [Park et al., 2023; Xiao et al., 2024].

This thesis investigates whether LLM-generated PDDL schemas combined with symbolic validation can reduce logical inconsistencies and incoherent action sequences while maintaining the naturalistic, context-aware behavior that makes LLM agents engaging. The specific research questions guiding this work are articulated in Chapter 1 and operationalized through the experimental design described in Chapter 3.

---

**Estimated page budget**: This chapter draft is approximately 8 to 10 pages (assuming standard academic formatting with 11pt font, 1.15 line spacing, and typical figure/table inclusion). Remaining budget for joint thesis: 40 to 50 pages (soft target 50 to 60 total; hard cap 70).
