const jwt = require('jsonwebtoken');

const generateToken = (payload) => {
  const expiresIn = process.env.JWT_EXPIRES_IN || '24h';
  
  return jwt.sign(payload, process.env.JWT_SECRET, { expiresIn });
};

const decodeToken = (token) => {
  return jwt.decode(token);
};

module.exports = { generateToken, decodeToken };
