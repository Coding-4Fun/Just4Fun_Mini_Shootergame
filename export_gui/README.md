# Export GUI (PySimpleGUI)

Kurzes Scaffold zum Exportieren von Godot‑Projekten mit einer kleinen GUI.

Installation:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Benutzung:
- `export_gui.py` starten
- Projektordner auswählen, Godot‑Binary angeben, Profil/Type wählen
- Auf `Save Config` drücken speichert `.export_config.json` im Projektordner
- `Import` und `Export` führen die entsprechenden Godot‑CLI Befehle aus und schreiben Logs in den Export‑Ordner
