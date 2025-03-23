#!/bin/bash

function char_remover() {
    echo "$1" | tr -d "$2"
}
