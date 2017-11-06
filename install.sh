#! /bin/bash
clear
printf '\033]2;INSTALLER\a'
echo -e "Pressione \e[1;33mqualquer tecla\e[0m pra instalar o script..."
read -n 1
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [[ "$DIR" != "/root/brscript" ]]
then
	echo -e "You didn't follow the github's simple install instructions.I will try to do it for you..."
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
echo -e "Instalando brscript..."
sleep 1
echo -e "Concedendo permissões"
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
chmod +x /root/brscript/ls/l131.sh
chmod +x /root/brscript/ls/l132.sh
chmod +x /root/brscript/ls/l133.sh
chmod +x /root/brscript/uninstall.sh
echo -e "Copiando o script para /bin"
sleep 1
cd /root/lscript
cp /root/lscript/l /bin/
cp /root/lscript/lh1 /bin/
cp /root/lscript/lh2 /bin/
cp /root/lscript/lh3 /bin/
cp /root/lscript/lh31 /bin/
cp /root/lscript/lh4 /bin/
cp /root/lscript/lh41 /bin/
cp /root/lscript/lh42 /bin/
cp /root/lscript/lh43 /bin/
if [[ ! -d /root/handshakes ]]
then
	mkdir /root/handshakes
	echo -e "Criando /root/handshake"
else
	echo -e "/root/handshakes directory detected.Good."
fi
if [[ ! -d /root/wordlists ]]
then
	mkdir /root/wordlists
	echo -e "Criando /root/wordlists"
else
	echo -e "/root/wordlists directory detected.Good."
fi
while true
do
echo -e "Você está \e[1;33ma\e[0mtualizando ou \e[1;33mi\e[0mnstalando o script?(\e[1;33ma\e[0m/\e[1;33mi\e[0m): "
echo -e "Use 'i' se for a primeira vez."
read UORI
if [[ "$UORI" = "u" ]]
then 
	echo -e "Digite 'changelog' para ver quais são as novidades nessa versão"
	sleep 3
	break
elif [[ "$UORI" = "i" ]]
then
	BASHCHECK=$(cat ~/.bashrc | grep "bin/")
	if [[ "$BASHCHECK" != "" ]]
	then
		echo -e "I SAID USE i ONLY ONE TIME..........."
		sleep 3
	fi
	echo -e "Adicionando o script no PATH para vocÊ poder usar de qualquer lugar"
	sleep 1
	export PATH=/bin:$PATH
	sleep 1
	echo "export PATH=/bin:$PATH" >> ~/.bashrc
	sleep 1
	break
fi
done
echo -e "Pronto"
sleep 1
echo -e "Abra um novo terminal e digite 'b' pra iniciar o script."
sleep  4
gnome-terminal -e l
exit
