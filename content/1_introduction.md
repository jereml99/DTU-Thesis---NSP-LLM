# Chapter 1 — Introduction

## Background and context

Artificial intelligence has increasingly turned toward Large Language Models (LLMs) for generating human-like text and behaviour. When embedded in generative agents, these models can simulate complex social dynamics and interactive narratives. Despite their linguistic fluency, such agents frequently exhibit logical inconsistencies and incoherent action sequences within simulated environments.

Recent work (e.g., Park et al., 2023; Zhao et al., 2023) suggests that combining symbolic planning with LLM reasoning can improve task coherence and narrative believability. This thesis develops a neuro-symbolic planning framework that leverages LLMs for open-ended interpretation and natural language generation while using symbolic planners to enforce constraints, temporal orderings, and resource bounds.

## Problem statement

Generative agents produce dynamic, human-like interactions, but their lack of consistent, constraint-respecting planning undermines realism. Current approaches either rely too heavily on symbolic systems—limiting flexibility—or on purely neural models, which lack logical guarantees.

Problem statement:

How can a neuro-symbolic planning framework improve the coherence and believability of LLM-driven generative agents in interactive environments?

## Research aim and objectives

Aim:

To develop and evaluate a hybrid neuro-symbolic planning framework combining the reasoning power of LLMs with the formal structure of symbolic planning.

Objectives:

1. Review and categorize state-of-the-art approaches to neuro-symbolic planning and LLM-based agents.  
2. Design a framework where LLMs generate and refine PDDL schemas.  
3. Implement the system in an interactive simulation environment.  
4. Evaluate the resulting agents for logical coherence and perceived believability.  
5. Reflect on broader implications for narrative AI and multi-agent systems.

## Methodological overview

The study combines computational implementation with human-centered evaluation, integrating a large language model with a symbolic planner (PDDL). Evaluation metrics include both constraint satisfaction and human-rated believability.

## Scope and limitations

The project focuses on simulation environments rather than real-world robotics. Symbolic representations are limited to deterministic domains, and results primarily assess narrative consistency and social plausibility.

## Thesis structure

- Chapter 2: Related Work — overview of neuro-symbolic methods and generative agent architectures.  
- Chapter 3: Methodology — experimental setup and system design.  
- Chapter 4: Implementation and Evaluation.  
- Chapter 5: Results and Discussion.  
- Chapter 6: Conclusion and Future Work.

---

This markdown was generated from `Chapters/01_Introduction.tex`. It preserves the original section structure while adapting to the thesis content style used in `content/` markdown drafts. Consider adding citations where indicated and a short introductory paragraph that names the running example (Maya the barista) if you prefer that to appear here (it currently appears in Chapter 2 drafts).
