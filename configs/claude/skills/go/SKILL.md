---
name: go
description: Go toolchain commands - build, test, modules, and more
argument-hint: "[command or question]"
allowed-tools: Bash, Read, Glob, Grep
---

Help with Go tooling based on `$ARGUMENTS`.

## Module Management

```bash
# Initialize module
go mod init github.com/user/project

# Add dependencies
go get github.com/pkg/errors
go get github.com/pkg/errors@v0.9.1    # Specific version
go get github.com/pkg/errors@latest    # Latest

# Tidy dependencies
go mod tidy

# Download dependencies
go mod download

# Vendor dependencies
go mod vendor

# Show dependency graph
go mod graph

# Why is dependency needed?
go mod why github.com/pkg/errors
```

## Building

```bash
# Build current package
go build

# Build specific package
go build ./cmd/myapp

# Build with output name
go build -o bin/myapp ./cmd/myapp

# Build for different OS/arch
GOOS=linux GOARCH=amd64 go build -o bin/myapp-linux

# Build with version info
go build -ldflags "-X main.version=1.0.0"

# Install binary
go install ./cmd/myapp
```

## Testing

```bash
# Run tests
go test ./...

# Verbose output
go test -v ./...

# Run specific test
go test -run TestName ./...

# With coverage
go test -cover ./...
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out

# Race detection
go test -race ./...

# Benchmarks
go test -bench=. ./...
go test -bench=BenchmarkName -benchmem ./...
```

## Code Quality

```bash
# Format code
go fmt ./...
gofmt -s -w .              # Simplify

# Vet (static analysis)
go vet ./...

# Generate code
go generate ./...
```

## Other Commands

```bash
# Run directly
go run main.go
go run ./cmd/myapp

# List packages
go list ./...
go list -m all             # All modules

# Show documentation
go doc fmt.Println
go doc -all fmt

# Environment
go env
go env GOPATH
go env -w GOPROXY=https://proxy.golang.org,direct
```

## Cross-Compilation Targets

| GOOS | GOARCH |
|------|--------|
| linux | amd64, arm64, arm |
| darwin | amd64, arm64 |
| windows | amd64, arm64 |
| freebsd | amd64 |
