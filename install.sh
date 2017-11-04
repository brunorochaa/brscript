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
chmod +x /root/brscript/br1
chmod +x /root/brscript/br2
chmod +x /root/brscript/br3
chmod +x /root/brscript/br31
chmod +x /root/brscript/b
chmod +x /root/brscript/br4
chmod +x /root/brscript/br41
chmod +x /root/brscript/br42
chmod +x /root/brscript/br43
chmod +x /root/brscript/b131.sh
chmod +x /root/brscript/b132.sh
chmod +x /root/brscript/b133.sh
chmod +x /root/brscript/uninstall.sh
echo -e "Copiando o script para /bin"
sleep 1
cd /root/brscript
cp /root/brscript/b /bin/
cp /root/brscript/br1 /bin/
cp /root/brscript/br2 /bin/
cp /root/brscript/br3 /bin/
cp /root/brscript/br31 /bin/
cp /root/brscript/br4 /bin/
cp /root/brscript/br41 /bin/
cp /root/brscript/br42 /bin/
cp /root/brscript/br43 /bin/
cp /root/brscript/b131.sh /bin
cp /root/brscript/b132.sh /bin
cp /root/brscript/b133.sh /bin
cp /root/brscript/uninstall.sh /bin
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
echo -e "Você está \e[1;33mA\e[0mtualizando ou \e[1;33mI\e[0mnstalando o script?(\e[1;33mA\e[0m/\e[1;33mI\e[0m): "
echo -e "Apenas use 'I' na primeira vez."
read UORI
if [[ "$UORI" = "A" ]]
then 
	echo -e "Digite 'changelog' para ver o que tem de novo nessa versão."
	sleep 3
	break
elif [[ "$UORI" = "I" ]]
then
	BASHCHECK=$(cat ~/.bashrc | grep "bin/brscript")
	if [[ "$BASHCHECK" != "" ]]
	then
		echo -e "EU, DISSE, USE, SOMENTE, UMA VEZ..."
		sleep 3
	fi
	echo -e "Adicionando o brscript no PATH para que você possa acessá-lo de qualquer lugar"
	sleep 1
	export PATH=/bin:$PATH
	sleep 1
	echo "exportando PATH=/bin:$PATH" >> ~/.bashrc
	sleep 1
	break
fi
done
echo -e "Pronto"
sleep 1
echo -e "Abra uma nova sessão ou digite "b" para iniciar"
sleep  4
gnome-terminal -e l
exit
