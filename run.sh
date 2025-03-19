#!/bin/bash

# Set error handling
set -e  # Exit on error

# Function to get directory name
get_dir_name() {
  basename "$(pwd)"
}

# Function to get current date (cross-platform)
get_current_date() {
  date "+%d-%m-%Y"  # Using unified format, modern systems handle it consistently
}

# Function to check dependencies
check_deps() {
  local deps=("$@")
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
  esbuild src/scripts/*.js --bundle --outdir=src/scripts/dist/ --minify
}

build_jekyll() {
  jekyll build
}

# Main commands
dev() {
  check_deps "jekyll" "esbuild"
  jekyll serve --host 0.0.0.0 --watch --force_polling --livereload --incremental --config _config.yml,_config_dev.yml &
  build_js --watch
}

build() {
  check_deps "jekyll" "esbuild"
  build_js
  build_jekyll
}

deploy() {
  check_deps "jekyll" "esbuild" "rsync"
  build_js
  build_jekyll
  rsync -avz --delete --include='*.htaccess' dist/ user@server.com:path/to/public_html/
  jekyll clean
}

backup() {
  check_deps "p7zip"
  jekyll clean
  local dir_name=$(get_dir_name)
  local current_date=$(get_current_date)
  7z a -t7z -mx=9 -m0=LZMA2 -mmt=on -x!"$dir_name/dist" -x!"$dir_name/node_modules" "./$dir_name-$current_date.7z" "$(pwd)"
}

preview() {
  check_deps "jekyll"
  jekyll serve --no-watch --host 192.168.1.126 --port 3000
}

watch() {
  check_deps "jekyll" "esbuild"
  # Run jekyll and esbuild in parallel
  jekyll build --watch --force_polling &
  build_js --watch
}

# Handle arguments
main() {
  case "$1" in
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

main "$@"
