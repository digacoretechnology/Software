Set objShell = CreateObject("WScript.Shell")
Set WshShell = WScript.CreateObject("WScript.Shell")
Dim oShell : Set oShell = CreateObject("WScript.Shell")
strValue = objShell.RegRead("HKLM\Software\Microsoft\Internet Explorer\Version")
strUsrProfile = objshell.ExpandEnvironmentStrings("%USERPROFILE%")
strDesktop = WshShell.SpecialFolders("Desktop")
strOS = objshell.ExpandEnvironmentStrings("%PROCESSOR_ARCHITECTURE%")
Set fso = CreateObject("Scripting.FileSystemObject")
Set objFSO = CreateObject("Scripting.FileSystemObject")
If (fso.FolderExists("c:\Program Files (x86)\Internet Explorer")) Then
      strOS = "amd64"
End If
If (objFSO.FileExists("C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe")) Then
intAnswer = _
    Msgbox("MICROSOFT EDGE NEEDS TO BE CLOSED, PRESS YES TO CONTINUE INSTALLATION AND CLOSE MICROSOFT EDGE or NO TO EXIT SETUP?", _
        vbYesNo, "Microsoft Edge")
If intAnswer = vbYes Then
    objShell.Run("RegEdit /s " & chr(34) & objShell.CurrentDirectory & "\edgesecurity.reg" & chr(34))
		Set myShortcut = objShell.CreateShortcut (strDesktop & "\Visual EMR.lnk")
		myShortcut.TargetPath = objShell.CurrentDirectory & "\" & strOS &"\edge\Visual_edge.bat"
		myShortcut.IconLocation = objShell.CurrentDirectory & "\visuali.ico"
		myShortcut.Save
		WshShell.Run "msiexec.exe /i c:\rhs\visual\emr\ScriptX.msi /passive"
		oShell.Run "taskkill /f /im msedge.exe", , True
	wscript.quit
Else
    wscript.quit
End If
  		

Else  
End If

If (objFSO.FileExists("C:\Program Files\Microsoft\Edge\Application\msedge.exe")) Then
  		objShell.Run("RegEdit /s " & chr(34) & objShell.CurrentDirectory & "\edgesecurity.reg" & chr(34))
		Set myShortcut = objShell.CreateShortcut (strDesktop & "\Visual EMR.lnk")
		myShortcut.TargetPath = objShell.CurrentDirectory & "\" & strOS &"\edge\Visual_edge.bat"
		myShortcut.IconLocation = objShell.CurrentDirectory & "\visuali.ico"
		myShortcut.Save
		WshShell.Run "msiexec.exe /i c:\rhs\visual\emr\ScriptX.msi /passive"
	wscript.quit

Else
End If


set fso = Nothing
intVersion = CInt(Left(strValue, 1))
If intVersion < 6 or intVersion >= 10 Then
msgbox "ie version not yet tested. Installation will continue"
end if

If intVersion >= 6 And intVersion < 7 Then 
		objShell.Run("RegEdit /s " & chr(34) & objShell.CurrentDirectory & "\iesecurity.reg" & chr(34))
		Set myShortcut = objShell.CreateShortcut (strDesktop & "\Visual EMR.lnk")
		myShortcut.TargetPath = objShell.CurrentDirectory & "\" & strOS & "\ie67\Visual_IE67.bat"
		myShortcut.IconLocation = objShell.CurrentDirectory & "\visuali.ico"
		myShortcut.Save
		WshShell.Run "msiexec.exe /i c:\rhs\visual\emr\ScriptX.msi /passive"
     Else If intVersion >= 7 And intVersion < 8 Then 
		objShell.Run("RegEdit /s " & chr(34) & objShell.CurrentDirectory & "\iesecurity.reg" & chr(34))
		Set myShortcut = objShell.CreateShortcut (strDesktop & "\Visual EMR.lnk")
		myShortcut.TargetPath = objShell.CurrentDirectory & "\" & strOS &"\ie67\Visual_IE67.bat"
		myShortcut.IconLocation = objShell.CurrentDirectory & "\visuali.ico"
		myShortcut.Save
		WshShell.Run "msiexec.exe /i c:\rhs\visual\emr\ScriptX.msi /passive"
     Else If intVersion >= 8 Then	
		objShell.Run("RegEdit /s " & chr(34) & objShell.CurrentDirectory & "\iesecurity.reg" & chr(34))
		Set myShortcut = objShell.CreateShortcut (strDesktop & "\Visual EMR.lnk")
		myShortcut.TargetPath = objShell.CurrentDirectory & "\" & strOS &"\ie8\Visual_IE8.bat"
		myShortcut.IconLocation = objShell.CurrentDirectory & "\visuali.ico"
		myShortcut.Save
		WshShell.Run "msiexec.exe /i c:\rhs\visual\emr\ScriptX.msi /passive"
	 End If
    End if 
End If
set objshell = Nothing