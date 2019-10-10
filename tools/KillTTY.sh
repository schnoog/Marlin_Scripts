#!/bin/bash
echo "Stoppe TTY"
screen -ls | grep tty | cut -d "." -f 1 | awk '{print $1}' | xargs kill

