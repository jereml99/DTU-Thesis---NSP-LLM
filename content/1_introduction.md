\chapter{Introduction}
\label{ch:introduction}

\section{Background and Context}
\label{sec:background-context}

Large Language Model (LLM)-driven generative agents can simulate complex, human-like behavior in virtual worlds, games, and social scenarios by leveraging commonsense reasoning and natural language capabilities (Park et al., 2023). However, purely neural approaches produce logical inconsistencies: agents attempt impossible actions (opening nonexistent doors), violate temporal constraints (simultaneous commitments), or pursue conflicting goals, undermining believability (Bates, 1994).

Park et al. (2023) demonstrated emergent social dynamics through memory streams, reflection, and hierarchical planning. Yet their planning component lacks mechanisms to verify logical consistency or enforce environmental constraints, producing plans that are contextually plausible but violate hard constraints or exhibit temporal inconsistencies.

Neuro-symbolic AI can address this by combining neural generation with symbolic planning (Tantakoun et al., 2025).

\section{Problem Statement}
\label{sec:problem-statement}

Existing agent architectures face a fundamental tradeoff: purely symbolic systems ensure logical consistency but lack flexibility and commonsense reasoning, while purely neural LLM-driven agents offer adaptability but produce logically inconsistent plans.

**Research question:** How can a neuro-symbolic planning framework improve the coherence and believability of LLM-driven generative agents?

\section{Research Aim and Objectives}
\label{sec:research-aim-objectives}

**Aim:** To develop and evaluate a hybrid neuro-symbolic planning system in which an LLM generates a hierarchical plan, the plan actions and environment constraints are formalized in PDDL, and a symbolic validator verifies logical consistency, identifies constraint violations, and guides iterative plan refinement.

**Objectives:**

1. Reimplement the generative agents architecture (Park et al., 2023) with a modular, extensible codebase that supports integration of symbolic planning components.
2. Design and implement a PDDL-based validator that formalizes environmental constraints, detects planning violations, and outputs actionable diagnostic feedback.
3. Develop visualization and explanation tools that make agent plans, constraint violations, and repair proposals inspectable to researchers and evaluators.
4. Evaluate the system using (a) quantitative metrics (constraint violation rates, plan success rates, and repair efficiency) comparing a baseline hierarchical planner against the neuro-symbolic approach, and (b) qualitative human evaluation of perceived believability.

\section{Methodological Overview}
\label{sec:methodological-overview}

This study extends the generative agents architecture (Park et al., 2023) by replacing hierarchical planning with a neuro-symbolic framework. The LLM generates hierarchical plans and PDDL action schemas; a symbolic validator detects constraint violations. Evaluation combines:

* **Quantitative metrics:** Constraint violation counts and rates on matched scenarios comparing (i) baseline hierarchical planning and (ii) neuro-symbolic planning with validator-guided revision. Metrics include violations per 100 actions, plan success rates, and repair efficiency.
* **Qualitative assessment:** Within-subjects user study comparing perceived believability of agent behaviors from both systems.

\section{Scope and Limitations}
\label{sec:scope-limitations}

This project focuses on simulation environments with deterministic action effects and complete observability. Real-world robotics introduces sensing uncertainty and physical dynamics beyond our scope. Evaluation focuses on constraint adherence and perceived believability rather than real-time performance or scalability to large multi-agent systems.

\section{Thesis Structure}
\label{sec:thesis-structure}

The remainder of the thesis is organized as follows:

* **Chapter 2: Theoretical Background**: Establishes core concepts (LLMs, agents, planning paradigms including PDDL) and reviews relevant literature.
* **Chapter 3: Methodology**: Describes the system design, experimental setup, and evaluation protocols. Details the symbolic validator architecture and the within-subjects user study for assessing believability and constraint adherence.
* **Chapter 4: Results**: Reports quantitative constraint-violation metrics and qualitative believability findings from the user study.
* **Chapter 5: Discussion**: Interprets results, situates findings within the literature, and discusses limitations and implications for agent design.
* **Chapter 6: Conclusion and Future Work**: Summarizes contributions and suggests directions for future research.
* **Chapter 7: Use of AI in this Thesis**: Declaration of AI tools used in the thesis preparation.

