const { query } = require('../config/database');

const createUser = async (userData) => {
  const { name, email, password_hash } = userData;
  
  const result = await query(
    `INSERT INTO users (name, email, password_hash)
     VALUES ($1, $2, $3)
     RETURNING id, name, email, created_at`,
    [name, email, password_hash]
  );
  
  return result.rows[0];
};

const findUserByEmail = async (email) => {
  const result = await query(
    `SELECT id, name, email, password_hash, created_at
     FROM users
     WHERE email = $1`,
    [email]
  );
  
  return result.rows[0];
};

const findUserById = async (id) => {
  const result = await query(
    `SELECT id, name, email, created_at
     FROM users
     WHERE id = $1`,
    [id]
  );
  
  return result.rows[0];
};

module.exports = { createUser, findUserByEmail, findUserById };
