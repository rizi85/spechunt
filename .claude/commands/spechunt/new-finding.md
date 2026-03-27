A new vulnerability has been discovered. Create the finding folder structure by running:

```
bash ./new_finding.sh $ARGUMENTS
```

After the script completes:

1. Open `findings/$ARGUMENTS/finding.md` and fill in all TODO fields:
   - `title`: Clear one-line description of the vulnerability
   - `severity`: low / medium / high / critical
   - `asset`: The affected domain or endpoint (include tier)
   - `cwe`: The applicable CWE ID (e.g. CWE-79 for XSS, CWE-639 for IDOR)
   - **Summary**: One paragraph — what the vuln is, how it was found, why it matters
   - **Current State**: What needs to happen next
   - **Attack Chain**: Step-by-step exploitation flow
   - **Impact**: What an attacker can achieve

2. Update `recon/triage.md` — add or update the finding's entry in the priority queue with its current status.

3. Confirm the changes by reading `status.md` to verify the finding appears in the dashboard.
