# Verification Harness

The shared loop every agent runs through: Gate 0 (deterministic lint scripts) -> Gate 1 (fact-trace verifier, isolated context) -> Gate 2 (rubric judge, adversarial posture) -> loop controller (code-enforced, 3-cycle cap, escalation with disagreement log) -> Amber's tiered gates. Design: pm-factory-strategy.md §3.3-3.4. Build spec: KICKOFF.md Phase 1. This gets built BEFORE any new agent.
