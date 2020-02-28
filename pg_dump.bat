SET PGUSER=user
SET PGPASSWORD=pass

net use backupdir 1cBackup /USER:bachupuser

Rem Backup pg_dump

"C:\Program Files\PostgreSQL\9.1.2-1.1C\bin\pg_dump.exe" -h localhost -U postgres -Fc -Z9 -c -f "backupdir\backupname.Dmp" ant_doc 2>logdir\Err.txt

Rem Archive Backups

"C:\Program Files\WinRAR\rar.exe" a backupdir\Daily\%date%.rar backupdir\Daily\basename.Dmp
del /f /q backupdir\Daily\basename.Dmp

Rem Backup rotation. Every 15 day of the month Backup copies from Daily catalog to Monthly catalog and than Daily catalog cleans

set dd=%DATE%
 
set /a ddd=%dd:~0,2%
IF %ddd% LSS 10 (
  SET day=0%ddd%) else (
  SET day=%ddd%)

set month=%dd:~3,2%
set year=%dd:~6,4%

IF %month:~0,1% equ 0 (set /A month=%month:~1,2%) else (set /a month=%month%)

set /a prevmonth=%month%-1
if %prevmonth% lss 10 (set prevmonth=0%prevmonth%)
if %month% equ 1 (set prevmonth=12)
if %month% equ 1 (set /a year=%year%-1)

if %day% equ 1 (copy /y backupdir\Daily\%date%.rar backupdir\Monthly\%date%.rar)

if %day% equ 15 (for %%i IN (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31) DO del /f /q backupdir\Daily\%%i.%prevmonth%.%year%.rar)