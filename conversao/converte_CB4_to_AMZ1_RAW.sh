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

# Definindo o nome dos arquivos
AMZ_RAW='AMAZONIA_1_WFI_RAW_'$data_hora'_'$antena
		
/usr/local/bin/station_drd_to_raw $path_passagem/$CB4_DRD $path_exe/$AMZ_RAW	
exit
