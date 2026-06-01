---
name: morning-briefing
description: >
  Run a daily ConnectWise ticket briefing for the current engineer. Search open CW tickets
  assigned to the user, categorize them by urgency, and save a markdown briefing to the
  workspace folder. Use this skill whenever the user says "run my morning briefing",
  "what tickets need action today", "what's on my plate in CW", "pull my CW tickets",
  "give me a ticket summary", or anything that implies they want an overview of their
  open ConnectWise workload for the day. Run proactively — don't ask for confirmation
  before pulling tickets.
metadata:
  sop: None
  owner: Ashwin Sridaran <asridaran@digacore.com>
---

# Morning briefing

Pull the engineer's open ConnectWise tickets and produce a concise, action-oriented briefing saved to their workspace.

## Why this exists

Engineers start their day needing to know: what needs action now, what's blocked on someone else, and what can be closed. This skill answers all three in one shot without opening the CW portal.

## First-time setup — confirm credentials

Before running the briefing, collect the engineer's personal CW credentials. Ask:

> "To get started, I need your ConnectWise details:
> 1. Your CW username (e.g. jsmith)
> 2. Your personal CW Public Key
> 3. Your personal CW Private Key
>
> You can generate API keys under CW > Account Settings > API Keys. These are personal to you — do not share them."

Store all three in working memory for the session. Never reuse another engineer's credentials. Each engineer must supply their own public/private key pair — the host, company, and client ID are shared and pre-configured.

## Steps

1. Search CW tickets using `cw_search_tickets` with:
   - `conditions`: `resources like "<username>" AND status/name != "Closed"`
   - `order_by`: `lastUpdated desc`
   - `page_size`: 25

2. Categorize each open ticket:
   - **Needs Action** — past SLA (`isInSla: false`), escalated, explicitly waiting on the engineer, or In Progress with no recent movement
   - **Waiting / Follow Up** — blocked on vendor, client, or third party (`Waiting Vendor`, `Waiting Client Response`, etc.)
   - **Housekeeping** — Completed or resolved but `closedFlag: false`, or no activity in 14+ days

3. Write the briefing as markdown to the workspace folder:
   `<workspace>/Morning Briefing - <YYYY-MM-DD>.md`

## Output format

```
# Morning Briefing — <Date>

### 🔴 Needs Action
**#XXXXX** | Company | Summary | Status | Action: [specific next step]

### 🟡 Waiting / Follow Up
**#XXXXX** | Company | Summary | Waiting on: [who] | Last updated: [date]

### 🟢 Housekeeping
**#XXXXX** | Company | Summary | Status | Last updated: [date]

### Summary
X open tickets, Y need action today.
```

## Tone

Blunt and direct — written for a senior engineer. Specific action items (who to contact, what to do). No filler.

## Notes

- The result set may be large — parse it via subagent if it exceeds context
- CW ticket statuses that indicate closure start with `>` (e.g. `>Closed`, `> Closed – Client Not Approved`)
- Board 54 = Help Desk - Engineering; Board 72 = Account Management Board — statuses differ between boards
