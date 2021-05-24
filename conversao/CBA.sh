#!/bin/bash 
path_exe='/home/transfoper/bin'

servidor=$1
montagem="/mnt/$servidor"
ingest_data=$montagem'/'$2
satelite=$3
sensor=$4
antena=$5
TEMP="/home/transfoper/TEMP-PASSAGEM/$servidor"

ano=`echo $ingest_data |cut -d '-' -f2`
mes=`echo $ingest_data |cut -d '-' -f3`
dia=`echo $ingest_data |cut -d '-' -f4`

hora=`echo $ingest_data |cut -d '-' -f5`
min=`echo $ingest_data |cut -d '-' -f6`
seg=`echo $ingest_data |cut -d '-' -f7`
ano_mes=$ano'_'$mes

case $servidor in
	SIR1)
		format_ingest='LANDSAT_5_TM_DRD'
		;;
	SIR11)
		format_ingest='LANDSAT_5_TM_DRD'
                ;;
	SIR13)
                format_ingest='CBERS_4_PAN5M_DRD'
                ;;
	SIR14)
                format_ingest='CBERS_4_PAN10M_DRD'
                ;;
	SIR15)
                format_ingest='CBERS_4_AWFI_DRD'
                ;;
	SIR17)
                format_ingest='CBERS_4_IRS_DRD'
                ;;
	SIR19)
		format_ingest='CBERS_4_MUX_DRD'
		;;
esac

DRD=$format_ingest'_'$ano'_'$mes'_'$dia'.'$hora'_'$min'_'$seg
NEW_DRD=$DRD'_'$antena

if [ "$satelite" == 'CBERS 4A' ]
then
	java -jar /home/transfoper/reuel/fdt.jar -pull -md5 -ss 124928 -P 50 -N -nolock -c 10.163.155.190 -d $TEMP $ingest_data/999_999_999_00000.raw	
	satelite='CBERS4A'
	$path_exe/$satelite'-CBA.sh' $TEMP $ingest_data $sensor $antena
	
else
	java -jar /home/transfoper/reuel/fdt.jar -pull -md5 -ss 124928 -P 50 -N -nolock -c 10.163.155.190 -d $TEMP $ingest_data/$DRD
fi

if [ "$satelite" == 'LANDSAT7' ] || [ "$satelite" == 'CBERS4' ] 
then
	$path_exe/$satelite'-CBA.sh' $TEMP $DRD $sensor $ano_mes $antena
fi
 
if [ "$satelite" == 'AMAZONIA 1' ]
then
	satelite='AMAZONIA'
	$path_exe/$satelite'-CBA.sh' $TEMP $DRD $sensor $ano_mes $antena $servidor
fi

exit
