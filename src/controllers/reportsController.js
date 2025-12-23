const Reports = require('../models/Reports');

exports.list = async (req, res, next) => {
  try {
    const data = await Reports.list();
    res.json(data);
  } catch (err) {
    next(err);
  }
};

exports.create = async (req, res, next) => {
  try {
    const payload = req.body;
    const created = await Reports.create(payload);
    res.status(201).json(created);
  } catch (err) {
    next(err);
  }
};

exports.getById = async (req, res, next) => {
  try {
    const id = req.params.id;
    const item = await Reports.getById(id);
    if (!item) return res.status(404).json({ error: 'Not found' });
    res.json(item);
  } catch (err) { 
    next(err); 
  }
};

exports.update = async (req, res, next) => {
  try {
    const id = req.params.id;
    const payload = req.body;
    const updated = await Reports.update(id, payload);
    res.json(updated);
  } catch (err) { 
    next(err); 
  }
};