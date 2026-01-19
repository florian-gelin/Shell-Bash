#!/bin/bash

tel="$1"

if [[ "$tel" =~ ^(0|\+33|0033)[1-9][0-9]{8}$ ]]; then
    echo "Numéro correct"
else
    echo "Numéro incorrect"
fi
