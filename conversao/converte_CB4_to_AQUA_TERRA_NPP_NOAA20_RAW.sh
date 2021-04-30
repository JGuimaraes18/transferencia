#!/bin/bash 
# Define variaveis locais #
passagem=$1
RAW=$2
DRD=$3
path_passagem="/mnt/solaria/$passagem"
path_exe="/TEMP/solaria"

cp $path_passagem/$DRD $path_exe
cd $path_exe
/usr/local/bin/station_drd_to_raw $path_exe/$DRD $path_exe/$RAW
rm $path_exe/$DRD

exit
