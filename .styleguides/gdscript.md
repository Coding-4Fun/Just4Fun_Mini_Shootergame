---
category: styleguide
language: gdscript
tool: godot
---

# GDScript / Godot Style Guide

## Naming Conventions

| Element | Convention | Example |
|---|---|---|
| Variables, functions, parameters | `snake_case` | `player_health`, `get_damage()` |
| Constants, enums | `SCREAMING_SNAKE_CASE` | `MAX_SPEED`, `DIRECTION.LEFT` |
| Classes, nodes, types | `PascalCase` | `PlayerController`, `HealthBar` |
| Signals | `snake_case`, past tense verb | `health_changed`, `enemy_died` |
| Private members | leading underscore | `_speed`, `_on_timer_timeout()` |
| Scene files | `snake_case.tscn` | `main_menu.tscn`, `player.tscn` |
| Script files | `snake_case.gd`, matching scene name | `player.gd`, `health_bar.gd` |
| Resource files | `snake_case.tres` / `snake_case.res` | `player_stats.tres` |

### `class_name`

Always declare `class_name` for reusable components — it enables type hints, better IDE support, and correct `@onready` / `@export` behaviour.

```gdscript
✅ class_name PlayerController extends CharacterBody2D
✅ class_name HealthBar extends Control

❌ extends CharacterBody2D  # anonymous script, no type safety
```

### Signal naming

```gdscript
✅ signal health_changed(new_value: int)   # past tense, descriptive
✅ signal enemy_died
✅ signal score_updated(points: int)

❌ signal BrickDestroyed                   # PascalCase
❌ signal event(data)                      # ambiguous
```

**Autoload signals** use a short uppercase prefix matching the autoload name, followed by an underscore. This makes it immediately clear that a signal originates from a global singleton:

```gdscript
# Autoload: Game (GameManager)
signal GM_state_changed(state: GameStates)
signal GM_change_state(state: GameStates)

# Autoload: AudioManager
signal AUDIO_track_changed(track_name: String)
```

**Suppressing unused signal warnings** — use `@warning_ignore` when signals are declared for external subscribers but never emitted within the same script:

```gdscript
@warning_ignore_start("unused_signal")
signal GM_state_changed(state: GameStates)
signal GM_change_state(state: GameStates)
@warning_ignore_restore("unused_signal")
```

### Function callbacks

Name signal callbacks `_on_<node_name>_<signal_name>()` — Godot generates this automatically:

```gdscript
✅ func _on_timer_timeout() -> void:
✅ func _on_enemy_area_body_entered(body: Node2D) -> void:

❌ func onTimerTimeout() -> void:
❌ func handleCollision(body: Node2D) -> void:
```

---

## Script Structure

Always follow this order within a script:

```gdscript
class_name MyClass
extends Node

# 1. Signals
signal health_changed(new_value: int)

# 2. Enums
enum State { IDLE, WALK, JUMP }

# 3. Constants
const MAX_HEALTH: int = 100

# 4. Exported variables
@export var speed: float = 200.0

# 5. Public variables
var current_state: State = State.IDLE

# 6. Private variables
var _health: int = MAX_HEALTH

# 7. @onready variables
@onready var _sprite: Sprite2D = $Sprite2D
@onready var _timer: Timer = $Timer

# 8. Built-in lifecycle functions
func _ready() -> void:
    pass

func _process(delta: float) -> void:
    pass

# 9. Public functions
func take_damage(amount: int) -> void:
    pass

# 10. Private functions
func _update_health(value: int) -> void:
    pass

# 11. Signal callbacks
func _on_timer_timeout() -> void:
    pass
```

### Code Regions

Use `#region` / `#endregion` to group related code in longer scripts:

```gdscript
#region Signals
signal health_changed(new_value: int)
signal enemy_died
#endregion

#region Exports
@export var speed: float = 200.0
@export_range(0.0, 500.0, 10.0) var jump_force: float = 400.0
#endregion

#region Lifecycle
func _ready() -> void:
    pass

func _process(delta: float) -> void:
    pass
#endregion
```

---

## Type Annotations

Always use static typing — annotate all variables, parameters, and return types.

```gdscript
✅ var speed: float = 200.0
✅ func take_damage(amount: int) -> void:
✅ func get_velocity() -> Vector2:

❌ var speed = 200.0
❌ func take_damage(amount):
```

**Common types:**

| Type | Use |
|---|---|
| `void` | No return value |
| `int`, `float`, `bool`, `String` | Primitives |
| `Vector2`, `Vector2i`, `Vector3` | Geometry |
| `Node`, `Node2D`, `Control` | Node types |
| `Array[Type]`, `Dictionary[K, V]` | Collections |
| `PackedScene`, `Resource` | Game objects |
| Custom `class_name` | Typed references to your own classes |

---

## Code Style

### Indentation

- Use **tabs** (Godot default) — never spaces

### Line Length

- Soft limit: **80 characters**
- Hard limit: **120 characters** — break long lines for readability

```gdscript
✅ signal_name.connect(
       callback_function,
       CONNECT_DEFERRED
   )

❌ some_node.some_signal.connect(callback_function, CONNECT_DEFERRED)  # over limit
```

### Spacing

```gdscript
✅ var result = x + y
✅ func move(direction: Vector2, speed: float) -> void:

❌ var result=x+y
❌ func move( direction:Vector2,speed:float )->void:
```

---

## Exported Variables

Use `@export` for all designer-tunable values. Always provide a default.

