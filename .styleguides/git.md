---
category: styleguide
tool: git
---

# Git Style Guide

## Branches

| Branch | Purpose |
|---|---|
| `master` | Stable, reviewed releases only — **never commit directly** |
| `development` | Ongoing development — default working branch |
| `feature/<name>` | Short-lived branches per session/feature — always branch off `development` |

### Rules

- At the start of each session, create a new `feature/<name>` branch from `development`
- Delete feature branches after merging into `development`
- **Never merge into `development` or `master` autonomously** — always wait for explicit approval
- Merges into `master` happen **only on explicit instruction** and only when the state is complete and error-free
- Releases on `master` are marked with a **version tag** (e.g. `v0.1.0`, `v1.0.0`)

### Workflows

#### Standard development

```bash
git checkout development
git pull origin development
git checkout -b feature/my-feature

# ... make changes, commit ...

git checkout development
git merge --no-ff feature/my-feature
git branch -d feature/my-feature
```

#### Create a release

```bash
git checkout master
git merge development
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin master --tags
git checkout development
```

---

## Commit Messages

### Format

```
<Type>: <short description>
```

- Written in **English**
- Short description is imperative, lowercase after the colon (e.g. `Add: user auth module`)
- Commit in **small, atomic steps** — one logical change per commit

### Types

| Type | Meaning |
|---|---|
| `Add:` | New files or features |
| `Fix:` | Bug fixes |
| `Upd:` | Updates / changes to existing code |
| `Del:` | Deletion of code or logic |
| `Docs:` | Documentation changes |
| `Ref:` | Refactoring (no functional change) |
| `Mve:` | File moves |
| `Rem:` | File deletions |
| `Ren:` | Renames |

### Examples

```
Add: player inventory system
Fix: collision not detected on steep slopes
Upd: increase jump force from 400 to 500
Docs: add setup instructions to README
Ref: extract damage calculation into separate function
```
