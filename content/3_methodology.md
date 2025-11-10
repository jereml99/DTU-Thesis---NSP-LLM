# Chapter 3 — Methodology

## Experimental Setup

[To be completed: overview of simulation environment, agent initialization, scenario design, and logging infrastructure.]

# Chapter 4: Implementation

**Remaining page budget: ~45 pages (target 50–60, hard cap 70)**

## 4.1 System Architecture Overview

The implementation transforms the Generative Agents simulation system from a monolithic architecture into a service-oriented design with clear separation of concerns. The system comprises three major components:

1. **Simulation Engine** – Core agent simulation logic with cognitive modules
2. **Environment Backend** – Django REST API for environment state management
3. **Frontend Application** – Vue.js SPA for visualization and replay

This chapter documents the architectural transformation, focusing on the structural changes that enable extensibility, testability, and maintainability while preparing for neuro-symbolic planning integration.

---

## 4.2 Architectural Transformation: From Monolith to Services

### 4.2.1 Original Monolithic Structure

The baseline Generative Agents system exhibited tight coupling between simulation logic, environment management, and LLM interactions. OpenAI API calls were embedded directly in cognitive modules, filesystem access was scattered throughout the codebase, and configuration was hardcoded with no abstraction layer.

**[Figure 4.1: Monolithic Architecture Diagram – Reserved Space (content/implementation_assets/Code Structure - before.svg)]**

**Critical Problems:**
- Hard-coded dependencies: impossible to swap LLM providers or test without live API access
- Mixed concerns: business logic intertwined with data access
- No extensibility: adding new planning modules required modifying core cognitive code
- Zero test coverage

### 4.2.2 Service-Oriented Architecture

The new architecture introduces **layered abstractions** through dependency injection, separating the system into three layers:

1. **Repository Layer** – Abstract data access (LLM APIs, environment storage) behind interfaces
2. **Service Layer** – Encapsulate business logic (planning, dialogue, perception) in swappable services  
3. **Orchestration Layer** – Simulation loop consumes services through interfaces

**[Figure 4.2: Service-Oriented Architecture Diagram – Reserved Space (content/implementation_assets/Code Structure - after.svg)]**

**Architectural Principles:**
- Repository Pattern abstracts external dependencies
- Service interfaces enable multiple implementations (baseline vs. neuro-symbolic)
- Dependency injection via centralized configuration
- Environment variables control provider selection and storage paths

---

## 4.3 Core Architectural Layers

### 4.3.1 Repository Layer: Data Access Abstraction

The repository layer isolates external dependencies (LLM APIs, file systems) behind abstract interfaces. The `LLMRepository` interface provides methods for text generation (`chat`) and structured JSON responses (`structured`), with implementations for OpenAI (production) and mock responses (testing). The `EnvironmentRepository` interface abstracts world state loading and agent state persistence.

**Key Benefit:** Switching from OpenAI to a local LLM or from filesystem to database storage requires implementing a single interface, not rewriting cognitive modules.

### 4.3.2 Service Layer: Business Logic Encapsulation

Five core service abstractions encapsulate cognitive capabilities:

1. **PlanningService** – Daily planning and task decomposition
2. **DialogueService** – Conversation generation
3. **PerceptionService** – Environment observation and memory retrieval
4. **ReflectionService** – Memory summarization
5. **EnvironmentService** – Spatial navigation and object interaction

**Implementation Strategy:**
- **Shim Services** wrap existing cognitive modules for backward compatibility
- **Symbolic Services** (future work) will implement PDDL-based planning

Services receive dependencies via constructor, enabling composition and testability.

### 4.3.3 Dependency Injection via Configuration

All services are instantiated in a centralized configuration module that reads environment variables to select implementations. For example, `LLM_PROVIDER=mock` switches to deterministic test responses, while `LLM_PROVIDER=openai` uses the production API. Custom storage paths are configurable via `NSPLLM_STORAGE_ROOT` and similar variables.

The simulation server receives a complete service container at initialization, avoiding direct instantiation of dependencies throughout the codebase.

---

