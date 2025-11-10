# Chapter 3 — Methodology

## Experimental Setup

[To be completed: overview of simulation environment, agent initialization, scenario design, and logging infrastructure.]

## System Design
[To be completed: architecture diagram and description of the neuro-symbolic planning pipeline, including LLM-to-PDDL generation, symbolic validation, and repair mechanisms.]

<!-- review-Jeremi: The Quantitative Evaluation seems underpolished. I think we should drop it right now for mitpoint review and just write is as to be complited.-->
## Quantitative Evaluation: Constraint Violation Analysis

We complement the human study with a concise, automated evaluation that compares a <!-- review-Jeremi: Let's say it's copmperions of herechical palnning to the to our system--> GA-like baseline against our validator-augmented system. The validator flags constraint violations; we optionally allow a small number of validator-guided revision rounds $R$ and observe how violations change. Validation is separated into day-level (schedule) and action-level (within-task) checks.

**(label: sec:quant-eval-summary)**

**Conditions**

 <!-- review-Jeremi: Isn't basline the herarchical planning from GA paper?-->Baseline (no repair) vs. ours with small $R$ (iterative critique-and-repair).

**Scenarios/protocol**

 <!-- review-Jeremi: is it right? --> 
Matched scenarios with the same initial states and settings across conditions; for each run: generate plan → validate → (optional) repair → re-run from the same initial state; uniform logging.
 <!-- review-Jeremi: Should we keep this things in ()-->
**Metrics (concise)**

Counts of validator-detected violations at day-level and action-level, plus an overall aggregate; simple derived indicators  <!-- review-Jeremi: Are we actualy know what are those metrics -->(e.g., violation rate per 100 actions, zero-violation success, rounds-to-zero, coarse plan edit/repair magnitude).

**Analysis (brief)**

 <!-- review-Jeremi: Is it what we do actually? -->
Compare conditions on distributions of violation counts/rates and trends across small $R$ (e.g., paired nonparametric tests or simple count models), with minimal plots/tables. Report day-level and action-level summaries separately and in aggregate.

**Reporting**
 <!-- review-Jeremi: Should we keep this? -->
Concise tables/figures highlighting main differences and a small script to re-run scenarios with the validator.


## User Study: Believability Evaluation

This section describes the human-subjects study we designed to test whether our approach improves the perceived believability of agent behaviour compared to the baseline architecture introduced in Generative Agents \cite{parkGenerativeAgentsInteractive2023a}. We focus the evaluation on the believability of *actions* rather than only on agent personalities or prompted conversations.

**(label: sec:user-study-believability)**

### Objectives and hypotheses

We evaluate two primary hypotheses:

- H1 (overall believability): Participants judge agents powered by our method as more believable overall than the baseline Generative Agents architecture in matched scenarios.
- H2 (action believability): For the same scenario, participants flag fewer actions as "unbelievable" in our method than in the baseline.

We also explore two secondary outcomes: (i)  <!-- review-Jeremi: I'm not sure about it. Will we do that? --> perceived causal coherence of behaviour when the high-level plan is visible, and (ii) free-text reasons participants provide when they deem an action unbelievable (used for qualitative error analysis) \cite{batesRoleEmotionBelievable1994,bogdanovychWhatMakesVirtual2016,tenceAutomatableEvaluationMethod2010,xiaoHowFarAre2024}.

### Conditions

We compare two  <!-- review-Jeremi: is that a proper word --> between-system conditions on the same simulated world and character seeds:

1. **Baseline (GA)**: Our faithful re-implementation of Generative Agents \cite{parkGenerativeAgentsInteractive2023a}.
2. **Ours (Neuro-symbolic)**: The proposed system with symbolic planning and consistency checks integrated into deliberation and action selection.

Each participant evaluates both conditions on the same character and scenario to enable within-subject comparison. Order is counterbalanced  <!-- review-Jeremi: what is latin squere?-->(Latin square) to reduce presentation effects.

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
 <!-- review-Jeremi: We have less participants so should we include this?-->
A conservative power analysis for a within-subject design with a moderate effect (Cohen's $d=0.5$, $\alpha=0.05$, power $=0.8$) suggests $N\approx34$. We therefore aim for 24--36 valid participants after exclusions; the pilot is analysed descriptively and may inform small interface adjustments.

### Preregistration and availability
 <!-- review-Jeremi: I don't think we will do it-->
We will preregister hypotheses, exclusion rules, and primary/secondary outcomes, and release the anonymized dataset, analysis scripts, and the evaluation interface after publication.
