#!/usr/bin/env bash

source "$BP_DIR/lib/failure.sh"

list_dependencies() {
  local -r build_dir="$1"
  cd "$build_dir" || fail
  (pnpm ls --depth=0 | tail -n +2 || true) 2>/dev/null
}

pnpm_node_modules() {
  local -r build_dir=${1:-}
  if [ -e "$build_dir/package.json" ]; then
    cd "$build_dir" || fail
    # N.B. the echo is to send an enter to pnpm install. This files an edge that can cause builds to fail
    # if we drastically modify how we utilize pnpm in the build process, possibly also in our repo. Under certain
    # changes, a wholesale rebuild of node_modules is triggered, resulting in the following prompt:
    #
    # The modules directory at "..." will be removed and reinstalled from scratch. Proceed? (Y/n) ‣ true
    echo | NODE_ENV= pnpm install --frozen-lockfile 2>&1
  else
    echo "Skipping (no package.json)"
  fi

#   # Workaround pnpm metadata issue where it's not always installed and can only be
#   # forced via pnpm update. This will ensure the metadata cache is built without modifying
#   # our checked in package.json.
#   local -r temp_dir=$(mktemp -d) || fail
#   echo "-- Applying pnpm offline metadata workaround in temp directory: ${temp_dir}"
#   cp "${build_dir}/package.json" "${temp_dir}"
#   printf "    \u2713  root package.json copied: ${temp_dir}\n"
#   pnpm -C "${temp_dir}" update --lockfile-only > /dev/null
#   printf "    \u2713  executed pnpm update --lockfile-only to generate offline metadata\n"
#   rm -rf "${temp_dir}"
#   printf "    \u2713  temp directory cleaned up\n"
}
