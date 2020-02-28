@echo off
@rem файл должен распологаться в каталоге reg_1541 ну или с другим портом сервера 1С предприятия
@rem службу сервера он перезапускает

net stop "1C:Enterprise 8.3 Server Agent(x86-64)"

@rem это такая пауза

ping -n 6 127.0.0.1 >nul
cd %~dp0

for /D %%p IN (*) DO (
   ren "%~d0%~p0%%p\1Cv8Log\1Cv8.lgd" _1Cv8.lgd
   ren "%~d0%~p0%%p\1Cv8Log\1Cv8.lgd-journal" _1Cv8.lgd-journal
   @echo off > "%~d0%~p0%%p\1Cv8Log\1Cv8.lgf"
)
	

net start "1C:Enterprise 8.3 Server Agent(x86-64)"