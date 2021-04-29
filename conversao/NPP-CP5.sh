#!/bin/bash 

passagem=$1
sensor='VIIRS'
servidor='solaria'
satelite='NPP'
formato='RAW'

path_exe='/home/transfoper/bin'
path_origem="/mnt/$servidor/$passagem"
path_convert='/TEMP'
cmd_raw="$path_exe/converte_CB4_to_AQUA_TERRA_NPP_NOAA20_RAW.sh"

cd $path_origem
DRD=`ls CBERS*`
ano_mes=`echo $DRD |cut -d '_' -f5-6`
data_hora=`echo $DRD |cut -d '_' -f5-`
path_destino='/Level-0/'$satelite/$ano_mes/$sensor
mkdir -p $path_convert
mkdir -p $path_destino

RAW=$satelite'_'$formato'_'$data_hora'_CP5'
$cmd_raw $passagem $RAW $DRD
cp $path_convert/$RAW $path_destino

echo "Dado $RAW disponível no Level-0 para processamento" | mail -s "Dado $RAW Disponível" $contatos

exit
