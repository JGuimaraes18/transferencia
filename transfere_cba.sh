#!/bin/bash
path_convert='/home/transfoper/bin/'
path_exe='/home/transfoper/bin'
source $path_exe/funcoes.sh
contador=0
hora_compara=`date +%H:%M:%S`
usuario='USER'
convert='HOST'

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

			if [ "$cidade" == "Cuiabá" ]
			then
				consultaServidor $servidor_pesquisa
				consultaSensor $sensor_pesquisa
				defineMascara
				
				ssh $usuario@$convert << EOF
            $path_convert/CBA.sh $servidor "$ingest_data" "$satelite" $sensor $antena $ponto_de_montagem $id
EOF
			fi
			
		fi
	fi
done
exit
