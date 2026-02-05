#!/usr/bin/env python3
"""Claude plugin MCP server for generating PlantUML URLs."""

import json
import sys
import zlib

BASE_URL = "https://www.plantuml.com/plantuml"
ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_"


def encode_plantuml(text: str) -> str:
    """Encode PlantUML diagram text to the format used in URLs."""
    compressed = zlib.compress(text.encode("utf-8"), level=9)
    return "~1" + _encode64(compressed)


def _encode64(data: bytes) -> str:
    """Encode bytes using PlantUML's custom base64 alphabet."""
    result = []
    for i in range(0, len(data), 3):
        if i + 2 < len(data):
            b1, b2, b3 = data[i], data[i + 1], data[i + 2]
        elif i + 1 < len(data):
            b1, b2, b3 = data[i], data[i + 1], 0
        else:
            b1, b2, b3 = data[i], 0, 0

        c1 = b1 >> 2
        c2 = ((b1 & 0x3) << 4) | (b2 >> 4)
        c3 = ((b2 & 0xF) << 2) | (b3 >> 6)
        c4 = b3 & 0x3F

        result.extend([ALPHABET[c1], ALPHABET[c2], ALPHABET[c3], ALPHABET[c4]])

    return "".join(result)


def generate_urls(diagram: str) -> dict:
    """Generate all PlantUML URLs for a diagram."""
    encoded = encode_plantuml(diagram)
    return {
        "png": f"{BASE_URL}/png/{encoded}",
        "svg": f"{BASE_URL}/svg/{encoded}",
        "txt": f"{BASE_URL}/txt/{encoded}",
        "editor": f"{BASE_URL}/uml/{encoded}",
    }


def handle_request(req: dict) -> dict | None:
    """Handle a JSON-RPC request."""
    method = req.get("method")
    req_id = req.get("id")

    if method == "initialize":
        return {
            "jsonrpc": "2.0",
            "id": req_id,
            "result": {
                "protocolVersion": "2024-11-05",
                "serverInfo": {"name": "claude-plugin-plantuml", "version": "1.0.0"},
                "capabilities": {"tools": {}},
            },
        }

    if method == "notifications/initialized":
        return None

    if method == "tools/list":
        return {
            "jsonrpc": "2.0",
            "id": req_id,
            "result": {
                "tools": [
                    {
                        "name": "plantuml_generate_urls",
                        "description": "Generate PlantUML image and editor URLs from diagram syntax. Returns URLs for PNG, SVG, TXT (ASCII art), and the online editor.",
                        "inputSchema": {
                            "type": "object",
                            "properties": {
                                "diagram": {
                                    "type": "string",
                                    "description": "The PlantUML diagram syntax (e.g., '@startuml\\nAlice -> Bob: Hello\\n@enduml')",
                                }
                            },
                            "required": ["diagram"],
                        },
                    }
                ]
            },
        }

    if method == "tools/call":
        params = req.get("params", {})
        tool_name = params.get("name")

        if tool_name == "plantuml_generate_urls":
            args = params.get("arguments", {})
            diagram = args.get("diagram")

            if not isinstance(diagram, str):
                return {
                    "jsonrpc": "2.0",
                    "id": req_id,
                    "error": {"code": -32602, "message": "diagram must be a string"},
                }

            urls = generate_urls(diagram)
            return {
                "jsonrpc": "2.0",
                "id": req_id,
                "result": {
                    "content": [{"type": "text", "text": json.dumps(urls, indent=2)}]
                },
            }

        return {
            "jsonrpc": "2.0",
            "id": req_id,
            "error": {"code": -32601, "message": f"Unknown tool: {tool_name}"},
        }

    return {
        "jsonrpc": "2.0",
        "id": req_id,
        "error": {"code": -32601, "message": f"Unknown method: {method}"},
    }


def main():
    """Main loop reading JSON-RPC requests from stdin."""
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue

        try:
            req = json.loads(line)
        except json.JSONDecodeError:
            continue

        resp = handle_request(req)
        if resp is not None:
            print(json.dumps(resp), flush=True)


if __name__ == "__main__":
    main()
