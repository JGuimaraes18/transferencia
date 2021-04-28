#!/bin/bash -x

dir_proc='/home/transfoper/bin'

proc=$(ps -ef | grep "transfere.sh" | wc -l)
if test "$proc" = "1"
then
	# Executa o script #
	$dir_proc'/transfere.sh' 
fi
exit
