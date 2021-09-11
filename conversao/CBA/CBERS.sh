#!/bin/bash 

dado=$1
path_dado='/home/transfoper/TEMP-PASSAGEM/CBERS'

ANO_MES=`echo $dado |cut -d '_' -f5-6`
SENSOR=`echo $dado |cut -d '_' -f3`
MISSAO=`echo $dado |cut -d '_' -f2`
STORAGE="/Level-0/CBERS$MISSAO/$ANO_MES/$SENSOR"

mkdir -p $STORAGE

cp $path_dado/$dado $STORAGE/

scp $path_dado/$dado* cdsr@bbftp.dgi.inpe.br:/cdsr/VPN/CBERS$MISSAO/

exit
