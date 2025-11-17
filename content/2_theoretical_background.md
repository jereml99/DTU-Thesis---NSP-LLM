\chapter{Theoretical Background}

This chapter establishes conceptual foundations and reviews prior work motivating this thesis. It defines core concepts (LLMs, agents, planning paradigms including PDDL), reviews LLM-driven generative agents with emphasis on the seminal Generative Agents paper (Park et al., 2023), and examines hybrid neuro-symbolic approaches combining LLM flexibility with symbolic planning guarantees (Huang et al., 2024; Tantakoun et al., 2025). We emphasize the challenge of maintaining coherence (adherence to environmental constraints) and believability (human-perceived realism) in LLM-driven agents.

\begin{example}[Running Example: Student NPC]
\label{ex:running-student}
Throughout this chapter, we illustrate concepts using a running example: an NPC simulating a university student managing academic and social commitments. The student must coordinate coursework (attending lectures, completing assignments), part-time work (café shifts), and social activities (meeting friends, attending events) while respecting temporal constraints (no overlapping commitments), location constraints (cannot be in two places simultaneously), and environmental rules (must be enrolled in a course to attend its lectures).
\end{example}

\section{Core Concepts and Definitions}

\subsection{Large Language Models (LLMs)}

\begin{definition}[Large Language Model]
\label{def:llm}
A large language model (LLM) is a transformer-based sequence predictor trained on large corpora to estimate conditional token distributions $P(x_t \mid x_{<t})$ (Vaswani et al., 2017; Brown et al., 2020). LLMs generate text autoregressively by sampling from next-token distributions, using self-attention to integrate information across prompts, examples, and tool inputs.
\end{definition}

LLMs exhibit instruction following, few-shot generalization, and approximate commonsense reasoning (Wei et al., 2022; Kojima et al., 2022). Critically, they perform pattern-conditioned statistical inference, not deductive logical inference with formal guarantees. LLMs can generate structured outputs (PDDL schemas, task specifications) from natural language domain descriptions (Tantakoun et al., 2025; Huang et al., 2024), but these outputs require external validation for logical consistency and constraint adherence.

In this thesis, the LLM (i) generates PDDL schemas from natural language domain descriptions, and (ii) proposes high-level goals and task decompositions grounded in agent memory and social context. The symbolic validator then checks whether proposed plans are executable given domain constraints, producing failure diagnostics (unsatisfied preconditions, invariant violations, temporal/resource conflicts, unsolvability). The LLM produces and sequences action plans; the validator enforces feasibility.

\subsection{Agents and Believability}

\begin{definition}[Agent]
\label{def:agent}
An agent receives percepts and produces actions via sensors and actuators, implementing a mapping $f: P^{*} \to A$ from percept histories $P^{*}$ to actions $A$ (Russell and Norvig, 2021).
\end{definition}

In simulated environments and games, non-player characters (NPCs) prioritize producing behavior that human observers find plausible, consistent, and engaging rather than maximizing numerical rewards (Mateas, 2002; Loyall, 1997).

\begin{definition}[Believability]
\label{def:believability}
Believability, the illusion of life, is the human-perceived realism of agent behavior: whether actions align with character goals, personality, knowledge, and social norms (Bates, 1994; Loyall, 1997).
\end{definition}

Constraining agents with realistic physical and environmental limits increases perceived believability (Bates, 1994; Bogdanovych et al., 2016). Park et al. showed that LLM-driven agents with memory, reflection, and planning were rated more believable than human crowdworkers in controlled evaluations (Park et al., 2023). Xiao et al. formalize metrics such as Consistency and Robustness for profile-grounded simulation (Xiao et al., 2024).

\begin{definition}[Coherence]
\label{def:coherence}
Coherence is the causal and temporal consistency of behavior: whether actions are feasible, properly ordered, and do not contradict prior commitments or environmental constraints (Young, 2001; Riedl and Young, 2010).
\end{definition}

Coherence is measured through constraint adherence: violations of environmental invariants, temporal overlaps, resource limits, and unsatisfied action preconditions.

