#---------ФУНКЦИИ
#Запуск службы пока она не будет запущена с интервалом 60 секунд. Возвращает статус службы
function StartService{
    param($ServiceName)
    $arrService = Get-Service -Name $ServiceName
    while ($arrService.Status -ne "Running") {
        Start-Service $ServiceName
        Start-Sleep -Seconds 60
        $arrService = Get-Service -Name $ServiceName
    }
    return $arrService.Status
}
#остановка службы. 3 попытки с интервалом 60 сек. Возвращает статус службы
function StopService{
    param($ServiceName)
    $arrService = Get-Service -Name $ServiceName
    $count = 0
    while (($arrService.Status -ne "Stopped") -or ($count -lt 3)) {
        Stop-Service $ServiceName
        Start-Sleep -Seconds 60
        $arrService = Get-Service -Name $ServiceName
        $count += 1
    }
    return $arrService.Status
}




#---------ПЕРЕМЕННЫЕ
#Наименование службы 1С на сервере
$NameOfService = "1C:Enterprise 8.3 Server Agent (x86-64)"
#Расположение кластера 1С + каталог с портом, на котором работает служба
$ClusterPath = "C:\Program Files\1cv8\srvinfo\reg_1541"
#Логирование изменений формата Журнала Регистрации
$logfile = "LogFille.txt"
$debug = "DebugFile.log"

#---------ТЕЛО СКРИПТА

Get-ChildItem -Path "*.log" | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-7))} | Remove-Item
$checkpoint = Get-Date -UFormat "%Y-%m-%d %T"
$checkpoint += " Script started" 
$checkpoint | out-file $debug

#Остановка службы через функцию
$status = StopService -ServiceName $NameOfService


$checkpoint = Get-Date -UFormat "%Y-%m-%d %T"
if ($status -eq "Stopped") {
    $checkpoint += " Service stoped correctly"
       
    } else {
    $checkpoint += " Service status is "
    $checkpoint += $status
    }
$checkpoint | out-file -Append $debug

#Завершение зависшних процессов

ps rphost -ErrorAction SilentlyContinue | kill -PassThru
ps rmngr -ErrorAction SilentlyContinue | kill -PassThru
ps ragent -ErrorAction SilentlyContinue | kill -PassThru

Start-Sleep -Seconds 20

#очистка кэша сервера 1С
$Files2Del = $ClusterPath + "\snccnt*\*.dat"
Remove-Item $Files2Del -Force

$checkpoint = Get-Date -UFormat "%Y-%m-%d %T"
$checkpoint += " Cache cleared"
$checkpoint | out-file -Append $debug
Start-Sleep -Seconds 20

#Проверка формата ЖР и приведение к старому варианту
$BaseFolders = Get-ChildItem $ClusterPath
Foreach ($bf in $BaseFolders) {
    IF (Test-Path  ($ClusterPath + "\" + $bf + "\1Cv8Log\1Cv8.lgd")) {
        $lgdfile = $ClusterPath + "\" + $bf + "\1Cv8Log\1Cv8.lgd"
        Rename-Item -Path $lgdfile -NewName "_1Cv8.lgd"
        $lgffile = $ClusterPath + "\" + $bf + "\1Cv8Log\1Cv8.lgf"
        IF (Test-Path $lgffile) {
        }
        else {
            New-Item $lgffile -ItemType File
            Get-Date -UFormat "%Y-%m-%d %T" | out-file -Append $logfile
            $lgffile | out-file -Append $logfile
        }
    
    }
}

$checkpoint = Get-Date -UFormat "%Y-%m-%d %T"
$checkpoint += " JR checked"
$checkpoint | out-file -Append $debug

#Запуск службы 1С
$status = StartService -ServiceName $NameOfService

$checkpoint = Get-Date -UFormat "%Y-%m-%d %T"
$checkpoint += " Service status is "
$checkpoint += $status
$checkpoint | out-file -Append $debug

$DateStamp = get-date -uformat "%Y%m%d"
$newname = "debug_" + $DateStamp + ".log"
Rename-Item -Path $debug $newname