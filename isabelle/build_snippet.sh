#!/bin/bash

isabelle=$1
session_dir=$2
session=$3
dest=$4

# add fake pdflatex script to PATH
DIR=$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )
export PATH="${DIR}:${PATH}"
echo $PATH

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
