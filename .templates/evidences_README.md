# evidences/

Proof that the vulnerability exists. Screenshots, logs, webhook captures, exfiltrated data.

## Naming Convention

```
YYYY-MM-DD_NN_description.ext
```

| Part | Meaning | Example |
|------|---------|---------|
| `YYYY-MM-DD` | Date captured | `2026-03-01` |
| `NN` | Step sequence number | `01`, `02` |
| `description` | Short, hyphen-separated description | `initial-request`, `response-with-data`, `account-takeover-proof` |
| `.ext` | File type | `.png`, `.txt`, `.json`, `.har` |

Examples:
- `2026-03-01_01_login-request.txt`
- `2026-03-01_02_token-in-response.png`
- `2026-03-01_03_account-takeover-proof.png`
- `2026-03-01_04_webhook-exfil.json`

## Agent Instructions

- Follow the naming convention above — submission.md references evidence files by name
- Save raw HTTP requests/responses as `.txt` or `.json`
- Save screenshots as `.png`
- Capture both attacker-side request and target-side response as separate files
- Do not modify evidence files after creation — they are timestamped proof
- Capture the minimum evidence needed to prove exploitation; quality over quantity