\begin{example}[Coherence Violation]
\label{ex:coherence-violation}
In our running example (\cref{ex:running-student}), a coherent agent must not schedule overlapping commitments (attending two simultaneous classes) or attempt impossible actions (submitting an assignment before completing it). A purely LLM-based planner might generate attend lecture at 10:00 and work café shift 09:00 to 12:00 without detecting the temporal conflict.
\end{example}

We adopt the NPC perspective where believability is primary. We hypothesize that coherence, enforced through symbolic planning, is necessary but not sufficient for believability. The neuro-symbolic approach aims to maintain naturalistic, context-aware LLM behavior while eliminating logical inconsistencies that undermine realism.

\subsection{Planning and PDDL}

\begin{definition}[Classical Planning Problem]
\label{def:planning-problem}
A classical planning problem is a tuple $\langle S, A, T, I, G \rangle$: $S$ is a state set, $A$ is an action set, $T: S \times A \to S$ is a transition function, $I \subseteq S$ is the initial state set, and $G \subseteq S$ is the goal state set. A plan is a finite action sequence $\pi = \langle a_1, \ldots, a_n \rangle$ such that executing $\pi$ from any $s \in I$ via $T$ reaches some $g \in G$ (Ghallab et al., 2004).
\end{definition}

Actions have preconditions (conditions required before execution) and effects (state changes produced), defining causal structure.

\begin{definition}[PDDL]
\label{def:pddl}
PDDL (Planning Domain Definition Language) is the standard formalism for encoding planning problems (McDermott et al., 1998; Ghallab et al., 2004). A PDDL specification consists of two files:
\begin{enumerate}
	\item \textbf{Domain file}: Defines predicates (representing the state space $S$) and action schemas (representing actions $A$ with typed parameters, preconditions, and effects). This captures universal aspects of the planning problem.
	\item \textbf{Problem file}: Defines objects, the initial state $s_I$, and goal conditions $G$ for a specific problem instance.
\end{enumerate}
\end{definition}

PDDL extensions support temporal planning (durative actions with start/end conditions and continuous effects) and resource constraints (numeric fluents tracking quantities like time or energy) (Haslum et al., 2019).

\begin{example}[Student Coursework Domain]
\label{ex:student-pddl}
For a student managing coursework, predicates might include:
\begin{itemize}
\item (enrolled ?s - student ?c - course)
\item (completed ?s - student ?a - assignment)
\item (at-location ?s - student ?l - location)
\end{itemize}
An action schema attend-lecture would specify preconditions (student must be enrolled, lecture must be scheduled, student must be at the lecture hall) and effects (student gains knowledge of lecture content, updates current location).
\end{example}

These extensions are particularly relevant for simulated agents whose actions have durations and consume resources (e.g., working a shift at a café consumes several hours, traveling between locations requires time proportional to distance).

\subsection{Symbolic Planning}

Symbolic planning uses explicit, compositional representations to algorithmically search for valid plans (Fikes and Nilsson, 1971; McDermott et al., 1998). Key strengths:

\begin{enumerate}
	\item \textbf{Explainability}: Plans are sequences of named actions with explicit preconditions and effects, enabling causal trace inspection.
	\item \textbf{Constraint enforcement}: Planners guarantee that plans satisfy all preconditions, avoid violated invariants, and respect temporal and resource bounds.
	\item \textbf{Optimality}: Many planners find optimal or bounded-suboptimal solutions under well-defined cost models.
\end{enumerate}

These properties directly address coherence: if behavior is synthesized via a symbolic planner, environmental constraints are satisfied by construction.

The primary limitation is authoring cost: PDDL domains require manual specification of predicates, actions, preconditions, and effects, which is brittle and labor-intensive for open-ended environments. Symbolic planning also struggles with commonsense reasoning and social nuance unless explicitly encoded (Haslum et al., 2019).

\subsection{LLM-Based Planning}

LLM-based planning uses language models to generate action sequences or subgoal decompositions directly from text (Ahn et al., 2022; Huang et al., 2022). LLMs can draft plausible multi-step procedures via chain-of-thought prompting (Wei et al., 2022), propose alternatives, and adapt plans to soft preferences without formal domain models.

However, LLM-generated plans lack correctness guarantees and can:
\begin{itemize}
	\item Omit necessary preconditions (opening a door without checking accessibility),
	\item Violate environmental invariants (simultaneous presence in two locations),
	\item Drift temporally (forgetting earlier commitments when context windows truncate),
	\item Hallucinate actions or states not grounded in the environment (Xiao et al., 2024).
