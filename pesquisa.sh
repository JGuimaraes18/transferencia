#!/bin/bash 
path_exe='/home/transfoper/bin/'
source $path_exe/funcoes.sh
contador=0
hora_compara=`date +%H:%M:%S`

consultaPassagens 

for ((i=0; i<${#array[@]}; i++))
do
	id=${array[$i]}
	consultaNulo $id

	if [ -z $validaNulo ]
	then
		consultaPassagem $id
		manipulaDataHora ${pesquisa_passagem}

		hora_final_compara=$(date -ud "$horario_final" +%s)
		hora_atual_compara=$(date -ud "$hora_compara" +%s)

		# Realiza a comparacao do horario final da passagem com o horario atual
		if [ $hora_final_compara -lt $hora_atual_compara ]
		then
			consultaServidor $servidor_pesquisa
			consultaSensor $sensor_pesquisa

			defineMascara
			
			lista_passagens=`ls $ponto_de_montagem |grep $data`

			for passagemIngestora in $lista_passagens
                        do
                                formataDataPassagem $passagemIngestora
                                comparaHorarioPassagem $data_completa $data_compara_passagem

				if [ $resultado -ge -5  ] && [ $resultado -le 10 ] 
				then
					cd $ponto_de_montagem/$passagemIngestora
					
					defineQuantidadePassagens

					echo "UPDATE core_passagem SET qt_passagem = '$quant_passagem', qt_arquivos = '$quant_arquivos' WHERE id = '$id';" > $path_exe'/teste.txt' 
					$cmd_sql $bd < $path_exe'/teste.txt'
					rm $path_exe'/teste.txt'

					if [ "$satelite" == 'CBERS4' ]
                                        then
                                               $path_exe/cbers4.sh $servidor $ingest_data $sensor
                                        fi

					if [ "$satelite" == 'AMAZONIA 1' ] 
					then
						$path_exe/amazonia.sh $servidor $ingest_data $sensor
					fi

					if [ "$satelite" == 'AQUA' ] || [ "$satelite" == 'TERRA' ] || [ "$satelite" == 'NPP' ] || [ "$satelite" == 'NOAA20' ]
                                        then
                                                $path_exe/aqua_terra_npp_noaa20.sh $servidor $ingest_data $satelite $sensor
                                        fi

					if [ "$satelite" == 'CBERS 4A' ]
                                        then
                                               $path_exe/cbers4A.sh $servidor $ingest_data $sensor $ponto_de_montagem
                                        fi
				fi
			done
		fi
	fi
done
exit
