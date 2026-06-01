---
name: ticket-triage
description: >
  Search, view, and review open ConnectWise tickets assigned to the current engineer.
  Use this skill whenever the user says "show me my open tickets", "what's assigned to me
  in CW", "search CW for tickets", "pull up ticket XXXXX", "what tickets do I have open",
  "check my CW queue", "look up a ticket", or any request to find or review CW ticket
  information. This skill is read-only — it does not add notes or change status. For those
  actions use the ticket-management skill instead.
metadata:
  sop: None
  owner: Ashwin Sridaran <asridaran@digacore.com>
---

# Ticket triage

Search and display ConnectWise tickets for the engineer.

## Why this exists

Engineers need to quickly look up tickets by company, status, or keyword without navigating the CW portal. This skill handles all read operations — fetching ticket details, reviewing notes, checking time entries.

## First-time setup — always confirm username

Before running any search, confirm the engineer's CW username. Ask:

> "What's your ConnectWise username? I want to make sure I only pull your tickets."

Store the answer in working memory for the session. Never assume or reuse another engineer's username from a prior conversation — CW usernames are personal and queries scoped to the wrong user could surface sensitive data.

## Available operations

Use the appropriate tool based on what the user is asking:

| User intent | Tool | Key parameters |
|-------------|------|---------------|
| My open tickets | `cw_search_tickets` | `resources like "<username>" AND status/name not in (">Closed","...")` |
| Tickets for a company | `cw_search_tickets` | `company/name like "<name>"` |
| Specific ticket | `cw_get_ticket` | ticket ID |
| Ticket notes/history | `cw_get_ticket_notes` | ticket ID |
| Time logged | `cw_get_time_entries` | ticket ID |
| Company info | `cw_get_company` | company ID |

## Output

Present results in a clean summary — ticket ID, company, summary, status, last updated, priority. Flag anything past SLA or escalated. Don't dump raw JSON at the user.

## Boundary

This skill is read-only. If the user wants to add a note, change a status, or close a ticket, hand off to the ticket-management skill.
