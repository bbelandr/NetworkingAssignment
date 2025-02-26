# Benjamin Belandres
# I worked together with Alec Merkle (amerkle) to get this lab done. He recently contracted a norovirus
# that left him unable to attend class, so he needed to catch up.
# 2-25-2025
# COSC-540-001
# GitHub Repo: https://github.com/bbelandr/NetworkingAssignment.git

#!/bin/bash
#####################################################
#
# script: reducePing.sh
#
# This script is meant to provide practice with bash and in 
# particular, pipelines
#
# The input data file always has a top line showing the IP address
#  Followed by the iteration results
# Ending with 4 lines that include blank, text, summary 1, summary 2
# 
#  PING 172.19.0.1 (172.19.0.1) 32(60) bytes of data.
#   [1727620148.344279] 40 bytes from 172.19.0.1: icmp_seq=1 ttl=64 time=1.23 ms
#  ....
#   [1727620152.864855] 40 bytes from 172.19.0.1: icmp_seq=10 ttl=64 time=1.09 ms
#
# --- 172.19.0.1 ping statistics ---
# 10 packets transmitted, 10 received, 0% packet loss, time 5851ms
# rtt min/avg/max/mdev = 0.600/0.931/7.559/0.270 ms
#
# Last update  2/20/2025
#
#####################################################

# To have the script quit on first error- otherwise it ignores all errors
set -e
#
#Turn on debugging
#set -x
#
#If a script  is not behaving, try :  bash -u script.sh #
#Also use shellcheck -  super helpful
# A script can call set to set options


myScriptName=$0
#Set to >1 matching the number of required params
MinNumberRequiredParams=1

#####################################################
#
# script: function askToExit() {
#   Called to query the user to exit or proceed
#   This will do an exit if the user choses
#
#
#####################################################
function askToExit() {

  rc=$NOERROR
  choice="n"
  echo "$0 Do you want to continue or quit ? (y to continue anything else quits) "
  read choice
  if [ "$choice" == "y" ]; then
    rc=$NOERROR
  else
    echo "$0: ok...we will exit "
    exit
  fi
  return $rc
}

usage () 
{
   echo "Usage  $myScriptName: MinNumberRequiredParams:$MinNumberRequiredParams "
   echo "  This script is a start to reducing the ping output data contained in the file name "
   echo ""
   echo "--->$myScriptName  [filename] "
   echo "     filename:  the name of the file containing the ping output data"
   echo ""
   echo "--->Example:  $myScriptName  tmp.dat "
   echo ""
}

INTEGER_REGEXP='^[1-9][0-9]*$'
MODE_REGEXP='^(1|2|3)$'




# ensure 2 args were passed
if (( $# != $MinNumberRequiredParams )) ; then
  echo "$myScriptName: HARD ERROR:  missing operands ($# entered, min is $MinNumberRequiredParams)"
  usage
  exit -1
fi

myFile="$1"

echo "$0: Entered param:  myFile:$myFile "

FILENAME="$1"

if [ -z "$FILENAME" ] ; then
  usage
  exit 0
fi

echo "$0:($LINENO): About to find info for file: $FILENAME,   ok? "
askToExit

Samples=$(tail +2 $FILENAME | head -n -4 | sed 's/\[//g' | sed 's/\]//g' | awk '{print $1, $8, $6}' | sed 's/time=//g' | sed 's/icmp_seq=//g' | awk '{printf "%9.9f %6.9f %s\n", $1, $2, $3}' )
echo "$Samples" > RTT3.dat


if [ -e $FILENAME ] ; then
  numberSamples=$(cat $FILENAME | wc -l)
  echo "$0: File:$FILENAME has $numberSamples samples "

else
  echo "$myScriptName: HARD ERROR:  File does not exist."
fi