\end{itemize}

For believability-centric NPCs, these failures manifest as broken commitments, physical impossibilities, and social incoherence. Park et al.'s Generative Agents exhibited emergent social behaviors but lacked constraint enforcement, relying on LLM prompt engineering to maintain temporal coherence heuristically (Park et al., 2023).

\subsection{Hierarchical Planning}

Hierarchical task networks (HTN) decompose high-level tasks into ordered or partially ordered subtasks until primitive actions are reached, using methods encoding admissible refinements and constraints (Erol et al., 1994; Nau et al., 2003). Hierarchy supports abstraction, reuse, and tractable search.

LLMs approximate hierarchical planning by proposing outlines, subgoals, and steps in natural language (Wei et al., 2022). Park et al.'s agents generate daily plans with morning, afternoon, and evening blocks containing embedded tasks, resembling HTN decomposition without explicit HTN semantics or validation (Park et al., 2023).

Formal HTN or temporal PDDL planners can validate such decompositions, ensuring high-level commitments refine into feasible, non-overlapping primitive actions. In our running example, complete coursework this week might decompose into attend lectures, complete assignments, and study for exam, with temporal constraints preventing overlaps and ensuring deadlines are met.

\subsection{Neuro-Symbolic Systems for Planning}

Neuro-symbolic systems combine learned (sub-symbolic) components with symbolic representations and reasoning to achieve both flexibility and guarantees (Garcez et al., 2015; d'Avila Garcez and Lamb, 2020). Common integration patterns:

\begin{enumerate}
	\item \textbf{LLM-propose/symbolic-validate}: The LLM generates candidate schemas or plans; a symbolic component validates them against domain constraints (Huang et al., 2024).
	\item \textbf{Iterative refinement}: Plans are critiqued by symbolic validators or planners, and feedback improves LLM proposals (Silver et al., 2023; Valmeekam et al., 2023).
	\item \textbf{Shared world models}: A symbolic state representation is updated from neural perception and queried for decisions.
\end{enumerate}

Recent work explores these patterns for PDDL generation. Tantakoun et al. survey approaches where LLMs construct PDDL domain and problem files from natural language, with symbolic planners validating and executing (Tantakoun et al., 2025). Huang et al. propose a pipeline where multiple LLM instances generate diverse PDDL action schemas, filtered via semantic coherence checks and validated by symbolic planners to identify solvable schema sets (Huang et al., 2024).

This thesis follows the LLM-propose/symbolic-validate pattern. The LLM generates tasks and action sequences grounded in agent memory; these are translated into PDDL schemas and validated by a symbolic planner to enforce temporal, causal, and resource constraints. Validation failures produce diagnostic feedback that can be returned to the LLM for iterative repair, preserving naturalistic behavior while ensuring logical coherence.

\begin{example}[Neuro-Symbolic Validation of Daily Schedule]
\label{ex:neurosymbolic-validation}
The LLM proposes a daily schedule: open the shop, serve customers, take a break, attend a social event in the evening. The PDDL validator checks:
\begin{itemize}
\item Location constraints (cannot be at café and park simultaneously),
\item Temporal constraints (shift hours, event times),
\item Action preconditions (café door must exist and be unlocked before opening).
\end{itemize}
Violations such as overlapping commitments or interactions with nonexistent objects are flagged with diagnostics (e.g., action attend_event at 18:00 conflicts with shift ending at 19:00; agent location café incompatible with event location park).
\end{example}

\section{Literature Review}

This section reviews work on neuro-symbolic planning for LLM-driven agents, focusing on the Generative Agents paper that motivates our system and hybrid approaches combining LLMs with symbolic planning.

\subsection{Generative Agents: Interactive Simulacra of Human Behavior}

Park et al. introduced generative agents: LLM-driven NPCs simulating believable human behavior in Smallville, a sandbox town environment (Park et al., 2023). The architecture comprises:

\begin{enumerate}
	\item \textbf{Memory Stream}: Time-stamped observations (own actions, others' actions, environment events), retrieved by weighted combination of recency (exponential decay), importance (LLM-rated 1 to 10), and relevance (embedding cosine similarity).
	\item \textbf{Reflection}: Periodic synthesis triggered when importance scores exceed a threshold. The LLM generates questions about recent experiences, produces insights with citations, and creates reflection trees.
	\item \textbf{Planning}: Top-down recursive decomposition into day-level plans, hour-level plans, and 5 to 15 minute action plans. Agents dynamically re-plan, with the LLM deciding whether to continue or react to new observations.
\end{enumerate}

Emergent behaviors include information diffusion, relationship formation, and coordination.

Evaluation with 100 human participants using TrueSkill showed the full architecture (memory, reflection, planning) outperforming ablations and human crowdworkers on believability. Failure modes involved memory retrieval errors, hallucination, overly formal dialogue, and over-cooperation.

Relevance: Generative Agents demonstrate that LLM agents with memory, reflection, and planning achieve high believability, but lack explicit symbolic grounding. No formal model of time, resources, or environmental constraints exists; temporal coherence is heuristic. Actions are not verified against preconditions beyond ad hoc checks, motivating PDDL-based validation.

\subsection{LLMs as Planning Modelers}

Tantakoun et al. survey how LLMs construct and refine automated planning models rather than directly perform planning (Tantakoun et al., 2025). They review approximately 80 papers, positioning LLMs as tools for extracting planning models to support reliable planners.

They introduce a taxonomy:
\begin{enumerate}
	\item LLMs-as-Heuristics.
	\item LLMs-as-Planners.
	\item LLMs-as-Modelers (survey focus).
\end{enumerate}

Within LLMs-as-Modelers they distinguish task modeling, domain modeling, and hybrid modeling.

Key findings: LLMs generate syntactically valid PDDL but struggle with semantic consistency; iterative refinement with planner feedback improves models. This grounds our use of LLMs as PDDL schema generators with symbolic validator feedback.

\subsection{Planning in the Dark: LLM-Symbolic Pipeline without Experts}

Huang et al. propose an LLM-symbolic planning pipeline eliminating expert intervention in action schema generation and validation (Huang et al., 2024). They note that a single LLM instance has extremely low probability of generating a solvable action-schema set from ambiguous descriptions, but combining multiple instances raises this probability substantially.

Their three-step architecture builds a diverse schema library, filters with semantic coherence and Conformal Prediction, and then uses a symbolic planner to generate and rank plans.

Key results show that layman descriptions can yield many solvable schema sets, CP filtering improves solvable ratios while shrinking the search space, and the pipeline solves classic planning benchmarks where direct LLM planning fails.

Relevance: This demonstrates that LLM diversity and semantic validation can produce solvable PDDL schemas without experts. We instead use iterative refinement with planner feedback, aligning with our believability-focused setting.

\subsection{Other Neuro-Symbolic Planning Approaches}

Additional work combines LLMs with planning: robotics approaches like SayCan (Ahn et al., 2022), iterative refinement loops such as LLM+P with critique and repair (Silver et al., 2023; Valmeekam et al., 2023; Lyu et al., 2023), and temporal planning integration (Cashmore and Fox, 2019).

Compared to Generative Agents, these methods assume explicit domain models and delegate feasibility to planners, trading authoring effort for guarantees. Our thesis takes this path but aims to reduce authoring effort via LLM-based schema generation.

\subsection{Summary of Insights and Research Focus}

The literature suggests three converging insights:

\begin{enumerate}
	\item LLM planning produces human-like behavior but lacks long-horizon coherence due to missing symbolic grounding, context window limits, and hallucination (Park et al., 2023; Xiao et al., 2024).
	\item Neuro-symbolic methods offer structure and guarantees by validating or synthesizing plans against explicit models of actions, time, and resources (Huang et al., 2024; Tantakoun et al., 2025).
	\item Believability and coherence should be assessed jointly: constraint adherence is necessary for plausibility, but human evaluation is needed for perceived realism (Park et al., 2023; Xiao et al., 2024).
\end{enumerate}

This thesis investigates whether LLM-generated PDDL schemas combined with symbolic validation can reduce logical inconsistencies and incoherent action sequences while maintaining naturalistic, context-aware LLM behavior.
