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

- **`submitted`** — Verify `submitted:` date is set in finding.md YAML. Confirm "Submitted" counter incremented in status.md. Create `findings/<name>/comms/YYYY-MM-DD_01_submitted.md` with the platform report URL/ID and submission date.

- **`accepted`** — Ask the user for the bounty amount, then run:
  ```bash
  bash ./update_finding.sh <name> accepted --bounty <amount>
  ```
  Verify "Accepted" counter, "Bounty earned" total, and the bounty column in the findings table all updated in status.md. Record the acceptance in `comms/` as `YYYY-MM-DD_NN_accepted.md`.

- **`rejected`** — Record the platform's reason in `findings/<name>/comms/YYYY-MM-DD_NN_rejected.md`. Then:
  1. Review the rejection reason carefully — was it scope, insufficient impact, or a duplicate?
  2. Add a note in `recon/triage.md` with the outcome to avoid similar findings in future
  3. If the rejection seems incorrect, consider whether additional evidence could support a dispute

- **`disputed`** — The finding has been rejected but you believe it's valid. Take these steps:
  1. Record the platform's rejection reason in `comms/YYYY-MM-DD_NN_disputed.md`
  2. Re-read `findings/<name>/writeup/submission.md` — identify the weakest parts of the original report
  3. Gather additional evidence: a more severe impact demonstration, affected user count, or a cleaner PoC
  4. Save the strengthened argument to `comms/YYYY-MM-DD_NN_dispute-response.md` before posting
  5. Rewrite the impact section in `submission.md` from a business risk perspective if it was too technical
  6. Check `program/rules.md` — confirm the vulnerability class is explicitly in scope and not excluded

- **`exploring`** or **`exploited`** — No counters change. Confirm the finding.md and status.md row reflect the new status.
