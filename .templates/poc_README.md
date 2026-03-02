# poc/

Proof-of-concept exploit code and automation scripts.

## Naming Convention

```
poc_NN_description.ext
```

| Part | Meaning | Example |
|------|---------|---------|
| `NN` | Step or version sequence | `01`, `02` |
| `description` | Short, hyphen-separated description | `initial-ssrf`, `auth-bypass`, `exfil-full` |
| `.ext` | File type | `.py`, `.sh`, `.js`, `.http`, `.txt` |

Examples:
- `poc_01_initial-request.http` — raw HTTP request proving the issue
- `poc_02_automated-exploit.py` — script that automates exploitation
- `poc_03_exfil-demo.sh` — demonstrates data exfiltration impact

## Agent Instructions

- `poc_01_*` is the **submission PoC** — clean, minimal, self-contained, ready to paste into the report
- Higher-numbered files are progressions: deeper exploitation, automation, impact amplification
- Every PoC file must include a comment block at the top explaining: target, prerequisite, expected result
- Do not include real credentials — use placeholder values (`VICTIM_TOKEN`, `TARGET_HOST`)
- Reference PoC files in `writeup/submission.md` using relative paths: `../poc/poc_01_initial-request.http`
