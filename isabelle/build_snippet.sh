#!/bin/bash

isabelle=$1
session_dir=$2
session=$3
dest=$4


build_dir="output"
HOME="." ${isabelle} build \
    -d "${session_dir}" \
    -o document=pdf \
    -o document_output="${build_dir}" \
    "${session}"

find "${session_dir}/${build_dir}/document" -type f -name "*.tex" \
    -exec sed -n -e '/\\providecommand{\\DefineSnippet}/n' \
        -e '/\\newcommand{\\Snip}/n' \
        -e '/\\newcommand{\\EndSnip}/n' \
        -e '/\\Snip/,/\\EndSnip/p' {} + | \
    sed -e 's/\\Snip{\([^}]*\)}/\\Snip{\1}{/' \
        -e 's/\\EndSnip/}\%EndSnip/' \
        > "${dest}"
