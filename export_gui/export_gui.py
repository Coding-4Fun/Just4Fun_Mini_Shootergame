#!/usr/bin/env python3
"""Ein kleines PySimpleGUI‑Tool zum Exportieren von Godot‑Projekten.

Funktionen:
- Pfad zur Godot Engine setzen
- Projektordner wählen
- Export Profil/Type wählen
- Save/Load per‑project config (.export_config.json)
- Import und Export ausführen und Logdatei schreiben

Nur ein einfaches Scaffold; erweiterbar.
"""
import json
import os
import shutil
import subprocess
import sys
import glob
from pathlib import Path

try:
    import PySimpleGUI as sg
except Exception:
    print("PySimpleGUI ist nicht installiert. Bitte: pip install -r requirements.txt")
    raise


DEFAULT_CONFIG_NAME = ".export_config.json"
USER_CONFIG_DIR = Path.home() / ".config" / "godot_export_gui"
ENGINES_FILE = USER_CONFIG_DIR / "engines.json"


def save_config(project_path: Path, cfg: dict):
    path = project_path / DEFAULT_CONFIG_NAME
    with open(path, "w", encoding="utf-8") as f:
        json.dump(cfg, f, indent=2, ensure_ascii=False)
    return path


def load_config(project_path: Path):
    path = project_path / DEFAULT_CONFIG_NAME
    if not path.exists():
        return None
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def run_command(cmd, cwd=None, log_file=None):
    with open(log_file, "a", encoding="utf-8") as log:
        log.write(f"\n--- RUN: {' '.join(cmd)}\n")
        proc = subprocess.run(cmd, cwd=cwd, stdout=log, stderr=log)
    return proc.returncode


def ensure_dir(p: Path):
    p.mkdir(parents=True, exist_ok=True)


def is_executable_file(p: Path):
    return p.exists() and os.access(str(p), os.X_OK) and p.is_file()


def find_godot_in_path():
    """Try to find godot executables via PATH and common names."""
    results = set()
    # common names
    names = ["godot", "Godot", "godot.x86_64", "Godot_v4*", "Godot_v*"]
    for name in names:
        found = shutil.which(name)
        if found:
            results.add(str(Path(found).resolve()))

    # scan PATH directories for files with 'godot' in name
    for p in os.getenv("PATH", "").split(os.pathsep):
        try:
            for f in Path(p).glob("*godot*"):
                if is_executable_file(f):
                    results.add(str(f.resolve()))
        except Exception:
            continue

    return sorted(results)


def scan_common_locations():
    """Scan typical install locations for Godot binaries."""
    results = set(find_godot_in_path())
    locations = [
        Path.home() / ".local" / "bin",
        Path("/usr/bin"),
        Path("/usr/local/bin"),
        Path("/opt"),
        Path("/snap"),
    ]
    for loc in locations:
        try:
            for f in loc.rglob("*godot*"):
                if is_executable_file(f):
                    results.add(str(f.resolve()))
        except Exception:
            continue
    return sorted(results)


def load_saved_engines():
    try:
        USER_CONFIG_DIR.mkdir(parents=True, exist_ok=True)
        if not ENGINES_FILE.exists():
            return []
        with open(ENGINES_FILE, "r", encoding="utf-8") as fh:
            data = json.load(fh)
            return list(dict.fromkeys(data))
    except Exception:
        return []


def save_engine_list(list_of_paths):
    USER_CONFIG_DIR.mkdir(parents=True, exist_ok=True)
    with open(ENGINES_FILE, "w", encoding="utf-8") as fh:
        json.dump(list_of_paths, fh, indent=2)


def probe_engine_version(path: str, timeout: float = 3.0) -> str:
    try:
        completed = subprocess.run([path, "--version"], capture_output=True, text=True, timeout=timeout)
        out = (completed.stdout or completed.stderr or "").strip().splitlines()
        if out:
            return out[0].strip()
        return "(no output)"
    except Exception as e:
        return f"(error: {e})"


def parse_export_presets(project_path: Path, profile_name: str) -> str | None:
    cfg_file = project_path / "export_presets.cfg"
    if not cfg_file.exists():
        return None
    try:
        with open(cfg_file, "r", encoding="utf-8") as fh:
            lines = fh.readlines()
    except Exception:
        return None

    current_preset = None
    found = None
    for line in lines:
        line = line.strip()
        if line.startswith("[preset"):
            current_preset = {}
            name = None
            continue
        if line.startswith("name=") and current_preset is not None:
            # name="Windows"
            try:
                name = line.split("=", 1)[1].strip().strip('"')
            except Exception:
                name = None
            if name == profile_name:
                # mark that following lines belong to our preset
                found = True
            else:
                found = False
            continue
        if found and line.startswith("export_path="):
            # export_path="../exports/foo.exe"
            try:
                val = line.split("=", 1)[1].strip()
                val = val.strip('"')
                # resolve relative to project path
                resolved = (project_path / val).resolve()
                return str(resolved.parent)
            except Exception:
                return None
    return None


