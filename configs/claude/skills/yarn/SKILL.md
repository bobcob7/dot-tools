---
name: yarn
description: Yarn commands for package management (v1 and v4/berry)
argument-hint: "[command or question]"
allowed-tools: Bash, Read
---

Help with Yarn based on `$ARGUMENTS`.

## Yarn Classic (v1)

### Package Management

```bash
# Initialize
yarn init
yarn init -y

# Install
yarn                        # Install from yarn.lock
yarn add lodash             # Add dependency
yarn add -D typescript      # Add dev dependency
yarn add lodash@4.17.21     # Specific version

# Remove
yarn remove lodash

# Update
yarn upgrade                # Update all
yarn upgrade lodash         # Update specific
yarn outdated               # Check for updates
```

### Scripts

```bash
yarn run build
yarn build                  # "run" is optional
yarn test
yarn dev
```

## Yarn Modern (v4/Berry)

### Setup

```bash
# Enable modern yarn
corepack enable
yarn set version stable
```

### Package Management

```bash
# Install
yarn                        # Install dependencies
yarn add lodash
yarn add -D typescript

# Update
yarn up                     # Interactive upgrade
yarn up lodash              # Upgrade specific

# Remove
yarn remove lodash
```

### Workspaces

```bash
# Run in workspace
yarn workspace @myorg/web build

# Run in all workspaces
yarn workspaces foreach run build

# Add to workspace
yarn workspace @myorg/web add lodash
```

### Plugins (v4)

```bash
# Import plugins
yarn plugin import typescript
yarn plugin import workspace-tools

# List plugins
yarn plugin list
```

## Common to Both

### Info Commands

```bash
yarn why lodash             # Why is package installed
yarn list                   # List dependencies
yarn info lodash            # Package info
```

### Cache

```bash
yarn cache clean            # v1
yarn cache clear            # v4
```

### Configuration

```bash
# .yarnrc.yml (v4)
nodeLinker: node-modules    # Use node_modules
enableGlobalCache: true

# Or use PnP (Plug'n'Play)
nodeLinker: pnp
```

## package.json Scripts

```json
{
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "test": "vitest",
    "lint": "eslint src/"
  }
}
```

## Yarn vs npm Commands

| Action | npm | yarn |
|--------|-----|------|
| Install all | `npm install` | `yarn` |
| Add package | `npm install pkg` | `yarn add pkg` |
| Add dev | `npm install -D pkg` | `yarn add -D pkg` |
| Remove | `npm uninstall pkg` | `yarn remove pkg` |
| Run script | `npm run cmd` | `yarn cmd` |
| Clean install | `npm ci` | `yarn --frozen-lockfile` |
