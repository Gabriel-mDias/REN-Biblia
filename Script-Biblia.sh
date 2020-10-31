#!/bin/bash

grafo=$1
if [ "$grafo" = "" ]
then
    grafo="CascataNEs.csc"
fi

rm -r Entrada1
mkdir Entrada1

cd Entrada
for i in *txt
do
	#Faz preprocessamento da base. Exclui o - porque no livro A Senhora tinham vários - no meio das strings, inclusive dos nomes. Exclui *
	#pq dá problemas na hora de rotular nomes.
	#sed -i 's/"//g' $i
	sed " s/amp;//g; s/<\/P>/./g; s/<[^>]*>//g; s/'//g; s/\"//g; s/«//g; s/^[..]*//g; s/^[...]*//g; s/^[- ]*//g; s/{//g; s/• //g; s/•//g; s;\r;;g; s;*;;g" $i > ../Entrada1/$i
done
cd ..

tipo=${grafo##*.}
if [ "$tipo" = "csc" ]
then
	./2-AplicaCascata.sh $grafo
else
	./2-AplicaGrafo.sh $grafo	
fi

./Prepara-Relacoes.sh
