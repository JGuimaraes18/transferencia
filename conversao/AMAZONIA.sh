#!/bin/bash 

servidor=$1
passagem=$2
sensor='WFI'		
contatos='joao.guimaraes@inpe.br'
servidor=`echo $servidor | tr [A-Z] [a-z]` 
ano=`echo $passagem |cut -d '-' -f2`
mes=`echo $passagem |cut -d '-' -f3`

path_exe='/home/transfoper/bin'
path_origem="/TEMP/$servidor"
path_destino='/Level-0/AMAZONIA1/'$ano'_'$mes/$sensor

cmd_raw="$path_exe/converte_CB4_to_AMZ1_RAW.sh"
cmd_drd="$path_exe/converte_CB4_to_AMZ1_DRD.sh"

if [ $servidor == 'solaria' ]
then
	$cmd_raw $passagem $servidor
	$cmd_drd $servidor
	cd $path_origem
	DADO=`ls AMAZONIA*`
	cp $DADO $path_destino
	echo "Dado $DADO disponível no Level-0 para processamento" | mail -s "Dado $DADO Disponível" $contatos	
fi
cd $path_origem
rm AMAZONIA*
exit
