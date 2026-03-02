List all available Spec Hunt skills with their usage and purpose.

Output the following table exactly as written:

---

## Spec Hunt — Available Skills

| Skill | Usage | What it does |
|-------|-------|--------------|
| `/help` | `/help` | Lists all available skills (this output) |
| `/setup` | `/setup` | Parses `program/program_description.md` → populates `program/scope.md` and `program/rules.md` |
| `/recon` | `/recon` | Structured passive recon — fingerprints assets, maps API surface, populates `recon_notes.md` and `triage.md` |
| `/triage` | `/triage` | OSINT-enriches `triage.md`, writes `triage-report.md`, re-orders the priority queue |
| `/new-finding` | `/new-finding <finding-name>` | Scaffolds finding folder, fills `finding.md`, updates `triage.md` and `status.md` |
| `/submit` | `/submit <finding-name>` | Drafts platform submission report at `writeup/submission.md` (platform-aware format) |
| `/update-finding` | `/update-finding <finding-name> <status>` | Updates finding status, increments counters, git milestone commit |
| `/scope-check` | `/scope-check <url-or-domain>` | Checks if a target is IN SCOPE / OUT OF SCOPE / AMBIGUOUS against `program/scope.md` |
| `/status` | `/status` | Current engagement summary — findings, bounty total, recommended next action |
| `/close` | `/close` | Generates `ENGAGEMENT_SUMMARY.md` and closes the engagement |

**Valid finding statuses:** `discovered` → `exploring` → `exploited` → `submitted` → `accepted` / `rejected` / `disputed`

---
