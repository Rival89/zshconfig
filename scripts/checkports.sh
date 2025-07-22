#!/bin/bash

# A script to check for open ports and kill the processes using them.

sudo lsof -i -P -n | gum choose | awk '{print $2}' | xargs sudo kill
