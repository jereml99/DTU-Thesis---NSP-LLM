# Chapter 3 — Methodology

## Experimental Setup

[To be completed: overview of simulation environment, agent initialization, scenario design, and logging infrastructure.]

## System Design

Our neuro-symbolic planning system builds on a re-implementation of the Generative Agents architecture [Park et al., 2023] with architectural modifications that enable controlled comparison between purely neural planning (baseline) and neuro-symbolic planning (our approach). This section describes the system architecture, the planning pipeline, and how the design supports rigorous evaluation.

### System Architecture

The implementation transforms the original monolithic Generative Agents codebase into a modular, service-oriented architecture with three layers:

1. **Repository Layer**: Abstracts external dependencies (LLM APIs, file storage) behind interfaces, enabling swappable implementations for testing and experimentation. The `LLMRepository` interface supports both OpenAI (production) and mock providers (testing). The `EnvironmentRepository` interface abstracts world state persistence.

2. **Service Layer**: Encapsulates cognitive capabilities in swappable service interfaces:
   - `PlanningService`: Daily planning and task decomposition
   - `DialogueService`: Conversation generation
   - `PerceptionService`: Environment observation and memory retrieval
   - `ReflectionService`: Memory summarization
   - `EnvironmentService`: Spatial navigation and object interaction

3. **Orchestration Layer**: The simulation loop consumes services through interfaces, configured via environment variables (`LLM_PROVIDER`, `PLAN_MODULE`) that control which implementations run.

**Key Design Principle**: The `PlanningService` abstraction enables side-by-side comparison of baseline (LLM-only hierarchical planning) and neuro-symbolic planning by ensuring both implementations share identical environment state, memory retrieval, and LLM infrastructure. Only the planning logic differs, isolating the independent variable for evaluation.

**[Figure: Service-Oriented Architecture – Reserved Space]**

### Neuro-Symbolic Planning Pipeline

The neuro-symbolic planning service implements an LLM-propose, symbolic-validate loop with optional iterative repair:

1. **High-Level Goal Generation**: The LLM generates daily goals and intentions based on agent memory, personality, and recent events (identical to baseline).

2. **Task Decomposition**: Goals are decomposed into tasks with temporal constraints (morning, afternoon, evening blocks). Tasks specify durations, locations, and preconditions in natural language.

3. **PDDL Translation**: Tasks and environment state are translated into PDDL problem and domain files:
   - **Domain**: Predicates encode agent location, object possession, knowledge state, and social commitments. Action schemas formalize preconditions (e.g., `attend-class` requires enrollment, correct time, and location) and effects (knowledge updates, location changes).
   - **Problem**: Initial state includes agent beliefs, world configuration, and scheduled events. Goals capture task completion criteria.

4. **Symbolic Validation**: A PDDL validator checks plan feasibility, detecting violations such as:
   - Temporal conflicts (overlapping tasks)
   - Unsatisfied preconditions (attempting unavailable actions)
   - Location inconsistencies (simultaneous presence in multiple locations)
   - Resource constraint violations (insufficient time or inventory)

5. **Diagnostic Feedback and Repair** (optional): If validation fails, diagnostic messages indicate violated constraints. These can be returned to the LLM for plan revision, though the current implementation focuses on detection rather than automated repair.

**Baseline Comparison**: The baseline `PlanningServiceShim` implements the original Generative Agents hierarchical planner without symbolic validation, enabling direct measurement of constraint violation rates and believability differences.

### Visualization and Logging Infrastructure

The system includes a Vue.js frontend with RESTful API integration for:

- **Real-time Simulation Monitoring**: Live agent state, current actions, and plan visualization
- **Replay Interface**: Time-lapse playback with plan overlay and action logs for user study evaluation
- **Constraint Violation Logging**: Automated flagging and timestamping of validator-detected violations for quantitative analysis
- **Diagnostic Visualization**: Display of PDDL validation errors with context (violated action, precondition, timestamp)

