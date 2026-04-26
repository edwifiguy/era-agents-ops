# Canonical-style MicroCloud Demo (Containerized)

This demo gives you a stakeholder-friendly, self-contained environment that looks and behaves like a lightweight "Replit-style" platform:

- **Dashboard UI** for a clear presentation surface
- **Workspace container** (`code-server`) for in-browser coding
- **Orchestrator API** that exposes node health + MemPalace wiring
- **Three mock MicroCloud nodes** (compute/storage/edge)

## Why this helps with stakeholders

1. Shows platform thinking (not just prompts): compute topology + orchestration + developer UX.
2. Demonstrates persistent memory readiness via `mempalace.yaml`.
3. Makes architecture explainable in one browser tab.
4. Gives a concrete migration path from demo -> production.

## Run

```bash
cd demos/microcloud-replitt
docker compose up -d --build
```

Open:

- Dashboard: http://localhost:18080
- Orchestrator API: http://localhost:18081/api/topology
- Workspace: http://localhost:18443 (password: `demo`)

Stop:

```bash
docker compose down
```

## Diagram

```text
                 +---------------------------+
                 |   Dashboard (nginx)      |
                 |   localhost:18080        |
                 +------------+-------------+
                              |
                reads topology|JSON
                              v
                 +---------------------------+
                 | Orchestrator API (Flask) |
                 | localhost:18081          |
                 +-----+----------+---------+
                       |          |
          probes nodes |          | reads memory contract
                       v          v
   +-------------------+--+   +------------------------+
   | node-a / node-b / node-c| | mempalace.yaml         |
   | mock microcloud roles   | | (rooms + backend info) |
   +-------------------------+ +------------------------+

                 +---------------------------+
                 | Workspace (code-server)   |
                 | localhost:18443           |
                 +---------------------------+
```

## Notes

- This is a **demo scaffold**: it visualizes the architecture and flow clearly.
- You can later replace mock nodes with real Canonical MicroCloud/LXD primitives.
