# Copilot Instructions for DTU-Thesis---NSP-LLM

Purpose: This repo is a XeLaTeX + biblatex/biber thesis template with DTU styling, structured for VS Code + LaTeX Workshop. The goal is to keep builds reproducible and content changes localized to chapters and front/back matter.

## Big picture
- Entry point: `main.tex` orchestrates the document; it inputs front matter, chapters, bibliography, and appendices in order.
- Shared setup lives in `Setup/`:
  - `Statics.tex`: thesis metadata (title, authors, date, dept). Edit here, not in pages.
  - `Preamble.tex`: packages (fontspec, cleveref, listings, biblatex) and `\addbibresource{bibliography.bib}`.
  - `Settings.tex`: DTU colors, fonts, headings, TOC depth, headers/footers.
- Content:
  - `Frontmatter/` (title, abstract, acknowledgements), `Chapters/` (01–06 files), `Backmatter/` (appendix, backpage).
  - Figures live in `Pictures/`.
- Bibliography: `bibliography.bib` (intended to be Zotero Better BibTeX auto-export). Bibliography rendered by `\printbibliography` in `main.tex`.
- Build system: `latexmk` configured via `.latexmkrc` to use XeLaTeX+biber and to output into `build/`.

## Build and clean
- Preferred: VS Code task “Build LaTeX (latexmk xelatex + biber)” or LaTeX Workshop auto-build on save.
- Manual: `latexmk -xelatex -synctex=1 -interaction=nonstopmode -file-line-error -outdir=build main.tex`.
- Clean aux: task “Clean LaTeX build files” (or `latexmk -c`); clean all incl. PDF: “Clean all LaTeX files (including PDF)” (or `latexmk -C`).
- Outputs are in `build/`; avoid editing files there.

## Editing conventions (project-specific)
- Add chapters by creating `Chapters/NN_Title.tex` and adding `\input{Chapters/NN_Title.tex}` in `main.tex` at the desired position.
- Update thesis metadata only in `Setup/Statics.tex` (e.g., `\thesistitle`, `\thesisauthor`, date); it propagates to headers/footers via `Settings.tex`.
- Citations: ensure a key exists in `bibliography.bib`, cite with `\cite{key}`; `biblatex`+`biber` will format and list under `\printbibliography`.
- Cross-references: use `\label{...}` and reference with `\cref{...}` (from `cleveref`) for section/figure/table names.
- Figures: place assets in `Pictures/`, then:
  ```tex
  \begin{figure}[H]\centering
    \includegraphics[width=0.8\linewidth]{Pictures/filename}
    \caption{...}\label{fig:filename}
  \end{figure}
  ```
- Code: use `listings` (already configured). For inline files: `\lstinputlisting[language=Python]{path}`; or `\begin{lstlisting}...\end{lstlisting}`.
- Fonts: `fontspec` with Arial requires XeLaTeX (do not switch to pdfLaTeX). On Linux, ensure Arial or substitute as per `LATEX_SETUP.md`.

## Integration notes
- Zotero: recommended to auto-export your collection to `bibliography.bib` (see `LATEX_SETUP.md`). Keys then autocomplete and compile via biber.
- Tasks: `.vscode/tasks.json` defines build/clean; `.latexmkrc` enforces XeLaTeX+biber and `build/` as output.
- Template style: avoid ad-hoc package changes; put new global macros/packages in `Setup/Preamble.tex` with a brief comment.

## Examples from this repo
- Document flow: `main.tex` → Frontmatter → `Chapters/01_Introduction.tex` … `06_Conclusion.tex` → `\printbibliography` → Appendix.
- Metadata example: `Setup/Statics.tex` defines `\thesistitle` used in footers via `Settings.tex`.
- Bibliography config lives in `Setup/Preamble.tex` with `\usepackage[backend=biber,style=numeric,sorting=none]{biblatex}` and `\addbibresource{bibliography.bib}`.

## Troubleshooting
- Citations show as “?”: ensure `biber` is installed and run a clean + full rebuild.
- Font errors: install Arial (Linux: `ttf-mscorefonts-installer`) or switch to TeX Gyre Heros in `Settings.tex` as documented in `LATEX_SETUP.md`.
- Check logs in `build/main.log` if `latexmk` continues after an error.

## Writing guidance for AI
- For content/style help (tone, page budget, epistemic logic notation), follow `.github/chatmodes/Thesis Writing agent.chatmode.md`.
- Keep changes minimal and localized; do not reformat large LaTeX files or alter `Setup/*` unless the change is clearly justified and commented.
