#!/usr/bin/env python3
"""Send Codex notifications through dunstify."""

import json
import subprocess
import sys
from typing import Any, Dict, Optional, Tuple


def extract_assistant_title(notification: Dict[str, Any]) -> Tuple[str, str]:
    """Return a title prefix and default title text extracted from the payload."""
    assistant_message = (
        notification.get("last-assistant-message")
        or notification.get("final-assistant-message")
        or notification.get("assistant_message")
    )

    if assistant_message:
        return "Codex", str(assistant_message)

    run_label = notification.get("run-label") or notification.get("id")
    if run_label:
        return "Codex", f"Run {run_label} complete"

    return "Codex", "Run Complete"


def gather_run_summary(notification: Dict[str, Any]) -> str:
    """Compose a concise summary for the agent run."""
    input_messages = notification.get("input-messages") or notification.get("input_messages")
    if isinstance(input_messages, list):
        parts = [str(item) for item in input_messages if item]
        if parts:
            return " ".join(parts)
    elif isinstance(input_messages, str):
        return input_messages

    summary = notification.get("summary") or notification.get("run-summary")
    if summary:
        return str(summary)

    return "Awaiting the next request."


def parse_notification(raw: str) -> Optional[Tuple[str, str]]:
    """Return (title, message) if the notification should be sent."""
    try:
        notification: Dict[str, Any] = json.loads(raw)
    except json.JSONDecodeError:
        return None

    if notification.get("type") != "agent-run-complete":
        return None

    app_name, detail = extract_assistant_title(notification)
    message = gather_run_summary(notification)

    title = f"{app_name}: {detail}" if detail else f"{app_name}: Run Complete"
    return title, message


def main() -> int:
    if len(sys.argv) != 2:
        print("Usage: notify.py <NOTIFICATION_JSON>", file=sys.stderr)
        return 1

    parsed = parse_notification(sys.argv[1])
    if parsed is None:
        # Either the notification could not be parsed or should be ignored.
        return 0

    title, message = parsed
    command = [
        "dunstify",
        "--appname",
        "Codex",
        "--urgency",
        "normal",
        title,
        message,
    ]

    try:
        subprocess.run(command, check=True)
    except FileNotFoundError:
        print("dunstify not found in PATH", file=sys.stderr)
        return 1
    except subprocess.CalledProcessError as exc:
        print(f"dunstify exited with status {exc.returncode}", file=sys.stderr)
        return exc.returncode or 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
