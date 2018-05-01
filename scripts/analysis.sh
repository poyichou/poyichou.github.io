#!/bin/sh
#first 5 largest file under your directory
ls -R -A -l | grep '^[-d]' | sort -k 5 -n | awk '{print $5, $9} /^-/ {fn+=1} /^-/ {fs+=$5} /^d/ {dn+=1} END {print "7b: "fn "\n" "6a: "fs "\n" "8c: "dn}' | tail -n 8 | sort -n -r | awk '{print NR ":" $1, $2}' | sed -e 's/[6-8]://g' -e 's/8c:/Dir num:/g' -e 's/7b:/File num:/g' -e 's/6a:/Total:/g'
