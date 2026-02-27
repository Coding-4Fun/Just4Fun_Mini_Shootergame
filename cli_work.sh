#!/bin/bash

################################################################################
# Godot Project Build & Export Script
# Bash implementation of cli_work_44b4.bat with enhanced features
# Supports multi-profile exports, custom filenames, and auto-detection
################################################################################

set -o pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

################################################################################
# HELPER LOGGING FUNCTIONS
################################################################################

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_section() {
    echo ""
    echo -e "${BLUE}=== $1 ===${NC}"
    echo ""
}

################################################################################
# HELP FUNCTION
################################################################################

show_help() {
    cat << 'EOF'
Godot Project Build & Export Script

USAGE:
    ./cli_work.sh [OPTION]

OPTIONS:
    (no option)     Execute build using build_config.json
    --help          Show this help message
    --init          Generate a new build_config.json with defaults
    --version       Show script version

DESCRIPTION:
    This script automates the Godot project build and export process.
    It reads configuration from build_config.json and supports:
    
    - Auto-detection of project directory (searches for project.godot)
    - Multiple build profiles in one configuration
    - Custom output filenames with placeholders
    - Automatic version and OS detection
    - Debug and release exports
    - Linux, Windows, and Web platforms

EXAMPLES:
    # Generate default configuration (interactive)
    ./cli_work.sh --init
    
    # Build using existing configuration
    ./cli_work.sh
    
    # Get help
    ./cli_work.sh --help

CONFIGURATION:
    - File: build_config.json
    - See README.md for detailed parameter documentation

For more information, see CLI_WORK_README.md
EOF
}

################################################################################
# FIND PROJECT DIRECTORY
################################################################################

find_project_directory() {
    local current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local check_dir="$current_dir"
    
    # Search upwards for project.godot
    while [ "$check_dir" != "/" ]; do
        if [ -f "$check_dir/project.godot" ]; then
            echo "$check_dir"
            return 0
        fi
        check_dir=$(dirname "$check_dir")
    done
    
    # If not found upwards, check current dir
    if [ -f "$current_dir/project.godot" ]; then
        echo "$current_dir"
        return 0
    fi
    
    log_error "Could not find project.godot"
    log_error "Please run this script from the project directory or a subdirectory"
    return 1
}

################################################################################
# PLATFORM DETECTION
################################################################################

detect_os() {
    local os=$(uname -s)
    case "$os" in
        Linux*)   echo "Linux" ;;
        Darwin*)  echo "Mac" ;;
        CYGWIN*|MINGW*|MSYS*) echo "Windows" ;;
        *) echo "Unknown" ;;
    esac
}

detect_os_short() {
    local os=$(uname -s)
    case "$os" in
        Linux*)   echo "Lin" ;;
        Darwin*)  echo "Mac" ;;
        CYGWIN*|MINGW*|MSYS*) echo "Win" ;;
        *) echo "Unk" ;;
    esac
}

################################################################################
# GODOT AUTO-DETECTION
################################################################################

detect_godot_executable() {
    # Try common godot names
    for cmd in godot godot4 godot3 /opt/godot/godot /snap/bin/godot; do
        if command -v "$cmd" &> /dev/null; then
            echo "$cmd"
            return 0
        fi
    done
    return 1
}

get_godot_version() {
    local godot_path=$1
    if [ ! -f "$godot_path" ]; then
        return 1
    fi
    
    local version_output=$("$godot_path" --version 2>&1 | head -1)
    
    # Extract major.minor from various formats
    # Handles: "4.6.stable.official.89cea1439" or "v4.6.0.stable" etc.
    echo "$version_output" | grep -oP '(v)?[0-9]+\.[0-9]+' | head -1 | sed 's/^v//'
}

################################################################################
# GET PROJECT NAME FROM DIRECTORY
################################################################################

get_project_name_from_dir() {
    local dir=$1
    basename "$dir"
}

################################################################################
# GENERATE DEFAULT CONFIG
################################################################################

