#!/bin/bash 

data=$1
horario=$2
montagem=$3
satelite='METOP'
missao='B'
antena='CP1'
sensor='AHRPT'
contatos='joao.guimaraes@inpe.br'

ano=`echo $data |cut -d '-' -f1`
mes=`echo $data |cut -d '-' -f2`
dia=`echo $data |cut -d '-' -f3`
hora=`echo $horario |cut -d '-' -f1`
min=`echo $horario |cut -d '-' -f2`
seg=`echo $horario |cut -d '-' -f3`

DADO=$satelite'-'$missao'_'$sensor'_'$ano'_'$mes'_'$dia'.'$hora'_'$min'_'$seg'_'$antena

path_dado=$montagem/$sensor/Archive/$data/*$horario
path_epsl0=$montagem/EPS*/Archive/$data/$hora-$min
path_destino='/Level-0/'$satelite$missao'/'$ano'_'$mes'/'$sensor

TEMP='/TEMP/'$satelite$missao'/'$DADO
TEMP_EPSL0=$TEMP'/EPSL0'

mkdir -p $path_destino
mkdir -p $TEMP $TEMP_EPSL0

cd $path_dado
cp * $TEMP 
cd $path_epsl0
cp * $TEMP_EPSL0
cd $TEMP

mv *.nav $DADO'.nav'
mv *.nmf $DADO'.nmf'
mv *.png $DADO'.png'

dados=`ls -1 $ano$mes$dia*`
for x in $dados
do
	sufixo=`echo $x |cut -d '_' -f3`
	mv $x $DADO'_'$sufixo
done

cd $TEMP_EPSL0
dados=`ls -1 *$ano$mes$dia*`
for x in $dados
do
	sufixo=`echo $x |cut -d '_' -f1`
	mv $x $sufixo'_'$DADO
done

cd ../../
tar -czvf $DADO'.tar.gz' $DADO
rm -r $DADO
cp $DADO'.tar.gz' $path_destino
rm $DADO'.tar.gz'

echo "Dado $DADO disponível no Level-0 para processamento" | mail -s "Dado $DADO Disponível" $contatos
exit
