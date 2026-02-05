---
name: jq
description: jq JSON processing - filters, transformations, and queries
argument-hint: "[query or question]"
allowed-tools: Bash, Read
---

Help with jq based on `$ARGUMENTS`.

## Basic Syntax

```bash
# Pretty print
cat file.json | jq '.'

# Get field
jq '.name' file.json

# Get nested field
jq '.user.email' file.json

# Get array element
jq '.[0]' file.json
jq '.items[0]' file.json
```

## Filters

```bash
# Select fields
jq '{name: .name, email: .email}' file.json

# Array iteration
jq '.[]' file.json           # Each element
jq '.items[]' file.json      # Each item in array

# Map over array
jq '.items | map(.name)' file.json

# Filter array
jq '.items | map(select(.active == true))' file.json
jq '.items[] | select(.age > 21)' file.json
```

## Operators

```bash
# Pipe
jq '.items | length' file.json

# Optional (suppress null errors)
jq '.maybe?.nested?' file.json

# Alternative (default value)
jq '.value // "default"' file.json

# Arithmetic
jq '.price * .quantity' file.json
```

## Constructing Output

```bash
# Build object
jq '{id: .id, full_name: "\(.first) \(.last)"}' file.json

# Build array
jq '[.items[].name]' file.json

# Add to object
jq '. + {new_field: "value"}' file.json
```

## Common Patterns

```bash
# Get all keys
jq 'keys' file.json

# Count items
jq '.items | length' file.json

# Unique values
jq '[.items[].category] | unique' file.json

# Group by
jq 'group_by(.category)' file.json

# Sort
jq 'sort_by(.name)' file.json

# Flatten
jq 'flatten' file.json

# Convert to CSV-ish
jq -r '.items[] | [.name, .email] | @csv' file.json

# Raw output (no quotes)
jq -r '.name' file.json
```

## Useful Flags

| Flag | Purpose |
|------|---------|
| `-r` | Raw output (no quotes) |
| `-c` | Compact output |
| `-s` | Slurp (read all inputs into array) |
| `-e` | Exit non-zero if output is null/false |
| `--arg name val` | Pass string variable |
| `--argjson name val` | Pass JSON variable |
