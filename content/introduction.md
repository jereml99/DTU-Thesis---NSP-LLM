# Introduction

## Background and Context
Artificial intelligence has increasingly turned toward **Large Language Models (LLMs)** for generating human-like text and behavior. When embedded in *generative agents*, these models can simulate complex social dynamics and interactive narratives. However, despite their linguistic fluency, such agents frequently exhibit **logical inconsistencies** and **incoherent action sequences** within simulated environments.

Recent research—such as [ref:park2023] and [ref:zhao2023]—shows that combining symbolic planning with LLM reasoning can significantly improve **task coherence** and **narrative believability**.

## Problem Statement
While generative agents can engage in dynamic, human-like interactions, their lack of **consistent, constraint-respecting planning** undermines realism. Current approaches either rely too heavily on symbolic systems—limiting flexibility—or on purely neural models, which lack logical guarantees.

**Problem:**  
How can a neuro-symbolic planning framework improve the coherence and believability of LLM-driven generative agents in interactive environments?

## Research Aim and Objectives
**Aim:**  
To develop and evaluate a hybrid neuro-symbolic planning framework combining the reasoning power of LLMs with the formal structure of symbolic planning.

**Objectives:**
1. Review and categorize state-of-the-art approaches to neuro-symbolic planning and LLM-based agents.  
2. Design a framework where LLMs generate and refine **PDDL schemas**.  
3. Implement the system in an **interactive simulation environment**.  
4. Evaluate the resulting agents for logical coherence and perceived believability.  
5. Reflect on broader implications for narrative AI and multi-agent systems.

## Methodological Overview
The study will combine **computational implementation** with **human-centered evaluation**, integrating a large language model with a symbolic planner (PDDL). Evaluation metrics include both **constraint satisfaction** and **human-rated believability**.

## Scope and Limitations
The project focuses on **simulation environments** rather than real-world robotics. Symbolic representations will be limited to deterministic domains, and results will primarily assess **narrative consistency** and **social plausibility**.

## Thesis Structure
- **Chapter 2:** Related Work — overview of neuro-symbolic methods and generative agent architectures.  
- **Chapter 3:** Methodology — experimental setup and system design.  
- **Chapter 4:** Implementation and Evaluation.  
- **Chapter 5:** Results and Discussion.  
- **Chapter 6:** Conclusion and Future Work.
