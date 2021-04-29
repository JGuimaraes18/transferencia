#!/bin/bash 
# Define variaveis locais #
passagem=$1
ingestora=$2
path_passagem="/mnt/$ingestora/$passagem"
path_exe="/TEMP/$ingestora"
antena='CP5'

cd $path_passagem
CB4_DRD=`ls -1 CBERS_4_*DRD*`		 
data_hora=`echo $CB4_DRD |cut -d '_' -f5- `
cp $path_passagem/$CB4_DRD $path_exe
cd $path_exe
AMZ_RAW='AMAZONIA_1_WFI_RAW_'$data_hora'_'$antena
		
/usr/local/bin/station_drd_to_raw $CB4_DRD $AMZ_RAW	

rm $CB4_DRD
exit
