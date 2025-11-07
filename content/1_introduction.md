# Chapter 1 — Introduction

## Background and context

<!-- review-Jeremi: I think we miss a bit of context, why is it important to have believable generative agents? We can get inspired by Generative Agents paper intro here. Also I think that we should say that we are building on top of the generative agents paper. So maybe a sentence or two about that paper and then how we extend it with our neuro-symbolic approach. -->

Artificial intelligence has increasingly turned toward Large Language Models (LLMs) for generating human-like text and behaviour. When embedded in generative agents, these models can simulate complex social dynamics and interactive narratives. Despite their linguistic fluency, such agents frequently exhibit logical inconsistencies and incoherent action sequences within simulated environments.

<!-- review-Jeremi: I don't think the park2023 reference suggest what is claimed here -->
Recent work (e.g., Park et al., 2023; Zhao et al., 2023) suggests that combining symbolic reasoning with LLMs can improve task coherence and narrative believability. This thesis focuses first on a neuro-symbolic validator (a form of symbolic scaffolding): the LLM continues to propose goals and sketches, while a symbolic validator checks proposed plans against explicit constraints, reports violations, and suggests repairs or diagnostics. The aim is to obtain the benefits of symbolic guarantees (constraint enforcement, temporal checks, explainability) without initially replacing the LLM's proposal role with a planner.


<!-- review-Jeremi: I would stick with closer description to our thesis proposal here. Currently we don't mention anything about belivablity iprovmentents. Also it seems maybe to specific. I would rather stick with more general description and leave specifics to methodology chapter  -->

## Problem statement

<!-- review-Jeremi: I like this section. Problem statement is good. -->
Generative agents produce dynamic, human-like interactions, but their lack of consistent, constraint-respecting planning undermines realism. Current approaches either rely too heavily on symbolic systems, limiting flexibility, or on purely neural models, which lack logical guarantees.

Problem statement:

How can a neuro-symbolic planning framework improve the coherence and believability of LLM-driven generative agents in interactive environments?


## Research aim and objectives

Aim:
<!-- review-Jeremi: should be actualy use the word scaffodling? is it accademic?
 -->
To develop and evaluate a hybrid neuro-symbolic scaffolding system in which an LLM proposes plans and a symbolic validator ("symbolic scaffolding") verifies, critiques, and suggests repairs to those plans.

Objectives:
<!-- review-Jeremi: Do we actually need to state this goals? -->
1. Reimplement the original system codebase in a modular, well-documented, and extensible architecture to ease future extensions and maintenance.
<!-- review-Jeremi: I don't really understend this goal. surface explanation? what is that?-->
2. Design a validator schema and data contract for expressing constraints, diagnostics, and suggested repairs (symbolic scaffolding), and implement a prototype that integrates an LLM sketching module with this symbolic validator (including tooling to surface explanations and repair proposals).
3. Improve UI/UX and tooling to surface explanations, visualizations, and decision rationales so that agent decisions/plans are inspectable by researchers and evaluators.
<!-- review-Jeremi: Is it what we actualy mesure? are we actually messuring narrative coherence? -->
4. Evaluate the prototype using: (a) quantitative, validator-based metrics (constraint violations per run, violation rate per 100 actions, success rate, rounds-to-zero, and repair efficiency), comparing the baseline against our system after R revision rounds; and (b) human-centered evaluation (perceived believability and narrative coherence).

## Methodological overview

<!-- review-Jeremi: I think we should more specific here that we build on top of the generative agents paper and that we will be changing how the planning is done by introducing symbolic scaffolding -->

The study combines computational implementation with human-centered evaluation, integrating a large language model with a symbolic validator (symbolic scaffolding) that inspects LLM-generated plans. Evaluation comprises two complementary strands:

<!-- review-Jeremi: two complementary strands seems a bit too fancy for me.  -->

- Quantitative (validator-based): count and analyse constraint violations on matched scenarios for (i) a GA-like baseline and (ii) our system after R validator-guided revision rounds, reporting violation counts/rates, success rates (zero violations), and rounds-to-zero.
- Qualitative (human-centered): perceived believability and narrative coherence via a within-subjects user study with matched replays.

## Scope and limitations

<!-- review-Jeremi: Maybe I don't understend but why do we say that symbolic representations are limited to deterministic domains? What sans it has here?  -->
The project focuses on simulation environments rather than real-world robotics. Symbolic representations are limited to deterministic domains, and results primarily assess narrative consistency and social plausibility.


## Thesis structure

<!-- review-Jeremi: this should have a clear description of each chapter. but it should probably be don't at the end of the writing thesis. for now it should be to be blank or very high level. -->

- Chapter 2: Related Work — overview of neuro-symbolic methods and generative agent architectures.  
- Chapter 3: Methodology — experimental setup and system design.  
- Chapter 4: Implementation and Evaluation.  
- Chapter 5: Results and Discussion.  
- Chapter 6: Conclusion and Future Work.

- Chapter 2: Related Work — overview of neuro symbolic methods and generative agent architectures. This chapter situates the validator first approach within prior work on symbolic planners, neural planners, and hybrid systems. It also reviews literature on agent believability and techniques for explanation and debugging in interactive settings.
- Chapter 3: Methodology — experimental setup and system design. This chapter describes the running example, the environment and data used in experiments, the validator schema and data contract, and the evaluation protocol for both symbolic metrics and human subject studies.
- Chapter 4: Implementation and Evaluation — prototype implementation details and tooling. Here we present the software architecture, the LLM sketching module, the symbolic validator implementation and the visualization and explainability tools used to surface diagnostics and repair proposals.
- Chapter 5: Results and Discussion — quantitative and qualitative findings. This chapter reports symbolic evaluation results, summarizes outcomes from human centered studies, analyzes common failure modes, and interprets what the results imply for agent coherence and believability.
- Chapter 6: Conclusion and Future Work — summary of contributions and limitations, and an agenda for next steps. We close by discussing directions for integrating planning components, expanding to non deterministic domains, and improving user facing explainability.

---

This markdown was generated from `Chapters/01_Introduction.tex`. It preserves the original section structure while adapting to the thesis content style used in `content/` markdown drafts. Consider adding citations where indicated and a short introductory paragraph that names the running example (Maya the barista) if you prefer that to appear here (it currently appears in Chapter 2 drafts).
