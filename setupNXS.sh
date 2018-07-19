#!/usr/bin/env bash

if ! [ -x "$(command -v julia)" ]; then
  echo 'Error: julia is not installed.' >&2
  exit 1
fi
VERPROG='(vM=0; vm=6; V=VERSION; VM=V.major;Vm=V.minor; (vM==VM&&vm==Vm) ? "$V tested OK" : (VM>vM||(VM==vM&&Vm>vm)) ? "$V is newer than tested" : "$V is older than tested, expect syntax errors")'
VERINFO=`julia --startup-file=no --history-file=no -E "$VERPROG"|sed "s/\"//g"`
echo "Your julia version" $VERINFO

julia --history-file=no setupNXS.jl
