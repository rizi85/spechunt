# Spec Hunt

An AI-powered bug bounty framework that provides structured workspaces for conducting security engagements with AI agents (Claude Code). Consistent folder conventions, YAML metadata tracking, and templates let agents orient themselves quickly and work autonomously on any target.

Each clone of Spec Hunt is a **single engagement** — one target, one repo.

## Quick Start

```bash
# 1. Clone the framework (name it after your target)
git clone <repo-url> target-name
cd target-name

# 2. Initialize the engagement
./init.sh "Target Name"

# 3. Fill in program info from the bounty platform
#    - program/program_description.md  (paste full description)
#    - program/rules.md                (paste rules of engagement)

# 4. Update CLAUDE.md with target-specific details
#    (see "Configuring CLAUDE.md" section below)

# 5. Launch Claude Code and begin recon
claude

# 6. Run /recon to kick off structured passive reconnaissance
#    /recon

# 7. When the agent discovers a vulnerability:
#    /new-finding <finding-name>
```

## Scripts

| Script | Usage | Description |
|--------|-------|-------------|
| `init.sh` | `./init.sh <TargetName>` | Initializes this directory as a new engagement — creates CLAUDE.md, status.md, program/, recon/, findings/ with all READMEs and templates. Git-commits the initial workspace. Run once per engagement. |
| `new_finding.sh` | `./new_finding.sh <finding-name>` | Creates a finding subfolder with finding.md (YAML frontmatter), a pre-filled submission draft, all 5 subfolders with READMEs, and auto-updates status.md + findings/README.md. Git-commits on creation. Finding names must be lowercase, hyphen-separated (e.g. `sql-injection`). |
| `update_finding.sh` | `./update_finding.sh <finding-name> <status> [--bounty <amount>]` | Updates a finding's status in finding.md and status.md, increments the relevant engagement counters, stamps the submission date, and git-commits at key milestones (submitted, accepted, rejected, disputed). |

## Engagement Structure

After running `./init.sh`, the directory looks like this:

```
./
├── README.md                              # This file
├── init.sh                                # Engagement initializer (run once)
├── new_finding.sh                         # Finding scaffolding script
├── update_finding.sh                      # Finding status updater
├── .claude/commands/                      # Agent slash commands (skills)
│   ├── new-finding.md                     # /new-finding <name>
│   ├── recon.md                           # /recon
│   ├── triage.md                          # /triage
│   ├── submit.md                          # /submit <name>
│   ├── update-finding.md                  # /update-finding <name> <status>
│   └── scope-check.md                     # /scope-check <url>
├── .templates/                            # File templates (used by scripts)
├── CLAUDE.md                              # Agent instructions for this engagement
├── status.md                              # Dashboard — all findings at a glance
├── program/                               # [mandatory] Raw program info from platform
│   ├── program_description.md             # Full program description (copy-paste)
│   └── rules.md                           # Rules of engagement, scope, exclusions
├── recon/                                 # [mandatory] Reconnaissance phase outputs
│   ├── scope.md                           # Structured scope (quick agent reference)
│   ├── recon_notes.md                     # Raw recon findings (9 structured sections)
│   ├── triage.md                          # Prioritized findings queue
│   └── triage-report.md                   # OSINT-enriched triage (populated by /triage)
└── findings/                              # [mandatory] One folder per finding
    └── {finding-name}/
        ├── finding.md                     # [mandatory] YAML metadata + state + key files
        ├── evidences/                     # Screenshots, logs, webhook data
        ├── poc/                           # Exploit code, automation scripts
        ├── writeup/
        │   └── submission.md              # Platform submission draft (auto-generated)
        ├── comms/                         # Triager/program owner communications
        └── misc/                          # Test scripts, scratch work
```

## Agent Skills

Spec Hunt includes six slash commands that agents invoke during a session. These live in `.claude/commands/` and are available automatically when Claude Code is launched in this directory.

