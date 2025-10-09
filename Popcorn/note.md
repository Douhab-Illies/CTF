nmap :
	application web sur le port 80

creation d'un compte 
	username: test
	password: test


upload d'un fihcier torrent 
	wget https://torrent.fedoraproject.org/torrents/Fedora-Budgie-Live-x86_64-43_Beta.torrent

Il faut publier le fichier torrent

puis passer l'editer et ajouter un screenshot.
il faut changer le nom du revershell php 
	
de 
	shell.php
a
	shell.png.php

changer l'entete http, le Content-Type : 
	application/x-file
	image/png

un fois le shell obtenu utiliser l'exploit pam de 2010 : 
	https://github.com/infinite-horizon219/Unix-Privilege-Escalation-Exploits-Pack/blob/master/2010/CVE-2010-0832.sh

un compte sera creer avec :
	username: toor
	password: toor

pour passer root
	su toor
	toor

