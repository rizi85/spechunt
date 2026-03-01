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
Update this section with target URL, platform, and description.
EOF

cat >> "${SCRIPT_DIR}/CLAUDE.md" << 'CLAUDEEOF'

## Scope & Rules (Critical)

- **Tier 1** (highest bounty): `TODO`
- **Tier 2**: `TODO`
- **Automated tooling:** TODO (check program rules for rate limits)
- Full rules: `program/rules.md`
- Structured scope: `recon/scope.md`

## Folder Structure

```
./
├── CLAUDE.md                              # This file — agent instructions
├── status.md                              # All findings at a glance
├── program/                               # [mandatory] Raw program info
│   ├── program_description.md
│   └── rules.md
├── recon/                                 # [mandatory] Reconnaissance outputs
│   ├── scope.md                           # Structured scope (quick reference)
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

1. **Read `program/` first** — understand scope, rules, out-of-scope items
2. **Read `recon/scope.md`** — quick reference for scope checks
3. **Read `status.md`** — understand current engagement state
4. **Read `recon/triage.md`** — know the priority order
5. **For any finding, read `findings/{name}/finding.md` first** — current state and key files

## Agent Skills

| Skill | Usage | What it does |
|-------|-------|--------------|
| `/new-finding` | `/new-finding <finding-name>` | Scaffolds finding folder, fills finding.md, updates triage and status |
| `/recon` | `/recon` | Structured passive recon workflow — scope extraction, fingerprinting, triage population |
| `/triage` | `/triage` | OSINT-enriched triage — enriches priority queue, writes triage-report.md |
| `/submit` | `/submit <finding-name>` | Drafts complete platform submission report from finding data |
| `/update-finding` | `/update-finding <finding-name> <status>` | Updates finding status, increments counters, git milestone commit |
| `/scope-check` | `/scope-check <url-or-domain>` | Verifies in-scope / out-of-scope with tier and bounty range |

## Known Constraints

<!-- Replace the examples below with constraints discovered during recon -->
- **WAF/CDN:** TODO — e.g., "Cloudflare — blocks payloads with `<script`, `UNION SELECT`, `../` patterns"
- **Rate Limits:** TODO — e.g., "100 req/min per IP on /api/; 10 login attempts before lockout"
- **Auth:** TODO — e.g., "JWT tokens expire after 15min; refresh via POST /auth/refresh with refresh_token cookie"
- **IP Restrictions:** TODO — e.g., "/admin restricted to internal IPs only"
- **CSP:** TODO — e.g., "script-src 'self' cdn.target.com — no unsafe-inline"
- **CORS:** TODO — e.g., "Reflects Origin only for *.target.com subdomains"
- **Other:** TODO

## Useful Commands

```bash
# Authenticate and capture session token
curl -s -X POST https://TARGET/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password"}' | jq '.token'

# Authenticated request template
curl -s https://TARGET/api/endpoint \
  -H "Authorization: Bearer TOKEN_HERE" \
  -H "Content-Type: application/json"

# Check response headers
curl -sI https://TARGET | grep -iE 'server|x-powered-by|content-security|set-cookie|x-frame'

# TODO: Add target-specific commands as they are discovered
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
| `program_description.md` | Full program description from the bounty platform |
| `rules.md` | Rules of engagement, scope, exclusions, rate limits |

## Agent Instructions

- Read these files **first** before any testing activity
- Extract scope into `recon/scope.md` for quick reference
- Reference `rules.md` before submitting any finding
- Do not modify these files — they are source-of-truth copies from the platform
EOF

cat > "${SCRIPT_DIR}/program/program_description.md" << EOF
# Program Description

TODO: Paste the full program description from the bounty platform here.
EOF

cat > "${SCRIPT_DIR}/program/rules.md" << EOF
# Rules of Engagement

TODO: Paste the full rules of engagement from the bounty platform here.
EOF

echo "    [+] program/program_description.md"
echo "    [+] program/rules.md"

# --- Generate recon/ files ------------------------------------------------

cat > "${SCRIPT_DIR}/recon/README.md" << 'EOF'
# recon/

Reconnaissance phase outputs. This folder is **mandatory** for every engagement.

## Contents

| File | Description |
|------|-------------|
| `scope.md` | Structured scope summary (from program description) |
| `recon_notes.md` | Raw reconnaissance findings |
| `triage.md` | Prioritized findings queue with scores and status |
| `triage-report.md` | OSINT-enriched triage (optional) |

## Agent Instructions

- `scope.md` is the quick-reference for scope checks — read before testing
- `triage.md` defines the testing priority order — work top-down
- Update findings status in `triage.md` as they are confirmed or ruled out
EOF

cat > "${SCRIPT_DIR}/recon/scope.md" << 'EOF'
# Scope Summary

Structured scope extracted from program description and rules of engagement.
Agents should reference this file for quick scope checks during active testing.

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

TODO: List out-of-scope items from program rules.

## Tech Stack

- **Backend:** TODO
- **Frontend:** TODO
- **Infrastructure:** TODO

## Key URLs

| URL | Purpose |
|-----|---------|
| TODO | |
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

echo "    [+] recon/scope.md"
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

# --- Done -----------------------------------------------------------------

echo ""
echo "[+] Engagement initialized successfully!"
echo ""
echo "Next steps:"
echo "  1. Paste program description into program/program_description.md"
echo "  2. Paste rules of engagement into program/rules.md"
echo "  3. Update CLAUDE.md with target URL, platform, tier details, and constraints"
echo "  4. Launch Claude Code and run /recon to begin"
echo ""
echo "Available skills once inside Claude Code:"
echo "  /recon              — structured passive reconnaissance"
echo "  /triage             — OSINT-enriched priority queue"
echo "  /new-finding <name> — scaffold a new vulnerability finding"
echo "  /submit <name>      — draft platform submission report"
echo "  /update-finding     — update finding status and counters"
echo "  /scope-check <url>  — verify in-scope / out-of-scope"
