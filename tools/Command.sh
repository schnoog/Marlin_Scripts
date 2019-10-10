#!/bin/bash

COMMAND="$*"

if [ "$COMMAND" == "" ]
then
COMMAND="M115"
fi
echo $COMMAND >> "command.log"

echo "Sending Command - $COMMAND -"
screen -S tty -p 0 -X stuff "$COMMAND""\n\r"
