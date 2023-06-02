#!/usr/bin/env bash

create_signature() {
  echo "v2; ${STACK}; $(node --version); $(npm --version); $(pnpm --version)"
}

save_signature() {
  local -r cache_dir="${1}"
  create_signature > "${cache_dir}/node/signature"
}

load_signature() {
  local -r cache_dir="${1}"
  if test -f "${cache_dir}/node/signature"; then
    cat "${cache_dir}/node/signature"
  else
    echo ""
  fi
}

get_cache_status() {
  local -r cache_dir="${1}"
  if ! ${NODE_MODULES_CACHE:-true}; then
    echo "disabled"
  elif ! test -d "${cache_dir}/node/"; then
    echo "not-found"
  elif [ "$(create_signature)" != "$(load_signature "${cache_dir}")" ]; then
    echo "new-signature"
  else
    echo "valid"
  fi
}

restore_default_cache_directories() {
  local -r build_dir="${1:-}"
  local -r cache_dir="${2:-}"

  # node_modules
  if [[ -e "${cache_dir}/node/cache/node_modules" ]]; then
    echo "- node_modules"
    mkdir -p "$(dirname "${build_dir}/node_modules")"
    mv "${cache_dir}/node/cache/node_modules" "${build_dir}/node_modules"
  else
    echo "- node_modules (not cached - skipping)"
  fi
}

clear_cache() {
  local -r cache_dir="${1}"
  rm -rf "${cache_dir}/node"
  mkdir -p "${cache_dir}/node/cache"
}

save_default_cache_directories() {
  local -r build_dir="${1:-}"
  local -r cache_dir="${2:-}"

  # node_modules
  if [[ -e "${build_dir}/node_modules" ]]; then
    echo "- node_modules"
    mkdir -p "${cache_dir}/node/cache/node_modules"
    cp -al "${build_dir}/node_modules" "${cache_dir}/node/cache/node_modules"
  else
    # this can happen if there are no dependencies
    echo "- node_modules (nothing to cache)"
  fi
}
