Parse the raw program description and rules into structured engagement files.

Run this immediately after pasting content into `program/program_description.md`.

**1. Read the raw program data**
- Read `program/program_description.md` in full
- Read `program/rules.md` if it has content beyond the TODO placeholder

**2. Populate `recon/scope.md`**

Extract and structure the following from the program description:
- **In-Scope Assets table** — every explicitly listed domain, subdomain wildcard, API, or mobile app, with its type (web/api/mobile/infra), tier (if mentioned), and bounty range
- **Bounty Table** — severity → bounty range per tier, exactly as stated by the program
- **Worst-Case Scenarios** — the program's stated priorities or highest-impact vulnerability classes
- **Rate Limits** — any automated tooling restrictions, request rate limits, or scanning policies
- **Out of Scope** — every explicitly excluded asset, vulnerability class, or behaviour, quoted verbatim
- **Tech Stack** — any backend, frontend, or infrastructure details mentioned
- **Key URLs** — login pages, API base URLs, admin panels, documentation links

**3. Populate `program/rules.md`**

If `rules.md` still contains only the TODO placeholder, extract and restructure the rules of engagement from `program_description.md` into clear sections:
- Allowed testing methods
- Prohibited actions
- Disclosure policy
- Response SLAs
- Reward conditions and exclusions

If the user already pasted content directly into `rules.md`, leave it as-is and only fill gaps.

**4. Update `status.md`**
- Fill in the `Platform:` field if identifiable (HackerOne, Bugcrowd, Intigriti, YesWeHack, etc.)

**5. Report what was extracted**

After populating the files, summarise what was found:
- How many in-scope assets were identified
- Bounty range for Tier 1 / critical findings
- Any ambiguous or missing scope items that the user should clarify
- Anything that could not be confidently extracted (leave as TODO in the file)

**6. Ask the user to review**

Prompt: "Please review `recon/scope.md` and `program/rules.md` — correct anything that was misread or missing, then run `/recon` to begin reconnaissance."

Do not run `/recon` automatically. The user should verify the extracted scope before any testing begins.
