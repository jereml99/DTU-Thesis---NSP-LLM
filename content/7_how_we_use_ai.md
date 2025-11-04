## How we use AI in this thesis

This page documents how AI will be used in the master's thesis, how it can help generate and choose approaches that meet the project's requisites, and how we will use AI to redact and rewrite drafts while keeping human control over content and emphasis. It also provides practical prompts, literature-search tips, and a short summary of DTU's guidance on using AI in academic writing.

### Quick contract (inputs / outputs / success criteria)
- Inputs: your draft text, project requisites (constraints, evaluation criteria), code and agent definitions, and any experimental data or logs.
- Outputs: (1) suggested approaches mapped to the requisites, (2) an AI-assisted rewrite of your draft that preserves your intent and emphasis, (3) suggested literature and citations for further reading, (4) small code or prompt edits (via GitHub Copilot) for experiments and agent definitions.
- Success criteria: output is readable, preserves the authors' intended emphasis, matches stated requisites, and is verifiable (we keep prompts and versions recorded). Final text must be approved and edited by the authors before submission.

### High-level uses
- Draft generation and editing: use an LLM to rewrite, restructure, or clarify text after an initial human draft. The AI acts as an assistant — it suggests phrasing, organization, and concise summaries while the student remains the final author.
- Idea & approach generation: brainstorm candidate methods and experimental designs that align with the project's requisites.
- Coding and asset updates: use GitHub Copilot to implement, refactor, or extend code (agent definitions, simulation scripts, prompt templates, test harnesses).
- Prompt and agent tuning: iterate on prompts and agent config files using AI to create clearer, more robust instructions for LLM-based agents.
- Literature discovery: generate search queries, annotate candidate papers, and summarize findings, while verifying sources and adding proper citations.

### Workflow (human + AI loop)
1. Student writes an initial draft or list of requirements and goals (short bullet list is fine).
2. Run a short AI rewrite pass with explicit instructions to preserve emphasis. Keep the prompt and model/version used. Example: "Rewrite the following paragraph to improve clarity while preserving emphasis on X and Y; keep technical terms and do not add new claims." Provide the draft.
3. Student reviews and edits the rewrite — adjust emphasis, fix factual errors, and add missing references.
4. Iterate (optionally run a second AI pass focusing on structure, or run a domain-expert pass for technical accuracy).
5. For code changes, use Copilot for suggestions and review generated changes locally and in code review before merging.

### How AI helps choose approaches (mapping to requisites)
To pick between candidate approaches, follow a small rubric derived from the project's requisites (assumed examples below — replace with your actual requisites):
- Requisite: interpretability → prefer simpler models, symbolic/logic-based components, or explicit explanation layers.
- Requisite: real-time performance → choose lightweight agents, cached responses, or distillation.
- Requisite: data-efficiency → use few-shot prompting, retrieval-augmented generation (RAG), or small fine-tuning with adapters.
- Requisite: controllability and safety → use constrained decoding, rule-based wrappers, and rigorous testing.

Suggested candidate approaches (shortlist to explore):
- Retrieval-augmented generation (RAG) for grounded responses and reproducible citations.
- Planner + executor architecture for agentic workflows (explicit planning, then grounded execution).
- Simulation-based evaluation: build small simulated environments and agent populations to stress-test behaviors.
- Prompt engineering + chain-of-thought / structured prompting for transparent reasoning.
- Lightweight fine-tuning or LoRA/adapters if reproducible domain tuning is required and compute/budget allow.

Decision steps:
1. Score each candidate against the rubric.
2. Prototype the top 1–2 approaches quickly (small experiments or prompt tests).
3. Pick one as main and another as fallback/ablation in the thesis experiments.

### Practical prompts / templates
Use these as starting points when asking an LLM to rewrite or help choose an approach.

- Rewrite-preserve-emphasis prompt:

"Rewrite the following paragraph to improve clarity and flow while preserving emphasis on [X] and [Y]. Do not introduce new claims or references. Keep the technical terms intact and shorten sentences where possible. Return the revised paragraph and list up to two phrasing alternatives for the first sentence." 

- Approach-scoring prompt:

"Given these project requisites: [list requisites], evaluate these candidate approaches: [A, B, C]. For each approach, give (a) a one-line description, (b) pros and cons relative to the requisites, (c) a small experiment sketch to validate it in 1-2 days." 

Keep a record of the core system prompts that materially shape outputs (for example, the agent prompt used for redaction and the coding assistant configuration), along with model/version and date. Given the interactive nature of AI use, we do not log every query; instead we keep representative examples sufficient for auditability and reproducibility.

### Using GitHub Copilot safely for code & assets
- Use Copilot to suggest code, tests, and refactors. Always review generated code, run tests, and perform static checks.
- Use Copilot suggestions as drafts — annotate and edit before committing. Keep PRs small and reviewable.

### Literature search: strategy and quick queries
1. Start with the repository `content/papers_markdown/` — those saved notes are likely relevant (they already include several agent and believability papers).
2. Useful search queries (for Google Scholar, DTU library, or DBs like ACM/IEEE):
   - "believable agents" agent believability LLM planning
   - "retrieval-augmented generation" evaluation citations reproducibility
   - "generative agents" simulation evaluation methodology
   - "LLM-based agents safety controllability" prompt engineering evaluation
3. Use forward/backward citation tracing on the most relevant papers. Save candidate bib entries in `bibliography.bib` and short notes under `content/papers_markdown/`.

Tip: when the AI suggests a paper, verify the title, authors, and venue via the publisher page or Google Scholar before citing.

### DTU guidance and citation norms
Follow DTU's guidance on the use of AI in academic work: disclose AI-assisted writing and code generation in the thesis (which model, date, and the role it played), keep records of the key system prompts and model versions that influenced outputs, and never attribute intellectual authorship to an AI. See the official DTU guidance: https://www.bibliotek.dtu.dk/en/publishing/reference-management/kunstig-intelligens/eksempler

Evidence from the research literature supports using AI to assist parts of the review workflow (refining search strategies, screening, data extraction, and summarization) when usage is disclosed and methods remain auditable \cite{fabianoHowOptimizeSystematic2024}. Our use aligns with these supported activities and we maintain the key system prompts and representative examples rather than a comprehensive log, balancing transparency with practicality.

Short checklist for DTU compliance:
- Add a short paragraph in the thesis frontmatter or acknowledgements stating which AI tools were used and for what purpose.
- Save the core system prompts that materially influence outputs (for example, the redaction agent prompt and the coding assistant configuration), plus representative examples of AI-assisted transformations with model/version and date.
- Ensure any substantive intellectual contribution is written/confirmed by the student and properly referenced.

### Edge cases & notes
- Do not rely on the AI for factual verification (check all facts, references, and equations).
- If using copyrighted material suggested by the AI, verify licensing and cite sources properly.
- For reproducible experiments, freeze model versions and keep random seeds and environment captures.

### Next steps (how I can help)
1. If you paste a first draft paragraph or bullets here, I can produce a rewrite that preserves your emphasis and tone.
2. I can run a targeted literature search (generate candidate papers and annotate them) if you confirm the subtopics to prioritise.
3. I can create a small `ai/prompt_log.md` and add a template PR that documents prompt usage and model versions.

If you'd like, I can now rewrite a paragraph you provide — paste it and state what to preserve (emphasis, technical terms, or claims).
