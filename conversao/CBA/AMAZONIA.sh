#!/bin/bash 

dado=$1
path_dado='/home/transfoper/TEMP-PASSAGEM/AMAZONIA'

ANO_MES=`echo $dado |cut -d '_' -f5-6`

STORAGE="/Level-0/AMAZONIA1/$ANO_MES/WFI"

mkdir -p $STORAGE

cp $path_dado/$dado $STORAGE/

exit
