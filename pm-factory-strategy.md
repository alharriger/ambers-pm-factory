# The PM Factory — Strategy & Build Plan

**Project:** ambers-pm-factory
**Date:** 2026-07-19 (Session 1 — research and planning only)
**Status:** PROPOSED — nothing in this document is built yet
**Decisions locked this session:** the factory serves the job-search proposal pipeline AND Amber's own product builds; the verification harness is built first as the pattern-setter; Amber sits at tiered judgment gates; this repo becomes the permanent home for the skills and voice system over time.

---

## 1. What we're building

A factory of specialized product-management agents, each one an extension of Amber: her voice, her factual record, her conviction areas, her way of working. Each agent does one well-scoped piece of PM work (a research brief, a hypothesis set, a spec, a roadmap view), and no agent's output reaches Amber until it has survived an independent verification loop that rejects bad work and sends it back until it passes or escalates.

The model is loosely based on the software-factory pattern IndyDevDan teaches ("FORGET Loop Engineering. Agentic Engineering is about THIS"), adapted for knowledge work. The parts that transfer directly:

- **Three actors of value creation.** Amber (judgment, taste, the bets), agents (non-deterministic generation and evaluation), and code (deterministic checks, orchestration, loop control). Code is the most reliable actor and costs nothing to run, so anything checkable by code gets checked by code, never by an agent. Knowing which actor does which job is the whole game.
- **Amber appears at the beginning and the end.** Planning (the prompt, the spec, the thesis) and reviewing (the judgment calls). The system does everything in between.
- **Specialization.** Scout → plan → build → test in his world; research → frame → draft → verify → produce in ours. Small agents with one job each, never one giant skill running a hundred nodes.
- **Closed loops with deterministic gates.** His build agent loops against the linter until it passes. Our generators loop against verification gates until they pass. The loop control lives in code, not in prompt text.
- **Separate code from agents.** Verification scripts are standalone tools the orchestration runs between agents, not lines buried at the bottom of a skill file.
- **Template your expertise.** His line: "your expertise is the most valuable thing you have now, and you can template that into your engineering." Amber's 8 years of PM practice, her writing methodology, her eval discipline — that's the expertise this factory templates.
- **Start with the simplest workflow and walk it yourself first.** Design each agent by doing the work manually once, then encoding it.

The part that does NOT transfer, and it's the crux: **software has a compiler and a test suite; PM artifacts don't.** A research brief that "looks right" has no failing test. The 2026 consensus (Osmani's "Factory Model" essay, Anthropic's agent engineering guidance) is blunt about this: generation capacity now exceeds verification capacity, and plausible-but-wrong output is the #1 failure mode of agent factories for knowledge work. That means the verification layer isn't a feature of this factory. **It IS the factory.** That's why it gets built first.

One more deliberate departure from the video: his endgame is "the best teams start dropping off engineering review." Ours is not. Zero margin for error means Amber's ship-gate never gets automated away. The factory earns trust by making her review fast and focused, not by removing it.

## 2. What already exists, and what it teaches us

The career project is a working prototype of half of this factory, and it's the strongest asset we have:

- The **proposal pipeline** (research → angle → draft → user-check → verify → produce) already discovered the right shape: staged workflow, generator/checker separation, fact-tracing with hard stops, synthetic panels as pressure-tests never validation, named human decision points ("Amber decides format").
- The **voice system** (voice guide, scoring rubric, writing methodology, anti-AI checklist, benchmark corpus, approved-outputs library) is a real, calibrated eval system with versioned rules, changelogs, tiered ground truth, and a flag-and-confirm update loop. This is exactly the "trainable" property Amber wants, already proven on one domain.
- The **failure history is gold.** The purged hallucinations (a fabricated timeline metric, an invented team, an inflated scope claim), the contaminated benchmark that let choppy drafts pass, a voice failure from an output type with no methodology binding — every one of these is a documented factory defect with a documented fix. These become seed test cases for the verification harness. (The specific cases live in the gitignored `evals/must-fail/` corpus, not in this public doc.)

