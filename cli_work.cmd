@echo off
cd C:\Proggen\Godot\Godot_v3.5.1-stable_win64
godot.windows.opt.tools.64.exe --verbose --export-debug "Windows Desktop" --test gui --path "C:\Proggen\Godot\Projekte\RTS_Dummy_Prototype" "C:\Proggen\Godot\Projekte\Export\RTS_Dummy_Prototype\RTS_Dummy_Prototype.exe" > "C:\Proggen\Godot\Projekte\Export\RTS_Dummy_Prototype\export.log.txt"