| Skill | Usage | What it does |
|-------|-------|--------------|
| `/recon` | `/recon` | Structured passive recon — extracts scope into scope.md, fingerprints assets, maps API surface, populates recon_notes.md and triage.md |
| `/triage` | `/triage` | OSINT-enriches each item in triage.md (CVEs, public exploits, complexity), writes triage-report.md, re-orders the priority queue |
| `/new-finding` | `/new-finding <finding-name>` | Runs `new_finding.sh`, then auto-fills finding.md (title, severity, CWE, summary, attack chain, impact) and updates recon/triage.md |
| `/submit` | `/submit <finding-name>` | Reads finding.md + evidences/ + poc/ and drafts a complete platform submission report at `writeup/submission.md` |
| `/update-finding` | `/update-finding <finding-name> <status>` | Runs `update_finding.sh`, verifies finding.md YAML and status.md counters were updated, handles submission date and bounty recording |
| `/scope-check` | `/scope-check <url-or-domain>` | Reads scope.md and rules.md, evaluates the target against exact matches, wildcards, and path exclusions — responds IN SCOPE / OUT OF SCOPE / AMBIGUOUS with the relevant rule quoted |

## Agent Workflow

The framework is designed so AI agents always know what to read first:

1. `program/` — Understand scope, rules, what's out of scope
2. `recon/scope.md` — Quick-reference for scope checks during testing
3. `status.md` — Current state of the engagement and all findings
4. `recon/triage.md` — Priority order for testing
5. `findings/{name}/finding.md` — Current state of any specific finding

## Finding Lifecycle

Each finding progresses through these statuses, tracked in `finding.md` YAML and mirrored in `status.md`:

```
discovered → exploring → exploited → submitted → accepted / rejected / disputed
```

Use `/update-finding <name> <status>` (or `./update_finding.sh` directly) to advance a finding. The script automatically:
- Updates the YAML `status:` field in `finding.md`
- Updates the finding's row in `status.md`
- Stamps `submitted:` date when transitioning to `submitted`
- Increments Submitted / Accepted / Rejected counters in `status.md`
- Adds the bounty amount to `Bounty earned` total when `--bounty` is provided
- Git-commits at key milestones with descriptive messages

## Finding Metadata

Every `finding.md` includes machine-parseable YAML frontmatter:

```yaml
---
id: ssrf-internal-api
title: SSRF on /api/v1/fetch Allows Internal Network Scanning
status: exploited
severity: high
cvss: 8.2
cvss_vector: CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N
asset: api.target.com (Tier 1)
endpoint: /api/v1/fetch?url=
cwe: CWE-918
discovered: 2026-03-01
submitted: null
bounty: null
---
```

Each finding also gets a pre-filled `writeup/submission.md` scaffold covering title, severity, steps to reproduce, evidence references, impact, and remediation.

## Naming Conventions

| Location | Convention | Example |
|----------|------------|---------|
| Finding folders | `lowercase-hyphenated` | `sql-injection`, `xss-search-page` |
| Evidence files | `YYYY-MM-DD_NN_description.ext` | `2026-03-01_01_initial-request.txt` |
| Comms files | `YYYY-MM-DD_NN_description.md` | `2026-03-03_02_triager-request-info.md` |

## Configuring CLAUDE.md

After `init.sh` generates `CLAUDE.md`, fill in the TODO sections. This file is what the AI agent reads first — the more detail you provide, the better it performs.

| Section | What to fill in |
|---------|-----------------|
| **Project Overview** | Target URL, bounty platform, one-line description |
| **Scope & Rules** | Tier 1 and Tier 2 assets, bounty ranges, rate limit for automated tooling |
| **Known Constraints** | WAF/CDN behaviour, auth token lifetimes, IP restrictions, CSP policy, CORS config |
| **Useful Commands** | Curl auth flows, API request templates, header inspection one-liners |

The file ships with commented examples for each constraint and command type. Fill them in as you discover constraints during recon, and remove the examples that don't apply.

## Git History

Every significant action is recorded as a git commit, giving you a full audit trail:

```
finding(xss-search-page): status → accepted ($500)
finding(xss-search-page): status → submitted
finding(xss-search-page): discovered
init(TestCorp): engagement workspace initialized
```

## Starting a New Engagement

For each new target, clone a fresh copy:

```bash
git clone <repo-url> new-target
cd new-target
./init.sh "New Target"
```

Each engagement is fully self-contained — its own repo, its own history.

## License

Private — for authorized security testing only.