generate_default_config() {
    local project_dir=$(find_project_directory) || return 1
    local project_name=$(get_project_name_from_dir "$project_dir")
    local godot_path=$(detect_godot_executable) || godot_path="/path/to/godot"
    local godot_version=$(get_godot_version "$godot_path") || godot_version="4.6"
    local os=$(detect_os)
    
    local default_profile=""
    case "$os" in
        Linux) default_profile="Linux" ;;
        Darwin) default_profile="Web" ;;
        Windows) default_profile="Windows" ;;
        *) default_profile="Windows" ;;
    esac
    
    cat > build_config.json << EOF
{
  "godot": {
    "path": "$godot_path",
    "version": "$godot_version"
  },
  "build": {
    "project_name": "$project_name",
    "version_suffix": "dev",
    "export_root": ".exports",
    "output_filename": "{project}_{date}_{os}_{type}",
    "use_separators": true
  },
  "profiles": [
    {
      "name": "$default_profile",
      "type": "export-debug",
      "platform": "x86_64"
    }
  ]
}
EOF
    
    return 0
}

################################################################################
# LOAD AND VALIDATE JSON CONFIG
################################################################################

load_config_from_json() {
    local config_file="build_config.json"
    
    # Check if file exists
    if [ ! -f "$config_file" ]; then
        log_error "$config_file not found"
        log_error "Run './cli_work.sh --init' to generate a default configuration"
        return 1
    fi
    
    # Check jq
    if ! command -v jq &> /dev/null; then
        log_error "jq is required to parse $config_file"
        log_error "Install it with: apt install jq (Debian/Ubuntu) or brew install jq (macOS)"
        return 1
    fi
    
    # Validate JSON
    if ! jq empty < "$config_file" 2>/dev/null; then
        log_error "$config_file is invalid JSON syntax"
        return 1
    fi
    
    # Parse global values
    GODOT_PATH=$(jq -r '.godot.path // empty' "$config_file")
    GODOT_VERSION=$(jq -r '.godot.version // empty' "$config_file")
    
    PROJECT_NAME=$(jq -r '.build.project_name // "DefaultProject"' "$config_file")
    VERSION_SUFFIX=$(jq -r '.build.version_suffix // "dev"' "$config_file")
    EXPORT_ROOT=$(jq -r '.build.export_root // ".exports"' "$config_file")
    OUTPUT_FILENAME=$(jq -r '.build.output_filename // "{project}_{date}_{os}_{type}"' "$config_file")
    USE_SEPARATORS=$(jq -r '.build.use_separators // true' "$config_file")
    EXPORT_PATH=$(jq -r '.build.export_path // empty' "$config_file")
    
    # Get profile count
    PROFILE_COUNT=$(jq '.profiles | length' "$config_file")
    
    if [ -z "$PROFILE_COUNT" ] || [ "$PROFILE_COUNT" -eq 0 ]; then
        log_error "No profiles defined in $config_file"
        return 1
    fi
    
    return 0
}

################################################################################
# GET PROFILE DATA
################################################################################

get_profile_data() {
    local config_file="build_config.json"
    local profile_index=$1
    
    # Get profile from JSON with fallback to global values
    local name=$(jq -r ".profiles[$profile_index].name" "$config_file")
    local type=$(jq -r ".profiles[$profile_index].type // .build.type // \"export-debug\"" "$config_file")
    local platform=$(jq -r ".profiles[$profile_index].platform // \"x86_64\"" "$config_file")
    local profile_export_filename=$(jq -r ".profiles[$profile_index].output_filename // empty" "$config_file")
    local profile_export_path=$(jq -r ".profiles[$profile_index].export_path // empty" "$config_file")
    
    # Use profile-specific or global output_filename
    local output_filename="${profile_export_filename:-$OUTPUT_FILENAME}"
    
    # Export as array for easy access
    echo "$name|$type|$platform|$output_filename|$profile_export_path"
}

################################################################################
# VERIFY GODOT VERSION
################################################################################

