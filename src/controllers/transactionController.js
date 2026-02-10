const { body, validationResult, query } = require('express-validator');
const { createTransaction, getUserTransactions, getTransactionSummary } = require('../models/transaction');
const { logger } = require('../config/logger');

const createTransactionValidation = [
  body('type').isIn(['income', 'expense']).withMessage('Type must be income or expense'),
  body('amount').isFloat({ min: 0.01 }).withMessage('Amount must be a positive number'),
  body('category').trim().notEmpty().withMessage('Category is required'),
  body('description').optional().trim(),
  body('date').optional().isISO8601().withMessage('Invalid date format'),
];

const getTransactionsValidation = [
  query('type').optional().isIn(['income', 'expense']),
  query('category').optional().trim(),
  query('from').optional().isISO8601(),
  query('to').optional().isISO8601(),
];

const addTransaction = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { type, amount, category, description, date } = req.body;
    
    const transaction = await createTransaction({
      user_id: req.user.userId,
      type,
      amount,
      category,
      description,
      date,
    });
    
    logger.info(`Transaction created: ${type} ${amount} by user ${req.user.userId}`);
    
    res.status(201).json(transaction);
  } catch (error) {
    logger.error('Create transaction error:', error);
    res.status(500).json({ error: 'Failed to create transaction' });
  }
};

const listTransactions = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { type, category, from, to } = req.query;
    
    const transactions = await getUserTransactions(req.user.userId, {
      type,
      category,
      from,
      to,
    });
    
    res.json(transactions);
  } catch (error) {
    logger.error('List transactions error:', error);
    res.status(500).json({ error: 'Failed to retrieve transactions' });
  }
};

const getSummary = async (req, res) => {
  try {
    const { from, to } = req.query;
    
    const summary = await getTransactionSummary(req.user.userId, { from, to });
    
    res.json(summary);
  } catch (error) {
    logger.error('Get summary error:', error);
    res.status(500).json({ error: 'Failed to retrieve summary' });
  }
};

module.exports = {
  addTransaction,
  listTransactions,
  getSummary,
  createTransactionValidation,
  getTransactionsValidation,
};
