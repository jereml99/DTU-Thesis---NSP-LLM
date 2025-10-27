# Quick Start Guide

## For Authors

### 1. Edit Your Content
Edit Markdown files in the `/content/` directory:
- `content/introduction.md`
- `content/background.md`
- `content/methodology.md`
- `content/results.md`
- `content/discussion.md`
- `content/conclusion.md`

### 2. Generate LaTeX Files
Run the conversion script:
```bash
python3 md2tex.py --all
```

This will generate corresponding `.tex` files in the `/tex/` directory.

### 3. Copy to Chapters Directory
Copy the generated files to the `/Chapters/` directory with appropriate numbering:
```bash
cp tex/introduction.tex Chapters/01_Introduction.tex
cp tex/background.tex Chapters/02_Background.tex
cp tex/methodology.tex Chapters/03_Methodology.tex
cp tex/results.tex Chapters/04_Results.tex
cp tex/discussion.tex Chapters/05_Discussion.tex
cp tex/conclusion.tex Chapters/06_Conclusion.tex
```

### 4. Compile Your Thesis
The chapters are already configured in `main.tex`:
```latex
\input{Chapters/01_Introduction.tex}
\input{Chapters/02_Background.tex}
\input{Chapters/03_Methodology.tex}
\input{Chapters/04_Results.tex}
\input{Chapters/05_Discussion.tex}
\input{Chapters/06_Conclusion.tex}
```

Use your preferred LaTeX compiler:
```bash
lualatex main.tex
biber main
lualatex main.tex
lualatex main.tex
```

Or use xelatex if you prefer:
```bash
xelatex main.tex
biber main
xelatex main.tex
xelatex main.tex
```

## Markdown Syntax Reference

### Headers
```markdown
# Chapter Title
## Section Title
### Subsection Title
```

### Formatting
```markdown
**bold text**
*italic text*
`inline code`
```

### Citations
```markdown
Research shows [ref:park2023] that...
```

### Lists
```markdown
1. Ordered item
2. Another item

- Unordered item
- Another item
```

### Code Blocks
````markdown
```python
def example():
    return "code"
```
````

## See Also

- `MD2TEX_README.md` - Comprehensive documentation
- `content/introduction.md` - Example content with all features
