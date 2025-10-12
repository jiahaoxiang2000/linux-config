# Git Simple Use

## 1. 🚀 Initialize Repository

```bash
git init
```

## 2. 📁 Track Files

```bash
# Track specific file
git add file.txt

# Track all files
git add .
```

## 3. 🚫 Ignore Files

Create `.gitignore` to exclude files:

```gitignore
# Ignore all .log files
*.log

# Ignore node_modules
node_modules/

# BUT track specific file in ignored folder
!node_modules/important.js
```

**Pattern**: Use `!` to track files within ignored directories.

## 4. 💾 Commit Changes

```bash
git commit -m "feat: add new feature"
```

## 5. ☁️ Push to Remote

```bash
# First time
git remote add origin <url>
git push -u origin master

# Subsequent pushes
git push
```

## 6. 🤖 Advanced Workflow

### 6.1 Claude Code Integration

Use `/commit-push` command to automate:

- Analyzes changes with `git status` and `git diff`
- Generates standardized commit message with emoji
- Stages, commits, and pushes automatically

```bash
/commit-push
```

### 6.2 Lazygit

For visual Git management:

```bash
lazygit
```

Navigate commits, branches, and diffs with keyboard shortcuts.
