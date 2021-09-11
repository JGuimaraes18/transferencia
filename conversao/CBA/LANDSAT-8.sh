#!/bin/bash 

dado=$1
path_dado='/home/transfoper/TEMP-PASSAGEM/LANDSAT-8'

data=`echo $dado |cut -d '_' -f2` 
dia=`echo $data |cut -c 7-8`
mes=`echo $data |cut -c 5-6`
ano=`echo $data |cut -c 1-4`
horario=`echo $dado |cut -d '_' -f3`
hora=`echo $horario |cut -c 1-2`
min=`echo $horario |cut -c 3-4`
seg=`echo $horario |cut -c 5-6`

ANO_MES=$ano'_'$mes
NOVO_NOME='LANDSAT_8_MD_'$ANO_MES'_'$dia'.'$hora'_'$min'_'$seg'_CB11.tar.gz'
STORAGE="/Level-0/LANDSAT8/MISSION_DATA/$ANO_MES"

mkdir -p $STORAGE

cp $path_dado/$dado $STORAGE/$NOVO_NOME

exit
