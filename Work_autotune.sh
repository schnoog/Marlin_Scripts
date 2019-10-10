#!/bin/bash

#####
BASEPATH=$(realpath $0 | xargs dirname)"/"
CFG="$BASEPATH""bootstrap.sh"
source "$CFG"
#####

cd "$BASEPATH"


STARTPOINT=0
ENDPOINT=4


function Step0 {
	echo " ######## Step 0 start"
	$SUDO ./tools/StartTTY.sh
}


function Step1 {
	echo " ######## Step 1 start"

	$SUDO ./tools/Command.sh "M115"
	sleep 2
}


function Step2 {
	echo " ######## Step 2 start"

	$SUDO ./tools/Command.sh "M106"
	sleep 2
	$SUDO ./tools/Command.sh "M303 E-0 S230 C8"
	echo "PID Autotune started, sleeping 4 minutes"
	sleep 240
	PIDFINISHED=$(grep "PID Autotune finished!" screenlog.0 | wc -l)
	while [ "$PIDFINISHED" == "0" ]
	do
		echo "Sleep another 10s waiting for Autotune finished"
		sleep 10
		PIDFINISHED=$(grep "PID Autotune finished!" screenlog.0 | wc -l)
	done

}

function Step3 {
	echo " ######## Step 3 start"
	grep -A 3 "PID Autotune finished!" screenlog.0 | tail -n 3 > workfile.txt
	

	KI=""
	KP=""
	KD=""

	KP=$(grep DEFAULT_Kp workfile.txt | awk '{print $3}')
	KI=$(grep DEFAULT_Ki workfile.txt | awk '{print $3}')
	KD=$(grep DEFAULT_Kd workfile.txt | awk '{print $3}')
	
	cmdx="M301 P""$KP"" I""$KI"" D""$KD"

	echo $cmdx
	$SUDO ./tools/Command.sh "$cmdx"
	sleep 3
	$SUDO ./tools/Command.sh "M500"



}


function Step4 {
	echo " ######## Step 4 start"
	$SUDO ./tools/KillTTY.sh
}




typeset -i STOP

PT=$STARTPOINT
STOP=$ENDPOINT+1






while [ $PT -lt $STOP ]
do
	cmd="Step""$PT"
	$cmd

	let PT=$PT+1
done



