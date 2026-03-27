# Spec Hunt

An AI-powered bug bounty framework that provides structured workspaces for conducting security engagements with AI agents (Claude Code). Consistent folder conventions, YAML metadata tracking, and templates let agents orient themselves quickly and work autonomously on any target.

Each clone of Spec Hunt is a **single engagement** — one target, one repo.

## Quick Start

```bash
# 1. Clone the framework
git clone <repo-url>
cd spechunt

# 2. Initialize the engagement — the directory is renamed automatically
./init.sh "Target Name"
cd ../target-name        # navigate to the renamed directory

# 3. Paste the full program description from the bounty platform
#    into program/program_description.md

# 4. Fill in two fields in CLAUDE.md: Program URL and Platform

# 5. Launch Claude Code
claude

# 6. Run /spechunt:setup — the agent reads program_description.md and
#    auto-populates program/scope.md and program/rules.md with
#    structured tiers, bounty tables, out-of-scope lists, etc.
#    Review the output, correct anything, then continue.

# 7. Run /spechunt:recon to begin passive reconnaissance

# 8. When the agent discovers a vulnerability:
#    /spechunt:new-finding <finding-name>
```

## Scripts

| Script | Usage | Description |
|--------|-------|-------------|
| `init.sh` | `./init.sh <TargetName>` | Initializes this directory as a new engagement — creates CLAUDE.md, status.md, program/, recon/, findings/ with all READMEs and templates. Renames the project directory to a slug of the target name (e.g. `"My Target"` → `my-target`). Git-commits the initial workspace. Run once per engagement. |
| `new_finding.sh` | `./new_finding.sh <finding-name>` | Creates a finding subfolder with finding.md (YAML frontmatter), a pre-filled submission draft, all 5 subfolders with READMEs, and auto-updates status.md + findings/README.md. Git-commits on creation. Finding names must be lowercase, hyphen-separated (e.g. `sql-injection`). |
| `update_finding.sh` | `./update_finding.sh <finding-name> <status> [--bounty <amount>]` | Updates a finding's status in finding.md and status.md, increments the relevant engagement counters, stamps the submission date, and git-commits at key milestones (submitted, accepted, rejected, disputed). Warns if the status.md row update cannot be verified. |

All three scripts support `--help` / `-h` for usage information.

## Engagement Structure

After running `./init.sh`, the directory looks like this:

