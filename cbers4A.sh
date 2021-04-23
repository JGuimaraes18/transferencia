#!/bin/bash 

servidor=$1
passagem=$2
sensor=$3
sufixo=$3
montagem=$4

cd $montagem/$passagem
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
	path_destino='/Level-0/CBERS4A/'$ano'_'$mes/$sensor
	mkdir -p $path_destino
	cp $montagem/$passagem/$RAW $path_destino/$DADO
fi
exit
