#!/usr/bin/env python3
"""MCP server for structured directory context storage as flat JSON files."""

import json
import os
import subprocess
import sys
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional


STORAGE_DIR = ".sudo-context"


# -- Path helpers --


def context_path(project_root: str, directory: str) -> str:
    """Return the absolute path to a context.json file."""
    if directory == ".":
        return os.path.join(project_root, STORAGE_DIR, "context.json")
    return os.path.join(project_root, STORAGE_DIR, directory, "context.json")


def read_context(project_root: str, directory: str) -> Optional[Dict[str, Any]]:
    """Read and parse a context.json file, or None if missing."""
    path = context_path(project_root, directory)
    if not os.path.isfile(path):
        return None
    with open(path, "r") as f:
        return json.load(f)


def write_context(project_root: str, directory: str, data: Dict[str, Any]) -> None:
    """Write a context.json file, creating parent dirs as needed."""
    path = context_path(project_root, directory)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        json.dump(data, f, indent=2)
        f.write("\n")


def list_existing_contexts(project_root: str) -> List[str]:
    """Return all directory keys that have a stored context.json."""
    storage = os.path.join(project_root, STORAGE_DIR)
    if not os.path.isdir(storage):
        return []
    results = []
    for root, _dirs, files in os.walk(storage):
        if "context.json" not in files:
            continue
        rel = os.path.relpath(root, storage)
        results.append("." if rel == "." else rel)
    return results


# -- Git helpers --


def git_ls_directories(project_root: str) -> List[str]:
    """Return unique directories containing tracked files (plus root '.')."""
    result = subprocess.run(
        ["git", "ls-files"],
        capture_output=True, text=True, cwd=project_root,
    )
    if result.returncode != 0:
        return ["."]
    dirs = set()
    dirs.add(".")
    for filepath in result.stdout.strip().splitlines():
        parts = filepath.split("/")
        for i in range(1, len(parts)):
            dirs.add("/".join(parts[:i]))
    return sorted(dirs)


def git_diff_has_changes(project_root: str, git_ref: str, directory: str) -> bool:
    """Check if a directory has changes since a given git ref."""
    dir_arg = "." if directory == "." else directory
    result = subprocess.run(
        ["git", "diff", "--quiet", f"{git_ref}..HEAD", "--", dir_arg],
        capture_output=True, text=True, cwd=project_root,
    )
    return result.returncode != 0


def git_check_ignore(project_root: str, path: str) -> bool:
    """Return True if the path is gitignored."""
    result = subprocess.run(
        ["git", "check-ignore", "-q", path],
        capture_output=True, text=True, cwd=project_root,
    )
    return result.returncode == 0


# -- Validation --


def validate_params(
    args: Dict[str, Any], required: List[str], types: Optional[Dict[str, type]] = None
) -> Optional[str]:
    """Return an error message if validation fails, else None."""
    for key in required:
        if key not in args:
            return f"Missing required parameter: {key}"
    if types:
        for key, expected in types.items():
            if key in args and not isinstance(args[key], expected):
                return f"Parameter '{key}' must be {expected.__name__}"
    return None


# -- Tool handlers --


def handle_upsert_context(args: Dict[str, Any]) -> Dict[str, Any]:
    """Create or update directory context, merging sections."""
    err = validate_params(
        args,
        required=["project_root", "repo", "git_ref", "directory", "sections"],
        types={
            "project_root": str,
            "repo": str,
            "git_ref": str,
            "directory": str,
            "sections": dict,
        },
    )
    if err:
        return {"error": err}
    project_root = args["project_root"]
    directory = args["directory"]
    existing = read_context(project_root, directory) or {}
    merged_sections = existing.get("sections", {})
    merged_sections.update(args["sections"])
    data = {
        "repo": args["repo"],
        "directory": directory,
        "git_ref": args["git_ref"],
        "updated_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "sections": merged_sections,
    }
    write_context(project_root, directory, data)
    return {"status": "ok", "path": context_path(project_root, directory)}


def handle_query_context(args: Dict[str, Any]) -> Dict[str, Any]:
    """Retrieve stored context for a directory."""
    err = validate_params(
        args,
        required=["project_root", "directory"],
        types={"project_root": str, "directory": str},
    )
    if err:
        return {"error": err}
    data = read_context(args["project_root"], args["directory"])
    if data is None:
        return {"error": f"No context found for directory: {args['directory']}"}
    sections_filter = args.get("sections")
    if isinstance(sections_filter, list) and sections_filter:
        data["sections"] = {
            k: v for k, v in data["sections"].items() if k in sections_filter
        }
    return data


