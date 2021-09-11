#!/bin/bash 
path_exe='/home/transfoper/bin/'
cmd_sql="/usr/bin/sqlite3"
bd="/home/transfoper/transferencia/database/db.sqlite3"
data_atual=`date +%Y-%m-%d`
contador=0

function consultaPassagens(){
consulta_array="SELECT id FROM core_passagem WHERE inicio LIKE '%$data_atual%';"
pesquisa_array=`$cmd_sql $bd "$consulta_array" ""`
array=($pesquisa_array)

export array=$array
}

function consultaNulo(){
id=$1
consultaNulo="SELECT qt_passagem FROM core_passagem WHERE id LIKE '%$id%';"
pesquisaNulo=`$cmd_sql $bd "$consultaNulo" ""`

export validaNulo=$pesquisaNulo
}


function consultaPassagem(){
data_pesquisa=$1
consulta="SELECT inicio, antena_id, sensor_id, servidor_id, fim, qt_passagem FROM core_passagem WHERE id LIKE '$id';"
pesquisa=`$cmd_sql $bd "$consulta" ""`

export pesquisa_passagem=$pesquisa
}

function manipulaDataHora(){
passagem=$@
# Extrai as informacoes necessarias
antena_pesquisa=`echo $passagem |cut -d '|' -f2`
sensor_pesquisa=`echo $passagem |cut -d '|' -f3`
servidor_pesquisa=`echo $passagem |cut -d '|' -f4`
data=`echo $passagem | cut -d '|' -f1 | cut -c -10`
horario_inicial=`echo $passagem | cut -d '|' -f1 | cut -c 12-`
data_completa=($data' '$horario_inicial)
hora_inicial=`echo $horario_inicial | cut -c 1-2`
min_inicial=`echo $horario_inicial | cut -c 4-5`
seg_inicial=`echo $horario_inicial | cut -c 7-8`
horario_final=`echo $passagem |cut -d '|' -f5 |cut -c -19`
}

function consultaAntena(){
consulta="select * from core_antena where id = '$antena_pesquisa';"   
pesquisa=`$cmd_sql $bd "$consulta" ""`
antena=`echo $pesquisa |cut -d '|' -f2`
cidade=`echo $pesquisa |cut -d '|' -f4`
}

function consultaServidor(){
data_pesquisa=$1
consulta="select * from core_servidor where id = '$servidor_pesquisa';"
pesquisa=`$cmd_sql $bd "$consulta" ""`
servidor=`echo $pesquisa |cut -d '|' -f2`
ponto_de_montagem=`echo $pesquisa |cut -d '|' -f3`
sistemaIngestao=`echo $servidor |cut -d '-' -f1`
}

function consultaSensor(){
data_pesquisa=$1
consulta="select * from core_sensor where id = '$sensor_pesquisa';"
pesquisa=`$cmd_sql $bd "$consulta" ""`
sensor=`echo $pesquisa |cut -d '|' -f2`
satelite_id=`echo $pesquisa |cut -d '|' -f3`
consulta_sat="select satelite from core_satelite where id = '$satelite_id';"
satelite=`$cmd_sql $bd "$consulta_sat" ""`
}

function formataDataPassagem(){
data_hora=$1

if [ "$sistemaIngestao" == "DARTCOM" ]
then
	ano_passagem=`echo $data_hora |cut -d '-' -f1`
        mes_passagem=`echo $data_hora |cut -d '-' -f2`
        dia_passagem=`echo $data_hora |cut -d '-' -f3 |cut -c -2`

	hora_passagem=`echo $data_hora |cut -d '-' -f3 |cut -c 4-5`
        min_passagem=`echo $data_hora |cut -d '-' -f4`
        seg_passagem=`echo $data_hora |cut -d '-' -f5`
else
	if [ "$satelite" == "CBERS 4A" ]
	then
		ano_passagem=`echo $data_hora |cut -d '-' -f1`
		mes_passagem=`echo $data_hora |cut -d '-' -f2`
		dia_passagem=`echo $data_hora |cut -d '-' -f3 |cut -c -2`

		hora_passagem=`echo $data_hora |cut -d 'T' -f2 |cut -c -2`
		min_passagem=`echo $data_hora |cut -d ':' -f2`
		seg_passagem=`echo $data_hora |cut -d ':' -f3 |cut -c -2`	
	else
		ano_passagem=`echo $data_hora |cut -d '-' -f2`
		mes_passagem=`echo $data_hora |cut -d '-' -f3`
		dia_passagem=`echo $data_hora |cut -d '-' -f4`

		hora_passagem=`echo $data_hora |cut -d '-' -f5`
		min_passagem=`echo $data_hora |cut -d '-' -f6`
		seg_passagem=`echo $data_hora |cut -d '-' -f7 |cut -c -2`
	fi
fi
data_compara_passagem=$ano_passagem-$mes_passagem-$dia_passagem' '$hora_passagem:$min_passagem:$seg_passagem
}

