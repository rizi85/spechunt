Draft a complete platform submission report for a finding.

Usage: `/spechunt:submit <finding-name>`

**1. Read all finding context**
- Read `findings/$ARGUMENTS/finding.md` — metadata, summary, attack chain, impact
- List files in `findings/$ARGUMENTS/evidences/` — note all evidence filenames
- List files in `findings/$ARGUMENTS/poc/` — get exploit code/steps
- Read `program/rules.md` — check submission requirements, severity definitions
- Read `program/scope.md` — confirm asset tier for bounty range estimate
- Read `CLAUDE.md` — extract the **Platform** field to determine submission format

**2. Select the correct submission format based on platform**

- **HackerOne** — Markdown with sections: Summary, Steps To Reproduce, Impact. Severity set via CVSS. Attach evidence as files.
- **Bugcrowd** — Plain sections: Description, Steps to Reproduce, Impact, Suggested Fix. Severity selected from a dropdown (P1–P4), not CVSS.
- **Intigriti** — Structured form: Summary, Reproduction Steps, Impact, Recommendation, References. CVSS vector required.
- **YesWeHack** — Similar to Intigriti; include CVSS vector and affected endpoint explicitly.
- **Other / Unknown** — Use the generic format already in `writeup/submission.md`.

**3. Populate `findings/$ARGUMENTS/writeup/submission.md`**

- **Title:** `[VulnType] on [endpoint] allows [impact]`
- **Severity + CVSS:** Use the program's severity definitions; include the full CVSS vector string
- **Steps to Reproduce:** Numbered, literal, copy-paste ready — exact URLs, headers, payloads, expected vs actual. A triager must reproduce with zero guesswork.
- **Evidence:** Reference actual filenames from `evidences/` — list every file, use relative paths (`../evidences/YYYY-MM-DD_NN_description.ext`)
- **Impact:** Business risk perspective — data exfiltration, account takeover, financial fraud, reputational damage
- **Remediation:** Specific fix, not generic advice
- **References:** CWE, OWASP, CVE, public writeups

**4. Quality check**
- Re-read the completed submission.md
- Every TODO is filled; every evidence filename referenced actually exists; steps are self-contained
- Severity matches the program's definitions in `program/rules.md`

**5. Finalize finding state**
- If `finding.md` status is `exploring`, update it to `exploited`
- Update Current State in `finding.md`: "Ready for submission — draft at `writeup/submission.md`"

Do not submit to the platform directly — the draft goes in `writeup/submission.md` for human review first. When ready, run `/spechunt:update-finding $ARGUMENTS submitted`.

**6. Log to `activity.log`**

```bash
echo "$(date '+%Y-%m-%d %H:%M') [submit]   $ARGUMENTS — submission.md drafted (<severity>, $X–$Y)" >> activity.log
```
