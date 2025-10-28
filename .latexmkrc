# LaTeX Workshop configuration for XeLaTeX + biber (matches Overleaf)

# Output directory for all build files
$out_dir = 'build';
$aux_dir = 'build';

# Use XeLaTeX (required for fontspec in Setup/Preamble.tex)
$pdf_mode = 5; # 5 = xelatex
$xelatex = 'xelatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# Force biber for biblatex
$bibtex_use = 2; # Use biber
$biber = 'biber %O %B';

# Default target file
@default_files = ('main.tex');

# Keep going on errors to mimic Overleaf behavior
$max_repeat = 5;
$diagnostics = 1;
$warnings_as_errors = 0;

# Previewer left to the editor (VS Code handles it)
$pdf_previewer = '';

# Clean-up rule similar to Overleaf ephemeral files
$clean_ext = 'run.xml bbl bcf -blx.bib synctex.gz';
