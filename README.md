# Dreamweaver - World Building Platform

A structured world building platform for writers, tabletop RPG players, and creators. Build and document fictional worlds through interconnected articles, typed relationships, and an interactive relationship graph.

---

## Problem Description

### System Purpose

Dreamweaver is a web-based platform that allows users to create and manage fictional worlds in a structured, consistent way. Users can write articles about the people, places, events, and organizations that make up their world, and define typed relationships between them (e.g. "ruled", "born in", "participated in"). The platform surfaces the connections between articles as an interactive graph and enforces visibility rules so that worlds can be shared publicly or kept private.

The system consists of two parts: a REST API backend and a single-page frontend application.

### Domain Objects

The system is built around three hierarchically related domain objects:

| Object | Hierarchy | Description |
|---|---|---|
| **World** | Root | Top-level object. Belongs to one member, contains many articles. |
| **Article** | World → Article | Describes a world element - a character, place, event, or organisation. Has a type and rich-text content stored as JSONB. |
| **Relationship** | Article → Relationship | A typed link between two articles (e.g. "ruled", "born in"). Belongs to the source article. |

## Technology Stack

| Layer | Technology |
|---|---|
| Frontend | React + TypeScript |
| API Client | Orval + TanStack Query |
| Routing | React Router v6 |
| Backend | ASP.NET Core |
| ORM | Entity Framework Core |
| Database | PostgreSQL 16 |
