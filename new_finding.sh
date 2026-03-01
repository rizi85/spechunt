#!/usr/bin/env bash
# ============================================================================
# Spec Hunt — New Finding Generator
# ============================================================================
# Creates the mandatory folder structure for a new finding within the current
# engagement.
#
# Usage:
#   ./new_finding.sh <finding-name>
#
# Examples:
#   ./new_finding.sh sql-injection
#   ./new_finding.sh xss-search-page
#   ./new_finding.sh ssrf-webhook
#
# Finding names should be lowercase, hyphen-separated, descriptive.
# ============================================================================

set -euo pipefail

# --- Configuration --------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Validation -----------------------------------------------------------

if [ $# -lt 1 ] || [ -z "$1" ]; then
    echo "Usage: $0 <finding-name>"
    echo ""
    echo "Examples:"
    echo "  $0 sql-injection"
    echo "  $0 xss-search-page"
    echo "  $0 ssrf-webhook"
    exit 1
fi

FINDING_NAME="$1"
FINDING_DIR="${SCRIPT_DIR}/findings/${FINDING_NAME}"

if [ ! -d "${SCRIPT_DIR}/findings" ]; then
    echo "[!] Missing findings/ directory in ${SCRIPT_DIR}"
    echo "    Initialize the engagement first with: ./init.sh <TargetName>"
    exit 1
fi

if [ -d "$FINDING_DIR" ]; then
    echo "[!] Finding already exists: ${FINDING_DIR}"
    echo "    Use a different name or remove the existing directory."
    exit 1
fi

# --- Create finding structure ---------------------------------------------

echo "[*] Creating finding: ${FINDING_NAME}"
echo "    Location: ${FINDING_DIR}"
echo ""

mkdir -p "${FINDING_DIR}/evidences"
mkdir -p "${FINDING_DIR}/poc"
mkdir -p "${FINDING_DIR}/writeup"
mkdir -p "${FINDING_DIR}/comms"
mkdir -p "${FINDING_DIR}/misc"

echo "    [+] evidences/"
echo "    [+] poc/"
echo "    [+] writeup/"
echo "    [+] comms/"
echo "    [+] misc/"

# --- Generate finding.md --------------------------------------------------

cat > "${FINDING_DIR}/finding.md" << EOF
---
id: ${FINDING_NAME}
title: TODO — Describe the vulnerability
status: discovered
severity: unknown
cvss: null
asset: TODO
cwe: TODO
discovered: $(date +%Y-%m-%d)
submitted: null
bounty: null
---

## Summary

TODO: One paragraph describing the vulnerability, how it was found, and why it matters.

## Current State

**Status: Discovered** — TODO: What needs to happen next.

## Attack Chain

\`\`\`
TODO: Step-by-step attack flow
\`\`\`

## Impact

TODO: What an attacker can do with this vulnerability.

## Key Files

| File | Purpose |
|------|---------|
| | |
EOF

echo "    [+] finding.md"

# --- Generate README.md for each subfolder --------------------------------

cat > "${FINDING_DIR}/evidences/README.md" << 'EOF'
# evidences/

Proof that the vulnerability exists. Screenshots, logs, webhook captures, exfiltrated data.

## Agent Instructions

- Name screenshots descriptively: `ss_{phase}_{description}.png`
- Save raw API/webhook responses as `.txt` or `.json`
- Capture both attacker-side and target-side evidence
- Do not modify evidence files after creation — they are timestamped proof
EOF

cat > "${FINDING_DIR}/poc/README.md" << 'EOF'
# poc/

Proof-of-concept exploit code and automation scripts.

## Agent Instructions

- PoC files should be self-contained and reproducible
- Include clear comments explaining each step of the exploit
- Separate production PoCs (for submission) from local test variants
- Automation scripts (CDP, Selenium, etc.) go here alongside the PoC files
EOF

cat > "${FINDING_DIR}/writeup/README.md" << 'EOF'
# writeup/

Analysis documents, vulnerability reports, and platform submissions.

## Agent Instructions

- The submission document is the canonical report — keep it updated
- Include: summary, steps to reproduce, impact, affected code, remediation
- Reference evidence files and PoC files by relative path
EOF

cat > "${FINDING_DIR}/comms/README.md" << 'EOF'
# comms/

All communications with the triager and program owner.

## Agent Instructions

- Save each response/comment as a separate file with date context
- Name files chronologically: `01_initial_response.md`, `02_impact_update.md`, etc.
- Read all files chronologically to understand the full discussion thread
- Always draft responses here before posting to the platform
EOF

cat > "${FINDING_DIR}/misc/README.md" << 'EOF'
# misc/

Test scripts, scratch work, and anything that doesn't fit in other folders.

## Agent Instructions

- Use for validation scripts, exploratory code, and temporary files
- If a file becomes important, move it to the appropriate folder (poc/, writeup/, etc.)
EOF

echo "    [+] README.md (x5 subfolders)"

# --- Update findings/README.md if it has "None yet" -----------------------

FINDINGS_README="${SCRIPT_DIR}/findings/README.md"
if grep -q "None yet" "$FINDINGS_README" 2>/dev/null; then
    sed -i "s/None yet./| [${FINDING_NAME}](${FINDING_NAME}\/finding.md) | discovered | Unknown |/" "$FINDINGS_README"
    echo "    [+] Updated findings/README.md"
else
    # Append to the table if it exists
    if grep -q "## Current Findings" "$FINDINGS_README" 2>/dev/null; then
        echo "| [${FINDING_NAME}](${FINDING_NAME}/finding.md) | discovered | Unknown |" >> "$FINDINGS_README"
        echo "    [+] Updated findings/README.md"
    fi
fi

# --- Update status.md with new finding row --------------------------------

STATUS_FILE="${SCRIPT_DIR}/status.md"
if [ -f "$STATUS_FILE" ]; then
    # Update the last-updated date
    sed -i "s/^\*\*Last Updated:\*\*.*/\*\*Last Updated:\*\* $(date +%Y-%m-%d)/" "$STATUS_FILE"

    # Add finding to the table (insert before the empty row marker)
    sed -i "/^| *| *| *| *| *| *|$/i\\| [${FINDING_NAME}](findings/${FINDING_NAME}/finding.md) | discovered | Unknown | TODO | - | Initial investigation |" "$STATUS_FILE"

    # Increment total findings count
    CURRENT_COUNT=$(grep -oP 'Total findings discovered:\*\* \K[0-9]+' "$STATUS_FILE" 2>/dev/null || echo "0")
    NEW_COUNT=$((CURRENT_COUNT + 1))
    sed -i "s/Total findings discovered:\*\* ${CURRENT_COUNT}/Total findings discovered:\*\* ${NEW_COUNT}/" "$STATUS_FILE"

    echo "    [+] Updated status.md"
fi

# --- Done -----------------------------------------------------------------

echo ""
echo "[+] Finding created successfully!"
echo ""
echo "Next steps:"
echo "  1. Edit findings/${FINDING_NAME}/finding.md — fill in title, summary, CWE"
echo "  2. Add PoC code to findings/${FINDING_NAME}/poc/"
echo "  3. Take screenshots → findings/${FINDING_NAME}/evidences/"
echo "  4. Write analysis → findings/${FINDING_NAME}/writeup/"
echo "  5. Update status.md and finding.md as the finding progresses"
