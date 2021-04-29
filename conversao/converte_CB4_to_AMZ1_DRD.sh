#!/bin/bash 
# Define variaveis locais #
ingestora=$1
path_exe="/TEMP/$ingestora"
antena='CP5'

cd $path_exe
AMZ_RAW=`ls -1 AMAZONIA_1_WFI_RAW*`		 
data_hora=`echo $AMZ_RAW |cut -d '_' -f5- `
AMZ_DRD='AMAZONIA_1_WFI_DRD_'$data_hora
		
/usr/local/bin/station_raw_to_drd  $AMZ_RAW AMAZONIA 1 WFI  $AMZ_DRD

rm $AMZ_RAW
exit
