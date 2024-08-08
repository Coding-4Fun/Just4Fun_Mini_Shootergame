@echo off
chcp 65001

cls

REM Full Project Path
set "project=%~dp0"
REM Path to Godot Executable
set "gdpath=C:\Proggen\Godot\Godot_v4.3-rc"
set "godotexe=Godot_v4.3-rc2_win64.exe"
REM Full Engine Path
set "build_godot=%gdpath%\%godotexe%"

REM Profilename in export_presets.cfg
REM set "build_profile=Windows Desktop"
set "build_profile=Windows_Pack_UI"
REM export Type export-debug or export-release or export-pack (musst be .pck or .zip)
REM set "build_type=export-debug"
REM set "build_type=export-release"
set "build_type=export-pack"


REM Path to Export root folder
set "build_path=C:\Proggen\Godot\Projekte\Just4Fun_Mini_Shootergame\4.1.x-Dev\export\"
REM Subfolder for Export Profile, overwrites preset
set "build_folder=%build_path%%build_profile%"

REM Output binary name
set "build_bin=MiniShooterGame.pck"
REM Full Build Path+Name
set "build_project=%build_folder%/%build_bin%"
REM Full Build Log output
set "build_log=%build_folder%\export.log.txt"

echo %project%
echo .

REM Execute Build Process from export_presets.cfg
"%build_godot%" --import --verbose --headless  --log-file "%build_log%"
"%build_godot%" --verbose --%build_type% "%build_profile%" --headless  --log-file "%build_log%" --path %project% %build_project%

REM Execute Build Process overwrite export_presets.cfg
REM "%build_godot%" --verbose --%build_type% "%build_profile%" --headless  --log-file "%build_log%" --path "%project%" "%build_project%"

