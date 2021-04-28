#!/bin/bash 

########################################################################################
# Script que realiza a conversao de dados no formato DRD_CBERS-4 para RAW_AQUA via ms3 #
# Autor: Joao Guimaraes                                              #
# Data: 19/04/2021                                                                     #
########################################################################################

# Define variaveis locais #
passagem=$1
DRD=$3
path_passagem="/mnt/solaria/disco1/A1/$passagem"
path_raw="/TEMP/$2"


cd $path_passagem
/usr/local/bin/station_drd_to_raw $path_exe/$DRD $path_raw
exit
