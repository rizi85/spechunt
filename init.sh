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
| `/new-finding` | `/new-finding <finding-name>` | Scaffolds finding folder, fills in finding.md, updates triage and status |

When you discover a vulnerability, use `/new-finding <name>` to create and populate the finding in one step.

## Known Constraints

- TODO: Add constraints discovered during recon

## Useful Commands

```bash
# TODO: Add useful commands as they are discovered
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

## 1. Infrastructure Overview

TODO

## 2. Domain & Subdomain Map

TODO

## 3. Technology Fingerprinting

TODO

## 4. Endpoint Discovery

TODO

## 5. Authentication Mechanisms

TODO
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

echo "    [+] recon/scope.md"
echo "    [+] recon/recon_notes.md"
echo "    [+] recon/triage.md"

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

# --- Done -----------------------------------------------------------------

echo ""
echo "[+] Engagement initialized successfully!"
echo ""
echo "Next steps:"
echo "  1. Paste program description into program/program_description.md"
echo "  2. Paste rules of engagement into program/rules.md"
echo "  3. Update CLAUDE.md with target-specific details"
echo "  4. Launch Claude Code and begin recon"
echo ""
echo "To create a new finding:"
echo "  ./new_finding.sh <finding-name>"
