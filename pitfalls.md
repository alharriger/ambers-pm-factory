# Pitfalls

The working-relationship log. Every mistake gets an entry with a prevention rule — an entry without one is just a diary entry. Read this before debugging anything. Format is fixed:

> **What happened** / **Root cause** / **Prevention rule** / **Status** (Active | Retired)

---

## 2026-07-19 — Public remote nearly received personal files

- **What happened:** The repo scaffold was created with the full Identity Pack (resume, about-me, story bank, personal evals) on disk inside a repo whose GitHub remote is PUBLIC, with no .gitignore. One `git add -A && git push` away from exposing everything.
- **Root cause:** The remote was created before any privacy review of what the repo would contain.
- **Prevention rule:** Personal paths are gitignored (`identity/`, `projects/*/evidence/`, `evals/must-fail/`, `*.personal.*`, `*.private.*`). Before every commit, scan `git status` and the staged diff for personal facts. Nothing gets pushed until Amber decides repo visibility (private strongly recommended — even the strategy docs reference personal topics).
- **Status:** Active

## 2026-07-20 — Deleted a subsection from the append-only decision log

- **What happened:** While updating decisions.md, I removed the "Pending Amber's ratification" subsection because both items were resolved. decisions.md is explicitly append-only ("Append, never rewrite history"). Caught and reverted within the same session — restored the text with RESOLVED annotations instead.
- **Root cause:** Treated a status marker as disposable scratch rather than as part of the historical record.
- **Prevention rule:** In append-only logs (decisions.md and any project decisions.md), never delete or rewrite prior lines. To update status, append a new entry or annotate the existing line in place (e.g. "RESOLVED <date>: ..."). Removal is never the move.
- **Status:** Active

## 2026-07-19 — Snapshot docs drift within hours

- **What happened:** `identity/README.md` states resume.md and the evals/ folder "were not exported in this snapshot" — but both exist on disk, added a couple of hours after the README was written. First session working from the docs would have gone hunting for files already present.
- **Root cause:** A snapshot README describes a moment in time; the directory kept changing after it was written, and nothing forces the two back into sync.
- **Prevention rule:** End every session with a doc sweep: does KICKOFF.md's phase line, the checklists, and any README claims still match the directory on disk? Identity Pack files themselves change only via flag-and-confirm (invariant 9) — so drift there gets *flagged* to Amber, not silently fixed.
- **Status:** Active
