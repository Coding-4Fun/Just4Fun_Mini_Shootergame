[![godot-ci export](https://github.com/Coding-4Fun/Just4Fun_Mini_Shootergame/actions/workflows/export.yml/badge.svg)](https://github.com/Coding-4Fun/Just4Fun_Mini_Shootergame/actions/workflows/export.yml)

# Just4Fun_Mini_Shootergame
Eigentlich ein Prototyp um Kleinigkeiten auszuprobieren hat es sich zu einem kleinen Shooting Game entwickelt

Ausgelagert in ein eigenes Projekt um es noch weiter zu einem Spiel auszubauen.

## Beschreibung
Der Spieler wird als Kanone am linken Bildschirmrand dargestellt.
Durch bewegen der Maus kann der Anstellwinkel verändert werden.

Mit dem Mausrad kann die Kraft des Schusses eingestellt werden
- Min = 7500
- Max = 30000
- Änderungen in +/- 100 mit Mausrad
- Änderung in +/- 1000 mit Mausrad + STRG

Mit der linken Maustaste kann ein Schuss ausgelöst werden.
Der Schuss hat einen Cooldown bis der nächste Schuss ausgelöst werden kann.

Auf dem Spielfeld erscheint ein kleines Ziel das bei einem Treffer entfernt wird und an einer neuen Position erscheint.
Der Treffer eines Zieles beschert dem Spieler Punkte
Die Punkte werden zufällig beim erstellen eines Zieles festgelegt.

Die Ziele haben als Vorgabe ein Timeout. In dieser Zeit hat der Spieler Zeit ein Ziel zu treffen um sich die Punkte zu sichern.
Trifft der Spieler in dieser Zeit nicht, wird ein neues Ziel an beliebiger stelle generiert.
Das automatische Timeout kann in den Einstellungen ein- und ausgeschaltet werden.

## Einstellungen
Der Spieler kann über die Einstellungen die Bedingungen einstellen die zum gewinnen oder verlieren einer Runde notwendig sind.

## Alpha.5
- Add: GameState für Win/Loose Conditions
- Add: GameOver
- Add: Parallax Effekt für den Hintergrund
- Add: Cooldown für den Schuss mit anzeige als Balken
- Add: Umschalten Game Pausieren (Esc)
- Add: Indikator der Position des Bullets ausserhalb des Bildschirms
- Fix: Instanzierung der Bullets
- Fix: Kollisionen mit der TileMap
- Fix: Anzeige von Werten in der UI
- Fix: Debugger/Compiler Warnungen
- Fix: Fehler im Export Build


## Alpha.4
- UI: Kleine Erweiterung im UI
- UI: Ein kleines Hauptmneü mit einem Play Button
- Visuell: Eine kleine Burg für den Spieler
- Fix: Target kann jetzt nicht mehr zu dicht spawnen
- Fix: Anzeigen in der IngameUI
- Fix: Löschen der Map bei GameReset
- Code: Refactoring des Codes
- Code: Verwendung von Autoloads
- Code: Mehr Verwendung von Signals
- Code/Fix: Collision Handling
- Game: Mit gedrückter STRG lässt sich die Schusskraft um 1000 erhöhen, ohne um 100


## Update Alpha.2.1
Add: Timer auf Ziel und Anzeige der möglichen Punkte bei einem Treffer

## Update Alpha.2
- Reset Button zum neustarten des Level
-- Erzeugt eine neue Bodenlinie
-- Setzt die Punkte zurück
- Negativ Punkte (-2) wenn daneben geschossen wird

## Bisher enthalten
- Spielfeld wird zufällig beim start generiert
- Spieler wird als Kanone dargestellt
- Spieler kann den Schusswinkel anpassen
- Spieler kann durch anpassen der Schussstärke die entfernung beeinflussen
- Ziele auf dem Spielfeld
- Bei einem tredder verschwindet das Ziel und wird ab neuer Position erstellt
- Ziele haben unterschiedliche Punktzahlen
- Anzeige des Winkels
- Anzeige der Schussstärke
- Anzeige der gefeuerten Schüsse
- Zählen der Punkte

![image](https://user-images.githubusercontent.com/665076/154135268-b6129b4b-0391-4e34-b88f-384609d26781.png)
