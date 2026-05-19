https://github.com/Coding-4Fun/godot3_procgen_demos/commits/master

Original aus
https://github.com/kidscancode/godot3_procgen_demos
http://kidscancode.org/blog/2018/08/godot3_procgen1/

Änderungen um Zeitraum 9.2.2022 - 15.2.2022
-------------------------------------------
Add: Ereignis für das Punkte zählen
Add: Zählen der Punkte im UI
Add: Ereignis für das Schiessen
Add: Zählen der Schuss im UI
Add: Verbinden der Signals aus Cannon mit Events im UI Script
Add: Festlegen einer Score beim erstellen eines Dummys
Add: Empfangen des Dummy Score beim Treffer Event
Chg: Änderungen der Childs
Add: Script um Änderungen per Signal zu empfangen
Ren: Label umbenannt
Add: Label für Punkte
Add: Label für Anzahl bisheriger Schüssen
Add: Übermittlung einer Punktzahl bei Treffer
Chg: Änderung von Winkel und Kraft per Signal an das UI
Rem: Nicht benötigte Zeilen entfernt
Add: Ereignisse von Childs um im Ablauf fortzusetzen
Chg: Add_cannon und Add_dummy erst nach sicherstellen das TerrainLine Ready ist
Add: Script für Dummy
===: Signalisiert das es getroffen wurde
Chg: Aufruf der Line erzeugung aus Main wieder in Line2D
Chg: Dummytarget mit get_transform statt global_transform
Fix: Pfad zum Font
===: Theme Ordner verschoben
Revert "Auxiliary commit to revert individual files from ab19ac3acf7dff906e0906073c64259527f61acf"

This reverts commit 54db428d62a53f0ad0c3139c9b31793f1ee1a1b0.
Mve: Assets in eigene Ordner verschoben
Upd: Scripte angepasst
===: Pfade zum Laden korrigiert
Mve: Assets in eigene Ordner verschoben
Upd: Scripte angepasst
===: Pfade zum Laden korrigiert
Mve: Assets in eigene Ordner verschoben
Upd: Scripte angepasst
===: Pfade zum Laden korrigiert
Mve: Assets in eigene Ordner verschoben
Upd: Scripte angepasst
===: Pfade zum Laden korrigiert
Upd: Scripte angepasst
===: Pfade zum Laden korrigiert
Mve: Assets in eigene Ordner verschoben
Upd: Scripte angepasst
===: Pfade zum Laden korrigiert
Mve: Assets in eigene Ordner verschoben
Upd: Scripte angepasst
===: Pfade zum Laden korrigiert
Mve: Assets in eigene Ordner verschoben
Upd: Scripte angepasst
===: Pfade zum Laden korrigiert
Mve: Assets in eigene Ordner verschoben
Upd: Scripte angepasst
===: Pfade zum Laden korrigiert
Mve: Assets in eigene Ordner verschoben
Upd: Scripte angepasst
===: Pfade zum Laden korrigiert
Revert "Mve: Assets in eigene Ordner verschoben"

This reverts commit 186d8ab6f0a018f1a887bd01aab37a460f1b3001.
Mve: Assets in eigene Ordner verschoben
Upd: Scripte angepasst
===: Pfade zum Laden korrigiert
Mve: Assets in eigene Ordner verschoben
Upd: Scripte angepasst
===: Pfade zum Laden korrigiert
Mve: Assets in eigene Ordner verschoben
Upd: Scripte angepasst
===: Pfade zum Laden korrigiert
Chg: UI Umgestaltung
Chg: Kleine Font Anpassung
Add: Some Fonts
Chg: Use Theme as Default
Add: Some Theme und Fonts
Add: Func zum generieren von rand DummyTargets an den Linienpunkten
Add: Entfernen eines Dummys wenn getroffen
Add: DummyTarget
Add: Ingame UI zum anzeigen des Winkel und der Power
Add: Power einstellung per MAsurad
Add: Anzeige der aktuellen Power
Add: Theme für UI
Add: Ingame UI zum anzeigen des Winkel und der Power
Rem: Nicht benötigte Func entfernt
Chg: Grundwert für Beschleunigung angepasst
Rem: Nicht benötigte Func entfernt
Add: Variable für unterscheidung Player 1 od. 2
Fix: Bullet wird der Main Szene untergeordnet
Add: Bullet entfernen wenn aus dem Bild
Chg: z-index für Explosion angepasst
Add: Einfügen einer Funktion für Explosion
Add: Collision für Terrain hinzugefügt
Add: Variable die bestimmt in welche Richtung die Kannone ausgerichtet werden soll
Add: Ausrichtung soll in Ready Func geschehen
Chg: Nicht benötigte Resourcen auskommentiert
Add: Kannonen Objekt dem linken Player zugeordnet
Add: Nodes für Player Objekte
Chg: Output auf Console auf Verbose gesetzt
Rem: Nicht benötigte Line entfernt
Chg: Collision in CollisionShape2d->Circle geändert
Rem: Event für Maus entfernt
Rem: Einsetzen der Burgen rechts und Linke entfernt
Chg: Kannonen aus dem Burgen Asset entfernt
Add: Script für Hauptszene
Chg: Ruft die Generierung der TerrainLinie auf
Chg: Instanziiert die Kanone und setzt die Position
Add: Neue Hauptszene erstellt
Upd: MainSzene angepasst
Chg: Cannon als eigenes Asset
Add: Assets für Explosion
Add: Taste zum Schiessen hinzugefügt
Add: Cannon zur Burg Scene
Add: Cannon Asset
Add: Cannonball Asset
Add: Generierung einer Burg rechts und links
Add: Szene für Castle
Add: Hauptszene
Chg: Eine Root Node hinzugefügtUpd: Projekt Settings angepasst
Add: Turm und Mauer Asset
Upd: Convert to GODOT 3.4.x
part 04
