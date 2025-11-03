# Chapter 1 — Introduction

## Background and context

Artificial intelligence has increasingly turned toward Large Language Models (LLMs) for generating human-like text and behaviour. When embedded in generative agents, these models can simulate complex social dynamics and interactive narratives. Despite their linguistic fluency, such agents frequently exhibit logical inconsistencies and incoherent action sequences within simulated environments.

Recent work (e.g., Park et al., 2023; Zhao et al., 2023) suggests that combining symbolic reasoning with LLMs can improve task coherence and narrative believability. This thesis focuses first on a neuro-symbolic validator (a form of symbolic scaffolding): the LLM continues to propose goals and sketches, while a symbolic validator checks proposed plans against explicit constraints, reports violations, and suggests repairs or diagnostics. The aim is to obtain the benefits of symbolic guarantees (constraint enforcement, temporal checks, explainability) without initially replacing the LLM's proposal role with a planner.

## Problem statement

Generative agents produce dynamic, human-like interactions, but their lack of consistent, constraint-respecting planning undermines realism. Current approaches either rely too heavily on symbolic systems, limiting flexibility, or on purely neural models, which lack logical guarantees.

Problem statement:

How can a neuro-symbolic planning framework improve the coherence and believability of LLM-driven generative agents in interactive environments?

## Research aim and objectives

Aim:

To develop and evaluate a hybrid neuro-symbolic scaffolding system in which an LLM proposes plans and a symbolic validator ("symbolic scaffolding") verifies, critiques, and suggests repairs to those plans.

Objectives:

1. Reimplement the original system codebase in a modular, well-documented, and extensible architecture to ease future extensions and maintenance.
2. Design a validator schema and data contract for expressing constraints, diagnostics, and suggested repairs (symbolic scaffolding), and implement a prototype that integrates an LLM sketching module with this symbolic validator (including tooling to surface explanations and repair proposals).
3. Improve UI/UX and tooling to surface explanations, visualizations, and decision rationales so that agent decisions/plans are inspectable by researchers and evaluators.
4. Evaluate the prototype using both symbolic evaluation (constraint adherence, repair frequency, diagnostic coverage) and human-centered evaluation (perceived believability, narrative coherence).

## Methodological overview

The study combines computational implementation with human-centered evaluation, integrating a large language model with a symbolic validator (symbolic scaffolding) that inspects LLM-generated plans. Evaluation comprises two complementary strands: symbolic evaluation (constraint adherence, repair frequency, and diagnostic coverage) and human-centered evaluation (perceived believability and narrative coherence).

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
