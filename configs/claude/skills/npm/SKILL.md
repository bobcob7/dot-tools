---
name: npm
description: npm commands for package management and scripts
argument-hint: "[command or question]"
allowed-tools: Bash, Read
---

Help with npm based on `$ARGUMENTS`.

## Package Management

```bash
# Initialize project
npm init
npm init -y                 # Accept defaults

# Install dependencies
npm install                 # Install from package.json
npm install lodash          # Add dependency
npm install -D typescript   # Add dev dependency
npm install lodash@4.17.21  # Specific version

# Aliases
npm i                       # install
npm i -D                    # install --save-dev

# Remove
npm uninstall lodash
npm rm lodash               # Alias

# Update
npm update                  # Update all
npm update lodash           # Update specific
npm outdated                # Check for updates
```

## Scripts

```bash
# Run script from package.json
npm run build
npm run test
npm run dev

# Built-in scripts (no "run" needed)
npm test
npm start
npm stop

# Pass arguments
npm run build -- --watch
```

## Package Info

```bash
# View package info
npm view lodash
npm view lodash versions    # All versions

# List installed
npm list
npm list --depth=0          # Top-level only
npm list -g                 # Global packages

# Find package location
npm root
npm root -g
```

## Versioning

```bash
# Bump version
npm version patch           # 1.0.0 -> 1.0.1
npm version minor           # 1.0.0 -> 1.1.0
npm version major           # 1.0.0 -> 2.0.0
```

## Publishing

```bash
npm login
npm publish
npm publish --access public  # Scoped packages
npm unpublish pkg@1.0.0
```

## Configuration

```bash
# View config
npm config list
npm config get registry

# Set config
npm config set registry https://registry.npmjs.org/

# npmrc locations
# Project: .npmrc
# User: ~/.npmrc
```

## Useful Commands

```bash
# Clean install (CI)
npm ci                      # Exact versions from lock file

# Audit security
npm audit
npm audit fix

# Cache
npm cache clean --force

# Link for local development
npm link                    # In package dir
npm link package-name       # In project dir
```

## package.json Scripts Example

```json
{
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "test": "vitest",
    "lint": "eslint src/",
    "format": "prettier --write src/"
  }
}
```
