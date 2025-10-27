#!/usr/bin/env python3
"""
Markdown to LaTeX Converter for DTU Thesis
Converts Markdown files from /content/ to LaTeX files in /tex/

Usage:
    python md2tex.py content/introduction.md
    python md2tex.py --all  # Convert all files in content/
"""

import re
import os
import sys
from pathlib import Path


class MarkdownToLatexConverter:
    """Converts Markdown content to LaTeX format following DTU thesis style."""
    
    def __init__(self):
        self.in_code_block = False
        
    def convert_inline_formatting(self, text):
        """Convert inline Markdown formatting to LaTeX."""
        # Handle bold (**text** or __text__)
        text = re.sub(r'\*\*(.+?)\*\*', r'\\textbf{\1}', text)
        text = re.sub(r'__(.+?)__', r'\\textbf{\1}', text)
        
        # Handle italic (*text* or _text_) - but not if already in bold
        # This is tricky because we need to avoid matching inside bold
        text = re.sub(r'(?<!\*)\*([^*]+?)\*(?!\*)', r'\\textit{\1}', text)
        text = re.sub(r'(?<!_)_([^_]+?)_(?!_)', r'\\textit{\1}', text)
        
        # Handle inline code (`code`)
        text = re.sub(r'`(.+?)`', r'\\texttt{\1}', text)
        
        # Handle citation markers [ref:xxx] -> \cite{xxx}
        text = re.sub(r'\[ref:([^\]]+)\]', r'\\cite{\1}', text)
        
        return text
    
    def convert_headers(self, line):
        """Convert Markdown headers to LaTeX sections."""
        # Count leading # symbols
        match = re.match(r'^(#{1,6})\s+(.+)$', line)
        if not match:
            return None
            
        level = len(match.group(1))
        title = match.group(2).strip()
        title = self.convert_inline_formatting(title)
        
        # Map header levels to LaTeX commands
        if level == 1:
            return f'\\chapter{{{title}}}'
        elif level == 2:
            return f'\\section{{{title}}}'
        elif level == 3:
            return f'\\subsection{{{title}}}'
        elif level == 4:
            return f'\\subsubsection{{{title}}}'
        elif level == 5:
            return f'\\paragraph{{{title}}}'
        else:  # level 6
            return f'\\subparagraph{{{title}}}'
    
    def convert_list_item(self, line):
        """Convert Markdown list items to LaTeX."""
        # Ordered list
        match = re.match(r'^(\s*)(\d+)\.\s+(.+)$', line)
        if match:
            indent = match.group(1)
            content = self.convert_inline_formatting(match.group(3))
            return f'{indent}\\item {content}'
        
        # Unordered list
        match = re.match(r'^(\s*)[-*+]\s+(.+)$', line)
        if match:
            indent = match.group(1)
            content = self.convert_inline_formatting(match.group(2))
            return f'{indent}\\item {content}'
        
        return None
    
    def is_list_line(self, line):
        """Check if line is a list item."""
        return bool(re.match(r'^\s*(\d+\.|-|\*|\+)\s+', line))
    
    def convert_content(self, markdown_text):
        """Convert full Markdown content to LaTeX."""
        lines = markdown_text.split('\n')
        latex_lines = []
        i = 0
        in_list = False
        list_type = None  # 'itemize' or 'enumerate'
        
        while i < len(lines):
            line = lines[i]
            
            # Handle code blocks
            if line.strip().startswith('```'):
                if not self.in_code_block:
                    # Start code block
                    self.in_code_block = True
                    # Close any open list
                    if in_list:
                        latex_lines.append(f'\\end{{{list_type}}}')
                        in_list = False
                    latex_lines.append('\\begin{verbatim}')
                else:
                    # End code block
                    self.in_code_block = False
                    latex_lines.append('\\end{verbatim}')
                i += 1
                continue
            
            # If inside code block, add line as-is
            if self.in_code_block:
                latex_lines.append(line)
                i += 1
                continue
            
            # Check for headers
            header = self.convert_headers(line)
            if header:
                # Close any open list before header
                if in_list:
                    latex_lines.append(f'\\end{{{list_type}}}')
                    in_list = False
                latex_lines.append(header)
                i += 1
                continue
            
            # Check for list items
            list_item = self.convert_list_item(line)
            if list_item:
                # Determine list type
                is_ordered = bool(re.match(r'^\s*\d+\.', line))
                new_list_type = 'enumerate' if is_ordered else 'itemize'
                
                # Start list if not in one, or switch type if needed
                if not in_list:
                    latex_lines.append(f'\\begin{{{new_list_type}}}')
                    in_list = True
                    list_type = new_list_type
                elif list_type != new_list_type:
                    # Switch list type
                    latex_lines.append(f'\\end{{{list_type}}}')
                    latex_lines.append(f'\\begin{{{new_list_type}}}')
                    list_type = new_list_type
                
                latex_lines.append(list_item)
                i += 1
                continue
            
            # If we were in a list but this line isn't a list item, close the list
            if in_list and not self.is_list_line(line):
                latex_lines.append(f'\\end{{{list_type}}}')
                in_list = False
            
            # Empty line - preserve as paragraph break
            if not line.strip():
                latex_lines.append('')
                i += 1
                continue
            
            # Regular paragraph text
            converted_line = self.convert_inline_formatting(line)
            latex_lines.append(converted_line)
            i += 1
        
        # Close any open list at end
        if in_list:
            latex_lines.append(f'\\end{{{list_type}}}')
        
        return '\n'.join(latex_lines)


def convert_file(md_file_path, output_dir='tex'):
    """Convert a single Markdown file to LaTeX."""
    md_path = Path(md_file_path)
    
    if not md_path.exists():
        print(f"Error: File {md_file_path} does not exist")
        return False
    
    # Read Markdown content
    with open(md_path, 'r', encoding='utf-8') as f:
        markdown_content = f.read()
    
    # Convert to LaTeX
    converter = MarkdownToLatexConverter()
    latex_content = converter.convert_content(markdown_content)
    
    # Determine output file path
    output_dir_path = Path(output_dir)
    output_dir_path.mkdir(parents=True, exist_ok=True)
    
    # Output filename: same as input but with .tex extension
    output_filename = md_path.stem + '.tex'
    output_path = output_dir_path / output_filename
    
    # Write LaTeX content
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(latex_content)
    
    print(f"Converted: {md_file_path} → {output_path}")
    return True


def convert_all_files(content_dir='content', output_dir='tex'):
    """Convert all Markdown files in the content directory."""
    content_path = Path(content_dir)
    
    if not content_path.exists():
        print(f"Error: Directory {content_dir} does not exist")
        return
    
    md_files = list(content_path.glob('*.md'))
    
    if not md_files:
        print(f"No Markdown files found in {content_dir}")
        return
    
    print(f"Found {len(md_files)} Markdown file(s) to convert:")
    for md_file in md_files:
        convert_file(md_file, output_dir)


def main():
    """Main entry point."""
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python md2tex.py <markdown_file>")
        print("  python md2tex.py --all")
        sys.exit(1)
    
    if sys.argv[1] == '--all':
        convert_all_files()
    else:
        convert_file(sys.argv[1])


if __name__ == '__main__':
    main()
