#!/bin/bash 

servidor=$1
passagem=$2
sensor=$3

servidor=`echo $servidor | tr [A-Z] [a-z]` 
ingest="$servidor.dgi.inpe.br"
usuario='cbers'

ano=`echo $passagem |cut -d '-' -f2`
mes=`echo $passagem |cut -d '-' -f3`

path_origem="/mnt/$servidor/$passagem"
path_destino='/home/cdsr/TEMP-TESTE-PASSAGEM/CBERS4/'$ano'_'$mes/$sensor

mkdir -p $path_destino

cp $path_origem'/CBERS'* $path_destino

exit
