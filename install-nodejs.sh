#!/bin/bash

if ! command -v node &>/dev/null; then
    omarchy-install-dev-env node
fi

if ! command -v laravel &>/dev/null; then
    omarchy-install-dev-env laravel
fi
