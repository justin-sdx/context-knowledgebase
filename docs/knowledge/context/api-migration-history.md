**Tier:** context

**Date:** 2026-02-17

**Last Reviewed:** 2026-02-17

**Summary**
Migration from REST to GraphQL API started in Q4 2025, partially complete

**Detail**
- Legacy REST API still serves /users, /products, /orders endpoints
- New GraphQL API handles /analytics, /recommendations, /search
- Both APIs run in parallel, sharing the same database
- Plan to fully migrate by Q3 2026, but not blocking current work
- REST endpoints at api.example.com/v1/*, GraphQL at api.example.com/graphql

**Background**
- REST API became too chatty for complex queries (N+1 problems)
- Frontend needed to make 5-10 requests to render dashboard
- GraphQL allows fetching related data in single query
- Migration is gradual to avoid disrupting production

**Tradeoffs**
- Running dual APIs increases infrastructure complexity
- Some data fetching patterns inconsistent during transition
- Team learning curve for GraphQL (mostly overcome now)
- Benefits: ~60% reduction in network requests for complex views

**Usage**
This is informational context. When working on features:
- Check if the data is available via GraphQL first
- If only REST exists, use REST (don't block work)
- Document any pain points that would benefit from GraphQL migration

This doesn't constrain your approach—use whichever API serves the current task best.
