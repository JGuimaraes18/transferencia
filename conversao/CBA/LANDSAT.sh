#!/bin/bash -x

dado=$1
path_dado='/home/transfoper/TEMP-PASSAGEM/LANDSAT'

ANO_MES=`echo $dado |cut -d '_' -f6-7`

STORAGE="/Level-0/LANDSAT7/$ANO_MES/ETM"

mkdir -p $STORAGE

cp $path_dado/$dado $STORAGE/

exit
