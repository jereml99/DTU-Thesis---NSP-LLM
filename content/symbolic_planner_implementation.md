# Symbolic Planning Implementation

## Neuro-Symbolic Planning Pipeline

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

