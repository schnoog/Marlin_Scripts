#!/bin/bash

SUDO=""
UN=$(whoami)
if [ "$UN" != "root" ]
then
SUDO="sudo"
fi