verify_godot_version() {
    if [ -z "$GODOT_VERSION" ]; then
        log_warn "godot.version not specified, skipping version check"
        return 0
    fi
    
    if [ ! -f "$GODOT_PATH" ]; then
        log_error "Godot executable not found at: $GODOT_PATH"
        return 1
    fi
    
    local actual_version=$(get_godot_version "$GODOT_PATH")
    
    if [ -z "$actual_version" ]; then
        log_error "Could not determine Godot version"
        return 1
    fi
    
    # Extract major.minor from both versions
    local config_version=$(echo "$GODOT_VERSION" | grep -oP '[0-9]+\.[0-9]+' | head -1)
    
    if [ "$actual_version" != "$config_version" ]; then
        log_error "Godot version mismatch!"
        log_error "  Expected: $config_version"
        log_error "  Got:      $actual_version"
        return 1
    fi
    
    log_info "Godot version verified: $actual_version"
    return 0
}

################################################################################
# CHECK AND CREATE DIRECTORIES
################################################################################

check_engine() {
    log_info "Checking Godot Engine installation"
    log_info "  Path: $GODOT_PATH"
    
    if [ ! -f "$GODOT_PATH" ]; then
        log_error "Godot executable not found"
        return 1
    fi
    
    if [ ! -x "$GODOT_PATH" ]; then
        chmod +x "$GODOT_PATH" || {
            log_error "Failed to make Godot executable"
            return 1
        }
    fi
    
    return 0
}

check_project_directory() {
    if [ ! -f "$PROJECT_DIR/project.godot" ]; then
        log_error "project.godot not found in: $PROJECT_DIR"
        return 1
    fi
    
    log_info "Project directory: $PROJECT_DIR"
    return 0
}

################################################################################
# GENERATE OUTPUT FILENAME
################################################################################

generate_output_filename() {
    local template=$1
    local profile_name=$2
    local export_type=$3
    local platform=$4
    
    local filename="$template"
    
    # Replace placeholders
    filename="${filename//\{project\}/$PROJECT_NAME}"
    filename="${filename//\{version_suffix\}/$VERSION_SUFFIX}"
    filename="${filename//\{platform\}/$platform}"
    filename="${filename//\{os\}/$(detect_os_short)}"
    filename="${filename//\{godot_version\}/${GODOT_VERSION:-unknown}}"
    filename="${filename//\{date\}/$(date +%Y%m%d)}"
    
    # Extract type from export-debug or export-release
    local type_short="${export_type#export-}"  # removes "export-" prefix
    filename="${filename//\{type\}/$type_short}"
    
    # Handle separators
    if [ "$USE_SEPARATORS" != "true" ]; then
        filename="${filename//\_/}"
    fi
    
    # Remove multiple underscores
    filename=$(echo "$filename" | sed 's/__/_/g')
    
    echo "$filename"
}

################################################################################
# RESOLVE EXPORT PATH
################################################################################

