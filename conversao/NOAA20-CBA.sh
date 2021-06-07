#!/bin/bash 

data=$2
horario=$3
montagem=$1
satelite='NOAA20'
antena='CB3'
sensor='VIIRS'
sufixo='RAW'
contatos='joao.guimaraes@inpe.br'

ano=`echo $data |cut -d '-' -f1`
mes=`echo $data |cut -d '-' -f2`
dia=`echo $data |cut -d '-' -f3`
hora=`echo $horario |cut -d '-' -f1`
min=`echo $horario |cut -d '-' -f2`
seg=`echo $horario |cut -d '-' -f3`

DADO=$satelite'_'$sufixo'_'$ano'_'$mes'_'$dia'.'$hora'_'$min'_'$seg'_'$antena

path_destino='/Level-0/'$satelite'/'$ano'_'$mes'/'$sensor
mkdir -p $path_destino

cd $montagem/$data*
DADO_INGEST=`ls *.vcdu`

cp $DADO_INGEST $path_destino/$DADO

rm -rf $montagem

echo "Dado $DADO disponível no Level-0 para processamento" | mail -s "Dado $DADO Disponível" $contatos
exit
