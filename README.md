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

# 6. When the agent discovers a vulnerability, it uses the built-in skill:
#    /new-finding <finding-name>
```

## Scripts

| Script | Usage | Description |
|--------|-------|-------------|
| `init.sh` | `./init.sh <TargetName>` | Initializes this directory as a new engagement — creates CLAUDE.md, status.md, program/, recon/, findings/ with all READMEs and templates. Run once per engagement. |
| `new_finding.sh` | `./new_finding.sh <finding-name>` | Creates a finding subfolder with finding.md (YAML frontmatter), all 5 subfolders with READMEs, and auto-updates status.md + findings/README.md |

Both scripts include error handling for duplicate names, missing directories, and missing arguments.

## Engagement Structure

After running `./init.sh`, the directory looks like this:

```
./
├── README.md                              # This file
├── init.sh                                # Engagement initializer (run once)
├── new_finding.sh                         # Finding scaffolding script
├── .claude/commands/                      # Agent slash commands (skills)
│   └── new-finding.md                     # /new-finding <name> — scaffold + fill
├── .templates/                            # File templates (used by scripts)
├── CLAUDE.md                              # Agent instructions for this engagement
├── status.md                              # Dashboard — all findings at a glance
├── program/                               # [mandatory] Raw program info from platform
│   ├── README.md
│   ├── program_description.md             # Full program description (copy-paste)
│   └── rules.md                           # Rules of engagement, scope, exclusions
├── recon/                                 # [mandatory] Reconnaissance phase outputs
│   ├── README.md
│   ├── scope.md                           # Structured scope (quick agent reference)
│   ├── recon_notes.md                     # Raw recon findings
│   ├── triage.md                          # Prioritized findings queue (P0, P1, ...)
│   └── triage-report.md                   # OSINT-enriched triage (optional)
└── findings/                              # [mandatory] One folder per finding
    ├── README.md
    └── {finding-name}/
        ├── finding.md                     # [mandatory] YAML metadata + state + key files
        ├── evidences/                     # Screenshots, logs, webhook data
        ├── poc/                           # Exploit code, automation scripts
        ├── writeup/                       # Analysis, vuln reports, submissions
        ├── comms/                         # Triager/program owner communications
        └── misc/                          # Test scripts, scratch work
```

## Configuring CLAUDE.md

After `init.sh` generates `CLAUDE.md`, open it and fill in the TODO sections. This file is what the AI agent reads first — the more detail you provide, the better it performs. Here's what to update:

| Section | What to fill in |
|---------|-----------------|
| **Project Overview** | Target name, URL, bounty platform (Intigriti, HackerOne, etc.), one-line description of what the target does |
| **Scope & Rules** | Tier 1 and Tier 2 assets with exact domains, bounty ranges per severity, rate limit for automated tooling (e.g. "max 2 req/sec") |
| **Known Constraints** | Anything that limits testing — no test accounts, WAF/CDN in front, specific auth mechanisms, blocked ports, IP restrictions |
| **Useful Commands** | Curl commands, API endpoints, authentication flows, or scripts you discover during recon. Add these as you go. |

**Example of a filled-in Scope section:**

```markdown
## Scope & Rules (Critical)

- **Tier 1** (highest bounty $200-$5,000): `app.target-dev.com`
- **Tier 2** ($100-$3,000): `api.target.com/v1`, `www.target.com`
- **Automated tooling:** max 2 req/sec — enforce `sleep 0.5` between requests
- **Cross-org data access is the primary concern** (tenant A accessing tenant B)
- Same-org role escalation is OUT OF SCOPE
- Self-XSS that can't exploit other users is OUT OF SCOPE
- Full rules: `program/rules.md`
```

The agent will reference `CLAUDE.md` throughout the engagement, so keep it updated as you discover new endpoints, constraints, or useful commands.

## Agent Skills

Spec Hunt includes slash commands that agents can invoke during a session. These live in `.claude/commands/` and are available automatically.

| Skill | Usage | What it does |
|-------|-------|--------------|
| `/new-finding` | `/new-finding <finding-name>` | Runs `new_finding.sh`, then auto-fills `finding.md` (title, severity, CWE, summary, attack chain, impact) and updates `recon/triage.md` |

When the agent discovers a vulnerability, it should use `/new-finding` instead of manually running the shell script. The skill handles both scaffolding and metadata — the agent creates the folder structure, fills in finding details, and updates the dashboard in one step.

You can also run `./new_finding.sh <finding-name>` directly from the terminal if you prefer to scaffold manually.

## Agent Workflow

The framework is designed so AI agents always know what to read first:

1. `program/` — Understand scope, rules, what's out of scope
2. `recon/scope.md` — Quick-reference for scope checks during testing
3. `status.md` — Current state of the engagement and all findings
4. `recon/triage.md` — Priority order for testing
5. `findings/{name}/finding.md` — Current state of any specific finding

## Finding Lifecycle

Each finding progresses through these statuses (tracked in `finding.md` YAML frontmatter):

```
discovered → exploring → exploited → submitted → accepted / rejected / disputed
```

The `status.md` at the root provides a table view of all findings and their current status.

## Finding Metadata

Every `finding.md` includes machine-parseable YAML frontmatter:

```yaml
---
id: ssrf-internal-api
title: SSRF on /api/v1/fetch Allows Internal Network Scanning
status: exploited
severity: high
cvss: 8.2
asset: api.target.com (Tier 1)
cwe: CWE-918
discovered: 2026-03-01
submitted: null
bounty: null
---
```

## Templates

The `.templates/` directory contains blank templates for all generated files. The scripts use these patterns internally — you don't need to copy templates manually.

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
