# findings/

All discovered findings, one subfolder per finding. This folder is **mandatory**.

## Finding Folder Structure (mandatory)

```
findings/{finding-name}/
├── finding.md          # [mandatory] Metadata, summary, state, key files
├── evidences/          # Screenshots, logs, webhook data
├── poc/                # Exploit code, automation scripts
├── writeup/            # Analysis, vulnerability reports, submissions
├── comms/              # Communications with triager/program owner
└── misc/               # Test scripts, scratch work
```

## Agent Instructions

- Read `finding.md` first when entering any finding folder
- Create finding folder + `finding.md` as soon as a vulnerability is discovered
- Update `finding.md` status and root `status.md` as findings progress

## Finding Lifecycle

```
discovered → exploring → exploited → submitted → accepted/rejected/disputed
```
