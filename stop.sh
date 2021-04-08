#!/bin/bash

argc=$#
args=("$@")

function printUsage() {
    echo "USAGE: /bin/bash stop.sh {target: integer value, 0 (local), 1 (dev), 2 (prod)}"
}

function init() {
    if [[ ${argc} -eq 1 ]]; then
        if [[ ${args[0]} -eq 0 ]]; then
            echo "Stop local profile services and deployments."
        elif [[ ${args[0]} -eq 1 ]]; then
            echo "Stop dev profile services and deployments."
        elif [[ ${args[0]} -eq 2 ]]; then
            echo "Stop prod profile services and deployments."
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

function stop() {
    if [[ ${args[0]} -eq 0 ]]; then
        kubectl delete ./*.yaml
    else
        sudo kubectl delete ./*.yaml
    fi

    rm .*.yaml
}
stop
