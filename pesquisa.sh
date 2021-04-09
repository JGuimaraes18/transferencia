#!/bin/bash -x
path_exe='/home/cdsr/bin'
contador=0
data_pesquisa=`date +%Y-%m-%d`
hora_compara=`date +%H:%M:%S`

# Variaveis para acesso e consulta ao BD 
cmd_sql="sqlite3"
bd="/home/cdsr/transferencia/database/db.sqlite3"
#bd="/home/cdsr/bin/db.sqlite3"

# Consulta o ID para gerar o laco de repeticao 
consulta_array="SELECT id FROM core_passagem WHERE inicio LIKE '%$data_pesquisa%';"
pesquisa_array=`$cmd_sql $bd "$consulta_array" ""`

array=($pesquisa_array)

for ((i=0; i<${#array[@]}; i++))
do
	id=${array[$i]}

	consulta_data_passagem="SELECT inicio, antena_id, sensor_id, servidor_id, fim FROM core_passagem WHERE id LIKE '$id';"

	# Consulta a passagem
	pesquisa_data_passagem=`$cmd_sql $bd "$consulta_data_passagem" ""`


	# Extrai as informacoes necessarias
	antena_pesquisa=`echo $pesquisa_data_passagem |cut -d '|' -f2`
	sensor_pesquisa=`echo $pesquisa_data_passagem |cut -d '|' -f3`
	servidor_pesquisa=`echo $pesquisa_data_passagem |cut -d '|' -f4`
	data=`echo $pesquisa_data_passagem | cut -d '|' -f1 | cut -c -10`
	horario_inicial=`echo $pesquisa_data_passagem | cut -d '|' -f1 | cut -c 12-`
	data_completa=($data' '$horario_inicial)
	hora_inicial=`echo $horario_inicial | cut -c 1-2`
	min_inicial=`echo $horario_inicial | cut -c 4-5`
	seg_inicial=`echo $horario_inicial | cut -c 7-8`
	horario_final=`echo $pesquisa_data_passagem |cut -d '|' -f5 |cut -c -19`
	hora_compara1=$(date -ud "$horario_final" +%s)
	hora_compara2=$(date -ud "$hora_compara" +%s)

	# Realiza a comparacao do horario final da passagem com o horario atual
	if [ $hora_compara1 -lt $hora_compara2 ]
	then
		echo 'passagem valida'	
	else
		exit
	fi

	# Consulta o servidor da passagem
	consulta_servidor_passagem="select * from core_servidor where id = '$servidor_pesquisa';"
	pesquisa_servidor_passagem=`$cmd_sql $bd "$consulta_servidor_passagem" ""`
	servidor=`echo $pesquisa_servidor_passagem |cut -d '|' -f2`
	ponto_de_montagem=`echo $pesquisa_servidor_passagem |cut -d '|' -f3`

	# Consulta o sensor da passagem
	consulta_sensor_passagem="select * from core_sensor where id = '$sensor_pesquisa';"
	pesquisa_sensor_passagem=`$cmd_sql $bd "$consulta_sensor_passagem" ""`
	sensor=`echo $pesquisa_sensor_passagem |cut -d '|' -f2`

	case $servidor in
		SOLARIA)
			ingest_sensor="MUX"
			;;
		COROT)
			ingest_sensor="AWFI"
			;;
	esac

	# Monta a mascara padrao da ingestao
	ingest_data=$ingest_sensor'-'$data'-'$hora_inicial'-'$min_inicial'-'$seg_inicial

	# Converte a data para segundos 
	ts1=$(date -ud "$data_completa" +%s)

	# Acessa o diretorio de ingestao e lista os dados 
	cd $ponto_de_montagem

	for passagem in $(ls  |grep $ingest_sensor'-'$data)
	do
		ano_passagem=`echo $passagem |cut -d '-' -f2`
		mes_passagem=`echo $passagem |cut -d '-' -f3`
		dia_passagem=`echo $passagem |cut -d '-' -f4`
		
		hora_passagem=`echo $passagem |cut -d '-' -f5`
		min_passagem=`echo $passagem |cut -d '-' -f6`
		seg_passagem=`echo $passagem |cut -d '-' -f7`
		data_compara_passagem=$ano_passagem-$mes_passagem-$dia_passagem' '$hora_passagem:$min_passagem:$seg_passagem

		ts2=$(date -ud "$data_compara_passagem" +%s)
		# Gera a diferenca do horario da ingestora para o horario do banco e converte para minutos
		dif=`expr $ts2 - $ts1`

		resultado=$(($dif / 60))
			
		# Entra no if se a diferenca for menor/igual que 10 minutos
		if [ $resultado -le 10 ] 
		then
			cd $passagem
			quant_arquivos=`ls |grep $dia_passagem |wc -l`
			quant_passagem=$((contador+1))
			
			echo "UPDATE core_passagem SET qt_passagem = '$quant_passagem', qt_arquivos = '$quant_arquivos' WHERE id = '$id';" > $path_exe'/teste.txt' 
			$cmd_sql $bd < $path_exe'/teste.txt'
			rm $path_exe'/teste.txt'
		fi
	done
done
exit
