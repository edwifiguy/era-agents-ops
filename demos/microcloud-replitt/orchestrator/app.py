import json
import os
from datetime import datetime, timezone

import requests
from flask import Flask, jsonify

app = Flask(__name__)


def _read_mempalace_summary(path: str) -> dict:
    if not os.path.exists(path):
        return {"configured": False, "reason": "mempalace.yaml not mounted"}
    summary = {"configured": True, "path": path, "rooms": []}
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            stripped = line.strip()
            if stripped.startswith("- id:"):
                summary["rooms"].append(stripped.split(":", 1)[1].strip())
    return summary


def _probe_nodes(node_urls: list[str]) -> list[dict]:
    nodes = []
    for url in node_urls:
        name = url.split("//", 1)[-1].split(":", 1)[0]
        node = {"name": name, "url": url, "status": "down", "payload": None}
        try:
            response = requests.get(url, timeout=2)
            node["status"] = "up" if response.ok else "degraded"
            try:
                node["payload"] = json.loads(response.text)
            except json.JSONDecodeError:
                node["payload"] = {"raw": response.text}
        except requests.RequestException as exc:
            node["payload"] = {"error": str(exc)}
        nodes.append(node)
    return nodes


@app.get("/health")
def health():
    return jsonify({"status": "ok"})


@app.get("/api/topology")
def topology():
    mempalace_path = os.getenv("MEMPALACE_CONFIG", "/config/mempalace.yaml")
    node_urls = [u.strip() for u in os.getenv("NODE_URLS", "").split(",") if u.strip()]

    return jsonify(
        {
            "name": "ERA MicroCloud Stakeholder Demo",
            "mode": "containerized-homelab",
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "mempalace": _read_mempalace_summary(mempalace_path),
            "nodes": _probe_nodes(node_urls),
            "entrypoints": {
                "dashboard": "http://localhost:18080",
                "orchestrator_api": "http://localhost:18081/api/topology",
                "workspace": "http://localhost:18443",
            },
        }
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
