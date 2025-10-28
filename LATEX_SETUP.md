# LaTeX + Zotero Setup for VS Code

This workspace is configured to match Overleaf's LaTeX compilation process using XeLaTeX and biber.

## Requirements

1. **LaTeX Distribution**: Install TeX Live (Linux/macOS) or MiKTeX (Windows)
   ```bash
   # Linux (Debian/Ubuntu)
   sudo apt-get install texlive-full latexmk biber
   
   # macOS (with Homebrew)
   brew install --cask mactex
   ```

2. **VS Code Extension**: Install [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop)

3. **Zotero + Better BibTeX**:
   - Install [Zotero](https://www.zotero.org/download/)
   - Install [Better BibTeX for Zotero](https://retorque.re/zotero-better-bibtex/installation/)

## Zotero Configuration (WSL + Windows)

Since Zotero runs on Windows and your workspace is in WSL, you have two options:

### Option 1: Auto-export to WSL path (Recommended)
1. In Zotero (Windows), right-click your collection → **Export Collection**
2. Choose format: **Better BibLaTeX**
3. Check **"Keep updated"** (auto-syncs when you add/edit citations)
4. Save to your WSL workspace using the Windows path:
   ```
   \\wsl$\Ubuntu\home\ledwo\DTU-Thesis---NSP-LLM\bibliography.bib
   ```
   (Replace `Ubuntu` with your WSL distro name if different)
5. Citation keys will auto-complete in `.tex` files when you type `\cite{`

### Option 2: Symlink from Windows
1. Export `bibliography.bib` to a Windows location (e.g., `C:\Users\YourName\Zotero\bibliography.bib`)
2. Create a symlink in WSL:
   ```bash
   ln -sf /mnt/c/Users/YourName/Zotero/bibliography.bib ~/DTU-Thesis---NSP-LLM/bibliography.bib
   ```

### Finding your WSL path in Windows Explorer
- Open Windows Explorer
- Type in address bar: `\\wsl$`
- Navigate to your distro → `/home/ledwo/DTU-Thesis---NSP-LLM/`
- Bookmark this location for easy access

## Building the Document

### Method 1: Auto-build on save (default)
- Just save any `.tex` file and it will compile automatically

### Method 2: Manual build
- Press `Ctrl+Alt+B` (or `Cmd+Option+B` on macOS)
- Or use the VS Code build task: `Ctrl+Shift+B`

### Method 3: Terminal
```bash
latexmk -xelatex -synctex=1 -interaction=nonstopmode main.tex
```

## Clean Build Files

Run the clean task from VS Code or use:
```bash
latexmk -c  # Clean auxiliary files
latexmk -C  # Clean all including PDF
```

## Font Notes

The template uses Arial (`\setmainfont{Arial}` in `Setup/Settings.tex`). Ensure Arial is installed on your system:

- **Linux**: Install `ttf-mscorefonts-installer`
- **macOS**: Arial is pre-installed
- **Alternative**: Replace with TeX Gyre Heros: `\setmainfont{TeX Gyre Heros}`

## VS Code Terminal Configuration

The workspace includes optimized terminal settings for working with LaTeX and GitHub Copilot:

### How to Change Terminal Settings

Terminal settings are configured in `.vscode/settings.json`. You can customize:

1. **Default Shell**:
   - Linux: `"terminal.integrated.defaultProfile.linux": "bash"` (or "zsh", "fish")
   - macOS: `"terminal.integrated.defaultProfile.osx": "zsh"` (or "bash")
   - Windows: `"terminal.integrated.defaultProfile.windows": "PowerShell"` (or "Command Prompt", "Git Bash")

2. **Terminal Appearance**:
   - Font size: `"terminal.integrated.fontSize": 14` (adjust as needed)
   - Font family: `"terminal.integrated.fontFamily": "monospace"` (or "Consolas", "Monaco", etc.)
   - Cursor style: `"terminal.integrated.cursorStyle": "line"` (or "block", "underline")

3. **Terminal Behavior**:
   - Working directory: `"terminal.integrated.cwd": "${workspaceFolder}"` (starts in project root)
   - Scrollback: `"terminal.integrated.scrollback": 10000` (command history size)

### GitHub Copilot Integration

Copilot is enabled for all file types including LaTeX and Markdown. To modify:
```json
"github.copilot.enable": {
  "*": true,
  "markdown": true,
  "latex": true
}
```

### Quick Terminal Shortcuts

- Open terminal: `` Ctrl+` `` (or `` Cmd+` `` on macOS)
- New terminal: `Ctrl+Shift+` ` (or `Cmd+Shift+` ` on macOS)
- Split terminal: `Ctrl+Shift+5` (or `Cmd+Shift+5` on macOS)

## Files Added

- `.latexmkrc` - XeLaTeX + biber configuration
- `.vscode/settings.json` - LaTeX Workshop and terminal settings
- `.vscode/tasks.json` - Build tasks
- `Setup/Preamble.tex` - Updated to use `\addbibresource` (biblatex best practice)
