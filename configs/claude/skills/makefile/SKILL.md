---
name: makefile
description: Help with Makefiles - targets, variables, patterns, and best practices
argument-hint: "[target or question]"
allowed-tools: Read, Glob, Grep, Bash
---

Help with Makefiles based on `$ARGUMENTS`.

## Makefile Basics

### Variables
```makefile
# Simple assignment (recursive)
CC = gcc

# Immediate assignment
CC := gcc

# Conditional (set if not defined)
CC ?= gcc

# Append
CFLAGS += -Wall
```

### Automatic Variables
| Variable | Meaning |
|----------|---------|
| `$@` | Target name |
| `$<` | First prerequisite |
| `$^` | All prerequisites |
| `$*` | Stem (matched by %) |
| `$(@D)` | Directory of target |
| `$(@F)` | File part of target |

### Pattern Rules
```makefile
# Compile .c to .o
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Any file from template
%: %.tmpl
	envsubst < $< > $@
```

### Common Patterns

```makefile
.PHONY: all clean test build

# Default target
all: build

# Build with dependencies
build: $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^

# Clean generated files
clean:
	rm -rf build/ *.o

# Run tests
test:
	go test ./...

# Help target
help:
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "%-15s %s\n", $$1, $$2}'
```

### Best Practices

- Use `.PHONY` for non-file targets
- Use `@` prefix to suppress command echo
- Use `-` prefix to ignore errors
- Define `clean` target
- Use variables for repeated values