def handle_check_context_status(args: Dict[str, Any]) -> Dict[str, Any]:
    """Audit all directories against stored contexts."""
    err = validate_params(
        args, required=["project_root"], types={"project_root": str}
    )
    if err:
        return {"error": err}
    project_root = args["project_root"]
    tracked_dirs = git_ls_directories(project_root)
    existing = list_existing_contexts(project_root)
    existing_set = set(existing)
    needs_creation = []
    for d in tracked_dirs:
        if d in existing_set:
            continue
        if d != "." and d.split("/")[0].startswith("."):
            continue
        needs_creation.append(d)
    needs_deletion = []
    for d in existing:
        dir_path = "." if d == "." else d
        abs_path = os.path.join(project_root, dir_path) if dir_path != "." else project_root
        if not os.path.isdir(abs_path):
            needs_deletion.append(d)
            continue
        if dir_path != "." and git_check_ignore(project_root, dir_path):
            needs_deletion.append(d)
    needs_update = []
    for d in existing:
        if d in [x for x in needs_deletion]:
            continue
        ctx = read_context(project_root, d)
        if ctx is None:
            continue
        git_ref = ctx.get("git_ref")
        if not git_ref:
            needs_update.append(d)
            continue
        if git_diff_has_changes(project_root, git_ref, d):
            needs_update.append(d)
    return {
        "needs_creation": sorted(needs_creation),
        "needs_deletion": sorted(needs_deletion),
        "needs_update": sorted(needs_update),
    }


# -- Tool schemas --


TOOLS = [
    {
        "name": "upsert_context",
        "description": "Create or update directory context. Merges sections (preserves existing keys not in this call).",
        "inputSchema": {
            "type": "object",
            "properties": {
                "project_root": {
                    "type": "string",
                    "description": "Absolute path to git repo root",
                },
                "repo": {
                    "type": "string",
                    "description": "Repo namespace/name (e.g. owner/repo)",
                },
                "git_ref": {
                    "type": "string",
                    "description": "Current short git ref",
                },
                "directory": {
                    "type": "string",
                    "description": 'Relative dir path ("." for root)',
                },
                "sections": {
                    "type": "object",
                    "description": "Section name to content string pairs",
                    "additionalProperties": {"type": "string"},
                },
            },
            "required": ["project_root", "repo", "git_ref", "directory", "sections"],
        },
    },
    {
        "name": "query_context",
        "description": "Retrieve stored context for a directory.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "project_root": {
                    "type": "string",
                    "description": "Absolute path to git repo root",
                },
                "directory": {
                    "type": "string",
                    "description": "Relative dir path",
                },
                "sections": {
                    "type": "array",
                    "items": {"type": "string"},
                    "description": "Filter to specific sections (omit for all)",
                },
            },
            "required": ["project_root", "directory"],
        },
    },
    {
        "name": "check_context_status",
        "description": "Audit all directories against stored contexts. Reports which directories need context creation, deletion, or update.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "project_root": {
                    "type": "string",
                    "description": "Absolute path to git repo root",
                },
            },
            "required": ["project_root"],
        },
    },
]

TOOL_HANDLERS = {
    "upsert_context": handle_upsert_context,
    "query_context": handle_query_context,
    "check_context_status": handle_check_context_status,
}


# -- Protocol --


def handle_request(req: Dict[str, Any]) -> Optional[Dict[str, Any]]:
    """Handle a JSON-RPC request."""
    method = req.get("method")
    req_id = req.get("id")
    if method == "initialize":
        return {
            "jsonrpc": "2.0",
            "id": req_id,
            "result": {
                "protocolVersion": "2024-11-05",
                "serverInfo": {"name": "sudo-context", "version": "1.0.0"},
                "capabilities": {"tools": {}},
            },
        }
    if method == "notifications/initialized":
        return None
    if method == "tools/list":
        return {
            "jsonrpc": "2.0",
            "id": req_id,
            "result": {"tools": TOOLS},
        }
    if method == "tools/call":
        params = req.get("params", {})
        tool_name = params.get("name")
        handler = TOOL_HANDLERS.get(tool_name)
        if not handler:
            return {
                "jsonrpc": "2.0",
                "id": req_id,
                "error": {"code": -32601, "message": f"Unknown tool: {tool_name}"},
            }
        args = params.get("arguments", {})
        result = handler(args)
        if "error" in result and isinstance(result["error"], str):
            return {
                "jsonrpc": "2.0",
                "id": req_id,
                "result": {
                    "content": [{"type": "text", "text": result["error"]}],
                    "isError": True,
                },
            }
        return {
            "jsonrpc": "2.0",
            "id": req_id,
            "result": {
                "content": [{"type": "text", "text": json.dumps(result, indent=2)}]
            },
        }
    return {
        "jsonrpc": "2.0",
        "id": req_id,
        "error": {"code": -32601, "message": f"Unknown method: {method}"},
    }


def main() -> None:
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
