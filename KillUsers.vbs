'       Скрипт мониторинга памяти сервера 1С 
'       удаляет сеансы, которые выполняют запрос к СУБД дольше определенного времени
'	в случае если процесс сервера "Съел" больше определенного объёма памяти 

	Dim Connector
	Dim Agent 
	Dim Cluster 
	Dim WorkingProcess 
	Dim Memory 
	Dim Sessions
	Dim Session
	Dim iDuration
	
	Set Connector = CreateObject("V83.COMConnector")
	Set Agent = Connector.ConnectAgent("tcp://ServerName")  		'Имя сервера
	Set Cluster = Agent.GetClusters()(0) 				'1 кластер в сервере
	Agent.Authenticate Cluster, "", ""  
	
	Set WorkingProcess = Agent.GetWorkingProcesses(Cluster)(0) 	'1 Рабочий процесс в кластере
	
	Memory = WorkingProcess.MemorySize
	
	if memory/1048576 > 12 then  					'Если сожрал больше 12 ГБ - ищем гада
		Sessions = Agent.GetSessions(Cluster)
		For i = LBound(Sessions) To UBound(Sessions) 
			Set Session = Sessions(i)  			
			iDuration = CLng(Session.durationCurrentDBMS)   'Преобразование типа обязательно
			if iDuration > 300000 then Agent.TerminateSession Cluster, session   'Если больше 5-ти минут выполняет запрос к СУБД - убиваем
		next
	end if
