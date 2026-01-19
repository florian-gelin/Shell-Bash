#!/bin/bash

if [[ "$1" =~ ^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,}$ ]]; then
    echo "Adresse correcte"
else
    echo "Mauvais Format"
fi