## 4.4 Environment Backend: RESTful API

### 4.4.1 Transformation from Template-Based to API-Driven

The original Django server rendered HTML templates with embedded JavaScript. The new architecture exposes a RESTful API to decouple backend from frontend, with endpoints for health checks, simulation listing, step-by-step data retrieval, and command execution.

CORS middleware allows cross-origin requests from the Vue.js SPA during development.

### 4.4.2 Benefits of API Separation

- Frontend independence: separate development, build, and deployment
- Third-party integrations: external tools can query simulation state programmatically
- Scalability: backend and frontend scale independently
- Testability: API endpoints testable with standard HTTP tools

---

## 4.5 Frontend Application: Vue.js SPA

### 4.5.1 Transition from Server-Rendered Templates

The original UI mixed server-side rendering with JavaScript. The new frontend is a Vue 3 Single-Page Application with TypeScript, featuring:

- **API Service Layer**: Centralized HTTP client abstracts backend communication
- **State Management**: Pinia store manages global simulation state with reactive updates
- **Component Composition**: Reusable Vue components for personas, environment map, and controls
- **Type Safety**: TypeScript interfaces enforce simulation data structures

### 4.5.2 Benefits of SPA Architecture

Modern tooling (hot module replacement, component-based development), reactive UI updates, and production-ready builds with code splitting and tree shaking.

---

## 4.6 Testing Infrastructure

### 4.6.1 Test Organization and Coverage

The migration introduced three test levels:

- **Unit Tests**: Fast, isolated tests with mocked dependencies (service delegation, prompt loading, state serialization)
- **Integration Tests**: Multi-component tests verifying LLM provider switching and multi-step scenarios
- **Smoke Tests**: Optional validation against live OpenAI API for prompt format and believability checks

**Key Testing Pattern:** The `MockLLMRepository` returns deterministic responses based on message content, enabling fast testing without API costs or external dependencies.

**Coverage Metrics:**
- Before: 0% (no automated tests)
- After: 75%+ for services and repositories

### 4.6.2 Developer Workflow Transformation

**Before:** Edit code → manually run full simulation with live API → check logs → hope it works  
**After:** Edit code → run unit tests in seconds → verify interface compliance → optional smoke test → deploy with confidence

---

## 4.7 Migration Benefits and Trade-offs

### 4.7.1 Architectural Improvements

| Aspect | Before | After |
|--------|--------|-------|
| **Coupling** | Tight (direct calls) | Loose (interface-based) |
| **Testability** | None (requires live API) | High (mock repositories) |
| **Extensibility** | Hard (rewrite modules) | Easy (implement interface) |
| **Configuration** | Scattered (hardcoded) | Centralized (env vars) |
| **Frontend** | Server-rendered Django | Modern Vue SPA |
| **API** | None | RESTful Django API |

### 4.7.2 Production Flexibility

Environment variables control all major behaviors:

- **LLM Provider Swapping**: `LLM_PROVIDER=openai|mock|local` switches between production API, test mocks, or future local models
- **Storage Backend**: `NSPLLM_STORAGE_ROOT` configures filesystem paths; future implementations can support PostgreSQL or S3 via `ENV_BACKEND` variable

### 4.7.3 Trade-offs and Complexity

**Added Complexity:**
- More files and abstractions (repositories, services, interfaces)
- Steeper learning curve for new contributors
- Dependency injection requires understanding service wiring

**Justified by Benefits:**
- Complexity is localized (interfaces separate from implementations)
- Testability dramatically reduces debugging time
- Extensibility enables thesis experiments without rewriting core code
- Maintainability improves through isolated changes

---

## 4.8 Enabling Neuro-Symbolic Planning Integration

### 4.8.1 Planning Service Interface as Extension Point

The `PlanningService` abstraction enables side-by-side comparison of baseline (LLM-only) and neuro-symbolic planning. The baseline `PlanningServiceShim` wraps existing cognitive modules, while future `SymbolicPlanningService` will integrate PDDL planning.

