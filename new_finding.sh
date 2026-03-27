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

if [ $# -eq 1 ] && { [ "$1" = "--help" ] || [ "$1" = "-h" ]; }; then
    echo "Usage: $0 <finding-name>"
    echo ""
    echo "Creates a structured finding folder inside findings/."
    echo "Names must be lowercase, hyphen-separated (e.g. sql-injection)."
    echo ""
    echo "Examples:"
    echo "  $0 sql-injection"
    echo "  $0 xss-search-page"
    echo "  $0 ssrf-webhook"
    exit 0
fi

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

# Validate slug format: lowercase letters, digits, hyphens only
if ! echo "$FINDING_NAME" | grep -qE '^[a-z0-9][a-z0-9-]*$'; then
    echo "[!] Invalid finding name: '${FINDING_NAME}'"
    echo "    Use lowercase letters, digits, and hyphens only."
    echo "    Examples: sql-injection, xss-search-page, ssrf-webhook"
    exit 1
fi

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
title: TODO — Describe the vulnerability in one line
status: discovered
severity: unknown
cvss: null
cvss_vector: null
asset: TODO
endpoint: TODO
cwe: TODO
discovered: $(date +%Y-%m-%d)
submitted: null
bounty: null
---

## Summary

TODO: One paragraph — what the vulnerability is, how it was found, and why it matters.

## Current State

**Status: Discovered** — TODO: What needs to happen next to advance this finding.

## Attack Chain

\`\`\`
TODO: Step-by-step attack flow
\`\`\`

## Steps to Reproduce

1. TODO: First step (include exact URL)
2. TODO: Second step (include exact payload/parameter)
3. TODO: Third step (expected vs actual response)
4. Observe: TODO

## Impact

TODO: What an attacker can achieve — written from a business risk perspective.

## Remediation

TODO: Specific, actionable fix.

## References

- TODO: CWE / OWASP / CVE links

## Key Files

| File | Purpose |
|------|---------|
| \`evidences/\` | Screenshots and logs |
| \`poc/\` | Exploit code |
| \`writeup/submission.md\` | Platform submission draft |
EOF

echo "    [+] finding.md"

# --- Generate README.md for each subfolder --------------------------------

cat > "${FINDING_DIR}/evidences/README.md" << 'EOF'
# evidences/

Proof that the vulnerability exists. Screenshots, logs, webhook captures, exfiltrated data.

## Naming Convention

```
YYYY-MM-DD_NN_description.ext
```

Examples: `2026-03-01_01_initial-request.txt`, `2026-03-01_02_response-with-data.png`

## Agent Instructions

- Follow the naming convention — submission.md references evidence files by name
- Save raw HTTP requests/responses as `.txt` or `.json`; screenshots as `.png`
- Capture both attacker-side request and target-side response as separate files
- Do not modify evidence files after creation — they are timestamped proof
EOF

cat > "${FINDING_DIR}/poc/README.md" << 'EOF'
# poc/

Proof-of-concept exploit code and automation scripts.

## Naming Convention

```
poc_NN_description.ext
```

Examples: `poc_01_initial-request.http`, `poc_02_automated-exploit.py`

## Agent Instructions

- `poc_01_*` is the submission PoC — clean, minimal, self-contained
- Higher-numbered files are progressions: deeper exploitation, automation, impact amplification
- Every file must include a comment block: target, prerequisite, expected result
- Do not include real credentials — use placeholders (`VICTIM_TOKEN`, `TARGET_HOST`)
- Reference PoC files in submission.md using relative paths: `../poc/poc_01_*.ext`
EOF

cat > "${FINDING_DIR}/writeup/README.md" << 'EOF'
# writeup/

Analysis documents, vulnerability reports, and platform submissions.

## Contents

| File | Purpose |
|------|---------|
| `submission.md` | **Primary** — Platform submission draft (auto-generated) |
| `analysis.md` | Optional — Deep technical analysis, root cause investigation |

## Agent Instructions

- `submission.md` is the canonical report — use `/spechunt:submit <finding-name>` to auto-fill it
- Reference evidence files by relative path: `../evidences/YYYY-MM-DD_NN_description.png`
- Steps to Reproduce must be literal and copy-paste ready
- Do not submit to the platform directly — human review first
EOF

cat > "${FINDING_DIR}/comms/README.md" << 'EOF'
# comms/

All communications with the triager and program owner.

## Naming Convention

```
YYYY-MM-DD_NN_description.md
```

Examples: `2026-03-01_01_submitted.md`, `2026-03-03_02_triager-request-info.md`

## Agent Instructions

- One file per communication event (sent or received)
- Read all files in alphabetical (chronological) order to follow the full thread
- Always draft outgoing responses here before posting to the platform
- Include received platform messages verbatim
EOF

cat > "${FINDING_DIR}/misc/README.md" << 'EOF'
# misc/

Test scripts, scratch work, and anything that doesn't fit in other folders.

## Agent Instructions

- Use for validation scripts, exploratory code, and temporary files
- If a file becomes important, move it to the appropriate folder (poc/, writeup/, etc.)
EOF

echo "    [+] README.md (x5 subfolders)"

# --- Generate writeup/submission.md ---------------------------------------

cat > "${FINDING_DIR}/writeup/submission.md" << EOF
# Submission — TODO: Finding Title

> **Draft** — Review before posting to the platform. Remove this line when ready.

---

## Title

\`[VulnType] endpoint — one-line impact\`

## Severity

**TODO** — CVSS null \`null\`

## Summary

TODO: One paragraph — what the vulnerability is, where it lives, what an attacker can do.

## Affected Asset

- **Domain / Endpoint:** \`TODO\`
- **Asset Tier:** TODO
- **CWE:** [TODO](https://cwe.mitre.org/data/definitions/XXX.html)

## Steps to Reproduce

> Environment: TODO (browser/tool, account type, any setup)

1. TODO — include exact URL
2. TODO — include exact request/payload
3. TODO — expected vs actual behavior
4. Observe: TODO

\`\`\`http
TODO: Paste the key request/response here
\`\`\`

## Proof of Concept

TODO: Brief description. See: \`../evidences/TODO_filename\`

## Impact

- **Confidentiality:** TODO
- **Integrity:** TODO
- **Availability:** TODO
- **Scope:** TODO

## Remediation

TODO: Specific fix.

## References

- [CWE-TODO](https://cwe.mitre.org/data/definitions/XXX.html)
- TODO: OWASP / CVE / writeup links
EOF

echo "    [+] writeup/submission.md"

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

# --- Append to activity.log -----------------------------------------------

LOG_FILE="${SCRIPT_DIR}/activity.log"
if [ -f "$LOG_FILE" ]; then
    echo "$(date '+%Y-%m-%d %H:%M') [finding]  created: ${FINDING_NAME} (discovered)" >> "$LOG_FILE"
fi

# --- Git milestone commit -------------------------------------------------

if git -C "$SCRIPT_DIR" rev-parse --git-dir > /dev/null 2>&1; then
    git -C "$SCRIPT_DIR" add "${FINDING_DIR}" 2>/dev/null || true
    [ -f "${FINDINGS_README}" ] && git -C "$SCRIPT_DIR" add "${FINDINGS_README}" 2>/dev/null || true
    [ -f "${STATUS_FILE}" ] && git -C "$SCRIPT_DIR" add "${STATUS_FILE}" 2>/dev/null || true
    [ -f "$LOG_FILE" ] && git -C "$SCRIPT_DIR" add "$LOG_FILE" 2>/dev/null || true
    git -C "$SCRIPT_DIR" commit -m "finding(${FINDING_NAME}): discovered" 2>/dev/null && \
        echo "    [+] Git commit: finding(${FINDING_NAME}): discovered" || true
fi

# --- Done -----------------------------------------------------------------

echo ""
echo "[+] Finding created successfully!"
echo ""
echo "Next steps:"
echo "  1. Edit findings/${FINDING_NAME}/finding.md — fill in title, severity, CWE, summary"
echo "  2. Add PoC code to findings/${FINDING_NAME}/poc/"
echo "  3. Take screenshots → findings/${FINDING_NAME}/evidences/"
echo "  4. Run /spechunt:submit ${FINDING_NAME} to draft the platform submission"
echo "  5. Run /spechunt:update-finding ${FINDING_NAME} <status> as the finding progresses"
