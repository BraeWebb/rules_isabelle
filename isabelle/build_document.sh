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

mv "${session_dir}/${build_dir}/document.pdf" "${dest}"