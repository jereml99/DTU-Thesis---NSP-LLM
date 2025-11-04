% Chapter 3 — Methodology

# Chapter 3 — Methodology

## Experimental Setup

Details of the experimental setup.

## System Design

Description of the system architecture and design.

## Quantitative Evaluation — Validator-based (summary)

This section specifies the automated, repeatable evaluation that complements the human study. We quantify coherence by counting constraint violations detected by the symbolic validator under matched scenarios, comparing a baseline system to our neuro-symbolic system with an increasing number of validator-guided revision rounds.

### Objectives and comparisons

- Quantify how many violations the validator finds in: (i) the baseline (GA-like) system and (ii) our system after R revision rounds.
- Measure repair efficiency: how quickly violations are eliminated (rounds-to-zero), and how plan quality evolves across rounds.

We evaluate the following conditions on identical scenarios:

1. Baseline (GA): no symbolic repair; the validator only logs violations.
2. Ours-R: our system with R ∈ {0, 1, 2, 3} revision rounds, where each round feeds validator diagnostics back to the LLM to propose targeted repairs. R = 0 corresponds to “ours without repairs” (validator-only logging); R ≥ 1 enables iterative critique-and-repair.

### Scenarios and protocol

- Scenarios: one or more daily scenarios; exact counts and durations will be specified later.
- Controls: identical character initial states, calendars, environment settings, prompts/system settings, and time budgets across conditions.
- Execution: for each scenario × condition, generate a high-level plan, refine to actions/schedule, and run the simulated day with logging. After each revision round (if any), re-validate and re-run from the same initial state.

### Granularity: day-level vs task-level validation

We separate validation into two stages to reflect how plans are produced and executed:

1. Day-plan validation (schedule level): checks on the daily schedule before execution (e.g., temporal overlaps across tasks, outside-hours scheduling, resource/location conflicts, unmet prerequisites that must be arranged earlier in the day).
2. Task-plan validation (within-task level): for each scheduled task, checks on the subplan/steps during refinement and execution (e.g., missing preconditions, intra-task temporal/order violations, local resource/contention issues).

Repairs can target either level (rescheduling at the day level vs. refining/fixing at the task level). We log violations and repairs separately for each level and also provide an overall aggregate.

### Metrics

- Counts of validator-detected violations at day-level (schedule) and task-level (within-task), plus an overall aggregate.  
- Simple derived indicators (e.g., violation rate per 100 actions, zero-violation success, rounds-to-zero, coarse plan edit/repair magnitude).  
- We report compact tables/plots to summarize patterns rather than exhaustive per-check breakdowns.

Optional qualitative-linked metrics (brief): explanation coverage and repair precision (reported only if helpful).

### Analysis

We compare conditions on distributions of violation counts/rates and simple trends across small R (e.g., paired nonparametric tests or simple count models), with minimal plots/tables. Day-level and task-level summaries are reported separately and in aggregate.

<!-- review-unknown: Specify the exact analysis methods; add references and a short explanation of chosen methods (e.g., paired tests, mixed models for event-level data). -->

### Reporting

Concise tables/figures that highlight the main differences (e.g., violation counts/rates by condition and level); a small script will allow re-running scenarios with the validator.

## User Study: Believability Evaluation

This section describes the human-subjects study we designed to test whether our approach improves the perceived believability of agent behaviour compared to the baseline architecture introduced in Generative Agents [CITE: parkGenerativeAgentsInteractive2023a]. We focus the evaluation on the believability of actions rather than only on agent personalities or prompted conversations.

### Objectives and hypotheses

We evaluate two primary hypotheses:

- H1 (overall believability): Participants judge agents powered by our method as more believable overall than the baseline Generative Agents architecture in matched scenarios.
- H2 (action believability): For the same scenario, participants flag fewer actions as "unbelievable" in our method than in the baseline.

We also explore two secondary outcomes: (i) perceived causal coherence of behaviour when the high-level plan is visible, and (ii) free-text reasons participants provide when they deem an action unbelievable (used for qualitative error analysis) [CITE: batesRoleEmotionBelievable1994; bogdanovychWhatMakesVirtual2016; tenceAutomatableEvaluationMethod2010; xiaoHowFarAre2024].

### Conditions

We compare two between-system conditions on the same simulated world and character seeds:

1. **Baseline (GA):** Our faithful re-implementation of Generative Agents [CITE: parkGenerativeAgentsInteractive2023a].
2. **Ours (Neuro-symbolic):** The proposed system with symbolic planning and consistency checks integrated into deliberation and action selection.

Each participant evaluates both conditions on the same character and scenario to enable within-subject comparison. Order is counterbalanced (Latin square) to reduce presentation effects.

### Participants

Small-to-moderate within-subject sample recruited from the university community/online; English proficiency required. A short pilot will validate timing and the interface. Informed consent is required; withdrawal without penalty.

### Materials and stimuli

For each condition, participants view a replay of an agent’s day with: (i) controllable playback; (ii) optional overlay for the high-level plan/action log; and (iii) simple controls to flag unbelievable actions with short reasons. Replays use matched scenarios and character profiles across conditions.

### Procedure

Brief intro and practice; then two matched conditions in counterbalanced order. Participants watch, flag unbelievable actions (with optional short reasons), and provide summary ratings. Simple interaction logs (e.g., time-on-task, overlay openings) are recorded for context.

### Measures

Primary: overall believability (Likert), action-level unbelievable rate (e.g., flags per 100 actions), and pairwise preference. Secondary: perceived causal coherence and plan adherence (Likert), plus brief coding of reasons for flagged actions (e.g., goal inconsistency, rule/time violations, social norms, control failures). Basic usage signals (e.g., order, time-on-task, overlay openings) are logged for context.

### Data quality and exclusion

Straightforward attention/completeness checks and implausibly fast completion will guide exclusions (rules preregistered).

<!-- review-unknown: Double check exclusion criteria — is this what we want? -->

### Analysis

Within-subject comparisons between conditions for the primary outcomes (e.g., paired tests or simple mixed models for event-level data), with concise effect summaries and confidence intervals; qualitative reasons are coded to contextualize quantitative findings.

### Ethics


The study involves only minimal risk. No personal data beyond demographics is collected; all logs are anonymized and stored on encrypted drives. We will seek approval from the institutional ethics board prior to recruitment.

<!-- review-unknown: Confirm whether DTU ethics board approval is required for this study. -->

### Power and timing

We target a practical within-subject study size appropriate for detecting moderate differences and will confirm with a simple power check; a short pilot informs timing and minor interface tweaks.

<!-- review-unknown: Clarify if this subsection is needed; define what “power” refers to and outline a simple power check. -->

### Preregistration and availability


We will preregister hypotheses, exclusion rules, and primary or secondary outcomes, and release the anonymized dataset, analysis scripts, and the evaluation interface after publication.

<!-- review-unknown: Consider whether this subsection is necessary for the final thesis or keep it if useful. -->