```gdscript
✅ @export_range(50.0, 1000.0, 10.0) var speed: float = 650.0
✅ @export_color var player_color: Color = Color.WHITE
✅ @export var use_mouse: bool = true

❌ var speed = 650.0            # not tunable in editor
❌ @export var _internal: bool  # exported private is confusing
```

Group related exports with `@export_group`:

```gdscript
@export_group("Movement")
@export var speed: float = 200.0
@export var jump_force: float = 400.0

@export_group("Combat")
@export var max_health: int = 100
```

Use setter/getter when the value should trigger side effects:

```gdscript
@export var speed: float = 200.0:
    set(value):
        speed = value
        speed_changed.emit(speed)
    get:
        return speed
```

---

## Node References

Use `@onready` for all node references. Never call `$Node` outside of `@onready` or `_ready()`.

```gdscript
✅ @onready var _label: Label = $UI/Label

   func _process(delta: float) -> void:
       _label.text = str(score)

❌ func _process(delta: float) -> void:
       $UI/Label.text = str(score)   # repeated lookup, no caching
```

---

## Signals

```gdscript
# Declaration
signal health_changed(new_value: int)

# Emission
health_changed.emit(_health)

# Connection in code
_timer.timeout.connect(_on_timer_timeout)

# Use CONNECT_DEFERRED for signals that change game state
game_manager.state_changed.connect(_on_state_changed, CONNECT_DEFERRED)

# Use CONNECT_APPEND_SOURCE_OBJECT when the callback needs to know the sender
some_node.hit.connect(_on_hit, CONNECT_DEFERRED | CONNECT_APPEND_SOURCE_OBJECT)

# Callback signature with CONNECT_APPEND_SOURCE_OBJECT — sender is the last parameter
func _on_hit(damage: int, _sender: Object) -> void:
    # Prefix _sender with _ if unused
    pass
```

- Use `CONNECT_DEFERRED` for signals that trigger state changes to avoid frame-timing issues
- Disconnect signals in `_exit_tree()` when a node may be freed before the emitter
- Document signal parameters with `##` docstrings

```gdscript
## Emitted when the player takes damage.
## [param new_value] is the health value after damage was applied.
signal health_changed(new_value: int)
```

---

## Functions

Keep functions short. Extract logic into private helpers if a function exceeds ~20 lines. Prefer early returns over deep nesting.

```gdscript
✅ func take_damage(amount: int) -> void:
       if amount <= 0:
           return
       _health -= amount
       health_changed.emit(_health)
       if _health <= 0:
           die()

❌ func take_damage(amount: int) -> void:
       if amount > 0:
           _health -= amount
           health_changed.emit(_health)
           if _health <= 0:
               die()
```

---

## Comments

Comment *why*, not *what*. Use `##` for public API docstrings (shown as editor tooltips).

```gdscript
✅ ## Applies damage and emits [signal health_changed]. Ignores values <= 0.
   func take_damage(amount: int) -> void:

✅ # Clamp prevents overshooting during fast frames
   velocity = velocity.move_toward(target_velocity, acceleration * delta)

❌ # Set bounce_angle to hit_pos * 60
   var bounce_angle = hit_pos * 60.0
```

---

## Common Patterns

### Property with setter

```gdscript
var health: int = MAX_HEALTH:
    set(value):
        health = clampi(value, 0, MAX_HEALTH)
        health_changed.emit(health)
    get:
        return health
```

### Resource preloading

Use UIDs instead of file paths — UIDs remain valid after files are moved or renamed:

```gdscript
✅ const BULLET_SCENE = preload("uid://abc123xyz")

❌ const BULLET_SCENE = preload("res://scenes/bullet/bullet.tscn")  # breaks on rename
```

### Scene reference via export

```gdscript
@export var enemy_scene: PackedScene  # set in editor — no hardcoded path
```

---

## Scene & Node Organization

- Root node name matches the scene file name in PascalCase (`Player` for `player.tscn`)
- Group related nodes under a clearly named parent (`UI`, `Hitboxes`, `VFX`)
- Keep scene trees flat where possible
- Each scene has exactly one root script

---

## Autoloads (Singletons)

- Use autoloads sparingly — only for truly global state (`GameManager`, `AudioManager`, `SaveSystem`)
- Name autoloads in `PascalCase`
- Keep autoloads as service/data layers — no game logic

---

## Anti-Patterns

```gdscript
❌ # Hardcoded file path — breaks on rename/move
   var scene = load("res://scenes/ball/ball.tscn")

❌ # Repeated node lookup in _process — use @onready instead
   func _process(delta: float) -> void:
       $CollisionShape2D.position = ...

❌ # Magic number — give it a name
   velocity.y = -1200

❌ # Unclear names
   var x = 10
   var temp = velocity

❌ # Circular signal connections
   # Node A connects to Node B's signal, Node B connects to Node A's signal


✅ const BALL_SCENE = preload("uid://abc123xyz")

✅ @onready var _collision: CollisionShape2D = $CollisionShape2D

✅ const INITIAL_JUMP_IMPULSE: float = -1200.0

✅ var initial_velocity: Vector2 = velocity

✅ # One-way signal flow, or use CONNECT_DEFERRED for state changes
```

---

## Linting & Formatting

- Use Godot's built-in GDScript formatter: **Ctrl+Shift+I** in the editor
- Consider `gdlint` for CI/CD pipelines
- An `.editorconfig` file ensures consistent tab/space handling across editors

---

## Optimization Tips

- Use `add_to_group()` for batch operations instead of iterating node trees manually
- `call_deferred()` for operations that don't need immediate execution (e.g. freeing nodes)
- Disable `set_physics_process(false)` for off-screen or inactive objects
- Prefer `@onready` caching over repeated `$Node` lookups in `_process`
