---
name: ticket-management
description: >
  Add notes, update status, or close ConnectWise tickets. Use this skill whenever the user
  says "add a note to ticket", "close this ticket", "set the status to", "update ticket
  XXXXX", "mark as waiting vendor", "add internal note", "add an external note", "change
  ticket status", "cancel this ticket", or any request that writes to a CW ticket.
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

## Safety first — always confirm ownership

Before making any change:
1. Confirm the ticket ID with the user if there is any ambiguity (never guess)
2. Never update a ticket that belongs to another engineer unless the user explicitly asks and provides the ID
3. If the user references a ticket by description ("the Mesorah ticket"), look it up first with `cw_get_ticket` or `cw_search_tickets` to confirm the ID before writing

## Operations

### Adding a note

Use `cw_add_ticket_note` with:
- `ticket_id`: the numeric CW ticket ID
- `text`: the note content — write in technician voice (what was done, what the result was, next steps)
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

**Board 72 — Account Management Board** statuses:
`New`, `In Progress`, `Scheduled`, `Waiting Vendor`, `Waiting Client Response`,
`On Hold`, `Completed`, `Completed - Day 3 No Response`,
`> Closed – Client Not Approved`, `> Closed`, `>Canceled`

Status names starting with `>` must be passed literally — do not HTML-encode them.

### Closing a ticket

Always add an internal note explaining why the ticket is being closed before changing the status. This creates an audit trail.

- Board 54 close status: `>Closed`
- Board 72 close status: `> Closed`
- Board 72 cancelled/unapproved: `>Canceled` or `> Closed – Client Not Approved`

## CW ticket note tone

Write notes the way a technician writes for other technicians:
- What the vendor/client/source said
- What steps were taken
- What the result was
- Current status / next action

No full sentences required. No filler. Action-oriented.