```
./
├── README.md                              # This file
├── init.sh                                # Engagement initializer (run once)
├── new_finding.sh                         # Finding scaffolding script
├── update_finding.sh                      # Finding status updater
├── .claude/commands/                      # Agent slash commands (skills)
│   └── spechunt/
│       ├── help.md                        # /spechunt:help
│       ├── setup.md                       # /spechunt:setup
│       ├── recon.md                       # /spechunt:recon
│       ├── triage.md                      # /spechunt:triage
│       ├── new-finding.md                 # /spechunt:new-finding <name>
│       ├── submit.md                      # /spechunt:submit <name>
│       ├── update-finding.md              # /spechunt:update-finding <name> <status>
│       ├── scope-check.md                 # /spechunt:scope-check <url>
│       ├── status.md                      # /spechunt:status
│       └── close.md                       # /spechunt:close
├── .gitignore                             # Protects secrets and sensitive files
├── .templates/                            # File templates (used by scripts)
├── CLAUDE.md                              # Agent instructions for this engagement
├── status.md                              # Dashboard — all findings at a glance
├── activity.log                           # Append-only audit trail (never read by agent on startup)
├── program/                               # [mandatory] Raw program info + structured scope
│   ├── program_description.md             # Full program description (copy-paste)
│   ├── rules.md                           # Rules of engagement (structured by /spechunt:setup)
│   └── scope.md                           # Tiers, bounty table, out-of-scope (structured by /spechunt:setup)
├── recon/                                 # [mandatory] Agent-discovered target data
│   ├── recon_notes.md                     # Raw recon findings (9 structured sections)
│   ├── triage.md                          # Prioritized findings queue
│   └── triage-report.md                   # OSINT-enriched triage (populated by /spechunt:triage)
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

Spec Hunt includes ten slash commands that agents invoke during a session. These live in `.claude/commands/spechunt/` and are available automatically when Claude Code is launched in this directory.

| Skill | Usage | What it does |
|-------|-------|--------------|
| `/spechunt:help` | `/spechunt:help` | Lists all available skills with usage and descriptions |
| `/spechunt:setup` | `/spechunt:setup` | Reads `program/program_description.md` and auto-populates `program/scope.md` (tiers, bounty table, out-of-scope list, rate limits) and structures `program/rules.md`. Run once after pasting the program description. |
| `/spechunt:recon` | `/spechunt:recon` | Structured passive recon — fingerprints assets, maps API surface, documents auth flows, populates recon_notes.md and triage.md. Pre-flight scope check aborts early if scope.md is not yet populated. |
| `/spechunt:triage` | `/spechunt:triage` | OSINT-enriches each item in triage.md (CVEs, public exploits, complexity), writes triage-report.md, re-orders the priority queue |
| `/spechunt:new-finding` | `/spechunt:new-finding <finding-name>` | Runs `new_finding.sh`, then auto-fills finding.md (title, severity, CWE, summary, attack chain, impact) and updates recon/triage.md |
| `/spechunt:submit` | `/spechunt:submit <finding-name>` | Reads finding.md + evidences/ + poc/ and drafts a complete platform submission report at `writeup/submission.md`. Detects the platform from CLAUDE.md and applies platform-specific formatting (HackerOne, Bugcrowd, Intigriti, YesWeHack). |
| `/spechunt:update-finding` | `/spechunt:update-finding <finding-name> <status>` | Runs `update_finding.sh`, verifies finding.md YAML and status.md counters were updated, handles submission date and bounty recording. Includes a full dispute workflow for rejected findings. |
| `/spechunt:scope-check` | `/spechunt:scope-check <url-or-domain>` | Reads scope.md and rules.md, evaluates the target against exact matches, wildcards, and path exclusions — responds IN SCOPE / OUT OF SCOPE / AMBIGUOUS with the relevant rule quoted |
| `/spechunt:status` | `/spechunt:status` | Reads status.md and active finding.md files — outputs current phase, finding counts, bounty total, top 3 priority queue items, and the recommended next action |
| `/spechunt:close` | `/spechunt:close` | Verifies no active findings, generates `ENGAGEMENT_SUMMARY.md` with results table and key learnings, marks the engagement closed in status.md, and creates a final git commit |

## Agent Workflow

The framework is designed so AI agents always know what to read first:

1. `program/` — All program-defined constraints: description, rules, scope
2. `status.md` — Current state of the engagement and all findings
3. `recon/triage.md` — Priority order for testing
4. `findings/{name}/finding.md` — Current state of any specific finding

## Finding Lifecycle

Each finding progresses through these statuses, tracked in `finding.md` YAML and mirrored in `status.md`:

```
discovered → exploring → exploited → submitted → accepted / rejected / disputed
```

Use `/spechunt:update-finding <name> <status>` (or `./update_finding.sh` directly) to advance a finding. The script automatically:
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
| PoC files | `poc_NN_description.ext` | `poc_01_initial-request.http`, `poc_02_automated-exploit.py` |
| Comms files | `YYYY-MM-DD_NN_description.md` | `2026-03-03_02_triager-request-info.md` |

## Configuring CLAUDE.md

After `init.sh`, only **two fields** need to be filled in manually:

| Field | What to fill in |
|-------|-----------------|
| **Program URL** | The bounty platform program page (e.g. `https://hackerone.com/target`) |
| **Platform** | The bounty platform (HackerOne, Bugcrowd, Intigriti, etc.) |

Everything else — scope tiers, bounty tables, out-of-scope lists, rate limits — is extracted automatically by `/spechunt:setup` from the program description you paste into `program/program_description.md`.

The **Known Constraints** and **Useful Commands** sections are populated incrementally as the agent discovers constraints during recon and testing. They start empty (with commented examples for reference) and grow over the course of the engagement.

## Git History

Every significant action is recorded as a git commit, giving you a full audit trail:

```
close(testcorp): engagement closed — $500 earned, 1 finding accepted
finding(xss-search-page): status → accepted ($500)
finding(xss-search-page): status → submitted
finding(xss-search-page): discovered
init(TestCorp): engagement workspace initialized
```

## Sensitive File Protection

A `.gitignore` is included to prevent accidental commits of credentials, keys, and environment files:

- `.env*`, `*.key`, `*.pem`, `*.p12`, `credentials.json`
- Auth/token files: `*_auth.*`, `*_token.*`, `*_secret.*`, `*_password.*`
- OS and editor noise (`.DS_Store`, Thumbs.db, `.vscode/`, etc.)

Evidence and PoC files should be committed explicitly by file name — never use `git add -A` or `git add .` in an engagement directory.

## Starting a New Engagement

For each new target, clone a fresh copy:

```bash
git clone <repo-url>
cd spechunt
./init.sh "New Target"
cd ../new-target    # directory was renamed automatically
```

The `init.sh` script slugifies the target name and renames the cloned directory to match — no need to name the clone manually upfront. Each engagement is fully self-contained with its own repo and git history.

## License

Private — for authorized security testing only.
