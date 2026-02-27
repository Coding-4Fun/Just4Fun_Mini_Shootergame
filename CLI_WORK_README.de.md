# Godot Projekt Build & Export Script - Vollständige Dokumentation

Ein leistungsstarkes Bash-Script, das die Godot-Projektentwicklung und das Exportieren mit Multi-Profile-Unterstützung, benutzerdefinierten Dateinamen und intelligenten Standardwerten automatisiert.

## Inhaltsverzeichnis

1. [Übersicht](#übersicht)
2. [Schnelleinstieg](#schnelleinstieg)
3. [Installation](#installation)
4. [Verwendung](#verwendung)
5. [Konfiguration](#konfiguration)
6. [JSON-Parameter](#json-parameter)
7. [Dateiname-Platzhalter](#dateiname-platzhalter)
8. [Multi-Profile-Exporte](#multi-profile-exporte)
9. [Profil-Overrides](#profil-overrides)
10. [CLI-Parameter](#cli-parameter)
11. [Fehlerbehandlung](#fehlerbehandlung)
12. [Beispiele](#beispiele)
13. [Häufig gestellte Fragen](#häufig-gestellte-fragen)
14. [Fehlerbehebung](#fehlerbehebung)

---

## Übersicht

Das `cli_work.sh` Script bietet eine vollständige Automatisierungslösung für Godot-Projekt-Exporte. Es ist die Bash-Entsprechung der Windows Batch-Datei `cli_work_44b4.bat` mit vielen Verbesserungen:

**Hauptmerkmale**
- ✅ **Auto-Erkennung**: Findet automatisch Projektverzeichnis und Godot-Executable
- ✅ **Multi-Profile-Exporte**: Konfigurieren Sie mehrere Build-Ziele in einer Datei
- ✅ **Benutzerdefinierte Dateinamen**: Template-basierte Ausgabename mit Datum, Version und mehr
- ✅ **Intelligente Defaults**: `--init` generiert Konfiguration basierend auf Ihrem Betriebssystem und Projekt
- ✅ **Projekt-relative Pfade**: Von überall ausführbar, Exporte relativ zum Projektverzeichnis
- ✅ **JSON-Konfiguration**: Alle Einstellungen in einer strukturierten Konfigurationsdatei
- ✅ **Versionsüberprüfung**: Validiert die Godot-Version vor dem Build
- ✅ **Farbige Ausgabe**: Klare, lesbare Konsolenausgabe
- ✅ **Detailliertes Logging**: Export-Logs für Debugging gespeichert
- ✅ **Plattformspezifisch**: Verwaltet Windows (.exe), Linux (.x86_64) und Web-Exporte

---

## Schnelleinstieg

### 1. Standard-Konfiguration generieren

```bash
./cli_work.sh --init
```

Dies erstellt `build_config.json` mit:
- Automatisch erkanntem Godot-Executable-Pfad
- Automatisch erkannter Godot-Version
- Projektname aus dem Verzeichnisnamen
- Aktuelles Betriebssystem als Standard-Export-Profil

### 2. Konfiguration anpassen (Optional)

Bearbeiten Sie `build_config.json`, um Export-Einstellungen anzupassen, mehrere Profile hinzuzufügen, Dateinamen anzupassen usw.

### 3. Build-Prozess starten

```bash
./cli_work.sh
```

Das Script führt folgende Schritte aus:
1. Validiert die Konfiguration
2. Überprüft die Godot-Version
3. Importiert Projektressourcen
4. Exportiert alle konfigurierten Profile
5. Fragt, ob die Binary gestartet werden soll (nur bei einzelnem Profil)

---

## Installation

### Anforderungen

- **Bash** 4.0 oder später
- **jq** JSON-Parser
- **Godot** 4.x Game Engine

### Schritt 1: jq installieren

**Debian/Ubuntu:**
```bash
sudo apt install jq
```

**macOS:**
```bash
brew install jq
```

### Schritt 2: Script ausführbar machen

```bash
chmod +x cli_work.sh
```

### Schritt 3: Konfiguration generieren

```bash
./cli_work.sh --init
```

Fertig! Sie können jetzt exportieren.

---

## Verwendung

### Grundbefehle

```bash
# Hilfe anzeigen
./cli_work.sh --help

# Standard-Konfiguration generieren
./cli_work.sh --init

# Build ausführen (nutzt build_config.json)
./cli_work.sh

# Script-Version anzeigen
./cli_work.sh --version
```

### Script aus verschiedenen Verzeichnissen ausführen

Das Script findet Ihr Projekt automatisch durch die Suche nach `project.godot`:

```bash
# Ausführung vom Projekt-Root
cd /pfad/zum/MeinProjekt
/pfad/zum/cli_work.sh

# Ausführung vom Unterverzeichnis
cd /pfad/zum/MeinProjekt/scripts
../../cli_work.sh

# Ausführung vom übergeordneten Verzeichnis
cd /pfad/zum
MeinProjekt/cli_work.sh
```

---

## Konfiguration

### Dateispeicherort

```
project_root/
├── project.godot
├── build_config.json          ← Ihre Konfiguration
├── cli_work.sh                ← Dieses Script
└── .exports/                  ← Standard-Export-Speicherort (versteckt)
    ├── Windows/
    ├── Linux/
    └── Web/
```

### Manuelles Erstellen einer Konfiguration

Falls Sie `build_config.json` manuell erstellen möchten:

```bash
cat > build_config.json << 'EOF'
{
  "godot": {
    "path": "/pfad/zum/godot",
    "version": "4.6"
  },
  "build": {
    "project_name": "MeinProjekt",
    "version_suffix": "dev",
    "export_root": ".exports",
    "output_filename": "{project}_{date}_{os}_{type}",
    "use_separators": true
  },
  "profiles": [
    {
      "name": "Windows",
      "type": "export-debug",
      "platform": "x86_64"
    }
  ]
}
EOF
```

---

## JSON-Parameter

### `godot` Sektion (Global)

Definiert Godot-Engine-Einstellungen.

#### `godot.path` (String, optional)

Pfad zur Godot-Executable.

- **Typ**: String (absoluter oder relativer Pfad)
- **Standard**: Automatische Erkennung aus PATH
- **Beispiele**:
  - `/home/benutzer/bin/godot`
  - `/Applications/Godot.app/Contents/MacOS/Godot`
  - `C:\Proggen\Godot\godot.exe` (mit WSL)

```json
{
  "godot": {
    "path": "/home/benutzer/bin/godot"
  }
}
```

#### `godot.version` (String, optional)

Erwartete Godot-Version (Major.Minor).

- **Typ**: String im Format "X.Y"
- **Standard**: Versionsprüfung wird übersprungen, falls nicht angegeben
- **Validierung**: `godot --version` muss diesem Wert entsprechen
- **Beispiele**: `"4.6"`, `"4.5"`, `"4.0"`
- **Bei Nichtübereinstimmung**: Script beendet sich mit Fehler

```json
{
  "godot": {
    "path": "/home/benutzer/bin/godot",
    "version": "4.6"
  }
}
```

---

### `build` Sektion (Global)

Globale Build-Einstellungen, die auf alle Profile angewendet werden (sofern nicht pro Profil überschrieben).

#### `build.project_name` (String)

Name des Projekts, verwendet in Dateinamen und Konfiguration.

- **Typ**: String
- **Standard**: `"DefaultProject"`
- **Verwendet in**: Ausgabedateinamen
- **Gesetzt von --init**: Verzeichnisname des Projekts

```json
{
  "build": {
    "project_name": "MiniShooterGame"
  }
}
```

#### `build.version_suffix` (String)

Suffix, das an alle exportierten Binaries angehängt wird.

- **Typ**: String
- **Standard**: `"dev"`
- **Beispiele**: `"_alpha9"`, `"_beta"`, `"_release"`, `"_1.0"`
- **Angewendet**: Vor der Dateierweiterung (`.exe`, `.x86_64`, usw.)

```json
{
  "build": {
    "version_suffix": "_alpha10"
  }
}
```

Ergebnis: `MiniShooterGame_alpha10.exe` (Windows), `MiniShooterGame_alpha10.x86_64` (Linux)

#### `build.export_root` (String)

Stammverzeichnis für Exporte (relativ zum Projektverzeichnis).

- **Typ**: String (relativer Pfad)
- **Standard**: `".exports"` (verstecktes Verzeichnis, ignoriert vom Godot-Editor)
- **Aufgelöst**: Relativ zum Projektverzeichnis (wo sich `project.godot` befindet)
- **Hinweis**: Verzeichnisse, die mit einem Punkt beginnen (`.`), werden automatisch von der Godot-Engine ignoriert
- **Beispiele**: `".exports"`, `"exports"`, `"../builds"`, `"build/output"`

```json
{
  "build": {
    "export_root": ".exports"
  }
}
```

Exporte werden gespeichert unter: `{project_dir}/{export_root}/{profile_name}/`

#### `build.export_path` (String, optional)

Überschreibt den Export-Speicherort (hat Vorrang vor `export_root`).

- **Typ**: String (absoluter oder relativer Pfad)
- **Standard**: Nicht festgelegt (nutzt `export_root`)
- **Aufgelöst**: Relativ zum Projektverzeichnis, falls nicht absolut
- **Beispiele**: `"../builds"`, `"/tmp/godot_exports"`, `"./custom_exports"`

```json
{
  "build": {
    "export_root": ".exports",
    "export_path": "../builds"
  }
}
```

#### `build.output_filename` (String)

Template für Ausgabedateiname (ohne Erweiterung).

- **Typ**: String mit Platzhaltern
- **Standard**: `"{project}_{date}_{os}_{type}"`
- **Platzhalter**: Siehe [Dateiname-Platzhalter](#dateiname-platzhalter) Sektion
- **Pro-Profil-Überschreibung**: Siehe [Profil-Overrides](#profil-overrides)

```json
{
  "build": {
    "output_filename": "{project}_{godot_version}_{date}_{os}_{type}"
  }
}
```

#### `build.use_separators` (Boolean)

Ob Unterstriche (`_`) zwischen Dateinamenkomponenten verwendet werden sollen.

- **Typ**: Boolean (`true` oder `false`)
- **Standard**: `true`
- **Bei `true`**: Behält Unterstriche im Dateinamen
- **Bei `false`**: Entfernt alle Unterstriche

```json
{
  "build": {
    "output_filename": "{project}_{date}_{type}",
    "use_separators": true
  }
}
```

Ergebnisse:
- Mit `true`: `MiniShooterGame_20260227_debug`
- Mit `false`: `MiniShooterGamedebug` (zusammenhängend)

---

### `profiles` Sektion (Array)

Array von Build-Profilen. Jedes Profil stellt eine Zielplattform/Konfiguration dar.

#### Grundstruktur eines Profils

```json
{
  "profiles": [
    {
      "name": "Windows",
      "type": "export-debug",
      "platform": "x86_64"
    }
  ]
}
```

#### Profil-Parameter

##### `profiles[].name` (String, erforderlich)

Export-Profilname aus `export_presets.cfg`.

- **Typ**: String
- **Erforderlich**: Ja
- **Muss entsprechen**: Profilname in Godots `export_presets.cfg`
- **Häufige Werte**: `"Windows"`, `"Linux"`, `"Web"`, `"Mac"`, `"iOS"`, `"Android"`

```json
{
  "profiles": [
    { "name": "Windows" },
    { "name": "Linux" }
  ]
}
```

##### `profiles[].type` (String)

Export-Typ (Debug oder Release).

- **Typ**: String
- **Optionen**: `"export-debug"` oder `"export-release"`
- **Standard**: Nutzt globales `build.type`, falls nicht angegeben (aktuell Standard `"export-debug"`)
- **Auswirkungen**: Dateiname (gekürzt zu `debug` oder `release` im `{type}` Platzhalter)

```json
{
  "profiles": [
    {
      "name": "Windows",
      "type": "export-debug"
    },
    {
      "name": "Windows",
      "type": "export-release"
    }
  ]
}
```

##### `profiles[].platform` (String)

Zielplattform/Architektur.

- **Typ**: String
- **Werte**: `"x86_64"`, `"x86_32"`, `"arm64"`, `"arm"`, `"web"`, `"mobile"`, usw.
- **Nicht validiert**: Kann jeden String enthalten, wird in Dateiname-Platzhaltern verwendet
- **Verwendet in**: `{platform}` Platzhalter

```json
{
  "profiles": [
    { "name": "Windows", "platform": "x86_64" },
    { "name": "Linux", "platform": "arm64" }
  ]
}
```

##### `profiles[].output_filename` (String, optional)

Überschreibt globales `build.output_filename` für dieses Profil.

- **Typ**: String mit Platzhaltern
- **Standard**: Nutzt globales `build.output_filename`
- **Vorrang**: Profilwert überschreibt globalen Wert
- **Platzhalter**: Gleich wie global (siehe [Dateiname-Platzhalter](#dateiname-platzhalter))

```json
{
  "build": {
    "output_filename": "{project}_{date}_{os}_{type}"
  },
  "profiles": [
    {
      "name": "Windows",
      "output_filename": "spiel_windows_{version}"
    }
  ]
}
```

##### `profiles[].export_path` (String, optional)

Überschreibt Export-Pfad für dieses Profil.

- **Typ**: String (absoluter oder relativer Pfad)
- **Standard**: Nutzt globales `build.export_root`
- **Vorrang**: Profilwert überschreibt globalen Wert
- **Aufgelöst**: Relativ zum Projektverzeichnis

```json
{
  "build": {
    "export_root": ".exports"
  },
  "profiles": [
    {
      "name": "Windows",
      "export_path": "./windows_builds"
    }
  ]
}
```

---

## Dateiname-Platzhalter

Das `output_filename` Template unterstützt folgende Platzhalter:

| Platzhalter | Beschreibung | Beispielwert | Hinweise |
|-------------|-------------|-----------------|---------|
| `{project}` | Projektname | `MiniShooterGame` | Aus `build.project_name` |
| `{version_suffix}` | Versionssuffix | `_alpha9` | Aus `build.version_suffix` |
| `{godot_version}` | Godot-Version | `4.6` | Aus `godot.version` oder Laufzeit |
| `{date}` | Aktuelles Datum | `20260227` | Format: YYYYMMDD |
| `{os}` | Betriebssystem (kurz) | `Win`, `Lin`, `Mac` | Erkannt vom System |
| `{type}` | Build-Typ | `debug`, `release` | Extrahiert aus `export-debug` oder `export-release` |
| `{platform}` | Zielplattform | `x86_64`, `arm64`, `web` | Aus `profiles[].platform` |

### Platzhalter-Beispiele

**Standard-Template:**
```
{project}_{date}_{os}_{type}
```
Ergebnis: `MiniShooterGame_20260227_Win_debug`

**Versionsbasiertes Template:**
```
{project}_{godot_version}_{type}
```
Ergebnis: `MiniShooterGame_4.6_debug`

**Detailliertes Template:**
```
{project}_v{godot_version}_{date}_{os}_{platform}_{type}
```
Ergebnis: `MiniShooterGame_v4.6_20260227_Win_x86_64_debug`

**Einfaches Template:**
```
{project}_{type}
```
Ergebnis: `MiniShooterGame_debug`

---

## Multi-Profile-Exporte

Exportieren Sie auf mehrere Ziele in einem einzigen Befehl.

### Beispiel: Windows + Linux + Web

```json
{
  "godot": {
    "path": "/home/benutzer/bin/godot",
    "version": "4.6"
  },
  "build": {
    "project_name": "MiniShooterGame",
    "version_suffix": "_alpha9",
    "export_root": ".exports",
    "output_filename": "{project}_{date}_{os}_{type}"
  },
  "profiles": [
    {
      "name": "Windows",
      "type": "export-release",
      "platform": "x86_64"
    },
    {
      "name": "Linux",
      "type": "export-release",
      "platform": "x86_64"
    },
    {
      "name": "Web",
      "type": "export-debug",
      "platform": "web"
    }
  ]
}
```

**Ausführung:**
```bash
./cli_work.sh
```

**Ausgabe:**
```
.exports/
├── Windows/
│   ├── MiniShooterGame_20260227_Win_release_alpha9.exe
│   └── MiniShooterGame_export.log.txt
├── Linux/
│   ├── MiniShooterGame_20260227_Lin_release_alpha9.x86_64
│   └── MiniShooterGame_export.log.txt
└── Web/
    ├── MiniShooterGame_20260227_Lin_debug_alpha9/
    │   ├── index.html
    │   └── ...
    └── MiniShooterGame_export.log.txt
```

---

## Profil-Overrides

Jedes Profil kann globale Build-Einstellungen überschreiben.

### Override-Beispiel

```json
{
  "build": {
    "project_name": "MiniShooterGame",
    "version_suffix": "dev",
    "output_filename": "{project}_{date}_{type}",
    "use_separators": true
  },
  "profiles": [
    {
      "name": "Windows",
      "type": "export-debug",
      "platform": "x86_64",
      "output_filename": "{project}_windows_{godot_version}",
      "export_path": "./windows_builds"
    },
    {
      "name": "Linux",
      "type": "export-release",
      "platform": "x86_64",
      "export_path": "./linux_builds"
    }
  ]
}
```

**Vorrangordnung:**
1. Profilspezifischer Wert (höchste Priorität)
2. Globaler Wert (Fallback)
3. Eingebauter Standard (niedrigste Priorität)

---

## CLI-Parameter

### `--help`

Befehlszeilenhilfe anzeigen.

```bash
./cli_work.sh --help
```

**Ausgabe:**
```
Godot Projekt Build & Export Script

VERWENDUNG:
    ./cli_work.sh [OPTION]

OPTIONEN:
    (keine Option)  Build mit build_config.json ausführen
    --help          Diese Hilfenachricht anzeigen
    --init          Neue build_config.json mit Defaults generieren
    --version       Script-Version anzeigen
    ...
```

### `--init`

Standard `build_config.json` mit automatisch erkannten Werten generieren.

```bash
./cli_work.sh --init
```

**Auto-Erkennung:**
- Godot-Executable-Pfad (aus PATH)
- Godot-Version (aus `godot --version`)
- Projektname (aus Verzeichnisname)
- Betriebssystem (Linux, Mac, Windows)

**Erstellt:** `build_config.json` im aktuellen Verzeichnis

**Beispielausgabe:**
```json
{
  "godot": {
    "path": "godot",
    "version": "4.6"
  },
  "build": {
    "project_name": "Just4Fun_Mini_Shootergame",
    "version_suffix": "dev",
    "export_root": ".exports",
    "output_filename": "{project}_{date}_{os}_{type}",
    "use_separators": true
  },
  "profiles": [
    {
      "name": "Linux",
      "type": "export-debug",
      "platform": "x86_64"
    }
  ]
}
```

### `--version`

Script-Version anzeigen.

```bash
./cli_work.sh --version
```

Ausgabe: `Godot Project Build Script v1.0`

---

## Fehlerbehandlung

Das Script validiert die Konfiguration vor dem Build und gibt klare Fehlermeldungen aus.

### Konfigurationsfehler (`exit 1`)

**JSON nicht gefunden:**
```
[ERROR] build_config.json nicht gefunden
[ERROR] Führen Sie './cli_work.sh --init' aus, um eine Standard-Konfiguration zu generieren
```

**Ungültiges JSON:**
```
[ERROR] build_config.json hat ungültige JSON-Syntax
```

**jq nicht installiert:**
```
[ERROR] jq wird benötigt, um build_config.json zu analysieren
[ERROR] Installieren Sie es mit: apt install jq (Debian/Ubuntu) oder brew install jq (macOS)
```

### Validierungsfehler (`exit 1`)

**Godot-Versionsnichtübereinstimmung:**
```
[ERROR] Godot-Versionsnichtübereinstimmung!
[ERROR]   Erwartet: 4.6
[ERROR]   Erhalten: 4.5
```

**Godot-Executable nicht gefunden:**
```
[ERROR] Godot-Executable nicht gefunden unter: /home/benutzer/bin/godot
```

### Laufzeitfehler (`exit 99`)

**project.godot nicht gefunden:**
```
[ERROR] project.godot konnte nicht gefunden werden
[ERROR] Führen Sie dieses Script vom Projektverzeichnis oder einem Unterverzeichnis aus
```

**Export fehlgeschlagen:**
```
[ERROR] Export mit Exit-Code 1 fehlgeschlagen
```

---

## Beispiele

### Beispiel 1: Einfacher einzelner Export

**Minimale Konfiguration für Windows-Export:**

```json
{
  "godot": {
    "path": "/home/benutzer/bin/godot",
    "version": "4.6"
  },
  "build": {
    "project_name": "MeinSpiel",
    "version_suffix": "dev"
  },
  "profiles": [
    {
      "name": "Windows",
      "type": "export-debug",
      "platform": "x86_64"
    }
  ]
}
```

Ausführung:
```bash
./cli_work.sh
```

### Beispiel 2: Multi-Plattform Release-Build

**Release-Builds für mehrere Plattformen:**

```json
{
  "godot": {
    "path": "/home/benutzer/bin/godot",
    "version": "4.6"
  },
  "build": {
    "project_name": "ShooterGame",
    "version_suffix": "_v1.0",
    "export_root": ".exports",
    "output_filename": "{project}_{godot_version}_{os}_{platform}_{type}"
  },
  "profiles": [
    {
      "name": "Windows",
      "type": "export-release",
      "platform": "x86_64"
    },
    {
      "name": "Linux",
      "type": "export-release",
      "platform": "x86_64"
    },
    {
      "name": "Web",
      "type": "export-release",
      "platform": "web"
    }
  ]
}
```

Ausgabedateien:
```
.exports/
├── Windows/ShooterGame_4.6_Win_x86_64_release_v1.0.exe
├── Linux/ShooterGame_4.6_Lin_x86_64_release_v1.0.x86_64
└── Web/ShooterGame_4.6_Lin_web_release_v1.0/
```

### Beispiel 3: Profilspezifische Overrides

**Unterschiedliche Einstellungen pro Profil:**

```json
{
  "build": {
    "project_name": "Spiel",
    "version_suffix": "dev",
    "output_filename": "{project}_{date}_{type}"
  },
  "profiles": [
    {
      "name": "Windows",
      "type": "export-debug",
      "platform": "x86_64",
      "export_path": "./windows_debug"
    },
    {
      "name": "Windows",
      "type": "export-release",
      "platform": "x86_64",
      "version_suffix": "_release",
      "output_filename": "{project}_final",
      "export_path": "./windows_release"
    }
  ]
}
```

---

## Häufig gestellte Fragen

**F: Kann ich das Script aus einem übergeordneten Verzeichnis ausführen?**
A: Ja! Das Script sucht nach `project.godot` in der Verzeichnishierarchie. Sie können es aus jedem Unterverzeichnis oder übergeordneten Verzeichnis Ihres Projekts ausführen.

**F: Was ist, wenn ich `godot.version` nicht angebe?**
A: Die Versionsprüfung wird übersprungen, aber das Script funktioniert trotzdem. Dies ist nützlich für die Entwicklung.

**F: Wie ändere ich das Export-Verzeichnis?**
A: Verwenden Sie `build.export_root` (global) oder `profiles[].export_path` (pro Profil).

**F: Kann ich auf das gleiche Profil mit unterschiedlichen Einstellungen exportieren?**
A: Ja! Erstellen Sie mehrere Profil-Einträge mit denselben `name`, aber unterschiedlichem `type` oder `output_filename`.

**F: Welche Dateierweiterungen werden automatisch hinzugefügt?**
A: 
- Windows: `.exe`
- Linux: `.x86_64`
- Web: Keine (gibt ein Verzeichnis aus)

**F: Wie füge ich das Datum in Dateinamen ein?**
A: Verwenden Sie den `{date}` Platzhalter in `output_filename`. Format: YYYYMMDD (z.B. `20260227`)

**F: Kann ich das Datumsformat anpassen?**
A: Derzeit ist das Format fest auf YYYYMMDD. Dies kann in zukünftigen Versionen angepasst werden.

---

## Fehlerbehebung

### Problem: `jq: command not found`

**Lösung:** Installieren Sie jq
```bash
sudo apt install jq      # Debian/Ubuntu
brew install jq          # macOS
```

### Problem: `Godot-Versionsnichtübereinstimmung`

**Aktuelle Version prüfen:**
```bash
/pfad/zum/godot --version
```

**Konfiguration aktualisieren:**
Bearbeiten Sie `build_config.json` und setzen Sie `godot.version` auf den entsprechenden Wert.

### Problem: `project.godot nicht gefunden`

**Speicherort überprüfen:**
```bash
find . -name "project.godot"
```

**Lösung:** Führen Sie das Script aus dem Projektverzeichnis oder einem Unterverzeichnis aus, in dem sich `project.godot` befindet.

### Problem: Export schlägt ohne klare Fehlermeldung fehl

**Export-Log überprüfen:**
```bash
cat .exports/Windows/MiniShooterGame_export.log.txt
```

Das Log enthält detaillierte Godot-Ausgaben, die bei der Diagnose von Problemen helfen können.

### Problem: Binary ist nicht ausführbar (Linux)

**Das Script macht Linux-Binaries automatisch ausführbar**, aber falls nötig manuell:
```bash
chmod +x .exports/Linux/spiel_name.x86_64
```

---

## Unterstützung

Bei Fragen oder Funktionswünschen, siehe:
- `./cli_work.sh --help` für Verwendung
- `./cli_work.sh --init` für Standard-Konfiguration
- Godot-Dokumentation für export_presets.cfg
