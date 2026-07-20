# KICKOFF — Start Here

**Current phase: Phase 0 + 0.5 COMPLETE and pushed. Next session starts Phase 1 (the verification harness).**
**Last updated:** 2026-07-20 (Session 4 — Phase 0.5 privacy gate built, tested, redactions applied, repo pushed public and clean)

## → Next session: start here

1. Run the session-start prompt below (read → confirm → ask → propose → wait).
2. Read `decisions.md` (Sessions 1–4) and `improvements.md` before touching anything — the learning backlog is current (the 3 Identity Pack drift items were resolved 2026-07-20; see `identity/README.md`'s path-convention note before using any snapshot cross-reference).
3. **Phase 1 is the work:** build the verification harness in `harness/` as standalone components, in the 7-step order below, then retrofit the proposal draft→verify stages as the pilot. Do NOT build any agent yet — the harness comes first.
4. First Phase-1 action to propose to Amber: the claims-ledger format (`harness/claims-ledger.md`), because it is the data contract every gate and generator depends on. Walk one real proposal artifact manually before encoding, per the working agreement.
5. Housekeeping already done, don't redo: privacy gate installed (`bash harness/privacy/install.sh` on a fresh clone), naming convention set (functional names, PM-native vocab, shared roster — in CLAUDE.md), invariants ratified.

**Open items carried in:** Amber to review/expand the private `harness/privacy/deny-list.txt`; the Phase 2 One Day Stronger evidence-inventory conversation (blocks Phase 2b, not Phase 1). (Identity Pack drift flags — resolved 2026-07-20.)
**Rule:** update the "Current phase" line and the checklists below at the end of every working session.

---

## How to start the first Claude Code session

Open Claude Code in this repo and paste:

> Read CLAUDE.md, KICKOFF.md, pm-factory-strategy.md, and decisions.md. Confirm your understanding of the current phase and its exit gate in 5 bullets or fewer, ask me any clarifying questions, and then propose the work plan for this session. Do not build anything until I approve the plan.

That prompt shape (read → confirm → ask → propose → wait) is the working agreement for every session, not just the first.

---

## Phase 0 — Bootstrap (finish first, ~1 session)

The scaffolding in this repo is most of Phase 0. What remains:

- [x] Ratify the 10 factory invariants in CLAUDE.md — **ratified 2026-07-20**
- [x] Naming/taxonomy decided **2026-07-20**: functional kebab-case agent names, PM-native vocabulary (artifacts / gates / ship), one shared project-agnostic roster driven by Project Packs. Convention lives in CLAUDE.md.
- [x] Repo visibility decided: **PUBLIC by design** (2026-07-20). It is a portfolio piece. Privacy becomes a build requirement — see Phase 0.5 below; nothing is pushed until that gate exists and the redaction review passes.
- [x] `git init` housekeeping: remote confirmed; `.gitignore` added excluding all personal information (`identity/`, `projects/*/evidence/`, `evals/must-fail/`, `*.personal.*`/`*.private.*`); scaffold committed 2026-07-19; pushed public 2026-07-20 after the Phase 0.5 privacy gate landed.
- [x] Create `projects/proposal-pipeline/` as the first Project Pack stub (it will be the Phase 1 pilot) — done 2026-07-19
- [x] Skim `identity/` files and flag anything stale — done 2026-07-19; drift flags logged in decisions.md (identity/README "known gap" is stale, two cross-repo path references)

**Exit gate:** invariants ratified ✓, first commit made ✓, pilot Project Pack exists ✓. **PHASE 0 COMPLETE** (push landed with Phase 0.5).

## Phase 0.5 — The privacy gate (DONE 2026-07-20, pending push)

The repo is public on purpose, so "don't commit personal information" is a rule enforced by code, not memory — invariant 2 applied to Amber's own privacy.

1. [x] **Pre-commit hook** (`harness/privacy/`) — blocks any staged file under a personal path and scans the staged diff against a gitignored deny-list of personal terms. Install: `bash harness/privacy/install.sh`. Verified: blocks a planted term, blocks a force-added personal file, allows a clean commit.
2. [x] **One-time redaction review** — the 5 pre-decision spots swapped for category references; `git grep` for the terms returns clean across tracked files. Details in improvements.md.
3. [x] **First push** — Amber did the read-through (One Day Stronger and cited author names confirmed fine to be public); pushed clean 2026-07-20.

**Exit gate:** hook proven on a planted string ✓; redactions applied ✓; repo pushed clean ✓. **PHASE 0.5 COMPLETE.**

## Phase 1 — The Verification Harness (the pattern-setter)

Build the shared loop as standalone components in `harness/`, then retrofit ONE existing skill (the proposal draft→verify stages) as the pilot. Full design in `pm-factory-strategy.md` §3.3–3.4. Build order:

1. **Gate 0 lint scripts** (`harness/gate0/`) — deterministic checks as runnable scripts: required sections, output-contract shape, citation presence + URL resolvability, freshness dates, claims-ledger completeness, banned patterns (em dashes, sentence-initial "So", "throughline", "point my work", "most want to", consecutive same-verb openers, run-on heuristics, consecutive-"I" openers). Every rule that can be a script becomes a script.
2. **Claims-ledger format** (`harness/claims-ledger.md`) — the tagging spec every generator must emit: `FACT(source)` / `AMBER(source)` / `HYPOTHESIS` / `ASSUMPTION`. This is the factory's core data contract; get it right before anything consumes it.
3. **Gate 1 fact-trace verifier** (`harness/gate1-verifier.md`) — subagent spec: fresh context; receives ONLY artifact + claims ledger + sources + acceptance criteria; opens every source and confirms the claim is IN it; unverifiable = hard fail. Generalizes the proposal-verify skill.
4. **Gate 2 judge** (`harness/gate2-judge.md`) — fresh-context judge spec with adversarial/refuter posture; versioned rubric per artifact type (hard-fail booleans + scored dimensions with thresholds); panel-of-lenses variant for ship-grade artifacts.
5. **Loop controller** (`harness/loop.md` + script) — code-enforced: fail report → back to generator with same session context → max 3 cycles per gate → escalation to Amber with disagreement log. Tiered Amber gates: judgment points stop, verified intermediates flow through.
6. **Seed the must-fail corpus** (`evals/must-fail/`) — from the career project's documented failure history (the specific cases live in the gitignored corpus, not in this public tracker): a fabricated timeline metric, an invented team, an inflated scope claim, a misattributed impact number, a choppy draft that slipped a contaminated benchmark, a cold third-person hook, and an unsupported competency claim. The harness is proven when it catches every one of them cold.
7. **Pilot retrofit** — run a real proposal artifact through the full loop (Gates 0→1→2, loop controller, Amber ship-gate). The generator's internal self-score stays as a pre-check; the harness becomes the binding gate.

**Exit gate:** harness catches 100% of the seeded must-fail cases; one real proposal artifact passes end-to-end; the escalation path has fired at least once (deliberately, if necessary) so the disagreement log format is proven.

## Phase 2 preview (do not start until Phase 1 exits)

Two generators, one per factory client: **Product Research & Landscape** (generalize proposal-research; serves the job search) and **Hypothesis & Experiment Designer** (the scientific-method spine; serves One Day Stronger and the other product builds). Both plug into the harness on day one. Roster, dependency order, and later phases: strategy doc §4–5.

---

## Open questions carried into build (answer as they become blocking)

1. Agent naming/taxonomy (blocking Phase 0 exit)
2. Scope of proposal-pipeline retrofit — draft→verify only in Phase 1, or angle/produce too? (default: draft→verify only)
3. What evidence exists today for a One Day Stronger Project Pack? (blocking Phase 2b)
4. Token/cost ceiling per fully-verified artifact (informs single-judge vs. panel tiering)
5. Monthly calibration ritual: Amber re-scores ~5 judged artifacts and diffs against the judge (recommended; decide by end of Phase 1)

## Future work (not scheduled — revisit after Phase 1)

- **Adoptability.** Someone else should be able to clone the factory and feed it their own identity and evidence files. Direction: a committed `identity/TEMPLATE/` blank pack that documents the interface (what each file supplies, required sections) without containing Amber's content. Cheap to add later *if* every identity-dependent component keeps referencing files by role rather than inlining Amber-specific content — so build that way from now on.

## What this factory never automates

The strategic bet, talking to customers, priority overrides, kill calls, relationships, and Amber's ship-gate. The factory prepares decisions; Amber makes them.
