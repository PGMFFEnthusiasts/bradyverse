#!/bin/bash

if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

process_template() {
    local input_file="$1"
    local output_file="$2"

    # Run gomplate
    if gomplate -f "$input_file" | sed -r '/^\s*$/d' > "$output_file"; then
        # todo: remove this branch
        # rm -f "$input_file"
        echo "rendered $input_file"
    else
        # echo "gomplate rendering failed. Input file not removed."
        echo "gomplate rendering failed."
        return 1
    fi
}


if [ ! -f "start.sh" ]; then
  echo "🌌 Welcome to the Bradyverse"
  cp -rT /template /server
  rm /server/bootstrap.sh
fi

if [ -f vars.env ]; then
    source vars.env
    rm -f vars.env
fi

ln -s /server/tom-brady/includes/ plugins/PGM/

process_template "server.properties.tmpl" "server.properties"
process_template "sportpaper.yml.tmpl" "sportpaper.yml"
process_template "plugins/Share/config.yml.tmpl" "plugins/Share/config.yml"

./start.sh
