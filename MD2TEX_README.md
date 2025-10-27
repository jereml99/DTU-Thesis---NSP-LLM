# Markdown to LaTeX Conversion System

This system automatically generates and maintains LaTeX files from Markdown content for the DTU Master's Thesis.

## Directory Structure

- `/content/` - Source Markdown files (.md)
- `/tex/` - Generated LaTeX files (.tex)
- `md2tex.py` - Conversion script

## Usage

### Convert a Single File

```bash
python3 md2tex.py content/introduction.md
```

This will generate `tex/introduction.tex`.

### Convert All Files

```bash
python3 md2tex.py --all
```

This will convert all `.md` files in the `/content/` directory to corresponding `.tex` files in the `/tex/` directory.

## Conversion Rules

The conversion script follows these rules:

### Headers
- `#` → `\chapter{}`
- `##` → `\section{}`
- `###` → `\subsection{}`
- `####` → `\subsubsection{}`

### Inline Formatting
- `**bold**` → `\textbf{...}`
- `*italic*` → `\textit{...}`
- `` `code` `` → `\texttt{...}`

### Code Blocks
```
```
code block
```
```

Converts to:
```latex
\begin{verbatim}
code block
\end{verbatim}
```

### Citations
- `[ref:park2023]` → `\cite{park2023}`

### Lists

**Ordered lists:**
```markdown
1. Item one
2. Item two
```

Converts to:
```latex
\begin{enumerate}
\item Item one
\item Item two
\end{enumerate}
```

**Unordered lists:**
```markdown
- Item one
- Item two
```

Converts to:
```latex
\begin{itemize}
\item Item one
\item Item two
\end{itemize}
```

## Workflow

1. **Edit** Markdown files in `/content/` directory
2. **Convert** using `python3 md2tex.py --all`
3. **Include** in `main.tex` using `\input{tex/introduction}`, etc.
4. **Compile** your thesis using your LaTeX compiler

## File Naming

The conversion maintains the base filename:
- `content/introduction.md` → `tex/introduction.tex`
- `content/background.md` → `tex/background.tex`
- `content/methodology.md` → `tex/methodology.tex`
- `content/results.md` → `tex/results.tex`
- `content/discussion.md` → `tex/discussion.tex`
- `content/conclusion.md` → `tex/conclusion.tex`

## Integration with main.tex

To use the generated files in your thesis, include them in `main.tex`:

```latex
\input{tex/introduction}
\cleardoublepage
\input{tex/background}
\cleardoublepage
\input{tex/methodology}
\cleardoublepage
\input{tex/results}
\cleardoublepage
\input{tex/discussion}
\cleardoublepage
\input{tex/conclusion}
```

## Style Compliance

The generated LaTeX files:
- Use standard section commands (`\chapter`, `\section`, `\subsection`)
- Preserve DTU report style compatibility
- Do **not** include preamble or document structure
- Are designed to be included in the main document using `\input{}`

## Notes

- Keep one chapter per Markdown file for better organization
- Use proper citation keys in your `bibliography.bib` file
- The script preserves paragraph breaks and formatting
- Empty lines in Markdown create paragraph breaks in LaTeX