The prototype also has the one flaw Amber herself named: **the generator grades its own homework.** The writing methodology's Step 7 self-score runs inside the same context that wrote the draft. LLM-as-judge research says this reliably inflates scores (self-preference bias), and the system's own history shows it (the 5.0 score on the choppy about-page draft). Several skills have no unbiased checker at all. The factory's core upgrade is moving the binding judgment OUT of the generator: self-score survives as a cheap internal pre-check, but the gate that counts is an isolated verifier that never sees the generator's reasoning.

## 3. Core architecture

### 3.1 Two-layer context: Identity Pack and Project Packs

Every agent is "based on Amber," and the factory must be transferable across projects. Those two requirements resolve into a clean separation:

**The Identity Pack** (one, permanent, versioned): who Amber is and how she thinks. Voice guide, about-me, resume facts, story bank, voice rubric, writing methodology, conviction areas, factual boundaries. Every agent loads it. It travels with the factory to any project.

**Project Packs** (one per project, disposable or long-lived): the context of the thing being worked on. For a proposal: the target company. For One Day Stronger: the product model, users, evidence corpus, decision log, metrics. A Project Pack has a standard shape (product context, evidence corpus, decisions log, open questions) so any agent can be pointed at any project without modification. "Transferable" = same agents, swap the Project Pack.

Agents never blur the two. A claim about Amber traces to the Identity Pack; a claim about the product traces to the Project Pack or a public source; anything else is a labeled hypothesis or a hard stop. This is the proposal-verify rule, promoted to a factory-wide invariant.

### 3.2 The anatomy of one agent

Every agent in the roster ships as a matched set. This is the pattern the verification harness pilot establishes and every later agent copies:

1. **SKILL.md (the generator).** The procedure: inputs, steps, output contract. Written by doing the work manually first, then encoding it. Outputs a draft artifact PLUS a claims ledger (every hard claim tagged `FACT(source)` / `AMBER(source)` / `HYPOTHESIS` / `ASSUMPTION`), so the verifier has something mechanical to grip.
2. **A verifier spec (the unbiased party).** A separate subagent with a fresh context that receives ONLY the artifact, the claims ledger, the sources, and the acceptance criteria — never the generator's reasoning or conversation. Its posture is adversarial: its job is to break the artifact, not to review it.
3. **A rubric, versioned.** Per-artifact-type scored dimensions plus hard-fail conditions, modeled on the voice rubric's structure (weighted dimensions, floors, changelog). Rubric changes bump the version; scores across versions are never compared.
4. **A golden corpus.** 10–20 test cases per agent: real past artifacts (passes), documented past failures (must-fail cases), and edge cases. Run after any change to the skill, rubric, or shared context. The career project's failure history seeds the first corpus.
5. **A changelog.** The flag-and-confirm learning loop the voice system already uses: feedback → classify → propose update → Amber confirms → apply + changelog. No silent self-modification, ever.

### 3.3 The verification loop (the harness)

Layered gates, cheapest and most deterministic first. Code before agents, agents before Amber.

**Gate 0 — Deterministic lint (code, free, instant).** Scripts, not prompts: required sections present, output contract shape valid, citations present and URLs resolvable, source freshness dates in range, claims ledger complete (no untagged hard claims), banned-pattern scan. A big chunk of the voice system's hard rules is mechanically lintable today: em dashes, sentence-initial "So", "most want to," "throughline," "point my work," consecutive same-verb bullet openers, run-on heuristics (word count, "and" count), consecutive "I" openers. Every rule that can move from rubric prose into a script moves; the rubric keeps only what needs judgment.

