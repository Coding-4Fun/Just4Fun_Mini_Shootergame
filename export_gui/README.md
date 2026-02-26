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

Engine‑Management:
- Mit `Scan Engines` sucht das Tool nach installierten Godot‑Binaries (PATH und üblichen Orte).
- Gefundene Engines werden in der Combobox angezeigt; per `Save Engine` lassen sie sich persistent speichern unter `~/.config/godot_export_gui/engines.json`.

Neue Optionen:
- `Probe Versions`: Läuft `--version` für gefundene Binaries und zeigt Versionen in der Liste an.
- `Scan Folder`: Ermöglicht manuelles Durchsuchen eines angegebenen Ordners nach Godot‑Binaries.
- `Auto Set Export Folder`: Liest `export_presets.cfg` im Projekt und setzt den Export‑Ordner basierend auf dem gewählten Profil.

Konfiguration:
- Per‑Project Konfiguration wird in `.export_config.json` im Projektordner gespeichert.
- Globale Engine‑Liste wird unter `~/.config/godot_export_gui/engines.json` verwaltet.

Schnellstart:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r export_gui/requirements.txt
python export_gui/export_gui.py
```
