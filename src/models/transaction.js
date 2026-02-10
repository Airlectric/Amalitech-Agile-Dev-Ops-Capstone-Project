const { query } = require('../config/database');

const createTransaction = async (transactionData) => {
  const { user_id, type, amount, category, description, date } = transactionData;
  
  const result = await query(
    `INSERT INTO transactions (user_id, type, amount, category, description, date)
     VALUES ($1, $2, $3, $4, $5, $6)
     RETURNING id, user_id, type, amount, category, description, date, created_at`,
    [user_id, type, amount, category, description || null, date || new Date()]
  );
  
  return result.rows[0];
};

const getUserTransactions = async (userId, filters = {}) => {
  let sql = `
    SELECT id, type, amount, category, description, date, created_at
    FROM transactions
    WHERE user_id = $1
  `;
  
  const params = [userId];
  let paramIndex = 2;
  
  if (filters.type) {
    sql += ` AND type = $${paramIndex}`;
    params.push(filters.type);
    paramIndex++;
  }
  
  if (filters.category) {
    sql += ` AND LOWER(category) = LOWER($${paramIndex})`;
    params.push(filters.category);
    paramIndex++;
  }
  
  if (filters.from) {
    sql += ` AND date >= $${paramIndex}`;
    params.push(filters.from);
    paramIndex++;
  }
  
  if (filters.to) {
    sql += ` AND date <= $${paramIndex}`;
    params.push(filters.to);
    paramIndex++;
  }
  
  sql += ' ORDER BY date DESC, created_at DESC';
  
  const result = await query(sql, params);
  return result.rows;
};

const getTransactionSummary = async (userId, dateRange = {}) => {
  let sql = `
    SELECT
      COALESCE(SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END), 0) as total_income,
      COALESCE(SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END), 0) as total_expenses
    FROM transactions
    WHERE user_id = $1
  `;
  
  const params = [userId];
  let paramIndex = 2;
  
  if (dateRange.from) {
    sql += ` AND date >= $${paramIndex}`;
    params.push(dateRange.from);
    paramIndex++;
  }
  
  if (dateRange.to) {
    sql += ` AND date <= $${paramIndex}`;
    params.push(dateRange.to);
    paramIndex++;
  }
  
  const result = await query(sql, params);
  const { total_income, total_expenses } = result.rows[0];
  
  let byCategorySql = `
    SELECT
      category,
      type,
      COALESCE(SUM(amount), 0) as total
    FROM transactions
    WHERE user_id = $1
  `;
  
  const categoryParams = [userId];
  let catParamIndex = 2;
  
  if (dateRange.from) {
    byCategorySql += ` AND date >= $${catParamIndex}`;
    categoryParams.push(dateRange.from);
    catParamIndex++;
  }
  
  if (dateRange.to) {
    byCategorySql += ` AND date <= $${catParamIndex}`;
    categoryParams.push(dateRange.to);
    catParamIndex++;
  }
  
  byCategorySql += ' GROUP BY category, type';
  
  const categoryResult = await query(byCategorySql, categoryParams);
  
  const byCategory = {};
  categoryResult.rows.forEach(row => {
    byCategory[row.category] = row.type === 'expense' 
      ? -parseFloat(row.total) 
      : parseFloat(row.total);
  });
  
  return {
    total_income: parseFloat(total_income),
    total_expenses: parseFloat(total_expenses),
    balance: parseFloat(total_income) - parseFloat(total_expenses),
    by_category: byCategory,
  };
};

module.exports = { createTransaction, getUserTransactions, getTransactionSummary };
