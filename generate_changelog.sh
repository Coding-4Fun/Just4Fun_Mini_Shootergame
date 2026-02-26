#!/bin/bash
# Generiert ein Markdown-Changelog analog zu generate_changelog.ps1.
# Usage: ./generate_changelog.sh [Pfad/zur/Datei] [Ziel/CHANGELOG.md]

FILE=${1:-Copy_Notfalldoku.ps1}
OUTPUT=${2:-../docs/CHANGELOG_$(basename "${FILE%.*}").md}
REMOTE=$(git config --get remote.origin.url 2>/dev/null || true)

python3 - "$FILE" "$OUTPUT" "$REMOTE" <<'PYTHON'
import sys, subprocess, os, re
file = sys.argv[1]
output = sys.argv[2]
remote = sys.argv[3]

proc = subprocess.run(['git','log','--pretty=format:%ad|%h|%s','--date=short','--',file],
                      capture_output=True, text=True)
if proc.returncode != 0 or not proc.stdout.strip():
    print(f"Keine Git-Einträge für '{file}' gefunden.")
    sys.exit(0)

entries = []
for line in proc.stdout.splitlines():
    parts = line.split('|',2)
    if len(parts) < 3: continue
    entries.append({'date':parts[0],'hash':parts[1],'msg':parts[2]})

# group by date preserving order
from collections import OrderedDict
groups = OrderedDict()
for e in entries:
    groups.setdefault(e['date'], []).append(e)

prefix_order = ['Add','Upd','Chg','Fix']

lines = []
lines.append(f"# Changelog für {file}\n")
lines.append("Die folgenden Einträge wurden automatisch aus der Git-Historie generiert. Die Reihenfolge der Typen ist Add → Upd → Chg → Fix → sonstige.\n")
for date, ents in groups.items():
    lines.append(f"## {date}\n")
    for pref in prefix_order:
        for e in ents:
            if e['msg'].startswith(pref):
                msg = e['msg'].replace('===', '\n  - ===')
                link = f" [{e['hash']}]({remote}/commit/{e['hash']})" if remote else f" {e['hash']}"
                lines.append(f"- {msg}{link}\n")
    for e in ents:
        if not re.match('^(Add|Upd|Chg|Fix)', e['msg']):
            msg = e['msg'].replace('===', '\n  - ===')
            link = f" [{e['hash']}]({remote}/commit/{e['hash']})" if remote else f" {e['hash']}"
            lines.append(f"- {msg}{link}\n")
    lines.append("\n")

os.makedirs(os.path.dirname(output), exist_ok=True)
with open(output, 'w', encoding='utf-8') as f:
    f.writelines(lines)
print(f"Changelog generiert: {output}")
PYTHON

chmod +x "$OUTPUT" 2>/dev/null || true
exit 0