resolve_export_path() {
    local export_path=$1
    
    if [ -n "$export_path" ]; then
        # Use override path
        if [[ "$export_path" = /* ]]; then
            # Absolute path
            echo "$export_path"
        else
            # Relative to project dir
            echo "$PROJECT_DIR/$export_path"
        fi
    else
        # Use export_root
        if [[ "$EXPORT_ROOT" = /* ]]; then
            # Absolute path
            echo "$EXPORT_ROOT"
        else
            # Relative to project dir
            echo "$PROJECT_DIR/$EXPORT_ROOT"
        fi
    fi
}

################################################################################
# DELETE OLD BINARY
################################################################################

delete_old_binary() {
    local binary_path=$1
    
    if [ -f "$binary_path" ]; then
        log_info "Removing old binary: $binary_path"
        rm -f "$binary_path" || {
            log_error "Failed to delete old binary"
            return 1
        }
    fi
    
    return 0
}

################################################################################
# EXECUTE IMPORT
################################################################################

execute_import() {
    local log_file=$1
    
    log_info "Starting Godot resource import..."
    log_info "  Command: $GODOT_PATH --verbose --import --headless"
    
    "$GODOT_PATH" --verbose --import --headless > "$log_file" 2>&1
    local exit_code=$?
    
    if [ $exit_code -ne 0 ]; then
        log_error "Import failed with exit code $exit_code"
        tail -20 "$log_file"
        return 1
    fi
    
    log_info "Import completed successfully"
    return 0
}

################################################################################
# EXECUTE EXPORT
################################################################################

execute_export() {
    local profile_name=$1
    local export_type=$2
    local build_project=$3
    local log_file=$4
    
    log_info "Starting Godot export..."
    log_info "  Profile: $profile_name"
    log_info "  Type: $export_type"
    log_info "  Output: $build_project"
    
    "$GODOT_PATH" --verbose --headless --"$export_type" "$profile_name" --path "$PROJECT_DIR" "$build_project" >> "$log_file" 2>&1
    local exit_code=$?
    
    if [ $exit_code -ne 0 ]; then
        log_error "Export failed with exit code $exit_code"
        tail -20 "$log_file"
        return 1
    fi
    
    log_info "Export completed successfully"
    return 0
}

################################################################################
# VERIFY EXPORT OUTPUT
################################################################################

check_export_output() {
    local build_project=$1
    local profile_name=$2
    
    if [ ! -f "$build_project" ]; then
        log_error "Export binary not found: $build_project"
        return 1
    fi
    
    local file_size=$(du -h "$build_project" | cut -f1)
    log_info "Export successful! Binary size: $file_size"
    
    # Make Linux binary executable
    if [ "$profile_name" = "Linux" ] || [ "$profile_name" = "Mac" ]; then
        chmod +x "$build_project"
        log_info "Made binary executable"
    fi
    
    return 0
}

################################################################################
# PROMPT TO RUN BINARY
################################################################################

prompt_run_binary() {
    local build_project=$1
    local profile_name=$2
    
    # Skip for Web
    if [ "$profile_name" = "Web" ]; then
        return 0
    fi
    
    if [ ! -f "$build_project" ]; then
        return 0
    fi
    
    echo ""
    read -p "Do you want to run the exported binary? (y/n, default=n) " -t 5 -n 1 -r run_binary
    echo ""
    
    if [[ $run_binary =~ ^[Yy]$ ]]; then
        log_info "Starting: $build_project"
        "$build_project" || {
            log_warn "Binary execution failed or returned non-zero code"
        }
    fi
}

################################################################################
# MAIN EXECUTION
################################################################################

main() {
    # Handle CLI parameters
    case "${1:-}" in
        --help)
            show_help
            exit 0
            ;;
        --init)
            log_section "Generating Default Configuration"
            if generate_default_config; then
                log_info "build_config.json created successfully"
                log_info "Edit the file to customize your build settings"
                exit 0
            else
                log_error "Failed to generate configuration"
                exit 1
            fi
            ;;
        --version)
            echo "Godot Project Build Script v1.0"
            exit 0
            ;;
        "")
            # Normal build mode
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Use './cli_work.sh --help' for usage information"
            exit 1
            ;;
    esac
    
    # Find project directory
    PROJECT_DIR=$(find_project_directory) || exit 1
    cd "$PROJECT_DIR" || exit 1
    
    log_section "Godot Project Build & Export Script"
    log_info "Project directory: $PROJECT_DIR"
    echo ""
    
    # Load configuration
    log_info "Loading configuration from build_config.json..."
    if ! load_config_from_json; then
        log_error "Configuration loading failed"
        exit 1
    fi
    log_info "Configuration loaded successfully"
    echo ""
    
    # Check project structure
    if ! check_project_directory; then
        exit 99
    fi
    
    # Setup Godot path
    if [ -z "$GODOT_PATH" ]; then
        GODOT_PATH=$(detect_godot_executable) || {
            log_error "Godot executable not found"
            exit 1
        }
        log_info "Auto-detected Godot at: $GODOT_PATH"
    fi
    
    # Verify Godot version
    log_info "Verifying Godot version..."
    if ! verify_godot_version; then
        exit 1
    fi
    echo ""
    
    # Check engine
    if ! check_engine; then
        exit 99
    fi
    echo ""
    
    # Execute import once for all profiles
    log_section "Resource Import Phase"
    log_info "Importing project resources..."
    IMPORT_LOG="$PROJECT_DIR/.import.log.txt"
    if ! execute_import "$IMPORT_LOG"; then
        exit 99
    fi
    echo ""
    
    # Process each profile
    log_section "Export Profiles ($PROFILE_COUNT)"
    
    for ((i=0; i<PROFILE_COUNT; i++)); do
        profile_data=$(get_profile_data "$i")
        IFS='|' read -r PROFILE_NAME EXPORT_TYPE PLATFORM OUTPUT_TEMPLATE PROFILE_EXPORT_PATH <<< "$profile_data"
        
        log_section "Profile $((i+1))/$PROFILE_COUNT: $PROFILE_NAME"
        log_info "Type: $EXPORT_TYPE"
        log_info "Platform: $PLATFORM"
        
        # Determine export path
        if [ -n "$PROFILE_EXPORT_PATH" ]; then
            PROFILE_EXPORT_DIR=$(resolve_export_path "$PROFILE_EXPORT_PATH")
        else
            PROFILE_EXPORT_DIR=$(resolve_export_path "$EXPORT_PATH")
        fi
        
        # Create export directory
        PROFILE_FOLDER="$PROFILE_EXPORT_DIR/$PROFILE_NAME"
        mkdir -p "$PROFILE_FOLDER" || {
            log_error "Failed to create export directory"
            exit 99
        }
        log_info "Export directory: $PROFILE_FOLDER"
        
        # Generate output filename
        GENERATED_FILENAME=$(generate_output_filename "$OUTPUT_TEMPLATE" "$PROFILE_NAME" "$EXPORT_TYPE" "$PLATFORM")
        
        # Add suffix with proper separators
        local suffix_separator=""
        if [ "$USE_SEPARATORS" = "true" ] && [ -n "$VERSION_SUFFIX" ]; then
            # Check if VERSION_SUFFIX already starts with underscore
            if [[ ! "$VERSION_SUFFIX" =~ ^_ ]]; then
                suffix_separator="_"
            fi
        fi
        
        # Add suffix and extension
        if [ "$PROFILE_NAME" = "Windows" ]; then
            BUILD_BIN="${GENERATED_FILENAME}${suffix_separator}${VERSION_SUFFIX}.exe"
        elif [ "$PROFILE_NAME" = "Linux" ]; then
            BUILD_BIN="${GENERATED_FILENAME}${suffix_separator}${VERSION_SUFFIX}.x86_64"
        elif [ "$PROFILE_NAME" = "Web" ]; then
            BUILD_BIN="${GENERATED_FILENAME}${suffix_separator}${VERSION_SUFFIX}"
        else
            BUILD_BIN="${GENERATED_FILENAME}${suffix_separator}${VERSION_SUFFIX}"
        fi
        
        BUILD_PROJECT="$PROFILE_FOLDER/$BUILD_BIN"
        BUILD_LOG="$PROFILE_FOLDER/${PROJECT_NAME}_export.log.txt"
        
        log_info "Output binary: $BUILD_BIN"
        
        # Delete old binary
        delete_old_binary "$BUILD_PROJECT" || exit 99
        
        # Export
        if ! execute_export "$PROFILE_NAME" "$EXPORT_TYPE" "$BUILD_PROJECT" "$BUILD_LOG"; then
            exit 99
        fi
        
        # Verify
        if ! check_export_output "$BUILD_PROJECT" "$PROFILE_NAME"; then
            exit 99
        fi
        
        # Offer to run
        if [ $PROFILE_COUNT -eq 1 ]; then
            prompt_run_binary "$BUILD_PROJECT" "$PROFILE_NAME"
        fi
        
        echo ""
    done
    
    log_section "Build Process Completed"
    log_info "All profiles exported successfully!"
    log_info "Exports location: $PROFILE_EXPORT_DIR"
    
    exit 0
}

# Run main function
main "$@"
