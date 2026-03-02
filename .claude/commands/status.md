Provide a concise summary of the current engagement state and recommend the next action.

**1. Read current state**
- Read `status.md` — findings table, counters, phase status
- Read `recon/triage.md` — priority queue and blocked items
- For any finding with status `exploring` or `exploited`, read `findings/{name}/finding.md`

**2. Report the following (keep it brief — one screen)**

```
## Engagement Snapshot

Phase:     [current active phase from status.md]
Findings:  [N total | N exploited | N submitted | N accepted | N rejected/disputed]
Bounty:    $[earned] earned

## Active Findings
[For each non-terminal finding (not accepted/rejected/disputed):]
- [name] — [status] — [severity] — next: [Current State from finding.md]

## Priority Queue (top 3 untested)
[Top 3 items from triage.md not yet in findings/]

## Recommended Next Action
[One specific action — e.g., "Investigate [triage item] — highest score, no auth required"
 or "Advance [finding] from exploited → submit via /submit <name>"
 or "All triage items tested — run /triage to enrich and reprioritize"]

## Blockers
[From status.md Blockers section, or "None"]
```

**3. Keep it actionable**
- If there are unstarted high-priority triage items, recommend starting the top one
- If a finding is `exploited` but not `submitted`, recommend running `/submit <name>`
- If all findings are in terminal states and triage is empty, recommend running `/recon` again or `/triage` to re-enrich
