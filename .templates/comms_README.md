# comms/

All communications with the triager and program owner.

## Naming Convention

```
YYYY-MM-DD_NN_description.md
```

| Part | Meaning | Example |
|------|---------|---------|
| `YYYY-MM-DD` | Date of the communication | `2026-03-01` |
| `NN` | Chronological sequence number | `01`, `02` |
| `description` | Short description of the message | `submitted`, `triager-request-info`, `impact-clarification`, `accepted`, `disputed` |

Examples:
- `2026-03-01_01_submitted.md`
- `2026-03-03_02_triager-request-info.md`
- `2026-03-04_03_impact-clarification-sent.md`
- `2026-03-10_04_accepted.md`

## Agent Instructions

- Create one file per communication event (sent or received)
- Read all files in alphabetical (chronological) order to follow the full thread
- Always draft outgoing responses here before posting to the platform
- Include the platform's message verbatim when saving received responses
- Use the header format below for consistency:

```markdown
# [direction: sent / received] — [date] — [brief subject]

[Full message content]
```
