# recon/

Reconnaissance phase outputs. This folder is **mandatory** for every engagement.

## Contents

| File | Description |
|------|-------------|
| `recon_notes.md` | Raw reconnaissance findings (populated by `/spechunt:recon`) |
| `triage.md` | Prioritized findings queue with scores and status |
| `triage-report.md` | OSINT-enriched triage (populated by `/spechunt:triage`) |

## Agent Instructions

- `triage.md` defines the testing priority order — work top-down
- Update finding status in `triage.md` as they are confirmed or ruled out
- For scope checks, read `program/scope.md` or run `/spechunt:scope-check <url>`
