


## How many TCP ports are open?

```bash
nmap -p- -A -T5 10.129.228.195
```

2 ports overts

## What is the name of the directory that is available on the FTP server?

```bash
ftp anonymous@10.129.228.195

ls
```

On trouve le dossier :
	drwxr-xr-x    2 ftp      ftp          4096 Nov 28  2022 mail_backup


## What is the default account password that every new member on the "Funnel" team should change as soon as possible?

```bash
cd mail_backup

ls
```

on trouve les fichiers : 
	-rw-r--r--    1 ftp      ftp         58899 Nov 28  2022 password_policy.pdf
	-rw-r--r--    1 ftp      ftp           713 Nov 28  2022 welcome_28112022


on les récupère 
```bash
get password_policy.pdf
get welcome_28112022
```


on trouve un fichier qui est un mail : welcome_28112022
et un fichier de règle de politique de mot de passe par défaut : password_policy.pdf

dans le fichier password_policy.pdf on trouve le mot de passe : 
	__funnel123#!#__


## Which user has not changed their default password yet?

On prend le fichier du mail : welcome_28112022
et on regarde la ligne TO:
	optimus@funnel.htb
	albert@funnel.htb
	andreas@funnel.htb
	christine@funnel.htb
	maria@funnel.htb


dans notre cas c'est :
	christine


On peut donc maintenant se connecter sur le serveur grace a SSH : 
```bash
ssh christine@10.129.228.195
```

et le mot de passe : 
	__funnel123#!#__

## Which service is running on TCP port 5432 and listens only on localhost?

On se sait que c'est :
	postgresql


## Since you can't access the previously mentioned service from the local machine, you will have to create a tunnel and connect to it from your machine. What is the correct type of tunneling to use? remote port forwarding or local port forwarding?


On sait que c'est le : 
	Local Port Forwarding


pour se connecter : 
	
```bash
ssh christine@10.129.228.195 -L 5432:localhost:5432

psql -h localhost -U christine
```


## What is the name of the database that holds the flag?

```psql
\l

```
On trouve la database : 
	secret


## Submit the flag

```psql

\c secret
Select * from flag ;
```
