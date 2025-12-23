module.exports = (err, req, res, next) => {
  console.error('Error:', err.message || err);
  const status = err.status || 500;
  if (req.originalUrl.startsWith('/api')) {
    return res.status(status).json({ error: err.message || 'Internal Server Error' });
  }
  res.status(status).render('layouts/main', { title: 'Error', page: '../pages/error', error: err });
};