**[Figure: Neuro-Symbolic Planning Pipeline – Reserved Space]**

### Design Rationale and Extensibility

This architecture prioritizes **experimental validity** through controlled comparison and **extensibility** for future planning approaches. Key benefits:

- **Testability**: Mock LLM repository enables deterministic testing without API costs (coverage increased from 0% to 75%+)
- **Reproducibility**: Environment variables control all experimental conditions; simulation logs capture complete state histories
- **Modularity**: New planning services (e.g., HTN-based, reinforcement learning-augmented) can be added by implementing the `PlanningService` interface without modifying core simulation logic

## Quantitative Evaluation: Constraint Violation Analysis

[To be completed: automated evaluation comparing the hierarchical planning baseline against our validator-augmented system. The validator will automatically detect and flag constraint violations such as attempting to use items that are not available, scheduling overlapping activities, violating location constraints, or executing actions whose preconditions are not satisfied. Metrics will include violation counts at day-level and action-level, violation rates per 100 actions, and success rates after optional validator-guided repair rounds.]


## User Study: Believability Evaluation

This section describes the human-subjects study we designed to test whether our approach improves the perceived believability of agent behavior compared to the baseline architecture introduced in Generative Agents \cite{parkGenerativeAgentsInteractive2023a}. We focus the evaluation on the believability of *actions* rather than only on agent personalities or prompted conversations.

**(label: sec:user-study-believability)**

### Objectives and hypotheses

We evaluate two primary hypotheses:

- H1 (overall believability): Participants judge agents powered by our method as more believable overall than the baseline Generative Agents architecture in matched scenarios.
- H2 (action believability): For the same scenario, participants flag fewer actions as "unbelievable" in our method than in the baseline.

We also explore two secondary outcomes: (i)  <!-- review-Jeremi: I'm not sure about it. Will we do that? --> perceived causal coherence of behaviour when the high-level plan is visible, and (ii) free-text reasons participants provide when they deem an action unbelievable (used for qualitative error analysis) \cite{batesRoleEmotionBelievable1994,bogdanovychWhatMakesVirtual2016,tenceAutomatableEvaluationMethod2010,xiaoHowFarAre2024}.

### Conditions

We compare two within-subject conditions on the same simulated world and character seeds:

1. **Baseline (GA)**: Our faithful re-implementation of Generative Agents \cite{parkGenerativeAgentsInteractive2023a}.
2. **Ours (Neuro-symbolic)**: The proposed system with symbolic planning and consistency checks integrated into deliberation and action selection.

Each participant evaluates both conditions on the same character and scenario to enable within-subject comparison. Order is counterbalanced (Latin square design) to reduce presentation effects.

### Participants

We target 10-15 adult participants recruited from the university community and online platforms. Inclusion criteria are English proficiency. We will run an initial pilot (3-4 participants) to validate timing and the interface, then proceed to the main study. All participants provide informed consent and can withdraw at any time without penalty.

### Materials and stimuli

The stimulus for each condition is a replay of a single random character's day in the sandbox world. To keep the evaluation focused on action believability, we present:

- a time-lapse *video replay* of the agent acting in the world; participants can control playback speed and pause/seek;
- an optional overlay with the *high-level plan* (intentions and sub-goals) and a *low-level action log;* and
- UI controls to mark an action as unbelievable ("thumbs down"), provide a short reason, and continue.

Replays cover the same scenario (e.g., two simulated in-game days) and use the same character profile and randomness seed across conditions, so any observed variation is attributable to the agent architecture (baseline vs. ours) rather than scenario noise.

### Procedure

Each session (~30 minutes) proceeds as follows:

