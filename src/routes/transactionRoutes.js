const express = require('express');
const { authMiddleware } = require('../middleware/auth');
const {
  addTransaction,
  listTransactions,
  getSummary,
  createTransactionValidation,
  getTransactionsValidation,
} = require('../controllers/transactionController');
const { validate } = require('../middleware/validate');

const router = express.Router();

router.use(authMiddleware);

router.post('/',
  createTransactionValidation,
  validate,
  addTransaction
);

router.get('/',
  getTransactionsValidation,
  validate,
  listTransactions
);

router.get('/summary',
  [
    require('express-validator').query('from').optional().isISO8601(),
    require('express-validator').query('to').optional().isISO8601(),
  ],
  validate,
  getSummary
);

module.exports = router;
