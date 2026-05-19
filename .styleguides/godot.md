---
category: styleguide
language: gdscript
tool: godot
---

# Godot Project Setup & Conventions

## Prerequisites

- **Godot Engine 4.x stable** — [godotengine.org](https://godotengine.org)
- **Git** — for version control
- IDE: VS Code with GDScript extension, or Godot's built-in editor

---

## Project Structure

The Godot project lives in `src/` — **never in the repository root**:

```
[repository_root]/
  .github/
  src/                        # Godot project root
    assets/
      images/                 # Textures, sprites, backgrounds
      audio/                  # Sound effects and music
    scenes/                   # Scenes organized by feature
      core/                   # Core systems (game manager, states)
      world/                  # Level / map scenes
      game/                   # Main gameplay scene
      ui/                     # HUD and UI
        main_menu/
    resources/                # Godot resources
      fonts/
      themes/
      audio/
    project.godot             # Godot project configuration
    build_config.json         # Export builder configuration
    export_presets.cfg        # Export profiles
  docs/                       # Technical documentation
  .gitignore
  .gitattributes
```

> Empty folders that need to be committed include a `.gitkeep` placeholder file.

---

## Build & Export

### Export Profiles

Two standard profiles:

| Profile | Target | Features |
|---|---|---|
| `Linux` | x86_64 | S3TC/BPTC compression, Embedded PCK, Console output |
| `Windows Desktop` | x86_64 | S3TC/BPTC compression, Embedded PCK, Direct3D 12 |

Output path: `.exports/` (relative to repository root)

### Via Godot Editor

1. Project → Export (`Ctrl+Alt+E`)
2. Select export profile
3. Click Export
4. Choose output directory and filename

### Via Command Line

```bash
/usr/local/bin/godot --export-debug "Linux" ".exports/game_linux.x86_64"
/usr/local/bin/godot --export-debug "Windows Desktop" ".exports/game_windows.exe"
```

### `build_config.json`

External build tools read `src/build_config.json` to automate exports. Keep this file up to date when changing the Godot binary path, project name, or output structure.

```json
{
  "godot": { "path": "/usr/local/bin/godot", "version": "4.x" },
  "build": {
    "project_name": "my-project",
    "export_root": ".exports/",
    "output_filename": "{project}_{date}_{os}_{type}"
  }
}
```

**Fields:**

| Field | Description |
|---|---|
| `godot.path` | Absolute path to the Godot binary |
| `godot.version` | Godot version (informational) |
| `build.project_name` | Used in output filenames |
| `build.export_root` | Output directory, relative to repo root |
| `build.output_filename` | Filename template — supports `{project}`, `{date}`, `{os}`, `{type}` |

### Troubleshooting

**"Export template not found"**
→ Editor → Export → Install export templates for the desired platform

---

## Development Workflow

### Creating a New Scene

1. Right-click in FileSystem panel → New Resource → PackedScene
2. Choose root node type (`Node2D`, `CharacterBody2D`, `Control`, …)
3. Add child nodes and attach scripts
4. Save with a descriptive `snake_case` name
5. Place in the appropriate folder under `src/scenes/`

### Adding a Script

1. Right-click node → Attach Script
2. Path pattern: `res://src/scenes/[component]/[script_name].gd`
3. Add `class_name` if it's a reusable component (see `styleguides/gdscript.md`)

### Testing Changes

1. Save the file (`Ctrl+S`)
2. Switch to Godot (`Alt+Tab`) — Godot auto-reloads scripts
3. Press `F5` to restart and test

---

## Core Systems Pattern

### Game Manager (Autoload Singleton)

A central `GameManager` autoload handles global state and coordinates cross-system communication via signals.

Recommended autoload name: `Game` (or a short, descriptive identifier)

```gdscript
class_name GameManager
extends Node

enum GameStates {
    NOTDEFINED,
    STARTUP,
    INITIALIZING,
    INITIALIZED,
    MENU,
    RUNNING,
    PAUSED,
    WAITING,
    ENDED,
}

# Autoload signals use the autoload's prefix (see Signal Naming Conventions)
signal GM_state_changed(state: GameStates)
signal GM_change_state(state: GameStates)

var game_state: GameStates = GameStates.NOTDEFINED:
    set(value):
        game_state = value
        GM_state_changed.emit(game_state)
```

**Usage from any script:**
```gdscript
Game.game_state = Game.GameStates.RUNNING   # triggers GM_state_changed
Game.GM_change_state.emit(Game.GameStates.PAUSED)
```

### RNG with Fixed Seed

Use a global RNG with a fixed seed for reproducible randomness (useful for debugging and replays):

```gdscript
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
    rng.seed = 19771202  # fixed seed — change for different random sequences
```

### State Machine Flow

```
NOTDEFINED → STARTUP → INITIALIZING → INITIALIZED
                                          ↓
                                        MENU
                                       ↙    ↘
                                   RUNNING   QUIT
                                  ↙  ↑  ↘
                             PAUSED  │  WAITING
                                     ↓
                                   ENDED
```

---

## Optimization Tips

- Use `add_to_group()` for batch operations instead of iterating node trees
- Cache `@onready` references — avoid repeated `get_node()` calls
- Disable physics (`set_physics_process(false)`) for off-screen or inactive objects
- Use `call_deferred()` for operations that don't need immediate execution
- Keep scenes small — large scenes are slow to load and edit

---

## Code Review Checklist

Before pushing commits:

- [ ] No hardcoded paths — use UIDs (`preload("uid://...")`) or `@export`
- [ ] Signals documented with `##` docstrings
- [ ] Exports have ranges and descriptions where applicable
- [ ] No console errors or warnings when running
- [ ] Game can be exported without errors
- [ ] `build_config.json` is up to date if the build setup changed

---

## Resources

- [Godot Docs](https://docs.godotengine.org/en/stable/)
- [GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [Signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html)
- [Signal.connect() flags](https://docs.godotengine.org/de/4.x/classes/class_object.html#enum-object-connectflags)
