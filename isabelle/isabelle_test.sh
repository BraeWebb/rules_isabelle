#!/bin/bash

isabelle=$1
session_dir=$2
session=$3

echo $isabelle
HOME=$(pwd) ${isabelle} build \
    -d "${session_dir}" \
    -o document=false \
    "${session}"
