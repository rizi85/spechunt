#!/usr/bin/env bash
# ============================================================================
# Spec Hunt — Engagement Initializer
# ============================================================================
# Initializes the current directory as a new bug bounty engagement.
# Creates CLAUDE.md, status.md, program/, recon/, findings/ with all READMEs.
#
# Usage:
#   ./init.sh <TargetName>
#   ./init.sh "Target Name"
#
# Example:
#   ./init.sh TargetCorp
#   ./init.sh "My-Target"
#
# Run once per engagement. Each clone of Spec Hunt is a single engagement.
# ============================================================================

set -euo pipefail

# --- Configuration --------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="${SCRIPT_DIR}/.templates"

# --- Validation -----------------------------------------------------------

if [ $# -eq 1 ] && { [ "$1" = "--help" ] || [ "$1" = "-h" ]; }; then
    echo "Usage: $0 <TargetName>"
    echo ""
    echo "Initializes the current directory as a new bug bounty engagement."
    echo "Renames the project directory to a slug of the target name."
    echo "Run once per engagement clone."
    echo ""
    echo "Examples:"
    echo "  $0 TargetCorp"
    echo "  $0 \"My Target\""
    exit 0
fi

if [ $# -lt 1 ] || [ -z "$1" ]; then
    echo "Usage: $0 <TargetName>"
    echo ""
    echo "Examples:"
    echo "  $0 TargetCorp"
    echo "  $0 \"My-Target\""
    exit 1
fi

TARGET_NAME="$1"

# Check if already initialized
if [ -f "${SCRIPT_DIR}/CLAUDE.md" ] && [ -d "${SCRIPT_DIR}/program" ]; then
    echo "[!] This engagement appears to be already initialized."
    echo "    Found CLAUDE.md and program/ in ${SCRIPT_DIR}"
    echo "    To start fresh, remove the generated files first."
    exit 1
fi

if [ ! -d "$TEMPLATES_DIR" ]; then
    echo "[!] Templates directory not found: ${TEMPLATES_DIR}"
    echo "    Ensure .templates/ exists in the Spec Hunt root."
    exit 1
fi

# --- Create structure -----------------------------------------------------

echo "[*] Initializing engagement: ${TARGET_NAME}"
echo "    Location: ${SCRIPT_DIR}"
echo ""

# Mandatory folders
mkdir -p "${SCRIPT_DIR}/program"
mkdir -p "${SCRIPT_DIR}/recon"
mkdir -p "${SCRIPT_DIR}/findings"

echo "    [+] program/"
echo "    [+] recon/"
echo "    [+] findings/"

# --- Generate CLAUDE.md ---------------------------------------------------

cat > "${SCRIPT_DIR}/CLAUDE.md" << 'CLAUDEEOF'
# CLAUDE.md

This file provides guidance to Claude Code when working in this bug bounty engagement.

## Project Overview

CLAUDEEOF

cat >> "${SCRIPT_DIR}/CLAUDE.md" << EOF
Bug bounty research workspace for **${TARGET_NAME}**.
- **Program URL:** TODO
- **Platform:** TODO
- **Program description:** \`program/program_description.md\`
EOF

cat >> "${SCRIPT_DIR}/CLAUDE.md" << 'CLAUDEEOF'

## Scope & Rules

Source of truth — always read these files before testing anything:
- **Full rules:** `program/rules.md`
- **Structured scope (tiers, bounty table, out-of-scope list):** `program/scope.md`

Run `/setup` after pasting the program description to auto-populate these files.
When in doubt about whether a target is in scope, run `/scope-check <url>`.

## Folder Structure

```
./
├── CLAUDE.md                              # This file — agent instructions
├── status.md                              # All findings at a glance
├── program/                               # [mandatory] Raw program info
│   ├── program_description.md
│   ├── rules.md
│   └── scope.md                           # Structured scope (tiers, bounty table, out-of-scope)
├── recon/                                 # [mandatory] Reconnaissance outputs
│   ├── recon_notes.md                     # Raw recon findings
│   ├── triage.md                          # Prioritized findings
│   └── triage-report.md                   # OSINT-enriched triage
└── findings/                              # [mandatory] One folder per finding
    └── {finding-name}/
        ├── finding.md                     # [mandatory] Metadata + summary + state
        ├── evidences/                     # Screenshots, logs, webhook data
        ├── poc/                           # Exploit code, automation scripts
        ├── writeup/                       # Analysis, vuln reports, submissions
        ├── comms/                         # Triager/program communications
        └── misc/                          # Test scripts, scratch work
```

## Agent Workflow

1. **Read `program/`** — description, rules, and scope (all program-defined constraints)
2. **Read `status.md`** — current engagement state and findings
3. **Read `recon/triage.md`** — priority order for testing
4. **For any finding, read `findings/{name}/finding.md` first** — current state

## Agent Skills

| Skill | Usage | What it does |
|-------|-------|--------------|
| `/setup` | `/setup` | Parses program_description.md → populates program/scope.md and program/rules.md |
| `/recon` | `/recon` | Structured passive recon — fingerprinting, API surface, populates recon_notes.md and triage.md |
| `/triage` | `/triage` | OSINT-enriched triage — enriches priority queue, writes triage-report.md |
| `/new-finding` | `/new-finding <finding-name>` | Scaffolds finding folder, fills finding.md, updates triage and status |
| `/submit` | `/submit <finding-name>` | Drafts platform-specific submission report (H1, Bugcrowd, Intigriti, etc.) |
| `/update-finding` | `/update-finding <finding-name> <status>` | Updates finding status, increments counters, git milestone commit |
| `/scope-check` | `/scope-check <url-or-domain>` | Verifies in-scope / out-of-scope with tier and bounty range |
| `/status` | `/status` | Engagement snapshot — finding counts, bounty total, recommended next action |
| `/close` | `/close` | Closes engagement, generates ENGAGEMENT_SUMMARY.md, final git commit |

## Known Constraints

<!-- Add constraints as they are discovered during recon and testing — examples:
- WAF/CDN: Cloudflare — blocks payloads with `<script`, `UNION SELECT`, `../` patterns
- Rate Limits: 100 req/min per IP on /api/; 10 login attempts before lockout
- Auth: JWT tokens expire after 15min; refresh via POST /auth/refresh
- IP Restrictions: /admin restricted to internal IPs only
- CSP: script-src 'self' cdn.target.com — no unsafe-inline
-->
- TODO

## Useful Commands

<!-- Add commands as they are discovered during recon — examples:
curl -s -X POST https://TARGET/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password"}' | jq '.token'
-->

```bash
# TODO
```
CLAUDEEOF

echo "    [+] CLAUDE.md"

# --- Generate status.md ---------------------------------------------------

cat > "${SCRIPT_DIR}/status.md" << EOF
# Engagement Status

**Target:** ${TARGET_NAME}
**Platform:** TODO
**Started:** $(date +%Y-%m-%d)
**Last Updated:** $(date +%Y-%m-%d)

## Findings Overview

| Finding | Status | Severity | Asset | Bounty | Next Action |
|---------|--------|----------|-------|--------|-------------|
| | | | | | |

## Engagement Summary

- **Total findings discovered:** 0
- **Submitted:** 0
- **Accepted:** 0
- **Rejected/Disputed:** 0
- **Bounty earned:** \$0

## Blockers

- None yet

## Phase Status

| Phase | Status |
|-------|--------|
| Reconnaissance | Not started |
| Triage | Not started |
| Unauthenticated testing | Not started |
| Authenticated testing | Not started |
| Submission | Not started |
EOF

echo "    [+] status.md"

# --- Generate program/ files ----------------------------------------------

cat > "${SCRIPT_DIR}/program/README.md" << 'EOF'
# program/

Bug bounty program information. This folder is **mandatory** for every engagement.

## Contents

| File | Description |
|------|-------------|
| `program_description.md` | Full program description from the bounty platform (raw paste) |
| `rules.md` | Rules of engagement, structured by `/setup` from program description |
| `scope.md` | Structured scope — tiers, bounty table, out-of-scope list, rate limits |

## Agent Instructions

- Read these files **first** before any testing activity
- `program_description.md` is the raw source — do not modify it
- `scope.md` and `rules.md` are populated by `/setup` — review and correct if needed
- Reference `scope.md` for all scope checks; use `/scope-check <url>` when unsure
EOF

cat > "${SCRIPT_DIR}/program/program_description.md" << EOF
# Program Description

TODO: Paste the full program description from the bounty platform here.
EOF

cat > "${SCRIPT_DIR}/program/rules.md" << EOF
# Rules of Engagement

TODO: Populated by /setup from program_description.md.
EOF

cat > "${SCRIPT_DIR}/program/scope.md" << 'EOF'
# Scope Summary

Structured scope extracted from program description and rules of engagement.
Populated by `/setup` — run it after pasting program_description.md.

## In-Scope Assets

| Asset | Type | Tier | Bounty Range |
|-------|------|------|--------------|
| TODO | | | |

## Bounty Table

| Severity | CVSS | Tier 1 | Tier 2 |
|----------|------|--------|--------|
| Low | 0.1-3.9 | | |
| Medium | 4.0-6.9 | | |
| High | 7.0-8.9 | | |
| Critical | 9.0-9.4 | | |
| Exceptional | 9.5-10.0 | | |

## Worst-Case Scenarios (Program Priorities)

1. TODO

## Rate Limits

- **Automated tooling:** TODO

## Out of Scope

TODO

## Tech Stack

- **Backend:** TODO
- **Frontend:** TODO
- **Infrastructure:** TODO

## Key URLs

| URL | Purpose |
|-----|---------|
| TODO | |
EOF

echo "    [+] program/program_description.md"
echo "    [+] program/rules.md"
echo "    [+] program/scope.md (run /setup to populate)"

# --- Generate recon/ files ------------------------------------------------

cat > "${SCRIPT_DIR}/recon/README.md" << 'EOF'
# recon/

Reconnaissance phase outputs. This folder is **mandatory** for every engagement.

## Contents

| File | Description |
|------|-------------|
| `recon_notes.md` | Raw reconnaissance findings (populated by `/recon`) |
| `triage.md` | Prioritized findings queue with scores and status |
| `triage-report.md` | OSINT-enriched triage (populated by `/triage`) |

## Agent Instructions

- `triage.md` defines the testing priority order — work top-down
- Update finding status in `triage.md` as they are confirmed or ruled out
- For scope checks, read `program/scope.md` or run `/scope-check <url>`
EOF

cat > "${SCRIPT_DIR}/recon/recon_notes.md" << EOF
# Reconnaissance Notes

**Target:** ${TARGET_NAME}
**Date:** $(date +%Y-%m-%d)

---

## 1. Asset Discovery

| Asset / Domain | IP / CDN | Registrar | Notes |
|----------------|----------|-----------|-------|
| TODO | | | |

## 2. Subdomain Enumeration

\`\`\`
# Sources: crt.sh, dnsx, subfinder, amass
# Paste raw output here
TODO
\`\`\`

Notable subdomains:
- TODO

## 3. Technology Fingerprinting

| Asset | Server | Framework | CDN/WAF | JS Libraries | Other |
|-------|--------|-----------|---------|--------------|-------|
| TODO | | | | | |

Response header observations:
- TODO

## 4. API Surface

| Endpoint | Method | Auth Required | Notes |
|----------|--------|---------------|-------|
| TODO | | | |

API spec / Swagger found at: TODO

## 5. Authentication Analysis

- **Login endpoint:** TODO
- **Session management:** TODO (cookies / JWT / session ID)
- **SSO / OAuth:** TODO
- **Token lifetime:** TODO
- **MFA:** TODO
- **Password reset flow:** TODO

## 6. Interesting Endpoints & Parameters

| URL / Path | Parameter | Observation | Priority |
|------------|-----------|-------------|----------|
| TODO | | | |

## 7. JavaScript Analysis

Files reviewed:
- TODO

Secrets / endpoints / internal paths found:
- TODO

## 8. Potential Attack Vectors

| Attack Vector | Affected Asset | Auth Needed | Initial Score | Notes |
|---------------|---------------|-------------|---------------|-------|
| TODO | | | | |

## 9. Scope Questions

Ambiguous assets or paths to clarify with the program before testing:
- TODO
EOF

cat > "${SCRIPT_DIR}/recon/triage.md" << EOF
# Triage Results

**Target:** ${TARGET_NAME}
**Date:** $(date +%Y-%m-%d)

---

## Priority Queue

| Priority | Finding | Score | Auth Needed? | Status |
|----------|---------|-------|--------------|--------|
| | | | | |

---

## Testable Now (No Auth Required)

| # | Action | How |
|---|--------|-----|
| | | |

## Blocked (Requires Auth)

| Finding | What's needed | Bypass attempted? |
|---------|---------------|-------------------|
| | | |
EOF

cat > "${SCRIPT_DIR}/recon/triage-report.md" << EOF
# OSINT-Enriched Triage Report

**Target:** ${TARGET_NAME}
**Date:** $(date +%Y-%m-%d)

> Generated by the \`/triage\` skill. Run \`/triage\` to populate this file with
> OSINT-enriched analysis of each item in \`triage.md\`.

---

<!-- Format per finding:

### [Finding Name]
- **CVSS Estimate:** X.X (Low/Medium/High/Critical)
- **Auth Required:** Yes / No
- **Public Exploits:** Yes ([link]) / No
- **Matches Worst-Case:** Yes / No
- **Priority Rationale:** [1-2 sentences]
- **Recommended First Step:** [specific action]

-->
EOF

echo "    [+] recon/recon_notes.md"
echo "    [+] recon/triage.md"
echo "    [+] recon/triage-report.md"

# --- Generate findings/ README --------------------------------------------

cat > "${SCRIPT_DIR}/findings/README.md" << 'EOF'
# findings/

All discovered findings, one subfolder per finding. This folder is **mandatory**.

## Finding Folder Structure (mandatory)

```
findings/{finding-name}/
├── finding.md          # [mandatory] Metadata, summary, state, key files
├── evidences/          # Screenshots, logs, webhook data
├── poc/                # Exploit code, automation scripts
├── writeup/            # Analysis, vulnerability reports, submissions
├── comms/              # Communications with triager/program owner
└── misc/               # Test scripts, scratch work
```

## Agent Instructions

- Read `finding.md` first when entering any finding folder
- Create finding folder + `finding.md` as soon as a vulnerability is discovered
- Update `finding.md` status and root `status.md` as findings progress

## Finding Lifecycle

```
discovered → exploring → exploited → submitted → accepted/rejected/disputed
```

## Current Findings

None yet.
EOF

echo "    [+] findings/README.md"

# --- Git milestone commit -------------------------------------------------

if git -C "$SCRIPT_DIR" rev-parse --git-dir > /dev/null 2>&1; then
    git -C "$SCRIPT_DIR" add \
        "${SCRIPT_DIR}/CLAUDE.md" \
        "${SCRIPT_DIR}/status.md" \
        "${SCRIPT_DIR}/program" \
        "${SCRIPT_DIR}/recon" \
        "${SCRIPT_DIR}/findings" \
        2>/dev/null || true
    git -C "$SCRIPT_DIR" commit -m "init(${TARGET_NAME}): engagement workspace initialized" 2>/dev/null && \
        echo "    [+] Git commit: engagement initialized" || true
fi

# --- Rename project directory ---------------------------------------------

TARGET_SLUG=$(echo "$TARGET_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-' | tr -s '-' | sed 's/^-*//;s/-*$//')
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
CURRENT_DIR_NAME="$(basename "$SCRIPT_DIR")"
NEW_DIR="${PARENT_DIR}/${TARGET_SLUG}"
DIR_RENAMED=0

if [ -z "$TARGET_SLUG" ]; then
    echo "    [!] Cannot generate a valid directory name from: '${TARGET_NAME}'"
    echo "    [~] Use alphanumeric characters and hyphens (e.g. \"TargetCorp\", \"my-target\")"
    echo "    [~] Skipping directory rename — engagement files were still created."
elif [ "$CURRENT_DIR_NAME" != "$TARGET_SLUG" ]; then
    if [ -d "$NEW_DIR" ]; then
        echo "    [!] Cannot rename: '${TARGET_SLUG}' already exists in ${PARENT_DIR}"
        echo "    [~] Keeping directory name: ${CURRENT_DIR_NAME}"
    else
        mv "$SCRIPT_DIR" "$NEW_DIR"
        echo "    [+] Directory renamed: ${CURRENT_DIR_NAME} → ${TARGET_SLUG}"
        DIR_RENAMED=1
    fi
fi

# --- Done -----------------------------------------------------------------

echo ""
echo "[+] Engagement initialized successfully!"
echo ""
echo "Next steps:"
if [ "$DIR_RENAMED" -eq 1 ]; then
echo "  0. Your directory was renamed — update your shell first:"
echo "     cd \"${NEW_DIR}\""
echo ""
fi
echo "  1. Paste program description into program/program_description.md"
echo "  2. Update CLAUDE.md: fill in Program URL and Platform (2 fields only)"
echo "  3. Launch Claude Code: claude"
echo "  4. Run /setup — agent will extract scope, tiers, and rules automatically"
echo "  5. Review program/scope.md and program/rules.md, then run /recon"
echo ""
echo "Available skills once inside Claude Code:"
echo "  /setup              — parse program description → populate scope + rules"
echo "  /recon              — structured passive reconnaissance"
echo "  /triage             — OSINT-enriched priority queue"
echo "  /new-finding <name> — scaffold a new vulnerability finding"
echo "  /submit <name>      — draft platform submission report"
echo "  /update-finding     — update finding status and counters"
echo "  /scope-check <url>  — verify in-scope / out-of-scope"
