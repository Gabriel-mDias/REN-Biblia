rm -r Saida1
mkdir Saida1

> saida-prolog.txt
> Fatos-Biblia.txt
> Fatos.txt

cd Entrada1

for i in *txt
do
    #Pega nome do arquivo sem extensão .txt
	arq="${i%.*}"

    #Primeiras relações separadas: casamentos. Relações simples que não envolvem loops ou coisas do tipo
    sed "s/<PESSOA>\([^\<]*\)<\/PESSOA>, marido de<PESSOA>\([^\<]*\)<\/PESSOA>\([^\\n]*\)/<PESSOA>\1<\/PESSOA>, marido de<PESSOA>\2<\/PESSOA>\3\\nis_married(\1,\2).\nis_pessoa(\1).\nis_pessoa(\2).\n/g;"  $i > auxiliar.txt

    #Padrão objetivo: PESSOA1, filho dePESSOA2
    sed -i "s/<PESSOA>\([^\<]*\)<\/PESSOA> nasceu<PESSOA>\([^\<]*\)<\/PESSOA>/<PESSOA>\2<\/PESSOA>, filho de<PESSOA>\1<\/PESSOA>/g;" auxiliar.txt

    sed -i "s/<PESSOA>\([^\<]*\)<\/PESSOA> nasceram<PESSOA>\([^\<]*\)<\/PESSOA> e seus irmãos/<PESSOA>\2<\/PESSOA>, filho de<PESSOA>\1<\/PESSOA>/g;" auxiliar.txt

    sed -i ":loop; s/<PESSOA>\([^\<]*\)<\/PESSOA> nasceram, de<PESSOA>\([^\<]*\)<\/PESSOA>,<PESSOA>/<PESSOA>\2<\/PESSOA>, filho de<PESSOA>\1<\/PESSOA>.A <PESSOA>\1<\/PESSOA> nasceram, de<PESSOA>/g; t loop;" auxiliar.txt

    sed -i ":loop; s/<PESSOA>\([^\<]*\)<\/PESSOA> nasceu, de<PESSOA>\([^\<]*\)<\/PESSOA>,<PESSOA>/<PESSOA>\2<\/PESSOA>, filho de<PESSOA>\1<\/PESSOA>.A <PESSOA>\1<\/PESSOA> nasceu, de<PESSOA>/g; t loop;" auxiliar.txt

    sed -i "s/<PESSOA>\([^\<]*\)<\/PESSOA> nasceram, de<PESSOA>\([^\<]*\)<\/PESSOA> e<PESSOA>\([^\<]*\)<\/PESSOA>/<PESSOA>\2<\/PESSOA>, filho de<PESSOA>\1<\/PESSOA>. <PESSOA>\3<\/PESSOA>, filho de<PESSOA>\1<\/PESSOA>./g;" auxiliar.txt

    sed -i "s/<PESSOA>\([^\<]*\)<\/PESSOA> nasceram, de<PESSOA>\([^\<]*\)<\/PESSOA>/<PESSOA>\2<\/PESSOA>, filho de<PESSOA>\1<\/PESSOA>/g;" auxiliar.txt

    sed -i "s/<PESSOA>\([^\<]*\)<\/PESSOA> nasceu, de<PESSOA>\([^\<]*\)<\/PESSOA> e<PESSOA>\([^\<]*\)<\/PESSOA>/<PESSOA>\2<\/PESSOA>, filho de<PESSOA>\1<\/PESSOA>. <PESSOA>\3<\/PESSOA>, filho de<PESSOA>\1<\/PESSOA>./g;" auxiliar.txt

    sed -i "s/<PESSOA>\([^\<]*\)<\/PESSOA> nasceu, de<PESSOA>\([^\<]*\)<\/PESSOA>/<PESSOA>\2<\/PESSOA>, filho de<PESSOA>\1<\/PESSOA>/g;" auxiliar.txt    

    sed -i ":loop; s/<PESSOA>\([^\<]*\)<\/PESSOA>, filho de<PESSOA>\([^\<]*\)<\/PESSOA>, filho de<PESSOA>\([^\<]*\)<\/PESSOA>/<PESSOA>\1<\/PESSOA>, filho de<PESSOA>\2<\/PESSOA>. <PESSOA>\2<\/PESSOA>, filho de<PESSOA>\3<\/PESSOA>./g; t loop;" auxiliar.txt	

    sed "s/<PESSOA>\([^\<]*\)<\/PESSOA>, filho de<PESSOA>\([^\<]*\)<\/PESSOA>/\nis_father(\2,\1).\nis_pessoa(\1).\nis_pessoa(\2).\n/g;" auxiliar.txt > ../Saida1/$i

    sed -n "/is_pessoa/p" ../Saida1/$i > ../Saida1/$arq"-prolog.txt"    

    sed -n "/is_father/p" ../Saida1/$i >> ../Saida1/$arq"-prolog.txt"

    sed -n "/is_married/p" ../Saida1/$i >> ../Saida1/$arq"-prolog.txt"

        #Formatação do arquivo
    sed -i "s/( */(/g" ../Saida1/$arq"-prolog.txt"

    sed -i "s/ *)/)/g" ../Saida1/$arq"-prolog.txt"

    sed -i "s/ *,/,/g" ../Saida1/$arq"-prolog.txt"

    sed -i "s/, */,/g" ../Saida1/$arq"-prolog.txt"

    cat ../Saida1/$arq"-prolog.txt" >> ../saida-prolog.txt
done
cd ..

cat saida-prolog.txt| sort | uniq -u > Fatos.txt

    #Tratamento de caracteres especiais 
sed 'y/áÁàÀãÃâÂéÉêÊíÍóÓõÕôÔúÚçÇ /aAaAaAaAeEeEiIoOoOoOuUcC_/' < Fatos.txt > Fatos-Biblia.txt 
tr 'A-Z' 'a-z' < Fatos-Biblia.txt > fatos-biblia.pl

rm saida-prolog.txt
rm Fatos-Biblia.txt
rm Fatos.txt
