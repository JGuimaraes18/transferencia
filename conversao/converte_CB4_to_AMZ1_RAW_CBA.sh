#!/bin/bash

# Define variaveis locais #
CB4_DRD=$1
ingestora=$2
path_passagem="/home/transfoper/TEMP-PASSAGEM/$ingestora/"
path_exe="/TEMP/$ingestora"
antena=$3
mkdir -p $path_exe

cd $path_passagem
data_hora=`echo $CB4_DRD |cut -d '_' -f5- `
cp $path_passagem/$CB4_DRD $path_exe
cd $path_exe

# Definindo o nome dos arquivos
AMZ_RAW='AMAZONIA_1_WFI_RAW_'$data_hora'_'$antena
		
/usr/local/bin/station_drd_to_raw $CB4_DRD $AMZ_RAW	

rm $CB4_DRD
exit
