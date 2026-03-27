Close the engagement and generate a final summary report.

Run this when the engagement is complete — all findings are in terminal states (accepted, rejected, or disputed) and no further testing is planned.

**1. Verify readiness to close**
- Read `status.md` — confirm no findings are in non-terminal states (discovered/exploring/exploited/submitted)
- If any findings are still active, warn: "Finding [name] is still [status] — resolve before closing."
- Do not proceed if active findings exist unless the user explicitly confirms.

**2. Generate `ENGAGEMENT_SUMMARY.md` in the root**

```markdown
# Engagement Summary — [Target Name]

**Platform:** [platform]
**Period:** [Started date] → [today]
**Status:** Closed

## Results

| Metric | Value |
|--------|-------|
| Total findings | N |
| Accepted | N |
| Rejected/Disputed | N |
| Total bounty earned | $N |
| Acceptance rate | N% |

## Accepted Findings

| Finding | Severity | Bounty | Submitted | Accepted |
|---------|----------|--------|-----------|----------|
| [name](findings/name/finding.md) | high | $500 | YYYY-MM-DD | YYYY-MM-DD |

## Rejected / Disputed Findings

| Finding | Severity | Reason |
|---------|----------|--------|
| [name] | medium | [reason from comms/] |

## Key Learnings

- [What worked well during this engagement]
- [Attack patterns that were productive]
- [Out-of-scope items to watch for in future engagements]

## Recon Notes Reference

Key assets and patterns documented: `recon/recon_notes.md`
```

**3. Update `status.md`**
- Add a new Phase Status row: `Closed | [today's date]`
- Update `Last Updated` date

**4. Log and git milestone commit**

```bash
echo "$(date '+%Y-%m-%d %H:%M') [close]    engagement closed — $[bounty] earned, [N]/[total] accepted" >> activity.log
git add ENGAGEMENT_SUMMARY.md status.md activity.log
git commit -m "close([target-slug]): engagement closed — $[bounty] earned, [N] findings accepted"
```

**5. Confirm closure**

Report the final stats to the user and remind them to push:
```bash
git push origin main
```
