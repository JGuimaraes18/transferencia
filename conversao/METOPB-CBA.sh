#!/bin/bash

montagem=$1
data=$2
horario=$3
satelite='METOP'
missao='B'
antena=$4
sensor='AHRPT'
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
path_epsl0=$path_dado/EPSL0
path_destino='/Level-0/'$satelite$missao'/'$ano'_'$mes'/'$sensor

mkdir -p $path_dado $path_destino

cd $montagem
cp -r * $path_dado
cd $path_dado

mv *.nav $DADO'.nav'
mv *.nmf $DADO'.nmf'
mv *.png $DADO'.png'

dados=`ls -1 $ano$mes$dia*`
for x in $dados
do
	sufixo=`echo $x |cut -d '_' -f3`
	mv $x $DADO'_'$sufixo
done

cd $path_epsl0
dados=`ls -1 *$ano$mes$dia*`
for x in $dados
do
	sufixo=`echo $x |cut -d '_' -f1`
	mv $x $sufixo'_'$DADO
done

cd ../../
tar -czvf $DADO'.tar.gz' $DADO
rm -r $montagem $DADO
cp $DADO'.tar.gz' $path_destino
rm $DADO'.tar.gz'

echo "Dado $DADO disponível no Level-0 para processamento" | mail -s "Dado $DADO Disponível" $contatos
exit
