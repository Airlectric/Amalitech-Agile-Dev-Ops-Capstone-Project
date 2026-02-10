const request = require('supertest');
const app = require('../src/server');
const { pool } = require('../src/config/database');

beforeAll(async () => {
  await pool.query('DROP TABLE IF EXISTS transactions');
  await pool.query('DROP TABLE IF EXISTS users');
  
  await pool.query(`
    CREATE TABLE users (
      id SERIAL PRIMARY KEY,
      email VARCHAR(255) UNIQUE NOT NULL,
      password_hash VARCHAR(255) NOT NULL,
      name VARCHAR(100) NOT NULL,
      created_at TIMESTAMPTZ DEFAULT NOW()
    )
  `);
});

afterAll(async () => {
  await pool.query('DROP TABLE IF EXISTS transactions');
  await pool.query('DROP TABLE IF EXISTS users');
  await pool.end();
});

describe('POST /api/auth/register', () => {
  it('TC-US01-03: should return 400 if name is missing', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send({ email: 'test@example.com', password: 'secret123' });
    
    expect(res.status).toBe(400);
    expect(res.body.errors[0].path).toBe('name');
  });

  it('TC-US01-04: should return 400 if email is missing', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send({ name: 'Test User', password: 'secret123' });
    
    expect(res.status).toBe(400);
    expect(res.body.errors[0].path).toBe('email');
  });

  it('TC-US01-05: should return 400 if password is missing', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send({ name: 'Test User', email: 'test@example.com' });
    
    expect(res.status).toBe(400);
    expect(res.body.errors[0].path).toBe('password');
  });

  it('TC-US01-08: should return 400 for password shorter than 6 characters', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send({ name: 'Test', email: 'test@example.com', password: '12345' });
    
    expect(res.status).toBe(400);
  });
});
