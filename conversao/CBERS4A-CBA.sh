#!/bin/bash 

dir_passagem=$1
passagem=`echo $2 |cut -d '/' -f4`
sensor=$3
sufixo=$3
antena=$4

contatos='joao.guimaraes@inpe.br'

cd $dir_passagem
RAW=`ls *raw`

if [ ! -z $RAW ]
	then
	ano=`echo $passagem |cut -d '-' -f1`
	mes=`echo $passagem |cut -d '-' -f2`
	dia=`echo $passagem |cut -d '-' -f3 |cut -c 1-2`
	hora=`echo $passagem |cut -d 'T' -f2 |cut -c 1-2`
	min=`echo $passagem |cut -d ':' -f2`
	seg=`echo $passagem |cut -d ':' -f3 |cut -c 1-2`

	if [ $sensor == 'DRP' ]
	then
		sufixo='DTS2'
	fi

    DADO='CBERS_4A_'$sufixo'_RAW_'$ano'_'$mes'_'$dia'.'$hora'_'$min'_'$seg'_CP5'
	path_destino='/TEMP/Level-0/CBERS4A/'$ano'_'$mes/$sensor
	mkdir -p $path_destino
	cp $dir_passagem/$RAW $path_destino/$DADO

	echo "Dado $DADO disponível no Level-0 para processamento" | mail -s "Dado $DADO Disponível" $contatos
fi
exit
