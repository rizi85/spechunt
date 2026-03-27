Check whether a URL, domain, or endpoint is in scope before testing.

Usage: `/spechunt:scope-check <url-or-domain>`

Target to check: `$ARGUMENTS`

**1. Load scope definitions**
- Read `program/scope.md` — in-scope assets, tiers, out-of-scope list
- Read `program/rules.md` — check for nuanced scope rules, path exclusions, vulnerability type exclusions

**2. Evaluate the target**

Check in this order:
1. **Exact domain match** — is `$ARGUMENTS` explicitly listed as in-scope or out-of-scope?
2. **Wildcard match** — does `$ARGUMENTS` fall under a wildcard like `*.target.com`?
3. **Path exclusion** — even if the domain is in-scope, is the specific path excluded (e.g., `/admin`, `/status`, third-party integrations)?
4. **Vulnerability type** — some programs exclude certain vuln classes (self-XSS, rate limiting, SPF, etc.) regardless of asset
5. **Acquisition / subsidiary** — is this a recently acquired asset that might not be in scope yet?

**3. Respond with one of:**

- `✅ IN SCOPE` — Tier N — Bounty range: $X–$Y — [quote the relevant rule]
- `❌ OUT OF SCOPE` — [reason] — [quote the relevant rule]
- `⚠️ AMBIGUOUS` — [what makes it unclear] — **Safe default: treat as out of scope**

**4. If ambiguous**
- Do not test the target
- Note the ambiguity in `recon/recon_notes.md` under a "Scope Questions" section
- Recommend: contact the program to clarify before proceeding

**5. Log this check to `activity.log`**

```bash
echo "$(date '+%Y-%m-%d %H:%M') [scope]    <target> — <IN SCOPE|OUT OF SCOPE|AMBIGUOUS> [tier/reason]" >> activity.log
```

Always err on the side of caution. Testing out-of-scope assets can result in disqualification and legal risk.
