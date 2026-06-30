# ConnectWise Toolkit

Engineering team plugin for ConnectWise ticket management in Cowork.

## What it does

Gives engineering team members direct access to their ConnectWise tickets from Claude — daily briefings, ticket triage, adding notes, updating statuses, and closing tickets — without opening the CW portal.

## Skills

| Skill | Purpose | Trigger examples |
|-------|---------|-----------------|
| `morning-briefing` | Daily CW ticket briefing saved to workspace | "run my morning briefing", "what tickets need action today" |
| `ticket-triage` | Search and review open CW tickets | "show me my open tickets", "what's assigned to me in CW" |
| `ticket-management` | Add notes, update status, close tickets | "add a note to ticket 12345", "close the Mesorah ticket", "set ticket to waiting vendor" |

## MCP connector

Requires the ConnectWise MCP server. Contact Nathan to confirm the package name and env vars for your environment.

See `mcps/connectwise.json` for the config template.

## Ownership & SOP

- **Revision owner:** Ashwin Sridaran <asridaran@digacore.com>
- **SOP:** None — this plugin documents the workflow implicitly through its skill instructions.

All future changes to this plugin require approval from the revision owner before merging.
