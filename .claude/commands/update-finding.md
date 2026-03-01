Update the status of an existing finding.

Usage: `/update-finding <finding-name> <new-status>`

Valid statuses: `discovered` | `exploring` | `exploited` | `submitted` | `accepted` | `rejected` | `disputed`

**Run the update script:**

```bash
bash ./update_finding.sh $ARGUMENTS
```

**After the script completes:**

1. Read `findings/<finding-name>/finding.md` — confirm `status:` field was updated
2. Read `status.md` — confirm the finding row status and counters were updated

**Status-specific follow-up actions:**

- **`submitted`** — Verify `submitted:` date is set in finding.md YAML. Confirm "Submitted" counter incremented in status.md. Note the submission in `findings/<name>/comms/` as `YYYY-MM-DD_01_submitted.md` with the platform report URL/ID.

- **`accepted`** — Ask the user for the bounty amount, then run:
  ```bash
  bash ./update_finding.sh <name> accepted --bounty <amount>
  ```
  Verify "Accepted" counter and "Bounty earned" total updated in status.md. Record the acceptance in `comms/` as `YYYY-MM-DD_NN_accepted.md`.

- **`rejected`** or **`disputed`** — Record the platform's reason in `findings/<name>/comms/` as `YYYY-MM-DD_NN_rejected.md` or `YYYY-MM-DD_NN_disputed.md`. Add a note in `recon/triage.md` with the outcome so future triage avoids similar dead ends.

- **`exploring`** or **`exploited`** — No counters change. Just confirm the finding.md and status.md row reflect the new status.