**Gate 1 — Fact-trace verification (isolated agent).** The verifier walks the claims ledger and confirms each claim against its actual source: opens the file, opens the URL, checks the claim is IN the source (not merely near it — source-laundering is a documented failure mode where citations point at pages that don't contain the claim). Amber-side claims trace to the Identity Pack. Anything unverifiable is a hard fail, not a deduction. This generalizes proposal-verify.

**Gate 2 — Rubric judgment (isolated agent, adversarial posture).** A fresh-context judge scores the versioned rubric: hard-fail dimensions are boolean (one fabricated claim fails the artifact regardless of averages — the voice system's floor rule, generalized), quality dimensions are scored against thresholds. For high-stakes artifacts, the judge runs as a small panel with distinct lenses (factual, voice, structural, "would a skeptical reader buy this") rather than one score. Judges are prompted to refute, and told that finding nothing wrong on a first pass is suspicious. Known judge biases we design against: self-preference (mitigated by context isolation and no access to generator reasoning — full cross-model judging isn't available in a Claude-only stack, so isolation is the mitigation), verbosity bias (economy is a scored dimension), authority bias (Gate 1 already opened the sources, so confident-sounding fake citations die before the judge sees them).

**Loop control (code, not prompts).** Fail → the failure report (specific, per-claim/per-dimension) goes back to the generator with the same session context → revise → re-verify. Maximum 3 cycles per gate. On the third failure the loop STOPS and escalates to Amber with the disagreement log: the artifact, what the verifier keeps rejecting, and why the generator keeps disagreeing. Never silently ship, never loop forever, never present sub-bar work as finished. (This kills quietly-degrading behavior: an infinite loop either games the rubric or burns tokens; a capped loop surfaces the real problem.)

**Gate 3 — Amber, tiered.** Two kinds of stops, per her decision this session:
- **Judgment gates (always stop):** the strategic bet, the thesis/angle, the priority call, the kill call, anything that leaves the building under her name. These are decision points, not rubber stamps — the factory prepares the decision (options, evidence, trade-offs) and waits.
- **Flow-through (no stop):** intermediate artifacts that passed Gates 0–2 feed the next stage automatically. Amber can always open the paper trail (every gate writes its report to disk), but the pipeline doesn't wait.

**Standing invariants** (enforced in the harness so no individual skill can drop them): synthetic-panel output is never citable as evidence in any artifact; no named competency Amber lacks is ever asserted; factual boundaries (the sensitive personal domains enumerated in `identity/`) never enter outgoing copy; every artifact carries its verification report reference.

### 3.4 Why the harness must be code-enforced, not prompt-enforced

Anthropic's own guidance draws the line we're using: instructions in skills and CLAUDE.md are probabilistic — the model can fail to follow them under pressure in a long session. Hooks, scripts, and orchestration are deterministic. Zero margin for error therefore means: the *must-run-verifier*, *block-on-fail*, and *max-iterations* rules live in the deterministic layer. A skill can't "forget" to run its gates, because the skill isn't what runs them.

## 4. The agent roster, pressure-tested

Amber's proposed list, tested against how the discipline actually works (continuous discovery, dual-track, Cagan's four risks, Lean hypothesis practice) and against one hard question per agent: *can an unbiased party actually verify its output?*

### 4.1 Verdicts on the proposed seven

