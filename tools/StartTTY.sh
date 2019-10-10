#!/bin/bash


PORT=""
SPORT=0
FINALTTY=""

echo "Suche seriellen Port"
while [ $SPORT -lt 10 ]
do
TTY="/dev/ttyUSB""$SPORT"
#echo "Pruefe $TTY"
CHECKME=$( ls $TTY 2>/dev/null )
if [ "$CHECKME" != "" ]
then
FINALTTY=$TTY
#echo "Gefunden $TTY"
SPORT=99
else
let SPORT=$SPORT+1
#echo "Nicht da: $TTY"
fi

done


if [ "$FINALTTY" == "" ]
then
echo "Kein serieller Anschluss gefunden"

exit 1
fi


isrunning=$(screen -ls | grep tty | cut -d "." -f 1 | awk '{print $1}')
if [ "$isrunning" != "" ]
then
echo "TTY is running"

else
rm screenlog.0
echo "Starte TTY auf $FINALTTY"
screen -L -d -m -S tty $FINALTTY 115200
fi





