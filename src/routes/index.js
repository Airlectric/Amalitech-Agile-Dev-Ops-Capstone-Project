const express = require('express');
const authRoutes = require('./authRoutes');
const transactionRoutes = require('./transactionRoutes');

const router = express.Router();

router.use('/auth', authRoutes);
router.use('/transactions', transactionRoutes);

module.exports = router;
