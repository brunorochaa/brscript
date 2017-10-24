#! /bin/bash
clear
printf '\033]2;INSTALLER\a'
echo -e "Pressione qualquer tecla para instalar o script..."
read -n 1
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [[ "$DIR" != "/root/brscript" ]]
then
	echo -e "Você não seguiu as simples instruções de instalação do github cara -.-  . Vou tentar fazer por você..."
	sleep 4
	if [[ -d /root/brscript ]]
	then
		rm -r /root/brscript
	fi
	mkdir /root/brscript
	cp -r "$DIR"/* /root/brscript
	chmod +x /root/brscript/install.sh
	gnome-terminal -e "bash /root/brscript/install.sh"
fi
echo -e "Instalando o BRscript..."
sleep 1
echo -e "Dando permissões"
sleep 2
chmod +x /root/brscript/lh1
chmod +x /root/brscript/lh2
chmod +x /root/brscript/lh3
chmod +x /root/brscript/lh31
chmod +x /root/brscript/l
chmod +x /root/brscript/lh4
chmod +x /root/brscript/lh41
chmod +x /root/brscript/lh42
chmod +x /root/brscript/lh43
chmod +x /root/brscript/l131.sh
chmod +x /root/brscript/l132.sh
chmod +x /root/brscript/l133.sh
chmod +x /root/brscript/uninstall.sh
echo -e "Copiando o script para /bin/"
sleep 1
mkdir /bin/brscript
cd /root/brscript
cp /root/brscript/l /bin/
cp /root/brscript/lh1 /bin/
cp /root/brscript/lh2 /bin/
cp /root/brscript/lh3 /bin/
cp /root/brscript/lh31 /bin/
cp /root/brscript/lh4 /bin/
cp /root/brscript/lh41 /bin/
cp /root/brscript/lh42 /bin/
cp /root/brscript/lh43 /bin/
if [[ ! -d /root/handshakes ]]
then
	mkdir /root/handshakes
	echo -e "Fazendo o caminho /root/handshake"
else
	echo -e "/root/handshakes detectado. Ótimo."
fi
if [[ ! -d /root/wordlists ]]
then
	mkdir /root/wordlists
	echo -e "Fazendo o caminho /root/wordlists"
else
	echo -e "/root/wordlists detectado. Ótimo."
fi
while true
do
echo -e "Você está \e[1;33ma\e[0mtualizando ou \e[1;33mi\e[0mnstalando o script?(\e[1;33ma\e[0m/\e[1;33mi\e[0m): "
echo -e "Apenas use 'i' na primeira vez."
read UORI
if [[ "$UORI" = "a" ]]
then 
	echo -e "Digite 'changelog' para ver o que tem de novo nessa versão."
	sleep 3
	break
elif [[ "$UORI" = "i" ]]
then
	BASHCHECK=$(cat ~/.bashrc | grep "bin/brscript")
	if [[ "$BASHCHECK" != "" ]]
	then
		echo -e "EU DISSE, USE, SOMENTE, UMA VEZ..........."
		sleep 3
	fi
	echo -e "Adicionando brscript para PATH para que você possa acessá-lo de qualquer lugar"
	sleep 1
	export PATH=/bin/brscript:$PATH
	sleep 1
	echo "exportando PATH=/bin/brscript:$PATH" >> ~/.bashrc
	sleep 1
	break
fi
done
echo -e "Pronto"
sleep 1
echo -e "Abra uma nova sessão e digite "l" para iniciar"
sleep  4
gnome-terminal -e l
exit
