// Entry point for the Express app
require('dotenv').config();
const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// View engine
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// Static files
app.use(express.static(path.join(__dirname, '..', 'public')));

// Routes
app.use('/', require('./routes/index'));
app.use('/api', require('./routes/api'));

// 404
app.use((req, res) => {
  res.status(404).render('layouts/main', { title: '404', page: '../pages/404', url: req.originalUrl });
});

// Error handler
app.use(require('./lib/errorHandler'));

// Start server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
