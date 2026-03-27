Update the status of an existing finding.

Usage: `/spechunt:update-finding <finding-name> <new-status>`

Valid statuses: `discovered` | `exploring` | `exploited` | `submitted` | `accepted` | `rejected` | `disputed`

**Run the update script:**

```bash
bash ./update_finding.sh $ARGUMENTS
```

**After the script completes:**

1. Read `findings/<finding-name>/finding.md` — confirm `status:` field was updated
2. Read `status.md` — confirm the finding row status and counters were updated

**Status-specific follow-up actions:**

- **`submitted`** — The script auto-generates `comms/YYYY-MM-DD_NN_submitted.md`. Open it and fill in the platform report ID / URL.

- **`accepted`** — Ask the user for the bounty amount, then run:
  ```bash
  bash ./update_finding.sh <name> accepted --bounty <amount>
  ```
  Verify "Accepted" counter, "Bounty earned" total, and the bounty column in the findings table all updated in status.md. The script auto-generates `comms/YYYY-MM-DD_NN_accepted.md` — open it and paste the platform's acceptance message.

- **`rejected`** — The script auto-generates `comms/YYYY-MM-DD_NN_rejected.md`. Open it and:
  1. Paste the platform's rejection message verbatim
  2. Fill in the Analysis section — was it scope, insufficient impact, or a duplicate?
  3. Add a note in `recon/triage.md` with the outcome to avoid similar findings in future
  4. If the rejection seems incorrect, consider whether additional evidence could support a dispute

- **`disputed`** — The finding has been rejected but you believe it's valid. The script auto-generates `comms/YYYY-MM-DD_NN_disputed.md`. Open it and:
  1. Fill in the original rejection reason
  2. Re-read `findings/<name>/writeup/submission.md` — identify the weakest parts of the original report
  3. Gather additional evidence: a more severe impact demonstration, affected user count, or a cleaner PoC
  4. Draft the dispute response in the file before posting
  5. When ready to post, save a clean copy as `comms/YYYY-MM-DD_NN_dispute-response.md`
  6. Check `program/rules.md` — confirm the vulnerability class is explicitly in scope and not excluded

- **`exploring`** or **`exploited`** — No counters change. Confirm the finding.md and status.md row reflect the new status.
