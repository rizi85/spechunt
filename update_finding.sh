#!/usr/bin/env bash
# ============================================================================
# Spec Hunt — Finding Status Updater
# ============================================================================
# Updates the status of an existing finding in finding.md and status.md.
# Handles counter increments, date stamping, and git milestone commits.
#
# Usage:
#   ./update_finding.sh <finding-name> <new-status> [--bounty <amount>]
#
# Valid statuses:
#   discovered | exploring | exploited | submitted | accepted | rejected | disputed
#
# Examples:
#   ./update_finding.sh sql-injection exploited
#   ./update_finding.sh xss-search-page submitted
#   ./update_finding.sh ssrf-webhook accepted --bounty 500
# ============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TODAY=$(date +%Y-%m-%d)
VALID_STATUSES="discovered exploring exploited submitted accepted rejected disputed"

# --- Validation -----------------------------------------------------------

if [ $# -lt 2 ]; then
    echo "Usage: $0 <finding-name> <new-status> [--bounty <amount>]"
    echo ""
    echo "Valid statuses: ${VALID_STATUSES}"
    echo ""
    echo "Examples:"
    echo "  $0 sql-injection exploited"
    echo "  $0 xss-search-page submitted"
    echo "  $0 ssrf-webhook accepted --bounty 500"
    exit 1
fi

FINDING_NAME="$1"
NEW_STATUS="$2"
BOUNTY_AMOUNT=""

# Parse optional --bounty flag
if [ $# -ge 4 ] && [ "$3" = "--bounty" ]; then
    BOUNTY_AMOUNT="$4"
fi

# Validate status
VALID=0
for s in $VALID_STATUSES; do
    if [ "$NEW_STATUS" = "$s" ]; then
        VALID=1
        break
    fi
done

if [ "$VALID" -ne 1 ]; then
    echo "[!] Invalid status: ${NEW_STATUS}"
    echo "    Valid statuses: ${VALID_STATUSES}"
    exit 1
fi

FINDING_DIR="${SCRIPT_DIR}/findings/${FINDING_NAME}"
FINDING_MD="${FINDING_DIR}/finding.md"
STATUS_FILE="${SCRIPT_DIR}/status.md"

if [ ! -d "$FINDING_DIR" ]; then
    echo "[!] Finding not found: ${FINDING_NAME}"
    echo "    Use ./new_finding.sh to create it first."
    exit 1
fi

if [ ! -f "$FINDING_MD" ]; then
    echo "[!] finding.md not found in: ${FINDING_DIR}"
    exit 1
fi

# Get current status
OLD_STATUS=$(grep -m1 "^status:" "$FINDING_MD" | awk '{print $2}' | tr -d '"' | tr -d "'")

if [ "$OLD_STATUS" = "$NEW_STATUS" ]; then
    echo "[!] Finding '${FINDING_NAME}' is already set to '${NEW_STATUS}'"
    exit 0
fi

echo "[*] Updating finding: ${FINDING_NAME}"
echo "    ${OLD_STATUS} → ${NEW_STATUS}"
echo ""

# --- Update finding.md YAML -----------------------------------------------

sed -i "s/^status: .*/status: ${NEW_STATUS}/" "$FINDING_MD"

# Stamp submitted date
if [ "$NEW_STATUS" = "submitted" ]; then
    sed -i "s/^submitted: .*/submitted: ${TODAY}/" "$FINDING_MD"
fi

# Record bounty amount
if [ -n "$BOUNTY_AMOUNT" ]; then
    sed -i "s/^bounty: .*/bounty: ${BOUNTY_AMOUNT}/" "$FINDING_MD"
fi

echo "    [+] Updated finding.md (status: ${OLD_STATUS} → ${NEW_STATUS})"

# --- Update status.md -----------------------------------------------------

if [ -f "$STATUS_FILE" ]; then
    # Update Last Updated date
    sed -i "s/^\*\*Last Updated:\*\*.*/\*\*Last Updated:\*\* ${TODAY}/" "$STATUS_FILE"

    # Update the finding's row status column in the findings table
    # Matches the link pattern and replaces only the status cell
    sed -i "/\[${FINDING_NAME}\]/ s/| ${OLD_STATUS} |/| ${NEW_STATUS} |/" "$STATUS_FILE"

    echo "    [+] Updated status.md finding row"

    # --- Counter updates --------------------------------------------------

    if [ "$NEW_STATUS" = "submitted" ]; then
        CURRENT=$(grep -oP '\*\*Submitted:\*\* \K[0-9]+' "$STATUS_FILE" 2>/dev/null || echo "0")
        NEW_COUNT=$((CURRENT + 1))
        sed -i "s/\*\*Submitted:\*\* ${CURRENT}/\*\*Submitted:\*\* ${NEW_COUNT}/" "$STATUS_FILE"
        echo "    [+] Submitted counter: ${CURRENT} → ${NEW_COUNT}"
    fi

    if [ "$NEW_STATUS" = "accepted" ]; then
        CURRENT=$(grep -oP '\*\*Accepted:\*\* \K[0-9]+' "$STATUS_FILE" 2>/dev/null || echo "0")
        NEW_COUNT=$((CURRENT + 1))
        sed -i "s/\*\*Accepted:\*\* ${CURRENT}/\*\*Accepted:\*\* ${NEW_COUNT}/" "$STATUS_FILE"
        echo "    [+] Accepted counter: ${CURRENT} → ${NEW_COUNT}"

        if [ -n "$BOUNTY_AMOUNT" ]; then
            CURRENT_BOUNTY=$(grep -oP '\*\*Bounty earned:\*\* \$\K[0-9]+' "$STATUS_FILE" 2>/dev/null || echo "0")
            NEW_BOUNTY=$((CURRENT_BOUNTY + BOUNTY_AMOUNT))
            sed -i "s/\*\*Bounty earned:\*\* \$${CURRENT_BOUNTY}/\*\*Bounty earned:\*\* \$${NEW_BOUNTY}/" "$STATUS_FILE"
            echo "    [+] Bounty earned: \$${CURRENT_BOUNTY} → \$${NEW_BOUNTY}"
        fi
    fi

    if [ "$NEW_STATUS" = "rejected" ] || [ "$NEW_STATUS" = "disputed" ]; then
        CURRENT=$(grep -oP '\*\*Rejected/Disputed:\*\* \K[0-9]+' "$STATUS_FILE" 2>/dev/null || echo "0")
        NEW_COUNT=$((CURRENT + 1))
        sed -i "s/\*\*Rejected\/Disputed:\*\* ${CURRENT}/\*\*Rejected\/Disputed:\*\* ${NEW_COUNT}/" "$STATUS_FILE"
        echo "    [+] Rejected/Disputed counter: ${CURRENT} → ${NEW_COUNT}"
    fi
fi

# --- Git milestone commit -------------------------------------------------

if git -C "$SCRIPT_DIR" rev-parse --git-dir > /dev/null 2>&1; then
    case "$NEW_STATUS" in
        submitted|accepted|rejected|disputed)
            git -C "$SCRIPT_DIR" add "$FINDING_MD" 2>/dev/null || true
            [ -f "$STATUS_FILE" ] && git -C "$SCRIPT_DIR" add "$STATUS_FILE" 2>/dev/null || true
            COMMIT_MSG="finding(${FINDING_NAME}): status → ${NEW_STATUS}"
            if [ -n "$BOUNTY_AMOUNT" ]; then
                COMMIT_MSG="${COMMIT_MSG} (\$${BOUNTY_AMOUNT})"
            fi
            git -C "$SCRIPT_DIR" commit -m "$COMMIT_MSG" 2>/dev/null && \
                echo "    [+] Git commit: ${COMMIT_MSG}" || true
            ;;
    esac
fi

# --- Done -----------------------------------------------------------------

echo ""
echo "[+] Done: ${FINDING_NAME} → ${NEW_STATUS}"
if [ -n "$BOUNTY_AMOUNT" ]; then
    echo "    Bounty recorded: \$${BOUNTY_AMOUNT}"
fi