| Proposed | Verdict | Why |
|---|---|---|
| Product Research & Analysis | **Split** | It's a category, not an agent. Becomes (a) Market & Competitive Landscape and (b) Evidence Synthesizer. Both highly verifiable (source-grounding, freshness gates — the proposal-research pattern, generalized). |
| Product Strategy | **Demote to red team** | Strategy is the highest-judgment artifact in PM; an agent-authored strategy is a weighted average of the internet. Amber authors the bet. The agent becomes a **Strategy Stress-Tester**: coherence checks (diagnosis → policy → action), falsifiability of assumptions, pre-mortems, "what would have to be true." You can't verify a strategy is good; you CAN verify it's coherent and falsifiable. |
| User Research | **Split by trust boundary** | (a) Interview Guide Designer (verifiable: no leading questions, past-behavior-over-hypotheticals, coverage) and (b) Research Synthesizer (verifiable: every theme traces to verbatim quotes with source IDs, evidence counts shown). Conducting interviews stays human — that's where PM intuition gets built, and the discipline's strongest voices are explicit that outsourcing it is the failure mode. |
| Set Up Synthetic Users | **Demote to shared infrastructure** | Not an agent — a resource every agent can call. One canonical panel per project, built ONLY from real evidence in the Project Pack, every persona trait carrying provenance (which real quote seeded it) or flagged `assumed`. The proposal pipeline's rule becomes a factory invariant: pressure-test, never validation, never citable as evidence. Research is unambiguous that synthetic users used as validation is theater — they're sycophantic and confirm whatever you feed them. Used as refuters ("what would this persona reject first?"), they're valuable. |
| Develop User Stories | **Keep, re-scoped** | Becomes the story-decomposition mode of the Definition agent (spec in → stories out). Standing alone it invites generating stories from thin air. Best verification story on the whole list: INVEST rubric per story, acceptance-criteria format checks, and a coverage matrix (every spec requirement → ≥1 story, every story → a requirement — which mechanically catches invented scope). |
| Roadmapping | **Keep as assembler, not decider** | A roadmap agent without a prioritization agent upstream will invent priorities. Scoped as: prioritized list + capacity + strategy pillars in → Now/Next/Later out, with a diff vs. the last version and a "what we said no to and why" section. Verifiable: every item traces to a scored opportunity and a pillar (orphans fail), outcome-vs-output phrasing lint. |
| Design Thinking Exercises | **Demote to a mode** | A facilitation method, not a work product. Becomes named modes of an Ideation Partner (How-Might-We, Crazy 8s, assumption mapping, reframing). Divergence quality isn't verifiable and that's fine — its outputs just can't skip the downstream hypothesis and prioritization gates. |

### 4.2 What was missing (ranked)

1. **Hypothesis & Experiment Designer** — the biggest gap. The proposed list had zero representation of the scientific-method spine Amber named as core to her product philosophy: assumption → falsifiable hypothesis → cheapest experiment → success threshold set IN ADVANCE. It's also the most verifiable agent possible (format lint: "We believe X for [segment]; we'll know if [metric] moves [amount] by [date]"; falsifiability check; pre-registered threshold present; risk-type tagged against Cagan's four; is-there-a-cheaper-test check). Every other agent either feeds it or consumes it.
2. **Prioritization Scorer** — RICE/opportunity scoring with shown work. Roadmapping is unbuildable without it. Verifiable: arithmetic recomputable, every input cites evidence or is flagged `guess`, sensitivity check on guessed inputs.
3. **Definition agent (PRD/Spec + Stories)** — the discovery→delivery bridge. Wraps the installed write-spec skill with verification (completeness rubric, problem-statement traceability to evidence, testable acceptance criteria).
4. **Metrics & North Star Definer** — everything upstream references "success metrics" nothing defines. Verifiable: metric-tree coherence, leading/lagging tagging, gameability red-team. Hands off cleanly to the installed product-tracking skills.
5. **Problem Framer / Opportunity Assessor** — turns raw signal into a framed opportunity (JTBD statement, segment, evidence strength, rough sizing with sourced denominators). Prevents every downstream agent from solving unvalidated problems.
6. **Stakeholder Comms Composer** — high frequency, low risk, wraps the installed stakeholder-update skill.
7. **GTM & Positioning Drafter** — real but later-stage.
8. **Post-Launch Review Analyst** — closes the flywheel: compares shipped outcomes to the pre-registered hypotheses and thresholds from #1, and flags outcome-washing. Almost fully mechanical once #1 exists.

### 4.3 What stays human, permanently

