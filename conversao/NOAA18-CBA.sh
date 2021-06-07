#!/bin/bash 

montagem=$1
data=$2
horario=$3
satelite='NOAA'
missao='18'
antena=$4
sensor='HRPT'
contatos='joao.guimaraes@inpe.br'

ano=`echo $data |cut -d '-' -f1`
mes=`echo $data |cut -d '-' -f2`
dia=`echo $data |cut -d '-' -f3`
hora=`echo $horario |cut -d '-' -f1`
min=`echo $horario |cut -d '-' -f2`
seg=`echo $horario |cut -d '-' -f3`

DADO=$satelite'-'$missao'_'$sensor'_'$ano'_'$mes'_'$dia'.'$hora'_'$min'_'$seg'_'$antena

path_dado=`echo $montagem |cut -d '/' -f1-6`
path_dado=$path_dado/$DADO
path_destino='/Level-0/'$satelite$missao'/'$ano'_'$mes'/'$sensor

mkdir -p $path_dado $path_destino

cd $montagem
cp -r * $path_dado
cd $path_dado

mv *.nav $DADO'.nav'
mv *.nmf $DADO'.nmf'
mv *.png $DADO'.png'
mv *.hrpt $DADO'.hrpt'
mv *.info $DADO'.info'
mv *.dcs $DADO'.dcs'
mv *.tbus $DADO'.tbus'

cd ../
tar -czvf $DADO'.tar.gz' $DADO
rm -r $montagem $DADO
cp $DADO'.tar.gz' $path_destino
rm $DADO'.tar.gz'

echo "Dado $DADO disponível no Level-0 para processamento" | mail -s "Dado $DADO Disponível" $contatos
exit
