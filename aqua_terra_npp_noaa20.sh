#!/bin/bash 

servidor=$1
passagem=$2
satelite=$3
sensor=$4

servidor=`echo $servidor | tr [A-Z] [a-z]` 
ingest="$servidor.dgi.inpe.br"
usuario='cbers'

path_servidor='/home/cbers/bin'
path_origem="/mnt/$servidor/$passagem"
cmd_raw="$path_servidor/converte_CB4_to_AQUA_RAW.sh"

cd $path_origem
DRD=`ls CBERS*`
ano_mes=`echo $DRD |cut -d '_' -f5-6`
data_hora=`echo $DRD |cut -d '_' -f5-`
path_destino='/Level-0/'$satelite/$ano_mes/$sensor
mkdir -p $path_destino

case $satelite in
	AQUA)
		formato='CADU'
		;;
	TERRA)
		formato='CADU'
		;;
	NPP)
		formato='RAW'
		;;
	NOAA20)
		formato='RAW'
		;;
esac

RAW=$satelite'_'$formato'_'$data_hora'_CP5'

ssh $usuario@$ingest << EOF
$cmd_raw $passagem $RAW $DRD
EOF

cp $path_origem/$RAW $path_destino
exit
