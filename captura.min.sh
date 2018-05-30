#!/bin/bash
#AUTOR JORGE DIAS jorgediasdsg@gmail.com https://github.com/jorgedsdsg/captura
cd $HOME/TRADE/tradeprint
e(){ echo $1; }; p(){ clear; seq 7 8 180 | paste -sd \X; e ""; e " SISTEMA CAPTURA DE TELA E ENVIO DE EMAIL"; e ""; e "	$1"; e ""; seq 7 8 180 | paste -sd \X; }; d=$(date +%d-%m-%Y-%X); s=sites.txt; m=emails.txt; l=`pwd`; w=google-chrome-stable; a=chrome
r(){ grep -v "^#" $s > g; while read n k; do d=$(date +%d-%m-%Y-%X); $w $k; e "$n - $d - $k" >> r; sleep 12; gnome-screenshot -f $l/$n-$d.png; done < g; killall $a; }
t(){ e "-----------------------------------------------" > $l/c; e "RELATORIO DE SITES ACESSADOS" >> $l/c; e "" >> $l/c; cat r >> $l/c; e "" >> $l/c; e "" >> $l/c; e "" >> $l/c; e "ATT NELSON BORCHARDT" >> $l/c; e "-----------------------------------------------" >> $l/c; }
j(){ grep -v "^#" $m > y; while read z n WHATS; do mutt -s "$n - SEU RELATORIO TRADE DE $d" $z < c -a $l/*.png; done < y; }
v(){ rm -rf $l/*.zip $l/c $l/y  $l/r $l/g $l/*.png; p "SESSAO ENCERRADA, PODE VOLTAR A TOMAR CAFÉ"; }
r; t; j; v; killall gnome-terminal-server
