# Commit Conventions

This document defines how commits are written and how they relate to issues.

---

## Commit Philosophy

Commits should:

- Be small and focused
- Represent a logical unit of work
- Be understandable in isolation
- Support traceability to issues

---

## Commit Message Format

`<scope>: <short description> (# <issue-number>)`

### Examples

```c
chore: initialize repository structure (#1)
startup: add vector table and reset handler (#7)
drivers: add gpio output driver (#14)
docs: document uart mapping for nucleo_f411re (#18)
```

---

## Scope Prefixes

Common prefixes include:

- `chore` – repo maintenance, structure, tooling
- `docs` – documentation changes
- `startup` – linker, startup, reset, memory init
- `core` – core utilities (assert, panic, systick)
- `drivers` – peripheral drivers
- `apps` – example applications
- `ci` – CI/build automation

Use the closest matching scope.

---

## Issue Linking

- Commits should reference the relevant issue using `(#<issue>)`
- Do **not** use `closes #<issue>` for system bring-up work
- Issues are closed **manually** after Definition of Done is verified

---

## One Issue, One Focus

- Multiple commits may reference the same issue
- Do not mix work from multiple issues in a single commit
- If work expands beyond the issue scope, create a new issue

---

## Commit Discipline

- Avoid “WIP” commits
- Avoid vague messages (“fix stuff”, “updates”)
- Prefer clarity over brevity

A commit message should answer:

> What changed, and why does it exist?
