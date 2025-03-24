#!/bin/bash

# Set error handling
set -e  # Exit on error

# Configuration variables
output_dir="dist/"
deploy_server="user@server.com:path/to/public_html/"
rsync_options="avz --delete --delete-excluded --include=*.htaccess"
jekyll_config="_config.yml,_config_dev.yml"
js_source_dir="src/scripts/*.js"
js_output_dir="src/scripts/dist/"
preview_host="192.168.1.126"
preview_port="3000"
backup_compression_options="-t7z -mx=9 -m0=LZMA2 -mmt=on"
backup_date_format="+%d-%m-%Y"

# Function to get directory name
get_dir_name() {
  basename "$(pwd)"
}

# Function to get current date (cross-platform)
get_current_date() {
  date $backup_date_format
}

# Function to check dependencies
check_deps() {
  local deps=($@)
  local missing=()

  for dep in "${deps[@]}"; do
    command -v "$dep" >/dev/null 2>&1 || missing+=("$dep")
  done

  if [ ${#missing[@]} -ne 0 ]; then
    echo "${missing[*]} is not installed"
    exit 1
  fi
}

# Build-related functions
build_js() {
  esbuild $js_source_dir --bundle --outdir=$js_output_dir --minify
}

build_jekyll() {
  jekyll build
}

# Main commands
dev() {
  check_deps "jekyll" "esbuild"
  jekyll serve --host 0.0.0.0 --watch --force_polling --livereload --incremental --config $jekyll_config &
  esbuild $js_source_dir --bundle --outdir=$js_output_dir --minify --watch=forever &
}

build() {
  check_deps "jekyll" "esbuild"
  build_js
  build_jekyll
}

deploy() {
  check_deps "jekyll" "esbuild" "rsync"
  jekyll clean
  build_js
  build_jekyll
  rsync $rsync_options $output_dir $deploy_server
  jekyll clean
}

backup() {
  check_deps "7z"
  jekyll clean
  local dir_name=$(get_dir_name)
  local current_date=$(get_current_date)
  7z a $backup_compression_options -x!$dir_name/dist -x!$dir_name/node_modules ./$dir_name-$current_date.7z $(pwd)
}

preview() {
  check_deps "jekyll"
  jekyll serve --watch --host $preview_host --port $preview_port
}

watch() {
  check_deps "esbuild" "jekyll"
  echo "Starting esbuild watch..."
  esbuild $js_source_dir --bundle --outdir=$js_output_dir --minify --watch=forever &
  jekyll build --watch --force_polling &
}

# Handle arguments
main() {
  case $1 in
    "dev")   dev   ;;
    "build")   build   ;;
    "deploy")  deploy  ;;
    "backup")  backup  ;;
    "preview") preview ;;
    "watch")   watch   ;;
    *)
      echo "Usage: $0 { dev | build | deploy | backup | preview | watch }"
      exit 1
      ;;
  esac
}

main $@
