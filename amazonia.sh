#!/bin/bash -x 

servidor=$1
passagem=$2
sensor=$3

servidor=`echo $servidor | tr [A-Z] [a-z]`
ingest="$servidor.dgi.inpe.br"
usuario='cbers'

ano=`echo $passagem |cut -d '-' -f2`
mes=`echo $passagem |cut -d '-' -f3`

path_servidor='/home/cbers/bin'
path_origem="/mnt/$servidor/$passagem"
path_destino='/Level-0/AMAZONIA1/'$ano'_'$mes/$sensor

mkdir -p $path_destino

cmd_raw="$path_servidor/converte_CB4_to_AMZ1_RAW.sh"
cmd_drd="$path_servidor/converte_CB4_to_AMZ1_DRD.sh"

ssh $usuario@$ingest << EOF
$cmd_raw $passagem
EOF

ssh $usuario@$ingest << EOF
$cmd_drd $passagem
EOF

if [ $servidor == 'solaria' ]
then
        cp $path_origem'/AMAZONIA'* $path_destino
fi

exit