def normalize_engine_path(display_value: str) -> str:
    """If the combobox shows 'path [version]' return the actual path."""
    if not display_value:
        return ""
    if Path(display_value).exists():
        return display_value
    # split before first ' [' or ' | '
    for sep in [" [", " | ", " — ", " || "]:
        if sep in display_value:
            candidate = display_value.split(sep, 1)[0].strip()
            if Path(candidate).exists():
                return candidate
    # fallback
    return display_value


def main():
    sg.theme("SystemDefault")

    layout = [
        [sg.Text("Godot Engine:"), sg.Input(key="-GODOT-"), sg.FileBrowse(file_types=(("Exe","*"),), target="-GODOT-")],
        [sg.Text("Detected Engines:"), sg.Combo(values=load_saved_engines() + scan_common_locations(), key="-ENGINES-", size=(80,1)), sg.Button("Scan Engines"), sg.Button("Probe Versions"), sg.Button("Save Engine")],
        [sg.Text("Scan Folder:"), sg.Input(key="-SCANFOLDER-"), sg.FolderBrowse(target="-SCANFOLDER-"), sg.Button("Scan Folder")],
        [sg.Text("Project Folder:"), sg.Input(key="-PROJECT-"), sg.FolderBrowse(target="-PROJECT-")],
        [sg.Text("Build Profile:"), sg.Input(default_text="Windows", key="-PROFILE-"), sg.Text("Build Type:"), sg.Combo(["export-debug","export-release","export-pack"], default_value="export-debug", key="-TYPE-")],
        [sg.Text("Project Name:"), sg.Input(default_text="MiniShooterGame", key="-PROJNAME-"), sg.Text("Version Suffix:"), sg.Input(default_text="_alpha9", key="-VERS-")],
        [sg.Text("Export Root Folder:"), sg.Input(key="-EXPORTROOT-"), sg.FolderBrowse(target="-EXPORTROOT-"), sg.Button("Auto Set Export Folder")],
        [sg.Checkbox("Overwrite export folder from config", default=True, key="-USECFGFOLDER-")],
        [sg.Multiline(size=(80,10), key="-LOG-", disabled=True)],
        [sg.Button("Load Config"), sg.Button("Save Config"), sg.Button("Import"), sg.Button("Export"), sg.Button("Open Log"), sg.Button("Quit")]
    ]

    window = sg.Window("Godot Export GUI", layout, finalize=True)

    while True:
        event, values = window.read()
        if event in (sg.WIN_CLOSED, "Quit"):
            break

        project = Path(values.get("-PROJECT-") or "").expanduser()
        godot = values.get("-GODOT-") or shutil.which("godot") or shutil.which("Godot")

        if event == "Load Config":
            if not project or not project.exists():
                sg.popup_error("Bitte ein gültiges Projektverzeichnis wählen.")
                continue
            cfg = load_config(project)
            if not cfg:
                sg.popup("Keine .export_config.json im Projekt gefunden. Sie können eine neue speichern.")
                continue
            # populate UI
            window["-GODOT-"].update(cfg.get("godot_path", ""))
            window["-PROFILE-"].update(cfg.get("build_profile", "Windows"))
            window["-TYPE-"].update(cfg.get("build_type", "export-debug"))
            window["-PROJNAME-"].update(cfg.get("build_project_name", project.name))
            window["-VERS-"].update(cfg.get("build_version", "_alpha"))
            window["-EXPORTROOT-"].update(cfg.get("build_path", ""))
            sg.popup("Config geladen.")

        if event == "Scan Engines":
            found = scan_common_locations()
            saved = load_saved_engines()
            combined = saved + [p for p in found if p not in saved]
            window["-ENGINES-"].update(values=combined)
            sg.popup(f"{len(found)} Engines gefunden (Liste aktualisiert).")

        if event == "Probe Versions":
            # probe versions for listed engines
            engines = list(dict.fromkeys(load_saved_engines() + scan_common_locations()))
            results = []
            for e in engines:
                ver = probe_engine_version(e)
                results.append(f"{e} [{ver}]")
            window["-ENGINES-"].update(values=results)
            sg.popup(f"Version probe abgeschlossen ({len(results)}).")

        if event == "Save Engine":
            chosen = values.get("-ENGINES-")
            if not chosen:
                sg.popup_error("Wähle zuerst eine Engine aus der Liste.")
                continue
            chosen_path = normalize_engine_path(chosen)
            saved = load_saved_engines()
            if chosen_path not in saved:
                saved.insert(0, chosen_path)
                save_engine_list(saved)
            sg.popup(f"Engine gespeichert: {chosen_path}")

        # when selecting an engine from the combobox, update the input field
        if event == "-ENGINES-":
            sel = values.get("-ENGINES-")
            if sel:
                window["-GODOT-"].update(normalize_engine_path(sel))

        if event == "Scan Folder":
            scan_folder = values.get("-SCANFOLDER-")
            if not scan_folder or not Path(scan_folder).exists():
                sg.popup_error("Wähle zuerst einen gültigen Ordner zum Scannen.")
                continue
            found = []
            for p in Path(scan_folder).rglob("*"):
                try:
                    if "godot" in p.name.lower() and is_executable_file(p):
                        found.append(str(p.resolve()))
                except Exception:
                    continue
            if not found:
                sg.popup("Keine Godot Binaries im Ordner gefunden.")
            else:
                saved = load_saved_engines()
                combined = list(dict.fromkeys(saved + found))
                window["-ENGINES-"].update(values=combined)
                sg.popup(f"{len(found)} Binaries gefunden und zur Liste hinzugefügt.")

        if event == "Auto Set Export Folder":
            if not project or not project.exists():
                sg.popup_error("Bitte ein gültiges Projektverzeichnis wählen.")
                continue
            profile = values.get("-PROFILE-")
            detected = parse_export_presets(project, profile)
            if detected:
                window["-EXPORTROOT-"].update(detected)
                sg.popup(f"Export-Ordner gesetzt: {detected}")
            else:
                sg.popup("Keine passende Export-Preset-Einstellung gefunden.")

        if event == "Save Config":
            if not project or not project.exists():
                sg.popup_error("Bitte ein gültiges Projektverzeichnis wählen.")
                continue
            cfg = {
                "godot_path": values.get("-GODOT-"),
                "build_profile": values.get("-PROFILE-"),
                "build_type": values.get("-TYPE-"),
                "build_project_name": values.get("-PROJNAME-"),
                "build_version": values.get("-VERS-"),
                "build_path": values.get("-EXPORTROOT-"),
            }
            path = save_config(project, cfg)
            sg.popup(f"Config gespeichert: {path}")

        if event in ("Import", "Export"):
            if not project or not project.exists():
                sg.popup_error("Bitte ein gültiges Projektverzeichnis wählen.")
                continue
            if not godot:
                sg.popup_error("Godot Engine nicht gefunden. Bitte Pfad angeben.")
                continue

            build_profile = values.get("-PROFILE-")
            build_type = values.get("-TYPE-")
            build_project_name = values.get("-PROJNAME-")
            build_version = values.get("-VERS-")
            export_root = values.get("-EXPORTROOT-") or os.path.join(str(project), "export")

            # determine build_gdversion by basename of godot
            build_gdversion = Path(godot).name
            build_path = Path(export_root)
            build_folder = build_path / build_profile
            ensure_dir(build_folder)

            build_bin = f"{build_project_name}{build_version}_{build_gdversion}.exe"
            build_project = build_folder / build_bin
            log_file = build_folder / f"{build_project_name}_export.log.txt"

            # Import step
            if event == "Import":
                sg.popup_no_wait("Import gestartet. Siehe Log.")
                # run import
                cmd = [str(godot), "--verbose", "--import", "--headless"]
                rc = run_command(cmd, cwd=str(project), log_file=str(log_file))
                sg.popup(f"Import beendet (rc={rc}). Log: {log_file}")

            if event == "Export":
                sg.popup_no_wait("Export gestartet. Siehe Log.")
                cmd = [str(godot), "--verbose", "--headless", f"--{build_type}", build_profile, "--path", str(project), str(build_project)]
                rc = run_command(cmd, cwd=str(project), log_file=str(log_file))
                if rc == 0 and build_project.exists():
                    sg.popup(f"Export erfolgreich: {build_project}")
                else:
                    sg.popup_error(f"Export fehlgeschlagen (rc={rc}). Log: {log_file}")

        if event == "Open Log":
            project = Path(values.get("-PROJECT-") or "")
            if not project.exists():
                sg.popup_error("Bitte ein gültiges Projektverzeichnis wählen.")
                continue
            export_root = values.get("-EXPORTROOT-") or os.path.join(str(project), "export")
            build_profile = values.get("-PROFILE-")
            log_file = Path(export_root) / build_profile / f"{values.get('-PROJNAME-')}_export.log.txt"
            if not log_file.exists():
                sg.popup("Keine Logdatei gefunden.")
                continue
            # show tail of log
            with open(log_file, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()[-10000:]
            window["-LOG-"].update(content)

    window.close()


if __name__ == "__main__":
    main()