The strategic bet. Talking to customers. Priority overrides on top of scores (logged with reasons — the override log is itself a strategy artifact). Kill calls and taste. Relationships and any conversation where trust is the deliverable. Accepting anything as user truth that came from a synthetic panel. The factory's design principle: agents produce drafts with tagged claims and shown work; verifiers check grounding, format, and math; **Amber's seat is choosing.**

## 5. The build plan — start small, scale little by little

Each phase has an exit gate. Nothing in phase N+1 starts until N's exit gate passes. Each agent is built one at a time, by doing the work manually once, then encoding, then testing against its golden corpus.

**Phase 0 — Bootstrap (1 session).** Repo skeleton: `identity/`, `projects/<name>/`, `agents/`, `harness/`, `evals/`, CLAUDE.md (short: house rules and pointers, not content). Migrate the Identity Pack files in as the first citizens. Write the factory's working agreement (this document, plus decisions log). *Exit: repo structure agreed, Identity Pack versioned in git.*

**Phase 1 — The verification harness, piloted on the proposal pipeline (the pattern-setter).** Build the four-gate loop as standalone components: the lint scripts (Gate 0), the fact-trace verifier spec (Gate 1), the judge spec + one versioned rubric (Gate 2), the loop controller with 3-cycle cap and escalation report (code). Then retrofit ONE existing skill end-to-end as the pilot — the natural choice is the proposal draft→verify stages, because live job-search work flows through them now and the self-scoring bias problem is known. Seed the first golden corpus from the career project's documented failures (the purged hallucinations and voice failures become must-fail test cases: the harness is proven when it catches every one of them cold). *Exit: the harness catches 100% of the seeded historical failures, a real proposal artifact passes through all gates, and the escalation path has fired at least once so we've seen what a disagreement log looks like.*

**Phase 2 — First two generators, one per client.** (a) **Product Research & Landscape**: generalize proposal-research into a project-agnostic agent (Project Pack in, sourced brief out) — serves the job search immediately. (b) **Hypothesis & Experiment Designer**: the scientific-method spine — serves One Day Stronger and the other product builds immediately, and its hypothesis-record format becomes the factory's core data contract. Both plug into the Phase 1 harness on day one. *Exit: each agent passes its golden corpus; one real deliverable per client produced through the full loop.*

