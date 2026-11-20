#!/usr/bin/env bash
# Memvalidasi setiap SKILL.md dengan validator milik Hermes sendiri
# (nama, frontmatter, ukuran, platform). Baca-saja: memakai HERMES_HOME sementara.
# Pakai: alat/cek-hermes.sh [path-instalasi-hermes]   (default /usr/local/lib/hermes-agent)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HA="${1:-/usr/local/lib/hermes-agent}"
PY="$HA/venv/bin/python"; [ -x "$PY" ] || PY="$HA/.venv/bin/python"
TMPH="$(mktemp -d)"; trap 'rm -rf "$TMPH"' EXIT
cd "$HA"
HERMES_HOME="$TMPH" "$PY" - "$ROOT/skills" <<'PY'
import sys, pathlib
from agent.skill_utils import parse_frontmatter, skill_matches_platform
from tools.skill_manager_tool import _validate_name, _validate_frontmatter, _validate_content_size
gagal = 0
for md in sorted(pathlib.Path(sys.argv[1]).glob("*/SKILL.md")):
    teks = md.read_text()
    fm, badan = parse_frontmatter(teks)
    err = [e for e in (_validate_name(fm.get("name", "")), _validate_frontmatter(teks), _validate_content_size(teks)) if e]
    if fm.get("name") != md.parent.name: err.append(f"name '{fm.get('name')}' != folder '{md.parent.name}'")
    if not skill_matches_platform(fm): err.append("tidak cocok platform ini")
    print(("GAGAL " if err else "ok    ") + md.parent.name + ("" if not err else ": " + "; ".join(err)))
    gagal += bool(err)
sys.exit(1 if gagal else 0)
PY
