# KICKOFF — Start Here

**Current phase: Phase 0 (Bootstrap) — scaffolding done; exit blocked on Amber's three decisions (invariants, naming, repo visibility)**
**Last updated:** 2026-07-19 (Session 2 — Claude Code bootstrap: .gitignore, working-agreement docs, pilot Project Pack, first local commit)
**Rule:** update the "Current phase" line and the checklists below at the end of every working session.

---

## How to start the first Claude Code session

Open Claude Code in this repo and paste:

> Read CLAUDE.md, KICKOFF.md, pm-factory-strategy.md, and decisions.md. Confirm your understanding of the current phase and its exit gate in 5 bullets or fewer, ask me any clarifying questions, and then propose the work plan for this session. Do not build anything until I approve the plan.

That prompt shape (read → confirm → ask → propose → wait) is the working agreement for every session, not just the first.

---

## Phase 0 — Bootstrap (finish first, ~1 session)

The scaffolding in this repo is most of Phase 0. What remains:

- [ ] Ratify the 10 factory invariants in CLAUDE.md (Amber reads them, edits or approves; log the outcome in decisions.md) — **AMBER**
- [ ] Decide naming/taxonomy for agents (functional names vs. branded stages) — open question #1 from the strategy doc — **AMBER**
- [ ] **AMBER: decide repo visibility.** The GitHub remote is PUBLIC. Recommendation: make it private (`gh repo edit alharriger/ambers-pm-factory --visibility private --accept-visibility-change-consequences`) before anything is pushed — even the strategy docs reference personal topics. Nothing gets pushed until this is decided.
- [x] `git init` housekeeping: remote confirmed; `.gitignore` added excluding all personal information (`identity/`, `projects/*/evidence/`, `evals/must-fail/`, `*.personal.*`/`*.private.*`); scaffold committed locally 2026-07-19. Push deliberately withheld pending the visibility decision above.
- [x] Create `projects/proposal-pipeline/` as the first Project Pack stub (it will be the Phase 1 pilot) — done 2026-07-19
- [x] Skim `identity/` files and flag anything stale — done 2026-07-19; drift flags logged in decisions.md (identity/README "known gap" is stale, two cross-repo path references)

**Exit gate:** invariants ratified, first commit made (push follows the visibility decision), pilot Project Pack exists.

## Phase 1 — The Verification Harness (the pattern-setter)

Build the shared loop as standalone components in `harness/`, then retrofit ONE existing skill (the proposal draft→verify stages) as the pilot. Full design in `pm-factory-strategy.md` §3.3–3.4. Build order:

1. **Gate 0 lint scripts** (`harness/gate0/`) — deterministic checks as runnable scripts: required sections, output-contract shape, citation presence + URL resolvability, freshness dates, claims-ledger completeness, banned patterns (em dashes, sentence-initial "So", "throughline", "point my work", "most want to", consecutive same-verb openers, run-on heuristics, consecutive-"I" openers). Every rule that can be a script becomes a script.
2. **Claims-ledger format** (`harness/claims-ledger.md`) — the tagging spec every generator must emit: `FACT(source)` / `AMBER(source)` / `HYPOTHESIS` / `ASSUMPTION`. This is the factory's core data contract; get it right before anything consumes it.
3. **Gate 1 fact-trace verifier** (`harness/gate1-verifier.md`) — subagent spec: fresh context; receives ONLY artifact + claims ledger + sources + acceptance criteria; opens every source and confirms the claim is IN it; unverifiable = hard fail. Generalizes the proposal-verify skill.
4. **Gate 2 judge** (`harness/gate2-judge.md`) — fresh-context judge spec with adversarial/refuter posture; versioned rubric per artifact type (hard-fail booleans + scored dimensions with thresholds); panel-of-lenses variant for ship-grade artifacts.
5. **Loop controller** (`harness/loop.md` + script) — code-enforced: fail report → back to generator with same session context → max 3 cycles per gate → escalation to Amber with disagreement log. Tiered Amber gates: judgment points stop, verified intermediates flow through.
6. **Seed the must-fail corpus** (`evals/must-fail/`) — from the career project's documented failure history: the purged 8→3-weeks metric, the invented "privacy team," the "experimentation systems" inflation, the 35%-attribution error, the choppy about-page draft, the OpenLoop cold-third-person hook, the build-versus-buy competency claim. The harness is proven when it catches every one of them cold.
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

## What this factory never automates

The strategic bet, talking to customers, priority overrides, kill calls, relationships, and Amber's ship-gate. The factory prepares decisions; Amber makes them.
