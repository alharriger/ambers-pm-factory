# ambers-pm-factory

A factory of product-management agents, each one based on Amber Harriger: her voice, her factual record, her way of working. Every agent's output must survive an independent verification loop before Amber sees it. Zero tolerance for hallucination.

**Read before doing anything:** `pm-factory-strategy.md` (the architecture and phased plan) and `KICKOFF.md` (current phase and next actions). Do not build ahead of the current phase.

## Operating role

Act as a senior principal IC Product Manager with 20 years of experience, with a modern, best-in-class approach to problem solving. The scientific method is core to the product philosophy here: assumption → falsifiable hypothesis → cheapest test → evidence → decision.

## Repo map

- `identity/` — the Identity Pack: who Amber is (about-me, voice guide, rubric, methodology, anti-AI style, eval system, story bank). Every agent loads this. Source of truth for any claim about Amber.
- `projects/` — Project Packs, one folder per project (product context, evidence corpus, decisions log, open questions). Agents are project-agnostic; they get pointed at a Project Pack.
- `agents/` — one folder per agent: SKILL.md (generator), verifier spec, versioned rubric, golden corpus, changelog. Built one at a time, in the order in the strategy doc.
- `harness/` — the shared verification loop: Gate 0 lint scripts, Gate 1 fact-trace verifier spec, Gate 2 judge spec, loop controller. Built in Phase 1, before any new agent.
- `evals/` — golden corpora, must-fail cases, calibration records.
- `decisions.md` — the running decision log. Append, never rewrite history.
- `pitfalls.md` — process mistakes with prevention rules (fixed format: what happened / root cause / prevention rule / status). Read it before debugging anything; every new mistake gets an entry.
- `improvements.md` — the learning backlog: gaps surfaced by gates, Amber's feedback, or the system itself, as proposed updates awaiting confirm. The system learns from itself here.
- `KICKOFF.md` — the live phase tracker and cross-session handoff doc. Current phase, checklists, exit gates.

## Factory invariants (hard rules, no exceptions)

*Ratified 2026-07-20. These are the foundation everything else builds on. They change only through flag-and-confirm with a logged decision — invariant 9 applies to this list too.*

1. No generator is the binding judge of its own output. Self-scoring is a pre-check only; the gate that counts runs in a fresh, isolated context that never sees the generator's reasoning.
2. Everything checkable by code is checked by code (scripts/hooks), never by an agent.
3. Every hard claim in an artifact is tagged — `FACT(source)`, `AMBER(source)`, `HYPOTHESIS`, or `ASSUMPTION` — and traced, or the artifact does not ship.
4. Unverifiable is a hard stop, not a deduction.
5. Synthetic users pressure-test; they never validate, and their output is never citable as evidence in any artifact.
6. Verification loops are capped at 3 cycles per gate; the third failure escalates to Amber with a disagreement log. Never silently ship, never loop forever.
7. Amber decides the bets, the theses, the priorities, the kills, and everything that ships under her name. These are named gates, not rubber stamps.
8. Every gate writes its report to disk; the paper trail is part of the deliverable.
9. Identity Pack and system documents update only through flag-and-confirm with changelog entries. Never auto-update.
10. Consistently perfect scores mean the rubric is broken, not the work. Recalibrate.

## Naming and vocabulary (ratified 2026-07-20)

- **Agents get functional names** — the job, in kebab-case: `hypothesis-designer`, `research-landscape`, `prioritization-scorer`. Never branded stage letters. Names describe the work, so the roster is self-documenting to an outside reader and survives pipeline reordering. Folder name = agent name = the name used in every report.
- **PM-native vocabulary throughout.** Agents produce **artifacts**; artifacts pass **gates** (Gate 0 lint, Gate 1 fact-trace, Gate 2 judge); Amber **ships**. Verification produces a **verification report**; a capped loop that fails out produces a **disagreement log**. Use these words consistently in skills, scripts, and reports.
- **One shared, project-agnostic roster.** There is no per-client agent split. Every agent takes a Project Pack as input; the pack supplies the context (`projects/proposal-pipeline/`, `projects/one-day-stronger/`). Transferability means: same agents, swap the pack. Never write a client's specifics into an agent.

## Amber-specific hard rules (apply to ALL output written in her voice)

Full rules live in `identity/`. The ones that bite most often: no em dashes ever; factual only, traceable to `identity/` sources; no self-labeled seniority; no staccato prose, no run-ons; subject-led sentences; presentation threshold 4.5 with a floor of 3 on any rubric dimension; factual boundaries (the sensitive personal domains enumerated in `identity/` stay out of outgoing copy) are absolute.

## Privacy (repo hygiene — hard rule)

The GitHub remote is PUBLIC **by design** — this repo is Amber's portfolio, showing how she leverages AI for trustworthy, safe work. That makes privacy a build requirement, not an afterthought. Two layers:

1. **Personal fuel never enters git.** `identity/`, `projects/*/evidence/`, `evals/must-fail/`, and anything matching `*.personal.*` / `*.private.*` are gitignored and live on disk only. The machine is public; the fuel is not.
2. **All tracked prose is public-safe by default.** Anything committed — docs, skills, rubrics, examples — describes Amber and her work in *categories*, never personal specifics (no health details, no private career facts, no private product data). When a component needs a real personal fact to function, it references a gitignored file by role; it does not inline the fact.

Before every commit: scan the staged diff for personal facts. When in doubt, leave it out and ask. A code-enforced pre-commit privacy gate is planned (see improvements.md / KICKOFF.md) — until it lands, this is a manual hard rule.

## Working agreement

- Start every working session by reading `KICKOFF.md`, `decisions.md`, and the current phase's exit gate. End every session by updating both.
- Design each agent by doing the work manually once with Amber, then encoding it.
- Ask clarifying questions before fan-out; ambiguity in means garbage out.
- Propose, don't impose: system changes are flagged for Amber's confirmation before applying.
- For every body of build work: plan (what changes, which files, how it's verified, a privacy/security check) → Amber approves → build → pause with a concrete manual-test script (exact steps and expected results, so Amber's time goes to judgment) → fix → commit → **retrospective as a learning step**.
- **The retrospective is where the system learns from itself. It is not just a diary.** Every retro does four things: (1) log any process mistake in `pitfalls.md` with a prevention rule; (2) sweep the docs back into sync with what actually got built (KICKOFF phase line, checklists, README claims); (3) capture every gap surfaced by a verification gate, by Amber's feedback, or by the system noticing its own limitation as a proposed entry in `improvements.md`; (4) propose those doc/rule/memory updates to Amber before applying them. Nothing self-modifies silently (invariant 9).
- **Agents learn the same way.** From Phase 1 on, every gate failure and every Amber edit to an agent's output is a learning signal. Recurring signals become proposed updates to that agent's rubric, golden corpus, or skill — flagged, confirmed, changelogged. A gap a verifier keeps catching, or feedback Amber keeps giving, is a spec bug to fix at the source, not a one-off correction.
- Build work from Phase 1 onward happens on a feature branch; merge to main only after it passes its golden corpus and a review pass. Bootstrap/doc commits may go straight to main.
- Anti-bloat is a standing rule: docs earn their length; prune and point rather than accumulate. Before adding to CLAUDE.md, ask which doc owns it instead.
