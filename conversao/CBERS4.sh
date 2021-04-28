#!/bin/bash 

servidor=$1
passagem=$2
sensor=$3
contatos='joao.guimaraes@inpe.br'

servidor=`echo $servidor | tr [A-Z] [a-z]` 

ano=`echo $passagem |cut -d '-' -f2`
mes=`echo $passagem |cut -d '-' -f3`

path_origem="/mnt/$servidor/$passagem"
path_destino='/Level-0/CBERS4/'$ano'_'$mes/$sensor

mkdir -p $path_destino
cd $path_origem
CB4_ORIG=`ls CBERS*`
CB4=$CB4_ORIG'_CP5'
cp $CB4_ORIG $path_destino/$CB4

echo "Dado $CB4 disponível no Level-0 para processamento" | mail -s "Dado $CB4 Disponível" $contatos
exit
