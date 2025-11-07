# Chapter 1 — Introduction

## Background and context

Generative agents powered by Large Language Models (LLMs) can simulate complex, human-like behavior in interactive environments such as virtual worlds, simulation games, and social scenarios. These agents enable rich narrative experiences and dynamic interactions by drawing on the commonsense reasoning and natural language capabilities of LLMs (Park et al., 2023). However, purely neural approaches to agent behavior often produce logical inconsistencies and incoherent action sequences. For example, an agent may attempt actions that violate environmental constraints (such as opening a door that does not exist) or pursue goals that conflict with its stated motivations, undermining the plausibility and believability of the simulation (Bates, 1994).

Park et al. (2023) introduced a generative agent architecture that uses memory streams, reflection, and hierarchical planning to guide agent behavior. While this architecture demonstrates compelling emergent social dynamics, the hierarchical planning component lacks explicit mechanisms for verifying logical consistency or ensuring adherence to environmental constraints. As a result, agents can generate plans that are fluent and contextually plausible but nonetheless violate hard constraints or exhibit temporal inconsistencies.

Recent work in neuro-symbolic AI explores combining neural generation with symbolic planning representations to address these limitations. Tantakoun et al. (2025) demonstrate that LLMs can serve as planning modelers, generating Planning Domain Definition Language (PDDL) schemas that formalize domain constraints and action preconditions. By pairing LLM-generated PDDL with symbolic planners or validators, such approaches provide explicit, inspectable guarantees about constraint satisfaction and logical coherence. This neuro-symbolic strategy retains the flexibility and commonsense reasoning of LLMs while introducing structured verification to detect and repair invalid plans before they are executed in the environment.


## Problem statement

Generative agents produce dynamic, human-like interactions, but their lack of consistent, constraint-respecting planning undermines realism. Current approaches either rely too heavily on symbolic systems, limiting flexibility, or on purely neural models, which lack logical guarantees.

**Research question:** How can a neuro-symbolic planning framework improve the coherence and believability of LLM-driven generative agents in interactive environments?


## Research aim and objectives

**Aim:** To develop and evaluate a hybrid neuro-symbolic planning system in which an LLM generates PDDL-based plans and a symbolic validator verifies logical consistency, identifies constraint violations, and suggests repairs.

**Objectives:**

1. Reimplement the generative agents architecture with a modular, extensible codebase that supports integration of symbolic planning components.
2. Design and implement a PDDL-based validator that formalizes environmental constraints, detects planning violations, and generates actionable diagnostic feedback.
3. Develop visualization and explanation tools that make agent plans, constraint violations, and repair proposals inspectable to researchers and evaluators.
4. Evaluate the system using (a) quantitative metrics (constraint violation rates, plan success rates, and repair efficiency) comparing a baseline hierarchical planner against the neuro-symbolic approach, and (b) qualitative human evaluation of perceived believability and narrative coherence.

## Methodological overview

This study builds on the generative agents architecture (Park et al., 2023) by replacing the hierarchical planning component with a neuro-symbolic planning framework. The LLM generates PDDL action schemas and plans, which are then validated by a symbolic checker that detects constraint violations and proposes repairs. The approach is evaluated through two methods:

- **Quantitative evaluation**: Constraint violation counts and rates are measured on matched scenarios for (i) a baseline system using hierarchical planning and (ii) the neuro-symbolic system with validator-guided revision rounds. Metrics include violation rates per 100 actions, plan success rates (zero violations), and repair efficiency.
- **Qualitative evaluation**: Perceived believability and narrative coherence are assessed via a within-subjects user study comparing agent behaviors from both systems.

## Scope and limitations
<!-- review-Jeremi: So let's think how to explain that we are not doing the symbolic planner. Explain the nature of the domain. Alex -->
This project focuses on simulation environments rather than real-world robotics, where sensing uncertainty and physical dynamics introduce additional complexity. The symbolic planning component uses PDDL, which assumes deterministic action effects and complete observability within the simulated domain. Evaluation emphasizes narrative consistency, environmental constraint adherence, and perceived believability rather than real-time performance or scalability to large multi-agent systems.


## Thesis structure

The remainder of the thesis is organized as follows:

- **Chapter 2: Related Work** — Surveys neuro-symbolic methods, generative agent architectures, and prior work on agent believability. Situates the PDDL-based validation approach within the landscape of symbolic planners, neural planners, and hybrid systems.
- **Chapter 3: Methodology** — Describes the experimental setup, system design, and evaluation protocols. Presents the running example, the PDDL validator schema, and procedures for both quantitative constraint-violation metrics and qualitative human evaluation.
- **Chapter 4: Implementation and Evaluation** — Details the software architecture, LLM-to-PDDL generation pipeline, symbolic validator implementation, and visualization tools for surfacing diagnostics and repair proposals.
- **Chapter 5: Results and Discussion** — Reports quantitative constraint-violation metrics and qualitative believability findings.
- **Chapter 6: Conclusion and Future Work** — Summarizes contributions and limitations. 

