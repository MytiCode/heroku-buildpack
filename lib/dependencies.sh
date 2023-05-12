#!/usr/bin/env bash

list_dependencies() {
  local build_dir="$1"
  cd "$build_dir" || return
  (pnpm ls --depth=0 | tail -n +2 || true) 2>/dev/null
}

pnpm_node_modules() {
  local build_dir=${1:-}
  if [ -e "$build_dir/package.json" ]; then
    cd "$build_dir" || return
    pnpm install 2>&1
  else
    echo "Skipping (no package.json)"
  fi
}

pnpm_prune_devdependencies() {
  local build_dir=${1:-}
  if [[ "$NPM_CONFIG_PRODUCTION" == "true" ]] ; then
      production="true"
      cd "$build_dir" || return
      pnpm prune 2>&1
  fi
}
