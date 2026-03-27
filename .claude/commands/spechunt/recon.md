Conduct structured reconnaissance on the target. Follow this sequence exactly:

**0. Pre-flight scope check**

Before doing anything, read `program/scope.md` and verify it has been populated (no TODO values in the In-Scope Assets table). If the file still contains TODO placeholders, stop and instruct the user:

> "`program/scope.md` has not been populated yet. Run `/spechunt:setup` first to extract scope from the program description, then review it before starting recon."

Do not proceed until scope.md is populated. Testing without a defined scope risks hitting out-of-scope assets.

**1. Ingest program data**
- Read `program/program_description.md` and `program/rules.md`
- Extract all in-scope assets, out-of-scope items, and rate limits

**2. Update `status.md`**
- Set Reconnaissance → `In Progress`

**3. Passive recon (stay within rate limits at all times)**

For each in-scope asset, collect:
- Certificate transparency logs — subdomains via crt.sh pattern: `%.target.com`
- Response headers — `Server`, `X-Powered-By`, `X-Frame-Options`, `Content-Security-Policy`, `Set-Cookie`
- Technology fingerprints — JS framework hints, error page signatures, cookie names
- robots.txt, sitemap.xml, /.well-known/security.txt
- Swagger/OpenAPI endpoints: `/api-docs`, `/swagger.json`, `/openapi.json`, `/api/v1/swagger`
- JavaScript files — extract endpoints, parameters, secrets, internal paths
- Authentication flow — login endpoints, SSO providers, token formats, session management

**4. Document findings in `recon/recon_notes.md`**
- Write under each relevant section heading
- Include raw output snippets where useful
- Flag anything interesting with `[!]`

**5. Build `recon/triage.md`**
- Score each potential finding: (impact × likelihood) / effort (1–5 scale each)
- List unauthenticated attack surface first
- Group authenticated findings under "Blocked (Requires Auth)"
- Mark findings that overlap with known CVEs or public writeups

**6. Update `status.md` phase status**
- Set Reconnaissance → `Complete` and Triage → `In Progress`

**7. Log to `activity.log`**

Append one line per significant discovery as you work through step 3. Use the Bash tool:
```bash
echo "$(date '+%Y-%m-%d %H:%M') [recon]    description — detail" >> activity.log
```
Examples of what to log:
- Subdomain batch: `[recon]    crt.sh: target.com — N subdomains`
- Tech stack: `[recon]    tech: nginx/1.18, React, Cloudflare WAF`
- API spec: `[recon]    swagger found: /api/v1/swagger.json`
- Notable endpoint: `[recon]    endpoint: /api/v1/admin — no auth observed [!]`
- Auth flow: `[recon]    auth: JWT, POST /auth/login, 15min expiry`

Never test out-of-scope assets. When in doubt about a specific URL, run `/spechunt:scope-check <url>` first.