1. **Introduction.** A short scripted briefing introduces the task and the notion of believability as coherence, plausibility, and consistency within world rules \cite{bogdanovychWhatMakesVirtual2016}.
2. **Practice.** Participants complete a 2--3 minute tutorial on the interface using a neutral example not used in the main study.
3. **Condition A.** Watch the replay, freely scrub, and mark any actions that feel unbelievable. For each mark, add a short explanation (optional but encouraged).
4. **Condition B.** Repeat the session with the other planner. The order of conditions is varied across participants, and assignment is double-blind so neither the participant nor the researcher knows which planner comes first.
5. **Summary ratings.** For each condition: provide (i) an overall believability rating (7-point Likert), (ii) a perceived causal coherence rating (7-point Likert), and (iii) a preference judgment (forced-choice which was more believable and why).

We record duration until the user is finished with the scenario and whether the plan overlay was opened, to analyse how explanations affect believability judgments.

### Measures

We operationalize believability with complementary participant-reported and behaviour-linked measures. Unless noted, higher values indicate higher believability.

#### Primary outcomes

1. **Overall believability (Likert).** Single item per condition on a 7-point scale with anchors: 1 "not at all believable", 4 "moderately believable", 7 "extremely believable". The item prompt is: "How believable was the agent's behaviour overall in this replay?"
2. **Action-level unbelievable rate (event-normalized).** Participants can flag any on-screen action as unbelievable. Let $F$ be the number of unique action events a participant flagged in a condition and $A$ the number of *atomic actions* actually viewed by that participant (derived from the action log restricted to watched timestamps). The primary rate is

\[ r_{\mathrm{unbel}} = \frac{F}{A} \times 100\, , \]

expressed as flags per 100 atomic actions. Atomic actions are the smallest logged action units (e.g., open-door, pick-up, speak, move-to). If a participant sets multiple flags within a 2-second window around the same atomic action, we merge them into one event-level flag.
3. **Pairwise preference.** Forced-choice question: "Which of the two replays was more believable overall?" (Baseline vs. Ours).

#### Secondary outcomes

- **Causal coherence (Likert).** 7-point rating of how coherent the behaviour felt as a sequence of goals and subgoals: 1 "not coherent", 7 "highly coherent".
- **Plan adherence (Likert).** 7-point rating of alignment between visible high-level plan and observed actions
 <!-- review-Jeremi: Isn't that an overkill?-->
- **Unbelievable-action categories (coded).** Free-text reasons for each flag are open-coded into categories such as: goal inconsistency, environment rule violation, temporal implausibility, social norm violation, and low-level control failure. Two independent coders label a stratified sample (≥30% of flags); disagreements are adjudicated and inter-rater agreement (Cohen's $\kappa$) is reported.

**Logged covariates (for analysis, not outcomes)** We log condition order, scenario ID, participant playback time, number of overlay openings, and self-reported prior experience with simulations/games. These are used as covariates in exploratory models and to check for order effects.

### Data quality and exclusion

Sessions are excluded if participants fail an attention check (simple comprehension question about the replay), leave more than half the session unanswered, or complete in less than one-third of the median time. We pre-register exclusion rules prior to data collection.

### Analysis

We analyse overall believability with within-subject comparisons   <!-- review-Jeremi: Check if those methods makes sens-->(paired *t*-test when normality holds; otherwise Wilcoxon signed-rank).  <!-- review-Jeremi: Dose this make sens? --> For action-level data, we fit a mixed-effects logistic regression on the probability that an action is flagged as unbelievable:

```
flag ~ condition + (1|participant) + (1|scenario)
```

We report effect sizes (Cohen's $d$ or odds ratios) and 95% CIs. Qualitative reasons are open-coded into categories of failure (e.g., goal inconsistency, environment rule violation) to contextualize quantitative effects.

### Ethics

The study involves only minimal risk. No personal data beyond demographics is collected; all logs are anonymized and stored on encrypted drives.

### Power and timing
<!-- review-Jeremi: Dose this make sens? --> 
A conservative power analysis for a within-subject design with a moderate effect (Cohen's $d=0.5$, $\alpha=0.05$, power $=0.8$) suggests $N\approx 34$. Given resource constraints, we aim for 10 to 15 valid participants after exclusions; the pilot is analyzed descriptively and may inform small interface adjustments.


