---
name: mdview
description: Render and view markdown files in the browser
argument-hint: "[file.md]"
allowed-tools: Bash, Read, Glob
---

Render a markdown file and open it in the default browser.

## Usage

- `/mdview README.md` - View README.md
- `/mdview docs/guide.md` - View a specific doc file
- `/mdview` - View README.md in current directory (default)

## Steps

1. **Determine the file to view**:
   - Use `$ARGUMENTS` if provided
   - Default to `README.md` if no argument given
   - If argument is a directory, look for README.md in it

2. **Verify the file exists**:
   ```bash
   [[ -f "$file" ]] || echo "File not found: $file"
   ```

3. **Render and open** using mdview:
   ```bash
   mdview "$file"
   ```

4. **Report the result** to the user:
   - Confirm the file was rendered
   - Note the temporary HTML file location if relevant

## Notes

- mdview converts markdown to HTML and opens in the default browser
- Images (including PlantUML URLs) are rendered inline
- Code blocks get syntax highlighting
- Works on WSL by opening in Windows browser
