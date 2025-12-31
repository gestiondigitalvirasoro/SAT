// Entry point for the Express app
require('dotenv').config();
const express = require('express');
const path = require('path');
const session = require('express-session');

const app = express();
const PORT = process.env.PORT || 3000;

// Session configuration
app.use(session({
  secret: process.env.SESSION_SECRET || 'mi-secreto-demo',
  resave: false,
  saveUninitialized: false,
  cookie: { 
    secure: process.env.NODE_ENV === 'production', // true en producción
    maxAge: 24 * 60 * 60 * 1000 // 24 horas
  }
}));

// Middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// View engine
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// Static files
app.use(express.static(path.join(__dirname, '..', 'public')));

// Middleware de demostración: crear sesión automática
app.use((req, res, next) => {
  if (!req.session.user && req.path === '/dashboard') {
    req.session.user = {
      id: 1,
      name: 'Administrador Demo',
      email: 'admin@potenciaactiva.com',
      role: 'admin'
    };
  }
  next();
});

// Routes
app.use('/', require('./routes/index'));
app.use('/api', require('./routes/api'));
app.use('/auth', require('./routes/auth'));

// 404
app.use((req, res) => {
  res.status(404).render('layouts/main', { title: '404', page: '../pages/404', url: req.originalUrl });
});

// Error handler
app.use(require('./lib/errorHandler'));

// Start server only if not in serverless environment (Vercel)
if (!process.env.VERCEL) {
  app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
  });
}

module.exports = app;
