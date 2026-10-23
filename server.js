const express = require('express');
const path = require('path');
const app = express();

app.get('/check', (req, res) => {
    res.setHeader('Content-Type', 'application/octet-stream');
    res.setHeader('Content-Disposition', 'attachment; filename="check.hta"');
    res.sendFile(path.join(__dirname, 'check.hta'));
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
