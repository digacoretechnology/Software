---
name: ticket-management
description: >
  Add notes, update status, or close ConnectWise tickets. Use this skill whenever the user
  says "add a note to ticket", "close this ticket", "set the status to", "update ticket
  XXXXX", "mark as waiting on 3rd party", "add internal note", "add an external note",
  "change ticket status", "cancel this ticket", or any request that writes to a CW ticket.
  This skill makes changes — confirm the ticket ID and action before proceeding when
  the intent is ambiguous. Do not guess ticket numbers.
metadata:
  sop: None
  owner: Ashwin Sridaran <asridaran@digacore.com>
---

# Ticket management

Add notes, update statuses, and close ConnectWise tickets.

## Why this exists

Engineers update tickets constantly — after calls, after vendor follow-ups, after resolving issues. This skill handles all write operations so they can do it from Claude without opening the CW portal.

## First-time setup — confirm credentials

Before making any change, collect the engineer's personal CW credentials. Ask:

> "To get started, I need your ConnectWise details:
> 1. Your CW username (e.g. jsmith)
> 2. Your personal CW Public Key
> 3. Your personal CW Private Key
>
> You can generate API keys under CW > Account Settings > API Keys. These are personal to you — do not share them."

Store all three in working memory for the session. Never reuse another engineer's credentials. The host, company, and client ID are shared and pre-configured — only the public/private key pair is personal.

## Safety — always confirm ownership

1. Confirm the ticket ID with the user if there is any ambiguity (never guess)
2. Never update a ticket belonging to another engineer unless the user explicitly provides the ID
3. If the user references a ticket by description ("the Mesorah ticket"), look it up first with `cw_get_ticket` or `cw_search_tickets` to confirm the ID before writing

## Operations

### Adding a note

Use `cw_add_ticket_note` with:
- `ticket_id`: the numeric CW ticket ID
- `text`: the note content — technician voice (what was done, result, next steps)
- `internal`: `true` for internal analysis notes, `false` for external/client-visible notes

Default to `internal: true` unless the user explicitly says "external" or "client-facing."

### Updating ticket status

Use `cw_update_ticket_status` with the exact status name. Status names are board-specific:

**Board 54 — Help Desk - Engineering** statuses:
`New`, `New Hardware`, `Hardware Close/Notify`, `Shipped OUT`, `Shipped IN`,
`Waiting for Approval`, `Approved`, `In Progress`, `Escalated`, `Re-Opened`,
`Customer Responded`, `Assigned`, `Scheduled`, `Process Still Running`,
`Scheduled - Waiting Parts`, `Scheduled - Parts Received`, `Scheduled - Need to update`,
`Traveling To`, `Traveling From`, `Waiting Client Response`,
`Waiting Client Response Day 1`, `Waiting Client Response Day 2`,
`Waiting Parts`, `Waiting Vendor`, `On Hold`, `Follow Up before close.`,
`Completed`, `Completed - Day 3 No Response`,
`>Closed`, `>Closed - Day 3 No Response`, `>Closed - Notification`,
`>Resolved - RMM`, `>Cancelled`, `>Closed - Bundled`

**Projects Board** statuses:
`Backlog`, `Ready to Work`, `Waiting on 3rd Party`, `Waiting on Procurement`,
`Ready to Continue`, `Process Still Running`, `In Progress`, `Scheduled`,
`Waiting on Client`, `Need to Schedule`, `Backlog - Date Pending`, `>Closed`

Status names starting with `>` must be passed literally — do not HTML-encode them.

### Closing a ticket

Always add an internal note explaining why before changing status. This creates an audit trail.

- Board 54 (service tickets): `>Closed`
- Projects board: `>Closed`

## CW ticket note tone

Technician writing for technicians: what was said, what was done, what the result was, next action. No full sentences required. No filler.
