#!/usr/bin/env python3
"""Checks every skill before it ships.

- frontmatter on line 1, with name, description, license, metadata.version and metadata.verified
- name: lowercase letters, digits and hyphens, at most 64 characters, equal to the folder name
- description: at most 1024 characters (claude.ai limit), no angle brackets
- SKILL.md under 500 lines
- every relative link inside a skill points to a file that exists
- every skill named in backticks with the pt- prefix exists
- plugin.json and marketplace.json agree on name and version

Usage: python3 scripts/validate-skills.py   (exits 1 on any error)
"""
import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
SKILLS = ROOT / "skills"
errors = []


def err(msg):
    errors.append(msg)


def frontmatter(text):
    if not text.startswith("---\n"):
        return None
    end = text.find("\n---", 4)
    if end < 0:
        return None
    fm = {}
    current = None
    for line in text[4:end].splitlines():
        if line.startswith("  ") and current:
            k, _, v = line.strip().partition(":")
            fm[f"{current}.{k.strip()}"] = v.strip().strip('"')
        elif ":" in line:
            k, _, v = line.partition(":")
            current = k.strip()
            fm[current] = v.strip()
    return fm


names = {p.name for p in SKILLS.iterdir() if p.is_dir()}
for d in sorted(SKILLS.iterdir()):
    if not d.is_dir():
        continue
    f = d / "SKILL.md"
    if not f.exists():
        err(f"{d.name}: missing SKILL.md")
        continue
    text = f.read_text(encoding="utf-8")
    fm = frontmatter(text)
    if fm is None:
        err(f"{d.name}: frontmatter must start on line 1")
        continue
    name = fm.get("name", "")
    if name != d.name:
        err(f"{d.name}: name '{name}' differs from folder")
    if not re.fullmatch(r"[a-z0-9-]{1,64}", name):
        err(f"{d.name}: invalid name '{name}'")
    desc = fm.get("description", "")
    if not desc or len(desc) > 1024:
        err(f"{d.name}: description length {len(desc)} (1-1024)")
    if "<" in desc or ">" in desc:
        err(f"{d.name}: description has angle brackets")
    for key in ("license", "metadata.version", "metadata.verified"):
        if not fm.get(key):
            err(f"{d.name}: missing {key}")
    lines = text.count("\n")
    if lines > 500:
        err(f"{d.name}: {lines} lines (max 500)")
    for md in d.rglob("*.md"):
        body = md.read_text(encoding="utf-8")
        for link in re.findall(r"\]\(([^)#\s]+)\)", body):
            if re.match(r"[a-z]+:", link):
                continue
            if not (md.parent / link).resolve().exists():
                err(f"{md.relative_to(ROOT)}: broken link {link}")
        for ref in set(re.findall(r"`(pt-[a-z-]+|portugal-open-data)`", body)):
            if ref not in names:
                err(f"{md.relative_to(ROOT)}: refers to unknown skill {ref}")
    print(f"ok  {name:24s} {len(desc):4d} chars description, {lines:3d} lines")

plugin = json.loads((ROOT / ".claude-plugin/plugin.json").read_text())
market = json.loads((ROOT / ".claude-plugin/marketplace.json").read_text())
entry = next((p for p in market["plugins"] if p["name"] == plugin["name"]), None)
if not entry:
    err("marketplace.json has no entry with the plugin name")
elif entry.get("version") != plugin.get("version"):
    err("plugin.json and marketplace.json versions differ")

for e in errors:
    print("ERROR", e)
sys.exit(1 if errors else 0)
