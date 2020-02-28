Set oLogQuery = CreateObject("MSUtil.LogQuery")
Set oFormat = CreateObject("MSUtil.LogQuery.FileSystemInputFormat")
Set oRecordSet = oLogQuery.Execute("SELECT * FROM 'Backupdir\\*.bak'", oFormat)
DateToCopy = DateAdd("M", -2, now)
Set fso = CreateObject("Scripting.FileSystemObject")
Dim WshShell
Set WshShell = CreateObject("WScript.Shell")
While Not oRecordSet.atEnd
    Set oRecord = oRecordSet.getRecord()    
    strValue = oRecord.getValue("Path")
    if fso.FIleExists(strValue) then
    	Set oFile =  fso.GetFile(strValue)
    	DateFile = oFile.DateCreated
    	DiffDate = DateDiff("d", DateFile, DateToCopy)
        if DiffDate > 0 Then
            PathToCopy = "directorytocopy" & year(DateFile) & "_" & month (DateFile) & "_" & day(DateFile) & "\"
            if fso.FolderExists(PathToCopy) = false then
            	fso.CreateFolder PathToCopy  
            End If		
	    fso.CopyFile StrValue, PathToCopy, 1		
	    fso.DeleteFile StrValue, 1
        End if
    	oRecordSet.moveNext
    end if
Wend
oRecordSet.Close
