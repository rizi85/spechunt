Draft a complete platform submission report for a finding.

Usage: `/submit <finding-name>`

**1. Read all finding context**
- Read `findings/$ARGUMENTS/finding.md` — metadata, summary, attack chain, impact
- List files in `findings/$ARGUMENTS/evidences/` — note all evidence filenames
- List files in `findings/$ARGUMENTS/poc/` — get exploit code/steps
- Read `program/rules.md` — check submission requirements, preferred format, severity definitions
- Read `recon/scope.md` — confirm asset tier for bounty range estimate

**2. Generate `findings/$ARGUMENTS/writeup/submission.md`**

Populate all fields in the existing `submission.md` template:
- **Title:** Clear, one-line description in the format: `[VulnType] on [endpoint] allows [impact]`
- **Severity + CVSS:** Use the program's severity definitions, not just CVSS score alone
- **Steps to Reproduce:** Must be numbered, literal, copy-paste ready — include exact URLs, headers, payloads, and expected vs actual responses. A triager must be able to reproduce with zero guesswork.
- **Evidence:** Reference actual filenames from `evidences/` using relative paths (`../evidences/filename.png`)
- **Impact:** Write from a business risk perspective — what can an attacker actually do? Data exfiltration, account takeover, financial fraud, reputational damage?
- **Remediation:** Concrete fix — not "validate input" but "use parameterized queries" or "enforce `SameSite=Strict` on session cookies"
- **References:** Link to relevant CWE, OWASP, CVE, or public writeups

**3. Quality check**
- Re-read the completed submission.md
- Verify: every TODO is filled, every evidence filename referenced actually exists, steps are complete and self-contained
- Ensure severity matches the program's definitions in `program/rules.md`

**4. Finalize finding state**
- If `finding.md` status is `exploring`, update it to `exploited`
- Update the Current State section in `finding.md` to reflect: "Ready for submission — draft at `writeup/submission.md`"

Do not submit to the platform directly — the draft goes in `writeup/submission.md` for human review first. When ready to submit, run `/update-finding $ARGUMENTS submitted`.
