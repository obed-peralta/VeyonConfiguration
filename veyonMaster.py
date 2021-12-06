import os
import subprocess
import db
os.chdir("C:/Users/adano/")

path = 'C:/Users/adano/Desktop/ServidorFlask/importToVeyon.ps1'
args = ["powershell.exe",'-command',path]
bd = db.Database()
print("-----SELECCIONA EL AULA A EXPORTAR-----\n")
print("1) F1\n")
print("2) F2\n")
print("3) F3\n")
aula = input("")
result = bd.ExportCSV(int(aula))
    
# Import to veyon master configuration
if result:
    subprocess.Popen(['powershell','-ExecutionPolicy', 'Unrestricted', '-command', path])
        