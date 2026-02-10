const request = require('supertest');
const http = require('http');

describe('POST /api/transactions', () => {
  let server;
  let app;
  let pool;
  let token;
  let testUserEmail = 'trans@test.com';

  beforeAll(async () => {
    app = require('../src/server');
    server = http.createServer(app);
    pool = require('../src/config/database').pool;
    
    await pool.query('DELETE FROM transactions');
    await pool.query('DELETE FROM users');
    
    await request(server)
      .post('/api/auth/register')
      .send({ name: 'Transaction Test', email: testUserEmail, password: 'secret123' });
    
    const loginRes = await request(server)
      .post('/api/auth/login')
      .send({ email: testUserEmail, password: 'secret123' });
    
    token = loginRes.body.token;
  });

  afterAll(async () => {
    await pool.query('DELETE FROM transactions');
    await pool.query('DELETE FROM users');
    await pool.end();
    server.close();
  });

  it('TC-US03-01: should create transaction with valid data', async () => {
    const res = await request(server)
      .post('/api/transactions')
      .set('Authorization', `Bearer ${token}`)
      .send({ type: 'expense', amount: 50.00, category: 'food', description: 'Lunch' });
    
    expect(res.status).toBe(201);
    expect(res.body).toHaveProperty('id');
    expect(res.body).toHaveProperty('type', 'expense');
    expect(res.body).toHaveProperty('amount', '50.00');
    expect(res.body).toHaveProperty('category', 'food');
    expect(res.body).toHaveProperty('description', 'Lunch');
  });

  it('TC-US03-02: should return 401 without token', async () => {
    const res = await request(server)
      .post('/api/transactions')
      .send({ type: 'expense', amount: 50.00, category: 'food' });
    
    expect(res.status).toBe(401);
  });

  it('TC-US03-03: should return 401 with invalid token', async () => {
    const res = await request(server)
      .post('/api/transactions')
      .set('Authorization', 'Bearer invalid-token-here')
      .send({ type: 'expense', amount: 50.00, category: 'food' });
    
    expect(res.status).toBe(401);
  });

  it('TC-US03-04: should return 400 for invalid type', async () => {
    const res = await request(server)
      .post('/api/transactions')
      .set('Authorization', `Bearer ${token}`)
      .send({ type: 'invalid', amount: 50.00, category: 'food' });
    
    expect(res.status).toBe(400);
  });

  it('TC-US03-05: should return 400 for negative amount', async () => {
    const res = await request(server)
      .post('/api/transactions')
      .set('Authorization', `Bearer ${token}`)
      .send({ type: 'expense', amount: -50, category: 'food' });
    
    expect(res.status).toBe(400);
  });

  it('TC-US03-05b: should return 400 for zero amount', async () => {
    const res = await request(server)
      .post('/api/transactions')
      .set('Authorization', `Bearer ${token}`)
      .send({ type: 'expense', amount: 0, category: 'food' });
    
    expect(res.status).toBe(400);
  });

  it('TC-US03-06: should return 400 if category is missing', async () => {
    const res = await request(server)
      .post('/api/transactions')
      .set('Authorization', `Bearer ${token}`)
      .send({ type: 'expense', amount: 50.00 });
    
    expect(res.status).toBe(400);
  });

  it('TC-US03-07: should default date to today if not provided', async () => {
    const today = new Date().toISOString().split('T')[0];
    
    const res = await request(server)
      .post('/api/transactions')
      .set('Authorization', `Bearer ${token}`)
      .send({ type: 'income', amount: 100, category: 'salary' });
    
    expect(res.status).toBe(201);
    expect(res.body.date).toContain(today);
  });

  it('should create income transaction successfully', async () => {
    const res = await request(server)
      .post('/api/transactions')
      .set('Authorization', `Bearer ${token}`)
      .send({ type: 'income', amount: 5000, category: 'salary', date: '2026-01-15' });
    
    expect(res.status).toBe(201);
    expect(res.body).toHaveProperty('type', 'income');
    expect(res.body).toHaveProperty('amount', '5000.00');
    expect(res.body).toHaveProperty('category', 'salary');
  });
});
