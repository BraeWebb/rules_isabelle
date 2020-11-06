#!/bin/bash

isabelle=$1
latex=$2
session_dir=$3
session=$4
main_dest=$5
srcs_dest=$6

# add fake pdflatex script to PATH
DIR=$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )
export PATH="${PATH}:${DIR}"

# build tex files with Isabelle
build_dir="output"
HOME="." ${isabelle} build \
    -d "${session_dir}" \
    -o document=pdf \
    -o document_output="${build_dir}" \
    "${session}"

# copy output to expected locations
mv "${session_dir}/${build_dir}/document" "${srcs_dest}"
mv "${srcs_dest}/root.tex" "${main_dest}"
