#!/bin/bash -x

contatos='contatos'

function enviaEmail(){
DADO=$1

echo "Dado $DADO disponível no Level-0 para processamento" | mail -s "Dado $DADO Disponível" $contatos
}
 
function verificaEmailIgual(){
echo "Prezado(a) Operador(a)," >> emailOP
echo "                                  "  >> emailOP
echo "O arquivo $DADO esta com o Checksum igual em Cachoeira Paulista.."  >> emailOP
echo "                                  " >> emailOP
echo "                                  " >> emailOP
echo "Obrigado." >> emailOP
echo "                                  " >> emailOP
echo "SUPORTE" >> emailOP
echo "                                  " >> emailOP
echo "                                  " >> emailOP


assunto="CHECKSUM IGUAL - $1"
mail -s "$assunto" $contatos < emailOP
rm emailOP
}

function verificaEmailDiferenca(){
echo "Prezado(a) Operador(a)," >> emailOP
echo "                                  "  >> emailOP
echo "O arquivo $DADO esta com o Checksum diferente"  >> emailOP
echo "                                  " >> emailOP
echo "Obrigado." >> emailOP
echo "                                  " >> emailOP
echo "SUPORTE" >> emailOP
echo "                                  " >> emailOP
echo "                                  " >> emailOP


assunto="CHECKSUM IGUAL - $1"
mail -s "$assunto" $contatos < emailOP
rm emailOP
}

