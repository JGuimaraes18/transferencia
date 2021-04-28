#!/bin/bash 

########################################################################################
# Script que realiza a conversao de dados no formato DRD_CBERS-4 para DRD_AMZ1 via ms3 #
# Autor: Reuel Junqueira / Joao Guimaraes                                              #
# Data: 17/03/2021                                                                     #
########################################################################################
# Define variaveis locais #
passagem=$1
ingestora=$2
path_passagem="/mnt/$ingestora/disco1/A1/$passagem"
path_exe="/TEMP/$ingestora"
antena='CP5'

cd $path_passagem
CB4_DRD=`ls -1 CBERS_4_*DRD*`		 
data_hora=`echo $CB4_DRD |cut -d '_' -f5- `
ano_mes=`echo $data_hora |cut -d '_' -f1-2`

# Definindo o nome dos arquivos
AMZ_RAW='AMAZONIA_1_WFI_RAW_'$data_hora'_'$antena
AMZ_DRD='AMAZONIA_1_WFI_DRD_'$data_hora'_'$antena
		
/usr/local/bin/station_raw_to_drd  $path_exe/$AMZ_RAW AMAZONIA 1 WFI  $path_exe/$AMZ_DRD

rm $path_exe/$AMZ_RAW
exit
