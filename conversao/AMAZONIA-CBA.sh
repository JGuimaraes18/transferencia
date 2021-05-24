#!/bin/bash

path_origem=$1
passagem=$2
sensor=$3		
contatos='joao.guimaraes@inpe.br'
ano_mes=$4
antena=$5
servidor=$6

path_exe='/home/transfoper/bin'
path_convert='/TEMP/'$servidor
path_destino='/TEMP/Level-0/AMAZONIA1/'$ano_mes/$sensor
mkdir -p $path_destino

cmd_raw="$path_exe/converte_CB4_to_AMZ1_RAW_CBA.sh"
cmd_drd="$path_exe/converte_CB4_to_AMZ1_DRD_CBA.sh"

$cmd_raw $passagem $servidor $antena
$cmd_drd $servidor $antena
cd $path_convert
DADO=`ls AMAZONIA*`
cp $DADO $path_destino
echo "Dado $DADO disponível no Level-0 para processamento" | mail -s "Dado $DADO Disponível" $contatos	

cd $path_convert
rm AMAZONIA*
exit
