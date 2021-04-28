#!/bin/bash 

data=$1
horario=$2
montagem=$3
satelite='NOAA'
missao='18'
antena='CP1'
sensor='HRPT'
contatos='joao.guimaraes@inpe.br'

ano=`echo $data |cut -d '-' -f1`
mes=`echo $data |cut -d '-' -f2`
dia=`echo $data |cut -d '-' -f3`
hora=`echo $horario |cut -d '-' -f1`
min=`echo $horario |cut -d '-' -f2`
seg=`echo $horario |cut -d '-' -f3`

DADO=$satelite'_'$missao'_'$sensor'_'$ano'_'$mes'_'$dia'.'$hora'_'$min'_'$seg'_'$antena

path_destino='/Level-0/'$satelite$missao'/'$ano'_'$mes'/'$sensor

TEMP='/TEMP/'$satelite$missao'/'$DADO

mkdir -p $path_destino
mkdir -p $TEMP

cd $montagem/$sensor/Archive/$data/*$horario
cp * $TEMP 
cd $montagem/Ancilary_Files/Archive/$data/$hora-$min/
cp * $TEMP
cd $TEMP

mv *.nav $DADO'.nav'
mv *.nmf $DADO'.nmf'
mv *.png $DADO'.png'
mv *.hrpt $DADO'.hrpt'
mv *.info $DADO'.info'
mv *.dcs $DADO'.dcs'
mv *.tbus $DADO'.tbus'

cd ..

tar -czvf $DADO'.tar.gz' $DADO

rm -r $DADO

cp $DADO'.tar.gz' $path_destino

rm $DADO'.tar.gz'

echo "Dado $DADO disponível no Level-0 para processamento" | mail -s "Dado $DADO Disponível" $contatos
exit
