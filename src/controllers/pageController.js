// Renders pages using the main layout and partials
exports.home = (req, res) => {
  res.render('layouts/main', { title: 'SAT - Inicio', page: '../pages/home' });
};

exports.faq = (req, res) => {
  res.render('layouts/main', { title: 'SAT - FAQ', page: '../pages/faq' });
};

exports.about = (req, res) => {
  res.render('layouts/main', { title: 'SAT - About', page: '../pages/about' });
};
