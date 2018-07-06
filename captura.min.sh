#!/bin/bash
#AUTOR JORGE DIAS jorgediasdsg@gmail.com https://github.com/jorgedsdsg/captura
cd $HOME/TRADE/tradeprint
e(){ echo $1; } 						#Substitue echo por e
d=$(date +%d-%m-%Y-%X) 						#Captura a data do sistema para nomear os arquivos.
s=sites.txt  							#Chama o arquivos com sites.
m=emails.txt 							#Chama o arquivo com e-mails.
l=`pwd` 							#Localiza a pasta atual do sistema.
#navegador=chromium-browser 					#Nome do navegador, Substitua aqui.
#a=chromium-browser						#Nome do processo no navegador que será encerrado.
captura(){
	grep -v "^#" $s > sites 
	while read site link; do 				#Abre o laço de execução dos screenshots.
		#$navegador $link 				#Abre navegador com o link do arquivo sites.txt.
		#e "Abrindo site $link"
		e "$site - $d - $link" >> r 			#Adiciona linha ao relatório que será enviado.
		#sleep 20 					#Tempo de delay para carregar o site no navegador.
		e "Capturando dados de $link"
		wget -q $link -O "$site.dados"
		d=$(date +%d-%m-%Y-%X) 				#Captura a data para o arquivo que será capturado.
		#scrot $l/$site-$d.png 		#Executa o screenshot e salva com o nome do link e a data atual.
		valor=`cat "$site.dados" | grep "last_last" | sed "s/<\/span>.*// ; s/.*>//"`
		variacao=`cat "$site.dados" | grep "pc\" dir=\"ltr\"" | sed "s/<\/span>.*// ; s/.*\"ltr\">//"`
		porcentagem=`cat "$site.dados" | grep "pcp parentheses\" dir=\"ltr\"" | sed "s/<\/span>.*// ; s/.*ltr\">//"`
		e "$site	$valor	$variacao	$porcentagem	$d	$link" >> $l/dados.txt
		e "" >> $l/dados.txt
		e "$site;	$valor;	$variacao;	$porcentagem;	$d;	$link;" >> $HOME/dados.csv
		paste <(grep "data-real-valu" $site.dados | sed "s/<\/td>.*// ; s/.*\">//" | sed "s/ var.*//" | xargs -n 5) <(grep "\<td\> class=\"bold" $site.dados | sed 's/<\/td>.*/ '$site'/ ; s/.*\">/ /') >> $HOME/historico.csv
		#killall $a; 						#Fecha o navegador após o laço.
		#x-terminal-emulator -e chromium-browser
		#sleep 10
	done < sites 						# Chama o arquivo sites.txt para o laço.

}
cria_email(){ 							#Modelo de e-mail que será enviado
	e "-----------------------------" > $l/c
	e "RELATORIO DE SITES ACESSADOS" >> $l/c
	e "" >> $l/c
	e "PAR----VALOR--VARIAÇÃO---%-----------DATA---------LINK--------->" >> $l/c
	e "" >> $l/c
	cat dados.txt >> $l/c
	e "" >> $l/c
	e "ATT NELSON BORCHARDT" >> $l/c
	e "-----------------------------" >> $l/c
}
envia_email(){
	grep -v "^#" $m > y
	while read z n WHATS; do 
		e "Enviando e-mail para $z"
		mutt -s "$n - SEU RELATORIO TRADE DE $d" $z < c -a $HOME/dados.csv $HOME/historico.csv; done < y
}
remove_temporarios(){ rm -rf $l/c $l/y  $l/r $l/g $l/*.dados $l/sites $l/dados $l/dados.txt; e "SESSAO ENCERRADA, PODE VOLTAR A TOMAR CAFÉ"; }
captura
cria_email
envia_email
remove_temporarios
killall x-terminal-emulator;
