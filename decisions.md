# Decision Log

Append-only. Every entry: date, decision, why, and what it affects. Amber's confirmations and overrides are decisions too.

---

## 2026-07-19 — Session 1 (Cowork planning session)

- **The factory serves two clients from day one:** the job-search proposal pipeline and Amber's own product builds. Agents are project-agnostic; context splits into a permanent Identity Pack and per-project Project Packs. *Affects: every agent's input contract.*
- **Build order: verification harness first**, piloted by retrofitting the proposal draft→verify stages. Rationale: PM artifacts have no compiler, so the verification layer IS the factory; zero-margin-for-error means it must exist before any new generator does. *Affects: Phases 1–2.*
- **Amber's role: tiered gates.** Agents self-loop on quality; she stops only at judgment points (bet, thesis, priority, kill, ship). Loop cap: 3 cycles per gate, then escalation with a disagreement log. *Affects: harness loop controller.*
- **This repo is the permanent home.** The voice system and proposal skills migrate in over time; migration is a phase (Phase 5), not a day-one task. Until then the career project remains the live source of truth for its own files — watch for drift against the `identity/` snapshot taken today.
- **Roster verdicts** (full reasoning in pm-factory-strategy.md §4): Product Research split in two; Product Strategy demoted to Strategy Stress-Tester (Amber authors the bet); User Research split (interviews stay human); Synthetic Users demoted to shared infrastructure (pressure-test, never validation); User Stories re-scoped into the Definition agent; Roadmapping scoped as assembler downstream of a Prioritization Scorer; Design Thinking demoted to ideation modes. Missing agents added, #1 ranked: Hypothesis & Experiment Designer.
- **Core architectural rule adopted:** no generator is the binding judge of its own output. The writing methodology's Step 7 self-score becomes a pre-check; an isolated verifier becomes the binding gate. Rationale: LLM self-preference bias, plus the system's own history (the 5.0-scored choppy about-page draft).
- **Rejected from the source video:** the "drop human review" endgame. Amber's ship-gate is permanent.

### Pending Amber's ratification
- The 10 factory invariants in CLAUDE.md
- Agent naming/taxonomy

---

## 2026-07-19 — Session 2 (Claude Code bootstrap)

- **Personal information never enters git.** `.gitignore` added covering `identity/`, `projects/*/evidence/`, `evals/must-fail/`, and `*.personal.*`/`*.private.*` conventions. Verified nothing personal was previously committed (only README.md was tracked). *Affects: every commit; the must-fail corpus stays disk-only unless Amber revisits after a visibility change.*
- **Discovered: the GitHub remote is PUBLIC.** Nothing is pushed until Amber decides visibility; recommendation is private, since even CLAUDE.md and the strategy doc reference personal topics (career specifics, factual-boundary categories). *Affects: Phase 0 exit gate, reworded from "first commit pushed" to "first commit made."* **PENDING AMBER.**
- **Working agreement extended** (from the startup-project bootstrap discipline, adapted): per-body-of-work loop (plan with privacy/security check → Amber approves → build → manual-test script → fix → commit → retrospective); feature branches from Phase 1 onward; `pitfalls.md` added as the process-mistake log with a required format; anti-bloat as a standing rule. Deliberately NOT duplicated from the skill: `ai_docs/` and `working_sprint.md` — this repo's existing docs (CLAUDE.md pointers, KICKOFF.md as live phase tracker, decisions.md, strategy doc) already fill those roles. *Affects: every session.* **Proposed — Amber may edit or veto any of it.**
- **Pilot Project Pack created:** `projects/proposal-pipeline/` (product-context, decisions, open-questions, gitignored evidence/), scoped to the draft→verify retrofit default.
- **Identity Pack drift flags** (flag-and-confirm only; nothing edited): (1) `identity/README.md` "known gap" paragraph is stale — resume.md and evals/ were added after it was written and now exist; (2) `amber_voice_guide.md` references `context/writing-eval-system.md`, a career-project path that is `identity/writing-eval-system.md` here; (3) `identity/evals/resume-evals.md` references `amber-resume-SKILL-updated.md`, which does not exist in this repo. **PENDING AMBER's confirm to fix.**
- **Cross-session memory established** (Claude-side): user context, the never-commit-personal-files rule, and the session protocol saved to persistent memory so every future session starts with them.
