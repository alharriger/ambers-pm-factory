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
- The 10 factory invariants in CLAUDE.md — *RESOLVED 2026-07-20: ratified as written (see Session 3).*
- Agent naming/taxonomy — *RESOLVED 2026-07-20: functional names + PM-native vocabulary + shared roster (see Session 3).*


---

## 2026-07-19 — Session 2 (Claude Code bootstrap)

- **Personal information never enters git.** `.gitignore` added covering `identity/`, `projects/*/evidence/`, `evals/must-fail/`, and `*.personal.*`/`*.private.*` conventions. Verified nothing personal was previously committed (only README.md was tracked). *Affects: every commit; the must-fail corpus stays disk-only unless Amber revisits after a visibility change.*
- **Discovered: the GitHub remote is PUBLIC.** Nothing is pushed until Amber decides visibility; recommendation is private, since even CLAUDE.md and the strategy doc reference personal topics (career specifics, factual-boundary categories). *Affects: Phase 0 exit gate, reworded from "first commit pushed" to "first commit made."* **PENDING AMBER.**
- **Working agreement extended** (from the startup-project bootstrap discipline, adapted): per-body-of-work loop (plan with privacy/security check → Amber approves → build → manual-test script → fix → commit → retrospective); feature branches from Phase 1 onward; `pitfalls.md` added as the process-mistake log with a required format; anti-bloat as a standing rule. Deliberately NOT duplicated from the skill: `ai_docs/` and `working_sprint.md` — this repo's existing docs (CLAUDE.md pointers, KICKOFF.md as live phase tracker, decisions.md, strategy doc) already fill those roles. *Affects: every session.* **Proposed — Amber may edit or veto any of it.**
- **Pilot Project Pack created:** `projects/proposal-pipeline/` (product-context, decisions, open-questions, gitignored evidence/), scoped to the draft→verify retrofit default.
- **Identity Pack drift flags** (flag-and-confirm only; nothing edited): (1) `identity/README.md` "known gap" paragraph is stale — resume.md and evals/ were added after it was written and now exist; (2) `amber_voice_guide.md` references `context/writing-eval-system.md`, a career-project path that is `identity/writing-eval-system.md` here; (3) `identity/evals/resume-evals.md` references `amber-resume-SKILL-updated.md`, which does not exist in this repo. **PENDING AMBER's confirm to fix.**
- **Cross-session memory established** (Claude-side): user context, the never-commit-personal-files rule, and the session protocol saved to persistent memory so every future session starts with them.

---

## 2026-07-20 — Session 4 (Phase 0.5: the privacy gate)

- **Built a code-enforced privacy gate** in `harness/privacy/`: a pre-commit hook that (1) refuses any staged file under a personal path even if force-added, and (2) scans staged additions against a gitignored deny-list of personal terms. The deny-list (`deny-list.txt`) is gitignored so it never leaks the terms it protects; `deny-list.example.txt` is the committed template; `install.sh` wires `core.hooksPath` and seeds a local deny-list. Proven on a planted term, a force-added personal file, and a clean control commit. *Affects: every commit; satisfies invariant 2 for Amber's own privacy on a public repo.*
- **Redaction review applied** (the 5 pre-decision spots): sensitive personal domains and specific past-failure lists swapped for category references, with the real cases living only in the gitignored `evals/must-fail/` corpus. `git grep` confirms tracked files are clean. *Affects: CLAUDE.md, KICKOFF.md, pm-factory-strategy.md.*
- **First push held for Amber's read-through.** Phase 0.5 exit is complete except the push itself; pushing is the moment personal-history prose goes public, so Amber does a final `git log -p` pass with Claude before it happens. *Affects: Phase 0/0.5 exit.*

---

## 2026-07-20 — Session 3 (Amber's Phase 0 decisions)

- **The 10 factory invariants are RATIFIED** as written in CLAUDE.md. They are the foundation future work builds on; they evolve only through flag-and-confirm with a logged decision here (invariant 9 applies to the invariants themselves). *Affects: everything.*
- **The repo stays PUBLIC — deliberately.** It is a portfolio: potential employers should see how Amber leverages AI for efficient, trustworthy, safe work. Consequences accepted and mitigated: (1) personal information never enters tracked files — the machine is public, the fuel (identity, evidence, personal eval cases) stays disk-only per .gitignore; (2) all tracked prose is written public-safe by default — categories, not personal specifics; (3) a code-enforced privacy gate must exist before the first push (plan pending Amber's approval); (4) a one-time redaction review of already-committed files happens before the first push, while history is still trivial to rewrite. *Affects: every commit and push; supersedes the "recommend private" note from Session 2.*
- **Adoptability is a stated future goal:** someone else should eventually be able to clone the factory and feed it their own identity/evidence files. Direction: a committed blank identity-pack template documenting the interface without containing Amber's data. Deferred — noted in KICKOFF future work, not built now. *Affects: how identity-dependent components reference files (by role, not by Amber-specific content) as they get built.*
- **Naming and taxonomy decided** (strategy doc open question #1, now closed): (a) **functional kebab-case agent names** — `hypothesis-designer`, not Stage C — because the roster must be self-documenting to an outside reader of a public portfolio repo and must survive pipeline reordering; (b) **PM-native vocabulary** — artifacts, gates, ship, verification report, disagreement log — which is already the strategy doc's language, so nothing needs rewriting and it reads as product craft; (c) **one shared project-agnostic roster**, with Project Packs supplying all client context, because per-client agent namespacing would duplicate skills and break the transferability the architecture is built on. Convention recorded in CLAUDE.md. *Affects: every agent folder, skill, and report from Phase 1 on.*
- **The factory must learn from itself (Amber's requirement, now part of the working agreement):** the retrospective step is a learning step, not a diary — log pitfalls, sweep docs back into sync, and convert gaps surfaced by verification gates, Amber's feedback, or the system itself into proposed updates in improvements.md. Agents grow the same way: every gate failure and every Amber edit is a learning signal; recurring signals become proposed rubric/corpus/skill updates. All of it flows through flag-and-confirm with changelogs — the system learns, but never silently rewrites itself. *Affects: every session's retrospective; every agent's changelog + golden corpus from Phase 1 on.*
