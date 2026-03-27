Generate an OSINT-enriched triage report from recon notes and populate the priority queue.

**1. Read current state**
- Read `recon/recon_notes.md` — all raw recon findings
- Read `recon/triage.md` — current priority queue
- Read `program/scope.md` — bounty tiers and worst-case scenarios

**2. Enrich each triage item with OSINT research**

For each item in the triage queue:
- Search for known CVEs or public exploits for the technology/version identified
- Search for historical bug bounty writeups targeting this type of endpoint or pattern
- Assess exploitation complexity: is a public PoC available? Does it require auth?
- Estimate CVSS score range based on impact and attack vector
- Identify if the finding maps to a program "worst-case scenario" (high bounty multiplier)

**3. Write `recon/triage-report.md`**

Use this format per finding:
```
### [Finding Name]
- **CVSS Estimate:** X.X (Low/Medium/High/Critical)
- **Auth Required:** Yes / No
- **Public Exploits:** Yes ([link]) / No
- **Matches Worst-Case:** Yes / No
- **Priority Rationale:** [1-2 sentences explaining why this is prioritized here]
- **Recommended First Step:** [specific action]
```

Order findings by: (impact × likelihood) / effort — highest first.

**4. Sync `recon/triage.md`**
- Update the Priority Queue table to reflect the OSINT-enriched order
- Fill in Score column with the (impact × likelihood) / effort calculation
- Mark any findings that can be tested immediately (no auth) vs blocked

**5. Update `status.md`**
- Set Triage phase → `Complete`
- Update Last Updated date

**6. Log to `activity.log`**

Append one line per scored finding:
```bash
echo "$(date '+%Y-%m-%d %H:%M') [triage]   <name> scored X.X — #N priority (<auth/no-auth>)" >> activity.log
```

After this skill completes, the next step is active testing. Start with the top-priority unauthenticated finding in `recon/triage.md`.
