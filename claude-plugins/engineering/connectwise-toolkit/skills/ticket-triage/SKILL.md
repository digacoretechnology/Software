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

## First-time setup — confirm credentials

Before running any query, collect the engineer's personal CW credentials. Ask:

> "To get started, I need your ConnectWise details:
> 1. Your CW username (e.g. jsmith)
> 2. Your personal CW Public Key
> 3. Your personal CW Private Key
>
> You can generate API keys under CW > Account Settings > API Keys. These are personal to you — do not share them."

Store all three in working memory for the session. Never reuse another engineer's credentials. The host, company, and client ID are shared and pre-configured — only the public/private key pair is personal.

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
