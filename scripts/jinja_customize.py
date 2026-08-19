"""jinjanate --customize hook: remap delimiters off {{ }}, since lazygit's own
Go-template syntax and {{{ }}} vim foldmarkers already own that shape.
Resolves palette.json role names to hex, injects OS from the env, and exposes
glob_sorted() so a template can include a numbered directory in order."""

import glob
import os
import re

HEX_RE = re.compile(r"^#[0-9a-fA-F]{6}$")


def glob_sorted(pattern):
    return sorted(glob.glob(pattern))


def j2_environment_params():
    return {
        "variable_start_string": "<<",
        "variable_end_string": ">>",
        "block_start_string": "<%",
        "block_end_string": "%>",
        "comment_start_string": "<#",
        "comment_end_string": "#>",
    }


def alter_context(context):
    os_name = os.environ.get("OS")
    if not os_name:
        raise SystemExit("OS env var missing (set by generate_configs.sh)")
    context["OS"] = os_name

    palette = context.get("palette")
    if not isinstance(palette, dict) or not palette:
        raise SystemExit("palette.json: missing top-level 'palette'")
    for name, value in palette.items():
        if not isinstance(value, str) or not HEX_RE.match(value):
            raise SystemExit(f"palette.json: bad hex for {name}: {value!r}")

    for group, mapping in list(context.items()):
        if group in ("palette", "OS"):
            continue
        if not isinstance(mapping, dict) or not mapping:
            raise SystemExit(f"palette.json: {group} must be a non-empty object")
        resolved = {}
        for key, ref in mapping.items():
            if not isinstance(ref, str) or ref.startswith("#"):
                raise SystemExit(
                    f"palette.json: {group}.{key} must be a palette name, got {ref!r}"
                )
            if ref not in palette:
                raise SystemExit(f"palette.json: {group}.{key} -> unknown {ref!r}")
            resolved[key] = palette[ref]
        context[group] = resolved
    context["glob_sorted"] = glob_sorted
    return context
