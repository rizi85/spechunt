# program/

Bug bounty program information. This folder is **mandatory** for every engagement.

## Contents

| File | Description |
|------|-------------|
| `program_description.md` | Full program description from the bounty platform (raw paste) |
| `rules.md` | Rules of engagement, structured by `/setup` from program description |
| `scope.md` | Structured scope — tiers, bounty table, out-of-scope list, rate limits |

## Agent Instructions

- Read these files **first** before any testing activity
- `program_description.md` is the raw source — do not modify it
- `scope.md` and `rules.md` are populated by `/setup` — review and correct if needed
- Reference `scope.md` for all scope checks; use `/scope-check <url>` when unsure
