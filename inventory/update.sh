#!/usr/bin/env -S zsh -f

for file in *; do
  echo "${0}"
  if [[ "${file}" == "$(basename "${0}")" ]]; then
    continue
  fi
  wget "https://raw.githubusercontent.com/heroku/heroku-buildpack-nodejs/main/inventory/${file}" -O "${file}"
done
