# Chapter 3 — Methodology

## Experimental Setup

[To be completed: overview of simulation environment, agent initialization, scenario design, and logging infrastructure.]

## System Design

Our neuro-symbolic planning system extends a re-implementation of the Generative Agents architecture (Park et al., 2023) with modifications enabling controlled comparison between purely neural planning (baseline) and neuro-symbolic planning (our approach).

### System Architecture

The implementation transforms the original monolithic Generative Agents codebase into a modular, service-oriented architecture:

1. **Repository Layer**: Abstracts external dependencies (LLM APIs, file storage) behind interfaces. `LLMRepository` supports both OpenAI (production) and mock providers (testing). `EnvironmentRepository` abstracts world state persistence.
2. **Service Layer**: Encapsulates cognitive capabilities in swappable interfaces:
	- `PlanningService`: daily planning and task decomposition
	- `DialogueService`: conversation generation
	- `PerceptionService`: environment observation and memory retrieval
	- `ReflectionService`: memory summarization
	- `EnvironmentService`: spatial navigation and object interaction
3. **Orchestration Layer**: The simulation loop consumes services through interfaces, configured via environment variables (`LLM_PROVIDER`, `PLAN_MODULE`) controlling which implementations run.

**Key design principle**: The `PlanningService` abstraction enables side-by-side comparison of baseline (LLM-only hierarchical planning) and neuro-symbolic planning by ensuring both share identical environment state, memory retrieval, and LLM infrastructure. Only the planning logic differs, isolating the independent variable.

### Neuro-Symbolic Planning Pipeline

We implement a three-stage LLM-propose / symbolic-validate framework (Kambhampati, 2024; Tantakoun et al., 2025; Huang et al., 2024):

1. **Task generation**: The LLM generates daily tasks from memory, grounding them in wants, needs, and commitments (Park et al., 2023).
2. **Action decomposition**: Tasks decompose into atomic actions with environment parameters. Example: “complete assignment” → `open-laptop`, `navigate-to-file`, `work-on-document(90min)`, `submit-via-portal`.
3. **Schema generation and validation**: The LLM generates PDDL schemas (preconditions, effects, durations) for each action. A symbolic validator checks causal consistency, temporal feasibility, resource limits, and environmental invariants. Violations trigger diagnostic feedback (e.g., unsatisfied precondition `(at-location student hall)`) for iterative LLM repair until constraints satisfy or iteration budget exhausts.

## Quantitative Evaluation: Constraint Violation Analysis

[To be completed: automated evaluation comparing the hierarchical planning baseline against our validator-augmented system. The validator will automatically detect and flag constraint violations such as attempting to use items that are not available, scheduling overlapping activities, violating location constraints, or executing actions whose preconditions are not satisfied. Metrics will include violation counts at day-level and action-level, violation rates per 100 actions, and success rates after optional validator-guided repair rounds.]

## User Study: Believability Evaluation

This section describes the human-subjects study testing whether our approach improves perceived believability of agent behavior compared to the baseline Generative Agents architecture (Park et al., 2023). We focus on believability of actions rather than only personalities or conversations.

### Objectives and hypotheses

Two primary hypotheses:

- **H1 (overall believability)**: Participants judge agents powered by our method as more believable overall than the baseline in matched scenarios.
- **H2 (action believability)**: For the same scenario, participants flag fewer actions as unbelievable in our method than in the baseline.

Secondary outcomes: (i) perceived causal coherence when the high-level plan is visible, and (ii) free-text reasons participants provide when deeming actions unbelievable (used for qualitative error analysis) (Bates, 1994; Bogdanovych et al., 2016; Tence et al., 2010; Xiao et al., 2024).

### Conditions

Two within-subject conditions on the same simulated world and character seeds:

1. **Baseline (GA)**: Faithful re-implementation of Generative Agents (Park et al., 2023).
2. **Ours (Neuro-symbolic)**: Proposed system with symbolic planning and consistency checks integrated into deliberation and action selection.

Each participant evaluates both conditions on the same character and scenario to enable within-subject comparison. Order is counterbalanced to reduce presentation effects.

### Participants

Target 10–15 adult participants recruited from the university community and online platforms. Inclusion criteria: English proficiency. We run an initial pilot (3–4 participants) to validate timing and interface, then proceed to the main study. All participants provide informed consent and can withdraw anytime without penalty.

### Materials and stimuli

The stimulus for each condition is a replay of a single random character's day. To focus on action believability, we present:

- time-lapse video replay of the agent acting in the world (controllable playback speed, pause/seek);
- optional overlay with high-level plan (intentions and sub-goals) and low-level action log; and
- UI controls to mark an action as unbelievable, provide a short reason, and continue.

Replays cover the same scenario (e.g., two simulated in-game days) and use the same character profile and randomness seed across conditions, so any variation is attributable to agent architecture (baseline vs. ours) rather than scenario noise.

### Procedure

Each session (approximately 30 minutes):

1. **Introduction.** Scripted briefing introduces the task and believability as coherence, plausibility, and consistency within world rules (Bogdanovych et al., 2016).
2. **Practice.** Participants complete a 2–3 minute tutorial on the interface using a neutral example not used in the main study.
3. **Condition A.** Watch the replay, freely scrub, and mark unbelievable actions. For each mark, add a short explanation (optional but encouraged).
4. **Condition B.** Repeat with the other planner. Order varies across participants; assignment is double-blind.
5. **Summary ratings.** For each condition: (i) overall believability rating (7-point Likert), (ii) perceived causal coherence rating (7-point Likert), and (iii) preference judgment (forced-choice which was more believable and why).

We record duration until finished and whether the plan overlay was opened, to analyze how explanations affect believability judgments.

### Measures

We operationalize believability with participant-reported and behavior-linked measures. Higher values indicate higher believability unless noted.

#### Primary outcomes

1. **Overall believability (Likert).** Single item per condition on a 7-point scale: 1 not at all believable, 4 moderately believable, 7 extremely believable. Prompt: “How believable was the agent's behaviour overall in this replay?”
2. **Action-level unbelievable rate (event-normalized).** Participants flag any action as unbelievable. Let $F$ be flagged action events and $A$ be atomic actions viewed (from action log restricted to watched timestamps). The rate is $r_{unbel} = (F/A) \times 100$, expressed as flags per 100 atomic actions. Multiple flags within 2 seconds around the same atomic action merge into one.
3. **Pairwise preference.** Forced-choice: “Which replay was more believable overall?” (Baseline vs. Ours).

#### Secondary outcomes

- **Causal coherence (Likert).** 7-point rating: 1 not coherent, 7 highly coherent.
- **Plan adherence (Likert).** 7-point rating of alignment between visible high-level plan and observed actions.
- **Unbelievable-action categories (coded).** Free-text reasons are open-coded into categories: goal inconsistency, environment rule violation, temporal implausibility, social norm violation, low-level control failure. Two independent coders label a stratified sample (≥30% of flags); disagreements are adjudicated and inter-rater agreement (Cohen's κ) is reported.

Logged covariates (for analysis, not outcomes): condition order, scenario ID, participant playback time, number of overlay openings, and self-reported prior experience with simulations/games. These are used as covariates in exploratory models and to check for order effects.

### Data quality and exclusion

Sessions are excluded if participants fail an attention check (simple comprehension question about the replay), leave more than half the session unanswered, or complete in less than one-third of median time. We pre-register exclusion rules prior to data collection.

### Ethics

The study involves minimal risk. No personal data beyond demographics is collected; all logs are anonymized and stored on encrypted drives.


