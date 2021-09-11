#!/bin/bash 
source email.sh

path_exe='/home/transfoper/bin/CBA'
dado=$1
satelite=$2

cd /home/transfoper/TEMP-PASSAGEM/$satelite

md5sum $dado > $dado.md5_cp
md51=$(cat $dado.md5_cba | cut -d " " -f1)
md52=$(cat $dado.md5_cp | cut -d " " -f1)

if [ $md51 == $md52 ]
then
	$path_exe/$satelite.sh $dado
	verificaEmailIgual $dado	
else
	verificaEmailDiferente $dado
fi

enviaEmail $dado

exit
