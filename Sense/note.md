On apprend sur le HTB que la machine est openBSD


What is the name of the webserver running on port 80 and 443 according to nmap?
	nmap -p80,443 -A 10.129.133.151
	lighttpd
	lighttpd 1.4.35

What is the name of the application that presents a login screen on port 443?
	pfsense

What txt file can be found on the webserver that contains user information?
	system-users.txt

What is the username found in the system-users.txt file?
	rohit

What is the default password for a pfsense installation?
	pfsense


What version of pfSense is running on Sense?
	2.1.3-RELEASE

What 2016 CVE ID describes a command injection vulnerability in a PHP page on pfSense via a GET parameter?
	CVE-2016-10709


Pour l'exploitation je suis passé par msfconsole et j'ai chercher la CVE
j'ai remplis les options demandé et j'ai run
j'ai eu l'acces en root et j'ai récup les flag