function comparaHorarioPassagem(){
data_recebida=$@
data_completa=`echo $data_recebida |cut -c -19`
data_compara_passagem=`echo $data_recebida |cut -c 21-`

ts1=$(date -ud "$data_completa" +%s)
ts2=$(date -ud "$data_compara_passagem" +%s)

# Gera a diferenca do horario da ingestora para o horario do banco e converte para minutos
dif=`expr $ts2 - $ts1`
resultado=$(($dif / 60))
}

function defineMascara(){
if [  $sistemaIngestao == "DARTCOM" ]
then
	ingest_data=$data' '$hora_inicial'-'$min_inicial'-'$seg_inicial
else
	case $servidor in
		SOLARIA)
			ingest_sensor="MUX"
        		  ;;
  		COROT)
  		        ingest_sensor="AWFI"
        		  ;;
		SIR1)
			ingest_sensor="TM"
			;;
		SIR11)
			ingest_sensor="TM"
			;;
		SIR13)
			ingest_sensor="PAN5M"
			;;
		SIR14)
			ingest_sensor="PAN10M"
			;;
		SIR15)
			ingest_sensor="AWFI"
			;;
		SIR17)
			ingest_sensor="IRS"
			;;
		SIR19)
			ingest_sensor="MUX"
			;;
  	esac

	# Monta a mascara padrao da ingestao
	if [ "$satelite" == 'CBERS 4A' ] 
	then
		ingest_data=$data'T'$hora_inicial':'$min_inicial':'$seg_inicial'.000Z'
	else
		ingest_data=$ingest_sensor'-'$data'-'$hora_inicial'-'$min_inicial'-'$seg_inicial
	fi
fi
}

function listaPassagens(){
if [ $sistemaIngestao == "DARTCOM" ] 
then
	case $satelite in
                AQUA)
                        sat='Aqua'
                        ;;
                TERRA)
                        sat='Terra'
                        ;;
                NPP)
                        sat='NPP'
                        ;;
                NOAA20)
                        sat='JPSS-1'
			;;
		NOAA18)
			sat='HRPT/Archive'
			;;
		NOAA19)
			sat='HRPT/Archive'
			;;
		METOPB)
			sat='AHRPT/Archive'
			;;
		METOPC)
			sat='AHRPT/Archive'
			;;
	esac
	lista_passagens=`ls $ponto_de_montagem/$sat/$data/ |grep $hora_inicial-$min_inicial`
	data_lista_passagem=`echo $lista_passagens |cut -d ' ' -f1`
	hora_lista_passagem=`echo $lista_passagens |cut -d ' ' -f2`
	lista_passagens=$data_lista_passagem'_'$hora_lista_passagem
else
	lista_passagens=`ls $ponto_de_montagem |grep $data`	
	hora_lista_passagem=`ls $ponto_de_montagem |grep $hora_inicial`
fi

}

function acertaPadraoIngestoraDartcom(){
dataIng=`echo $passagemIngestora |cut -d '_' -f1`
horaIng=`echo $passagemIngestora |cut -d '_' -f2`
passagemIngestora=$dataIng' '$horaIng
}

function defineQuantidadePassagens(){
quant_passagem=$((contador+1))

if [ "$sistemaIngestao" == 'DARTCOM' ]
then
	quant_arquivos=`ls * |wc -l`
else
	if [ "$satelite" == 'CBERS 4A' ]
  	then
  	     quant_arquivos=`ls *.raw |wc -l`
	else
 	     quant_arquivos=`ls |grep $ingest_sensor |grep $dia_passagem |wc -l`
 	fi
fi	
}

function atualizaBD(){
echo "UPDATE core_passagem SET qt_passagem = '$quant_passagem', qt_arquivos = '$quant_arquivos' WHERE id = '$id';" > $path_exe'/update.txt'
$cmd_sql $bd < $path_exe'/update.txt'
rm $path_exe'/update.txt'
}
