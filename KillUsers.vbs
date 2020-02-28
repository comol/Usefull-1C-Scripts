'       ������ ����������� ������ ������� 1� 
'       ������� ������, ������� ��������� ������ � ���� ������ ������������� �������
'	� ������ ���� ������� ������� "����" ������ ������������� ������ ������ 

	Dim Connector
	Dim Agent 
	Dim Cluster 
	Dim WorkingProcess 
	Dim Memory 
	Dim Sessions
	Dim Session
	Dim iDuration
	
	Set Connector = CreateObject("V83.COMConnector")
	Set Agent = Connector.ConnectAgent("tcp://ServerName")  		'��� �������
	Set Cluster = Agent.GetClusters()(0) 				'1 ������� � �������
	Agent.Authenticate Cluster, "", ""  
	
	Set WorkingProcess = Agent.GetWorkingProcesses(Cluster)(0) 	'1 ������� ������� � ��������
	
	Memory = WorkingProcess.MemorySize
	
	if memory/1048576 > 12 then  					'���� ������ ������ 12 �� - ���� ����
		Sessions = Agent.GetSessions(Cluster)
		For i = LBound(Sessions) To UBound(Sessions) 
			Set Session = Sessions(i)  			
			iDuration = CLng(Session.durationCurrentDBMS)   '�������������� ���� �����������
			if iDuration > 300000 then Agent.TerminateSession Cluster, session   '���� ������ 5-�� ����� ��������� ������ � ���� - �������
		next
	end if
