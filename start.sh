#!/bin/bash

argc=$#
args=("$@")

function printUsage() {
    echo "USAGE: /bin/bash start.sh {target: integer value, 0 (local), 1 (dev), 2 (prod)}"
}

function init() {
    REGISTRY_ID="hyuk0628"

    if [[ ${argc} -eq 1 ]]; then
        if [[ ${args[0]} -eq 0 ]]; then
            echo "Start local profile services and deployments."
            PROFILE="local"
            TAG="snapshot"
        elif [[ ${args[0]} -eq 1 ]]; then
            echo "Start dev profile services and deployments."
            PROFILE="dev"
            TAG="snapshot"
        elif [[ ${args[0]} -eq 2 ]]; then
            echo "Start prod profile services and deployments."
            PROFILE="prod"
            TAG="release"
        else
            printUsage
            exit 0
        fi
    else
        printUsage
        exit 0
    fi
}
init

function start() {
    for file in $(ls *.yaml); do
        echo $file
        sed "s/@{registry_id}/${REGISTRY_ID}/g" ${file} >.${file}_0
        sed "s/@{tag}/${TAG}/g" .${file}_0 >.${file}_1
        sed "s/@{profile}/${PROFILE}/g" .${file}_1 >.${file}
        rm .${file}_0 .${file}_1

        if [[ ${args[0]} -eq 0 ]]; then
            kubectl apply -f .${file}
        else
            sudo kubectl apply -f .${file}
        fi
    done
}
start
