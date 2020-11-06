#!/bin/bash

isabelle=$1
session_dir=$2
session=$3
dest=$4
release=$5

# add fake pdflatex script to PATH
DIR=$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )
export PATH="${DIR}:${PATH}"

build_dir="output"
HOME="." ${isabelle} build \
    -d "${session_dir}" \
    -o browser_info \
    "${session}"

mkdir -p "${dest}"
cp -R ".isabelle/Isabelle${release}/browser_info/." "${dest}"
cp -R "${session_dir}/.isabelle/Isabelle${release}/browser_info/." "${dest}"
