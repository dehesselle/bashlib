#!/usr/bin/env bash

# purpose:
# Setup post-checkout hook for git repository. This is a one-time thing you have
# to do after cloning this repository.

MY_DIR=$(dirname $0)
ln -sf '../../hooks/post-checkout' $MY_DIR/.git/hooks