**Phase 3 — The discovery chain.** Research Synthesizer + Interview Guide Designer, then the Synthetic Panel infrastructure (only buildable now, because panels must be seeded from the synthesizer's real-evidence corpus), then Problem Framer. *Exit: raw evidence in → framed, evidence-graded opportunity out, with every theme quote-traceable.*

**Phase 4 — The delivery chain.** Prioritization Scorer → Metrics Definer → Definition agent (spec + stories) → Roadmap Assembler, in that order because each consumes the previous one's output. *Exit: a framed opportunity travels the whole chain to a roadmap slot with an unbroken trace.*

**Phase 5 — The wrap-around + the router.** Strategy Stress-Tester, Stakeholder Comms, GTM/Positioning, Post-Launch Review. Only now, with multiple proven workflows, does a router (the video's factory-entry agent: request in, right workflow chosen) earn its place. Building the router first would have been building the factory entrance before the factory. *Exit: the full dual-track shape runs; migration of remaining career-project skills into the repo completes.*

## 6. Risks and how the design answers them

- **Judge and generator share a model family (all Claude), so shared blind spots are real.** Mitigations: context isolation (the strongest available lever), deterministic Gate 0 doing as much work as possible, refuter-posture prompts, panel-of-lenses on high-stakes artifacts, and Amber's periodic calibration — she spot-checks a sample of judge verdicts, and every disagreement becomes a rubric test case. If she ever adds a second model provider, the judge is where it plugs in.
- **Score inflation / rubric gaming.** The voice system already learned this lesson (threshold raised to 4.5, floors raised, "if scores are consistently 5.0 the rubric is too easy"). Generalize it: consistently perfect scores trigger recalibration, not celebration.
- **Verification theater** — gates that run but don't bite. Answer: the golden corpus always contains must-fail cases; a harness release that passes a must-fail case is itself a failed release.
- **Token cost.** Multi-agent verification is roughly an order of magnitude more expensive than single-pass generation. That's the price of zero margin, but tier it: full panel treatment for artifacts that leave the building or drive decisions; lighter single-judge loops for internal intermediates.
- **Ambiguity in, garbage out.** Osmani's "specification debt" warning: vague requests propagate wrongly through every downstream agent. Answer: every agent's skill starts with an input contract, and the factory's front door asks Amber the clarifying questions BEFORE fan-out (her own management-style AI practice, encoded).
- **Comprehension drift** — the operator stops understanding what the factory produces. Answer: the tiered gates keep Amber inside every judgment loop, and the paper trail (claims ledgers, verification reports, decision logs) is designed for her reading speed, not for completeness theater.

## 7. Open questions for next session

1. **Naming and taxonomy** — do we brand the agents (like the proposal pipeline's Stage A–F) or keep functional names? Worth deciding before Phase 0 scaffolding.
2. **The proposal pipeline retrofit scope** — Phase 1 pilots the harness on draft→verify. Do the other proposal stages (angle, produce) migrate during Phase 1 or wait for Phase 5?
3. **Project Pack for One Day Stronger** — what evidence exists today (user notes, your own personal training logs, app analytics)? The Hypothesis Designer is only as good as the evidence corpus behind it.
4. **Judge budget** — comfortable ceiling per artifact for the full loop (it will be several model calls per deliverable)?
5. **A second pair of eyes** — any interest in an occasional human calibration ritual (e.g., monthly: re-score 5 judged artifacts yourself and diff against the judge)? The research says this is the single highest-leverage habit for keeping automated judges honest.

---

## Appendix A — Source notes

The video: IndyDevDan, "FORGET Loop Engineering. Agentic Engineering is about THIS" (youtu.be/VQy50fuxI34): three actors of value creation; ADWs (AI developer workflows) composing deterministic code + non-deterministic agents; scout/plan/build/test specialization; closed loops against deterministic gates with same-session retry; sandbox isolation and parallelism; router-fronted factories; "design your workflows by doing the work yourself first"; "keep it simple"; "separate your code and your agents."

Key outside sources shaping the verification design: Addy Osmani, "The Factory Model" (verification is the bottleneck; plausible-but-wrong detection is the operator's #1 skill) and "Loop Engineering" (unattended loops make mistakes unattended); Anthropic, "Building Effective Agents" (evaluator-optimizer pattern, gates between chained steps, max-iteration limits, human checkpoints), "Multi-Agent Research System" (single-call rubric judging, ~20 test cases to start, humans catch what judges miss, structured outputs to filesystem), Claude Code guidance on skills/subagents/hooks (probabilistic vs deterministic enforcement; subagents as isolated contexts); LLM-as-judge bias literature (self-preference, verbosity, authority bias; mitigations: isolation, reference-guided evaluation, panels, human calibration); NN/g and related work on synthetic users (hypothesis generation yes, validation never); adversarial generator/evaluator harness patterns (evaluator sees acceptance criteria + artifact only, never generator reasoning; contract-first acceptance criteria; capped retries with escalation).

## Appendix B — Factory invariants (draft, to be ratified)

1. No generator is the binding judge of its own output.
2. Everything checkable by code is checked by code.
3. Every hard claim is tagged and traced, or the artifact does not ship.
4. Unverifiable ≠ deduction; unverifiable = hard stop.
5. Synthetic users pressure-test; they never validate, and they are never citable as evidence.
6. Loops are capped; the third failure escalates with a disagreement log.
7. Amber decides the bets, the priorities, the kills, and everything that ships under her name.
8. Every gate writes its report to disk; the paper trail is part of the deliverable.
9. System documents update only through flag-and-confirm, with changelogs.
10. Consistently perfect scores mean the rubric is broken, not the work.
