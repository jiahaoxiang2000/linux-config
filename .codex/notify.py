#!/usr/bin/env python3
"""Send Codex notifications through dunstify."""

import json
import re
import subprocess
import sys
from collections.abc import Mapping, Sequence
from typing import Any, Dict, Optional, Tuple


def parse_notification(raw: str) -> Optional[Tuple[str, str]]:
    """Return (title, message) if the notification should be sent."""
    try:
        notification: Dict[str, Any] = json.loads(raw)
    except json.JSONDecodeError:
        return None

    notification_type = notification.get("type")
    if notification_type == "agent-turn-complete":
        assistant_message = notification.get("last-assistant-message")
        if assistant_message:
            title = f"Codex: {assistant_message}"
        else:
            title = "Codex: Turn Complete"

        input_messages = notification.get("input-messages") or notification.get("input_messages")
        if isinstance(input_messages, list):
            message = " ".join(str(item) for item in input_messages if item)
        elif isinstance(input_messages, str):
            message = input_messages
        else:
            message = ""

        if not message:
            message = "Awaiting the next request."

        return title, message

    return None


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
