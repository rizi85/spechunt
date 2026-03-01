Conduct structured reconnaissance on the target. Follow this sequence exactly:

**1. Ingest program data**
- Read `program/program_description.md` and `program/rules.md`
- Extract all in-scope assets, out-of-scope items, and rate limits

**2. Populate `recon/scope.md`**
- Fill the In-Scope Assets table: asset, type (web/api/mobile/infra), tier, bounty range
- Fill the Bounty Table from the program rules
- List all Out of Scope items verbatim from the rules
- Document the tech stack if mentioned
- Set the Rate Limits field

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
- Set Reconnaissance → `In Progress` at the start
- Set Reconnaissance → `Complete` and Triage → `In Progress` when done

Never test out-of-scope assets. When in doubt, run `/scope-check <url>` first.
