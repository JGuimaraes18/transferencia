#!/bin/bash 

data=$1
horario=$2
montagem=$3
satelite='AQUA'
antena='CP6'
sensor='MODIS'
sat='Aqua'
sufixo='CADU'
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

cd $montagem/$sat/$data/*$horario
DADO_INGEST=`ls *.vcdu`

cp $DADO_INGEST $path_destino/$DADO

echo "Dado $DADO disponível no Level-0 para processamento" | mail -s "Dado $DADO Disponível" $contatos
exit
