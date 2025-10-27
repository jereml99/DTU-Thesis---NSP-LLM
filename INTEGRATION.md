# Integration with DTU Thesis Template

## Overview

This Markdown to LaTeX conversion system integrates seamlessly with the DTU thesis template. The generated LaTeX files are designed to work with the existing `main.tex` structure.

## Integration Steps

### Step 1: Ensure Bibliography Citations Exist

Make sure all citations used in your Markdown files (e.g., `[ref:park2023]`) have corresponding entries in `bibliography.bib`.

Example:
```bibtex
@article{park2023,
  title = {Your Article Title},
  author = {Author Names},
  journal = {Journal Name},
  year = {2023}
}
```

### Step 2: Update main.tex

The thesis chapters are stored in the `/Chapters/` directory with numbered prefixes.

After converting Markdown files to LaTeX using `md2tex.py`, copy them from `/tex/` to `/Chapters/` with appropriate numbering:

```latex
\input{Chapters/01_Introduction.tex}
\input{Chapters/02_Background.tex}
\input{Chapters/03_Methodology.tex}
\input{Chapters/04_Results.tex}
\input{Chapters/05_Discussion.tex}
\input{Chapters/06_Conclusion.tex}
```

### Step 3: Compile

The DTU template uses `biblatex` with `biber` backend. Compile with:

```bash
# Using lualatex (recommended for this template due to fontspec)
lualatex main.tex
biber main
lualatex main.tex
lualatex main.tex
```

or

```bash
# Using xelatex
xelatex main.tex
biber main
xelatex main.tex
xelatex main.tex
```

## Generated File Structure

The conversion system maintains a clean structure:

```
DTU-Thesis---NSP-LLM/
├── content/               # Source Markdown files (you edit these)
│   ├── introduction.md
│   ├── background.md
│   ├── methodology.md
│   ├── results.md
│   ├── discussion.md
│   └── conclusion.md
├── tex/                   # Temporary generated LaTeX files (auto-generated)
│   ├── introduction.tex
│   ├── background.tex
│   ├── methodology.tex
│   ├── results.tex
│   ├── discussion.tex
│   └── conclusion.tex
├── Chapters/              # Final thesis chapters (numbered)
│   ├── 01_Introduction.tex
│   ├── 02_Background.tex
│   ├── 03_Methodology.tex
│   ├── 04_Results.tex
│   ├── 05_Discussion.tex
│   └── 06_Conclusion.tex
├── md2tex.py              # Conversion script
├── main.tex               # Main thesis document
└── bibliography.bib       # Bibliography database
```

## Workflow

1. **Edit**: Write/edit your content in Markdown files in `content/`
2. **Convert**: Run `python3 md2tex.py --all` to generate LaTeX files in `tex/`
3. **Copy**: Copy converted files from `tex/` to `Chapters/` with appropriate numbering (e.g., `01_`, `02_`, etc.)
4. **Review**: Check the chapter files in `Chapters/` directory
5. **Compile**: Compile `main.tex` with your LaTeX compiler
6. **Iterate**: Repeat as needed

## Style Compliance

The generated LaTeX files:
- ✅ Use standard DTU section commands (`\chapter`, `\section`, `\subsection`)
- ✅ Compatible with `report` document class
- ✅ Work with `biblatex` and `biber`
- ✅ Support `cleveref` for cross-references
- ✅ No preamble or document structure (pure content)
- ✅ Can be included with `\input{}` command

## Advanced Features

### Custom Chapters

You can create additional chapters by:
1. Creating a new `.md` file in `content/` (e.g., `content/appendix.md`)
2. Running the conversion script (`python3 md2tex.py content/appendix.md`)
3. Copying the generated file to `Chapters/` with appropriate numbering (e.g., `Chapters/07_Appendix.tex`)
4. Adding `\input{Chapters/07_Appendix.tex}` to `main.tex`

### Mixed Approach

You can mix manually written LaTeX chapters with generated ones in the `Chapters/` directory:
```latex
\input{Chapters/01_Introduction.tex}    % Generated from Markdown
\input{Chapters/02_Background.tex}      % Generated from Markdown
\input{Chapters/03_Methodology.tex}     % Generated from Markdown
\input{Chapters/04_CustomChapter.tex}   % Manually written LaTeX
\input{Chapters/05_Results.tex}         % Generated from Markdown
```

## Troubleshooting

### Citations Not Working
- Ensure bibliography entries exist in `bibliography.bib`
- Use correct citation key: `[ref:key]` in Markdown → `\cite{key}` in LaTeX
- Run `biber main` after LaTeX compilation

### Formatting Issues
- Check that your Markdown syntax is correct
- Re-run the conversion script after fixing Markdown
- Review generated `.tex` files for any issues

### Compilation Errors
- The template requires `fontspec` package (use lualatex or xelatex, not pdflatex)
- Ensure all required packages are installed
- Check LaTeX error messages for specific issues

## Benefits

✅ **Simplicity**: Write in easy-to-read Markdown
✅ **Version Control**: Markdown is more git-friendly than LaTeX
✅ **Collaboration**: Non-LaTeX users can contribute in Markdown
✅ **Automation**: Automatic conversion reduces manual formatting
✅ **Consistency**: Guaranteed consistent LaTeX output
✅ **Flexibility**: Mix Markdown and LaTeX chapters as needed
