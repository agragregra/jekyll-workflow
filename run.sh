#!/bin/bash

set -e # Exit on error

# Configuration variables
output_dir="dist/"
deploy_server="user@server.com:path/to/public_html/"
rsync_options="-avz --delete --delete-excluded --include=*.htaccess"
jekyll_config="_config.yml,_config_dev.yml"
js_sources="src/scripts/*.js"
js_output_dir="src/scripts/dist/"
preview_host="192.168.1.126"
preview_port="3000"
compression_options="-t7z -mx=9 -m0=LZMA2 -mmt=on"

# Core commands
run_dev() {
  check_deps "jekyll" "esbuild"
  trap run_clean INT
  jekyll serve --host 0.0.0.0 --watch --force_polling --livereload --incremental --config "$jekyll_config" &
  esbuild "$js_sources" --bundle --outdir="$js_output_dir" --minify --watch
  wait
}
run_build() {
  check_deps "jekyll" "esbuild"
  build_js
  build_jekyll
}
run_backup() {
  check_deps "7z"
  jekyll clean
  local dir_name="$(basename "$(pwd)")"
  local current_date=$(date +%d-%m-%Y)
  7z a $compression_options -x!"$dir_name/dist" -x!"$dir_name/node_modules" "./$dir_name-$current_date.7z" "$(pwd)"
}
run_deploy() {
  check_deps "jekyll" "esbuild" "rsync"
  trap run_clean INT
  jekyll clean
  build_js
  build_jekyll
  rsync $rsync_options "$output_dir" "$deploy_server" || { echo "Deploy failed: rsync error"; exit 1; }
  jekyll clean
}
run_preview() {
  check_deps "jekyll"
  trap run_clean INT
  jekyll serve --watch --host "$preview_host" --port "$preview_port"
}
run_watch() {
  check_deps "esbuild" "jekyll"
  trap run_clean INT
  jekyll build --watch --force_polling &
  esbuild "$js_sources" --bundle --outdir="$js_output_dir" --minify --watch
  wait
}
run_clean() {
  check_deps "jekyll"
  jekyll clean
}

# Build-related functions
build_js() {
  esbuild "$js_sources" --bundle --outdir="$js_output_dir" --minify
}
build_jekyll() {
  jekyll build
}

# Docker commands
run_up() {
  check_deps "docker-compose"
  sudo chmod -R 777 .
  docker-compose up -d
}
run_down() {
  check_deps "docker-compose"
  docker-compose down
}
run_bash() {
  check_deps "docker-compose"
  docker-compose exec jekyll bash
}
run_prune() {
  check_deps "docker"
  docker system prune -af --volumes
}

# Main function
main() {
  local cmds=($(declare -F | awk '{print $3}' | grep '^run_'))
  local cmd_list=("${cmds[@]#run_}")
  local cmd="$1" usage="Usage: $0 {"
  [[ -z "$cmd" || ! " ${cmd_list[*]} " =~ " $cmd " ]] && {
    for c in "${cmd_list[@]}"; do usage+=" $c |"; done
    echo "${usage%|} }" >&2
    exit 1
  }
  "run_$cmd"
}

# Check dependencies
check_deps() {
  local deps=("$@")
  local missing=()
  for dep in "${deps[@]}"; do
    command -v "$dep" >/dev/null 2>&1 || missing+=("$dep")
  done
  if [ ${#missing[@]} -ne 0 ]; then
    echo "Missing dependencies: ${missing[*]}"
    exit 1
  fi
}

main $@
