rem variables

Set WSHShell = WScript.CreateObject("WScript.Shell")
RegLoc = "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3\"
Dim oShell
Set oShell=CreateObject("WScript.shell")
Const COOKIES = &H21&
Const TEMPIE = &H20&
Set objShell = CreateObject("Shell.Application")

rem base parameters of security
rem �������������� ������� Acitve X
WSHShell.RegWrite RegLoc & "2201",0,"REG_DWORD" 
rem ��������� �� ����������� Acitve X
WSHShell.RegWrite RegLoc & "1001",0,"REG_DWORD" 
rem ������������ Active X
WSHShell.RegWrite RegLoc & "1207",3,"REG_DWORD"
rem ������������ �� ����������� Active X
WSHShell.RegWrite RegLoc & "1201",0,"REG_DWORD"
rem ������������ Active X
WSHShell.RegWrite RegLoc & "1200",0,"REG_DWORD"
rem ���������� ActiveX ������������ ��� ��������������
WSHShell.RegWrite RegLoc & "120B",3,"REG_DWORD"
rem ������������ �������
WSHShell.RegWrite RegLoc & "1206",3,"REG_DWORD"
rem ��������� ��� ����
WSHShell.RegWrite RegLoc & "1A10",0,"REG_DWORD"
rem ������������ Active Scripting
WSHShell.RegWrite RegLoc & "1400",0,"REG_DWORD"

rem pop-up blocker
WSHShell.RegWrite RegLoc & "1809",3,"REG_DWORD"

rem home pages
RegLoc = "HKCU\Software\Microsoft\Internet Explorer\Main\"
WSHShell.RegWrite RegLoc & "Security Risk Page","about:Blank","REG_SZ"


rem delete cookies
Set objFolder = objShell.Namespace(COOKIES)
Set objFolderItem = objFolder.Self
strPath = objFolderItem.Path
oShell.run("cmd /C del /F /Q " & strPath & "\*.*")

rem temporary internet files
Set objFolder = objShell.Namespace(TEMPIE)
Set objFolderItem = objFolder.Self
strPath = objFolderItem.Path
oShell.run("cmd /C del /F /Q " & strPath & "\*.*")

WScript.Echo("��������� Internet Explorer ��� 1C ����������� ������� ���������! ��������� 1�, ��������� � ���� �����������������->������������ ���������->���������� ���������� ��� ������ � �������")
