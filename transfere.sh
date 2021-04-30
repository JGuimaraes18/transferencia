#!/bin/bash
path_convert='/home/transfoper/bin/'
path_exe='/home/transfoper/bin'
source $path_exe/funcoes.sh
contador=0
hora_compara=`date +%H:%M:%S`
usuario=transfoper
convert=ms3-conversao

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
			consultaAntena $antena_pesquisa
			consultaServidor $servidor_pesquisa
			consultaSensor $sensor_pesquisa
			defineMascara
			listaPassagens	

			if [ -z $hora_lista_passagem ]
			then
				quant_passagem='0'
				quant_arquivos='0'
				atualizaBD
			else
				for passagemIngestora in $lista_passagens
	                        do
					if [ "$sistemaIngestao" == 'DARTCOM' ]
	                        	then
						acertaPadraoIngestoraDartcom	
	                        	fi	

	                              	formataDataPassagem "$passagemIngestora"
	                               	comparaHorarioPassagem $data_completa $data_compara_passagem

					if [ $resultado -ge -5  ] && [ $resultado -le 10 ] 
					then
						if [ "$sistemaIngestao" == 'DARTCOM' ]
						then
							cd $ponto_de_montagem/$sat/$data/"$passagemIngestora"
						else
							cd $ponto_de_montagem/$passagemIngestora
						fi
				
						defineQuantidadePassagens
						atualizaBD

						if [ $antena == 'CP5' ]
						then
							if [ "$satelite" == 'CBERS4' ]
	                	        	        then
								ssh $usuario@$convert << EOF
								$path_exe/$satelite.sh $servidor $ingest_data $sensor
EOF
	                               		        fi
							if [ "$satelite" == 'AMAZONIA 1' ] 
							then
								ssh $usuario@$convert << EOF
								$path_exe/AMAZONIA.sh $servidor $ingest_data 
EOF
							fi
							if [ "$satelite" == 'AQUA' ] || [ "$satelite" == 'TERRA' ] || [ "$satelite" == 'NPP' ] || [ "$satelite" == 'NOAA20' ]
	               		                        then
								ssh $usuario@$convert << EOF
	                	       	                        $path_exe/$satelite-CP5.sh $ingest_data
EOF
							fi
							if [ "$satelite" == 'CBERS 4A' ]
	        	       	                        then
								ssh $usuario@$convert << EOF
								$path_exe/CB4A.sh $servidor $ingest_data $sensor $ponto_de_montagem
EOF
							fi
						fi
						if [ $antena == 'CP6' ] || [ $antena == 'CP1' ] 
						then
							ssh $usuario@$convert << EOF
							$path_exe/$satelite-$antena.sh $data_hora $ponto_de_montagem
EOF
						fi
					fi
				done
			fi
		fi
	fi
done
exit
