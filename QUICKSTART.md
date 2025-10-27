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

### 3. Use in Your Thesis
In `main.tex`, uncomment the OPTION 2 section and comment out OPTION 1:

```latex
% OPTION 2: Use automatically generated chapters from tex/ directory
% Uncomment the lines below and comment out OPTION 1 above
\pagenumbering{arabic}
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
\cleardoublepage 
```

### 4. Compile Your Thesis
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
