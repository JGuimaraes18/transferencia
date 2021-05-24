#!/bin/bash

TEMP=$1
DRD=$2
SENSOR=$3
ANO_MES=$4

cd $TEMP

case $SENSOR in
	I)
		sir=SIR1
		;;
	Q)	
		sir=SIR2
		;;
esac

DATA=`echo $DRD |cut -d '_' -f5-`
NOME_DADO='LANDSAT_7_'$sir'_RAW_'$SENSOR'_'$DATA

STORAGE="/TEMP/Level-0/LANDSAT7/$ANO_MES/ETM"

mkdir -p $STORAGE

cp $DRD $STORAGE/$NOME_DADO
exit
