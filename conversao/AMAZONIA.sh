#!/bin/bash
source email.sh

servidor=$1
passagem=$2
sensor='WFI'		
servidor=`echo $servidor | tr [A-Z] [a-z]` 
ano=`echo $passagem |cut -d '-' -f2`
mes=`echo $passagem |cut -d '-' -f3`

ftp='HOST'
user='USER'
dirDPI='/cdsr/VPN/AMAZONIA'

path_exe='/home/transfoper/bin'
path_origem="/TEMP/$servidor"
path_destino='/Level-0/AMAZONIA1/'$ano'_'$mes/$sensor

cmd_raw="$path_exe/converte_CB4_to_AMZ1_RAW.sh"
cmd_drd="$path_exe/converte_CB4_to_AMZ1_DRD.sh"

$cmd_raw $passagem $servidor
$cmd_drd $servidor
cd $path_origem
DADO=`ls AMAZONIA*`
mkdir -p $path_destino
cp $DADO $path_destino

enviaEmail $DADO

scp $DADO $user@$ftp:@$dirDPI

cd $path_origem
rm AMAZONIA*
exit
