# Privacy gate (Phase 0.5)

A deterministic pre-commit hook for a **public** portfolio repo. Invariant 2 applied to Amber's own privacy: keeping personal information out of a public repo is a checkable rule, so it is enforced by code, not by remembering to scan every diff.

## What it does

The [`pre-commit`](pre-commit) hook runs two checks and blocks the commit on any hit:

1. **Personal paths** — refuses any staged file under `identity/`, `projects/*/evidence/`, `evals/must-fail/`, `private/`, `local/`, or matching `*.personal.*` / `*.private.*`. These are gitignored already; this catches a force-add (`git add -f`).
2. **Personal terms** — scans the staged additions against `deny-list.txt`, a gitignored file of real personal terms (names, employers, health specifics, private product identifiers). The deny-list is never committed, so it never leaks the terms it protects. [`deny-list.example.txt`](deny-list.example.txt) is the committed template.

## Install (once per clone)

```
bash harness/privacy/install.sh
```

This sets `core.hooksPath` to this folder (so the hook is version-controlled and travels with the repo) and seeds `deny-list.txt` from the example. **Edit `deny-list.txt` with your real terms** before relying on the gate.

## False positives

If a blocked term is a genuine false positive, `git commit --no-verify` skips the hook — you then own the diff. Prefer rewording the copy to a category reference over bypassing.

## For anyone adopting this factory

Nothing here is Amber-specific. Clone, run the installer, put your own terms in `deny-list.txt`, and the same gate protects you.
