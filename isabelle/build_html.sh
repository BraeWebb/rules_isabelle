#!/bin/bash

isabelle=$1
session_dir=$2
session=$3
dest=$4
release=$5


build_dir="output"
HOME="." ${isabelle} build \
    -d "${session_dir}" \
    -o browser_info \
    "${session}"

mkdir -p "${dest}"
cp -R ".isabelle/Isabelle${release}/browser_info/." "${dest}"
cp -R "${session_dir}/.isabelle/Isabelle${release}/browser_info/." "${dest}"