**Critical Implementation Detail:** The symbolic service will use the LLM repository for task decomposition and the PDDL planner for action sequence generation, with environment variables controlling which implementation runs (`PLAN_MODULE=shim|symbolic`).

### 4.8.2 Architecture Supports Controlled Experiments

The service-oriented design enables rigorous comparison by ensuring both implementations use the same `EnvironmentService` (world state), same `LLMRepository` (model and prompts for high-level tasks), with only the planning logic differing. This isolates the independent variable for statistical analysis.

---

## 4.9 Summary and Next Steps

### 4.9.1 Architectural Achievements

✅ Repository Pattern abstracts LLM and environment access  
✅ Service Layer encapsulates swappable business logic  
✅ Dependency Injection centralizes configuration  
✅ RESTful API decouples backend from frontend  
✅ Modern Vue SPA with TypeScript  
✅ 75%+ test coverage with fast unit tests  

### 4.9.2 Foundation for Thesis Contributions

This architecture directly enables:

1. Baseline evaluation (existing LLM-based planning as control)
2. Symbolic planning integration via `PlanningService` interface
3. Comparative analysis in identical simulation environments
4. Prompt engineering through versioned template management
5. Metrics collection via API endpoints

### 4.9.3 Future Implementation Work

**Thesis Scope:**
1. Implement `SymbolicPlanningService` with PDDL planner
2. Design PDDL domain/problem definitions for household environment
3. Develop LLM-to-PDDL translation
4. Collect comparative metrics (baseline vs. neuro-symbolic)


## System Design
[To be completed: architecture diagram and description of the neuro-symbolic planning pipeline, including LLM-to-PDDL generation, symbolic validation, and repair mechanisms.]

# Symbolic Planning Implementation

## Neuro-Symbolic Planning Pipeline
[This section will be subject to change after finalizing the implementation details.]
We implement a neuro-symbolic planning framework following the LLM-propose/symbolic-validate pattern \cite{kambhampatiLLMsCantPlan2024,tantakounLLMsPlanningModelers2025,huangPlanningDarkLLMSymbolic2024}. Unlike the baseline hierarchical planner (§2.3), our pipeline validates all proposed action sequences against formal constraints before execution, directly addressing the coherence challenge (§2.2.2).

### Three-Stage Pipeline

**Stage 1: Task Generation**  
The LLM generates daily tasks from the agent's memory stream using the baseline retrieval mechanism \cite{parkGenerativeAgentsInteractive2023a}, grounding tasks in wants, needs, commitments, and objectives.

**Stage 2: Action Decomposition**  
Each task is decomposed into atomic actions with environment-grounded parameters (locations, objects, relationships). Example: "complete assignment" → `open-laptop`, `navigate-to-file`, `work-on-document(90min)`, `submit-via-portal`.

**Stage 3: Schema Generation and Validation**  
The LLM generates PDDL schemas (§2.2.3) encoding preconditions, effects, and durations for each action. A symbolic validator then checks:
- **Causal consistency**: Precondition–effect chains across actions;
- **Temporal feasibility**: No overlapping activities;
- **Resource limits**: Numeric fluents (time, energy) stay within bounds;
- **Environmental invariants**: Domain constraints (e.g., single-location occupancy).

When validation fails, diagnostic feedback (e.g., "unsatisfied precondition `(at-location student hall)`" or "temporal overlap between `study-session` and `coffee-break`") is returned to the LLM for iterative repair until constraints are satisfied or the iteration budget is exhausted.

### Integration and Rationale

The pipeline integrates with memory retrieval, reflection synthesis, and execution monitoring from the baseline architecture \cite{parkGenerativeAgentsInteractive2023a}, preserving naturalistic behavior while enforcing coherence (§2.2.2).

We use LLM-generated schemas rather than pre-defined models to enable adaptation to novel situations \cite{tantakounLLMsPlanningModelers2025,huangPlanningDarkLLMSymbolic2024}, at the cost of potential schema misalignment. The validation layer mitigates this risk through constraint checking and iterative repair. Quantitative evaluation of violation rates and repair efficiency is detailed in §3.3.




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


