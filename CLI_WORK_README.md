# Godot Project Build & Export Script - Complete Documentation

A powerful Bash script that automates Godot project building and exporting with multi-profile support, custom filenames, and intelligent defaults.

## Table of Contents

1. [Overview](#overview)
2. [Quick Start](#quick-start)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Configuration](#configuration)
6. [JSON Parameters](#json-parameters)
7. [Filename Placeholders](#filename-placeholders)
8. [Multi-Profile Exports](#multi-profile-exports)
9. [Profile Overrides](#profile-overrides)
10. [CLI Parameters](#cli-parameters)
11. [Error Handling](#error-handling)
12. [Examples](#examples)
13. [FAQ](#faq)
14. [Troubleshooting](#troubleshooting)

---

## Overview

The `cli_work.sh` script provides a complete automation solution for Godot project exports. It's the Bash equivalent of the Windows batch file `cli_work_44b4.bat` with many enhancements:

**Key Features**
- ✅ **Auto-Detection**: Automatically finds project directory and Godot executable
- ✅ **Multi-Profile Exports**: Configure multiple build targets in one file
- ✅ **Custom Filenames**: Template-based output names with date, version, and more
- ✅ **Smart Defaults**: `--init` generates configuration based on your OS and project
- ✅ **Project-Relative Paths**: Run from anywhere, exports relative to project directory
- ✅ **JSON Configuration**: All settings in one structured configuration file
- ✅ **Version Verification**: Validates Godot version before building
- ✅ **Colored Output**: Clear, readable console feedback
- ✅ **Detailed Logging**: Export logs saved for debugging
- ✅ **Platform-Specific**: Handles Windows (.exe), Linux (.x86_64), and Web exports

---

## Quick Start

### 1. Generate Default Configuration

```bash
./cli_work.sh --init
```

This creates `build_config.json` with:
- Auto-detected Godot executable path
- Auto-detected Godot version
- Project name from directory name
- Current OS as default export profile

### 2. Customize Configuration (Optional)

Edit `build_config.json` to adjust export settings, add multiple profiles, customize filenames, etc.

### 3. Build

```bash
./cli_work.sh
```

The script will:
1. Validate configuration
2. Verify Godot version
3. Import project resources
4. Export all configured profiles
5. Ask if you want to run the binary (for single profile exports)

---

## Installation

### Requirements

- **Bash** 4.0 or later
- **jq** JSON parser
- **Godot** 4.x Game Engine

### Step 1: Get jq

**Debian/Ubuntu:**
```bash
sudo apt install jq
```

**macOS:**
```bash
brew install jq
```

**macOS (Homebrew alternative):**
```bash
brew install jq
```

### Step 2: Make Script Executable

```bash
chmod +x cli_work.sh
```

### Step 3: Generate Configuration

```bash
./cli_work.sh --init
```

Done! You're ready to export.

---

## Usage

### Basic Commands

```bash
# Show help
./cli_work.sh --help

# Generate default configuration
./cli_work.sh --init

# Execute build (uses build_config.json)
./cli_work.sh

# Show script version
./cli_work.sh --version
```

### Running from Different Directories

The script automatically finds your project by searching for `project.godot`:

```bash
# Run from project root
cd /path/to/MyProject
/path/to/cli_work.sh

# Run from subdirectory
cd /path/to/MyProject/scripts
../../cli_work.sh

# Run from parent directory
cd /path/to
MyProject/cli_work.sh
```

---

## Configuration

### File Location

```
project_root/
├── project.godot
├── build_config.json          ← Your configuration
├── cli_work.sh                ← This script
└── .exports/                  ← Default export location (hidden)
    ├── Windows/
    ├── Linux/
    └── Web/
```

### Creating Configuration Manually

If you prefer to create `build_config.json` manually:

```bash
cat > build_config.json << 'EOF'
{
  "godot": {
    "path": "/path/to/godot",
    "version": "4.6"
  },
  "build": {
    "project_name": "MyProject",
    "version_suffix": "dev",
    "export_root": "./exports",
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

## JSON Parameters

### `godot` Section (Global)

Defines Godot engine settings.

#### `godot.path` (string, optional)

Path to the Godot executable.

- **Type**: String (absolute or relative path)
- **Default**: Auto-detected from PATH
- **Examples**:
  - `/home/user/bin/godot`
  - `/Applications/Godot.app/Contents/MacOS/Godot`
  - `C:\Proggen\Godot\godot.exe` (with WSL)

```json
{
  "godot": {
    "path": "/home/user/bin/godot"
  }
}
```

#### `godot.version` (string, optional)

Expected Godot version (Major.Minor).

- **Type**: String in format "X.Y"
- **Default**: Skips version check if not specified
- **Validation**: `godot --version` must match this value
- **Examples**: `"4.6"`, `"4.5"`, `"4.0"`
- **On Mismatch**: Script exits with error

```json
{
  "godot": {
    "path": "/home/user/bin/godot",
    "version": "4.6"
  }
}
```

---

### `build` Section (Global)

Global build settings that apply to all profiles (unless overridden per-profile).

#### `build.project_name` (string)

Name of the project, used in filenames and configuration.

- **Type**: String
- **Default**: `"DefaultProject"`
- **Used In**: Output filenames
- **Set By --init**: Directory name of project

```json
{
  "build": {
    "project_name": "MiniShooterGame"
  }
}
```

#### `build.version_suffix` (string)

Suffix appended to all exported binaries.

- **Type**: String
- **Default**: `"dev"`
- **Examples**: `"_alpha9"`, `"_beta"`, `"_release"`, `"_1.0"`
- **Applied**: Before file extension (`.exe`, `.x86_64`, etc.)

```json
{
  "build": {
    "version_suffix": "_alpha10"
  }
}
```

Result: `MiniShooterGame_alpha10.exe` (Windows), `MiniShooterGame_alpha10.x86_64` (Linux)

#### `build.export_root` (string)

Root directory for exports (relative to project directory).

- **Type**: String (relative path)
- **Default**: `".exports"` (hidden directory, ignored by Godot Editor)
- **Resolved**: Relative to project directory (where `project.godot` is)
- **Note**: Directories starting with a dot (`.`) are automatically ignored by the Godot engine
- **Examples**: `".exports"`, `"exports"`, `"../builds"`, `"build/output"`

```json
{
  "build": {
    "export_root": "./exports"
  }
}
```

Exports will be saved to: `{project_dir}/{export_root}/{profile_name}/`

#### `build.export_path` (string, optional)

Override the export location (takes precedence over `export_root`).

- **Type**: String (absolute or relative path)
- **Default**: Not set (uses `export_root`)
- **Resolved**: Relative to project directory if not absolute
- **Examples**: `"../builds"`, `"/tmp/godot_exports"`, `"./custom_exports"`

```json
{
  "build": {
    "export_root": "./exports",
    "export_path": "../builds"
  }
}
```

#### `build.output_filename` (string)

Template for output filename (without extension).

- **Type**: String with placeholders
- **Default**: `"{project}_{date}_{os}_{type}"`
- **Placeholders**: See [Filename Placeholders](#filename-placeholders) section
- **Per-Profile Override**: See [Profile Overrides](#profile-overrides)

```json
{
  "build": {
    "output_filename": "{project}_{godot_version}_{date}_{os}_{type}"
  }
}
```

#### `build.use_separators` (boolean)

Whether to use underscores (`_`) between filename components.

- **Type**: Boolean (`true` or `false`)
- **Default**: `true`
- **When `true`**: Keeps underscores in filename
- **When `false`**: Removes all underscores

```json
{
  "build": {
    "output_filename": "{project}_{date}_{type}",
    "use_separators": true
  }
}
```

Results:
- With `true`: `MiniShooterGame_20260227_debug`
- With `false`: `MiniShooterGamedebug` (concatenated)

---

### `profiles` Section (Array)

Array of build profiles. Each profile represents a target platform/configuration.

#### Basic Profile Structure

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

#### Profile Parameters

##### `profiles[].name` (string, required)

Export profile name from `export_presets.cfg`.

- **Type**: String
- **Required**: Yes
- **Must match**: Profile name in Godot's `export_presets.cfg`
- **Common values**: `"Windows"`, `"Linux"`, `"Web"`, `"Mac"`, `"iOS"`, `"Android"`

```json
{
  "profiles": [
    { "name": "Windows" },
    { "name": "Linux" }
  ]
}
```

##### `profiles[].type` (string)

Export type (debug or release).

- **Type**: String
- **Options**: `"export-debug"` or `"export-release"`
- **Default**: Uses global `build.type` if not specified (currently no global type, so defaults to `"export-debug"`)
- **Affects**: Filename (shortened to `debug` or `release` in `{type}` placeholder)

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

##### `profiles[].platform` (string)

Target platform/architecture.

- **Type**: String
- **Values**: `"x86_64"`, `"x86_32"`, `"arm64"`, `"arm"`, `"web"`, `"mobile"`, etc.
- **Not Validated**: Can be any string, used in filename placeholders
- **Used In**: `{platform}` placeholder

```json
{
  "profiles": [
    { "name": "Windows", "platform": "x86_64" },
    { "name": "Linux", "platform": "arm64" }
  ]
}
```

##### `profiles[].output_filename` (string, optional)

Override global `build.output_filename` for this profile.

- **Type**: String with placeholders
- **Default**: Uses global `build.output_filename`
- **Precedence**: Profile value overrides global value
- **Placeholders**: Same as global (see [Filename Placeholders](#filename-placeholders))

```json
{
  "build": {
    "output_filename": "{project}_{date}_{os}_{type}"
  },
  "profiles": [
    {
      "name": "Windows",
      "output_filename": "game_windows_{version}"
    }
  ]
}
```

##### `profiles[].export_path` (string, optional)

Override export path for this profile.

- **Type**: String (absolute or relative path)
- **Default**: Uses global `build.export_root`
- **Precedence**: Profile value overrides global value
- **Resolved**: Relative to project directory

```json
{
  "build": {
    "export_root": "./exports"
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

## Filename Placeholders

The `output_filename` template supports the following placeholders:

| Placeholder | Description | Example Value | Notes |
|-------------|-------------|-----------------|-------|
| `{project}` | Project name | `MiniShooterGame` | From `build.project_name` |
| `{version_suffix}` | Version suffix | `_alpha9` | From `build.version_suffix` |
| `{godot_version}` | Godot version | `4.6` | From `godot.version` or runtime |
| `{date}` | Current date | `20260227` | Format: YYYYMMDD |
| `{os}` | Operating system (short) | `Win`, `Lin`, `Mac` | Detected from system |
| `{type}` | Build type | `debug`, `release` | Extracted from `export-debug` or `export-release` |
| `{platform}` | Target platform | `x86_64`, `arm64`, `web` | From `profiles[].platform` |

### Placeholder Examples

**Default Template:**
```
{project}_{date}_{os}_{type}
```
Result: `MiniShooterGame_20260227_Win_debug`

**Version-Based Template:**
```
{project}_{godot_version}_{type}
```
Result: `MiniShooterGame_4.6_debug`

**Detailed Template:**
```
{project}_v{godot_version}_{date}_{os}_{platform}_{type}
```
Result: `MiniShooterGame_v4.6_20260227_Win_x86_64_debug`

**Simple Template:**
```
{project}_{type}
```
Result: `MiniShooterGame_debug`

---

## Multi-Profile Exports

Export to multiple targets in a single command.

### Example: Windows + Linux + Web

```json
{
  "godot": {
    "path": "/home/user/bin/godot",
    "version": "4.6"
  },
  "build": {
    "project_name": "MiniShooterGame",
    "version_suffix": "_alpha9",
    "export_root": "./exports",
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

**Execution:**
```bash
./cli_work.sh
```

**Output:**
```
.exports/
├── Windows/
│   ├── MiniShooterGame_20260227_Win_release_alpha9.exe
│   └── MiniShooterGame_export.log.txt
├── Linux/
│   ├── MiniShooterGame_20260227_Lin_release_alpha9.x86_64
│   └── MiniShooterGame_export.log.txt
└── Web/
    ├── MiniShooterGame_20260227_Lin_debug/
    │   ├── index.html
    │   └── ...
    └── MiniShooterGame_export.log.txt
```

---

## Profile Overrides

Each profile can override global build settings.

### Override Example

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

**Precedence:**
1. Profile-specific value (highest priority)
2. Global value (fallback)
3. Built-in default (lowest priority)

---

## CLI Parameters

### `--help`

Show command-line help.

```bash
./cli_work.sh --help
```

**Output:**
```
Godot Project Build & Export Script

USAGE:
    ./cli_work.sh [OPTION]

OPTIONS:
    (no option)     Execute build using build_config.json
    --help          Show this help message
    --init          Generate a new build_config.json with defaults
    --version       Show script version
    ...
```

### `--init`

Generate default `build_config.json` with auto-detected values.

```bash
./cli_work.sh --init
```

**Auto-Detects:**
- Godot executable path (from PATH)
- Godot version (from `godot --version`)
- Project name (from directory name)
- OS (Linux, Mac, Windows)

**Creates:** `build_config.json` in current directory

**Example Output:**
```json
{
  "godot": {
    "path": "godot",
    "version": "4.6"
  },
  "build": {
    "project_name": "Just4Fun_Mini_Shootergame",
    "version_suffix": "dev",
    "export_root": "./exports",
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

Show script version.

```bash
./cli_work.sh --version
```

Output: `Godot Project Build Script v1.0`

---

## Error Handling

The script validates configuration before building and provides clear error messages.

### Configuration Errors (`exit 1`)

**JSON not found:**
```
[ERROR] build_config.json not found
[ERROR] Run './cli_work.sh --init' to generate a default configuration
```

**Invalid JSON:**
```
[ERROR] build_config.json is invalid JSON syntax
```

**jq not installed:**
```
[ERROR] jq is required to parse build_config.json
[ERROR] Install it with: apt install jq (Debian/Ubuntu) or brew install jq (macOS)
```

### Validation Errors (`exit 1`)

**Godot version mismatch:**
```
[ERROR] Godot version mismatch!
[ERROR]   Expected: 4.6
[ERROR]   Got:      4.5
```

**Godot executable not found:**
```
[ERROR] Godot executable not found at: /home/user/bin/godot
```

### Runtime Errors (`exit 99`)

**project.godot not found:**
```
[ERROR] Could not find project.godot
[ERROR] Please run this script from the project directory or a subdirectory
```

**Export failed:**
```
[ERROR] Export failed with exit code 1
```

---

## Examples

### Example 1: Simple Single Export

**Minimal configuration for Windows export:**

```json
{
  "godot": {
    "path": "/home/user/bin/godot",
    "version": "4.6"
  },
  "build": {
    "project_name": "MyGame",
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

Execute:
```bash
./cli_work.sh
```

### Example 2: Multi-Platform Release Build

**Release builds for multiple platforms:**

```json
{
  "godot": {
    "path": "/home/user/bin/godot",
    "version": "4.6"
  },
  "build": {
    "project_name": "ShooterGame",
    "version_suffix": "_v1.0",
    "export_root": "./releases",
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

Output files:
```
releases/
├── Windows/ShooterGame_4.6_Win_x86_64_release_v1.0.exe
├── Linux/ShooterGame_4.6_Lin_x86_64_release_v1.0.x86_64
└── Web/ShooterGame_4.6_Lin_web_release_v1.0/
```

### Example 3: Profile-Specific Overrides

**Different settings per profile:**

```json
{
  "build": {
    "project_name": "Game",
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

## FAQ

**Q: Can I run the script from a parent directory?**
A: Yes! The script searches for `project.godot` up the directory tree. You can run it from any subdirectory or parent directory of your project.

**Q: What if I don't specify `godot.version`?**
A: Version checking is skipped, but the script still works. This is useful for development.

**Q: How do I change the export directory?**
A: Use `build.export_root` (global) or `profiles[].export_path` (per-profile).

**Q: Can I export to the same profile multiple times with different settings?**
A: Yes! Create multiple profile entries with the same `name` but different `type` or `output_filename`.

**Q: What file extensions are added automatically?**
A: 
- Windows: `.exe`
- Linux: `.x86_64`
- Web: None (outputs a directory)

**Q: How do I include the date in filenames?**
A: Use the `{date}` placeholder in `output_filename`. Format: YYYYMMDD (e.g., `20260227`)

**Q: Can I customize the date format?**
A: Currently the format is fixed as YYYYMMDD. This can be customized in future versions.

---

## Troubleshooting

### Issue: `jq: command not found`

**Solution:** Install jq
```bash
sudo apt install jq      # Debian/Ubuntu
brew install jq          # macOS
```

### Issue: `Godot version mismatch`

**Check actual version:**
```bash
/path/to/godot --version
```

**Update configuration:**
Edit `build_config.json` and set `godot.version` to match the output.

### Issue: `project.godot not found`

**Verify location:**
```bash
find . -name "project.godot"
```

**Solution:** Run the script from the project directory or a subdirectory where `project.godot` exists.

### Issue: Export fails with no clear error

**Check export log:**
```bash
cat exports/Windows/MiniShooterGame_export.log.txt
```

The log contains detailed Godot output that can help diagnose issues.

### Issue: Binary not executable (Linux)

**The script automatically makes Linux binaries executable**, but if needed manually:
```bash
chmod +x exports/Linux/game_name.x86_64
```

---

## Support

For issues or feature requests, refer to:
- `./cli_work.sh --help` for usage
- `./cli_work.sh --init` for default configuration
- Godot documentation for export_presets.cfg
