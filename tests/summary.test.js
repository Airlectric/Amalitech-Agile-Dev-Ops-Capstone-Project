const request = require('supertest');
const http = require('http');

describe('GET /api/transactions/summary', () => {
  let server;
  let app;
  let pool;
  let token;

  beforeAll(async () => {
    app = require('../src/server');
    server = http.createServer(app);
    pool = require('../src/config/database').pool;
    
    await pool.query('DELETE FROM transactions');
    await pool.query('DELETE FROM users');
    
    await request(server)
      .post('/api/auth/register')
      .send({ name: 'Summary Test', email: 'summary@test.com', password: 'secret123' });
    
    const loginRes = await request(server)
      .post('/api/auth/login')
      .send({ email: 'summary@test.com', password: 'secret123' });
    token = loginRes.body.token;
    
    await request(server)
      .post('/api/transactions')
      .set('Authorization', `Bearer ${token}`)
      .send({ type: 'income', amount: 1000, category: 'salary', date: '2026-01-15' });
    
    await request(server)
      .post('/api/transactions')
      .set('Authorization', `Bearer ${token}`)
      .send({ type: 'expense', amount: 200, category: 'food', date: '2026-01-20' });
    
    await request(server)
      .post('/api/transactions')
      .set('Authorization', `Bearer ${token}`)
      .send({ type: 'expense', amount: 100, category: 'transport', date: '2026-02-10' });
  });

  afterAll(async () => {
    await pool.query('DELETE FROM transactions');
    await pool.query('DELETE FROM users');
    await pool.end();
    server.close();
  });

  it('TC-US06-01: should return correct summary calculations', async () => {
    const res = await request(server)
      .get('/api/transactions/summary')
      .set('Authorization', `Bearer ${token}`);
    
    expect(res.status).toBe(200);
    expect(parseFloat(res.body.total_income)).toBe(1000);
    expect(parseFloat(res.body.total_expenses)).toBe(300);
    expect(parseFloat(res.body.balance)).toBe(700);
    expect(res.body.by_category).toHaveProperty('salary');
    expect(res.body.by_category).toHaveProperty('food');
    expect(res.body.by_category).toHaveProperty('transport');
  });

  it('TC-US06-02: should only include authenticated user data', async () => {
    await request(server)
      .post('/api/auth/register')
      .send({ name: 'Other', email: 'other@summary.com', password: 'secret123' });
    
    const loginRes = await request(server)
      .post('/api/auth/login')
      .send({ email: 'other@summary.com', password: 'secret123' });
    
    await request(server)
      .post('/api/transactions')
      .set('Authorization', `Bearer ${loginRes.body.token}`)
      .send({ type: 'income', amount: 500, category: 'salary' });
    
    const res = await request(server)
      .get('/api/transactions/summary')
      .set('Authorization', `Bearer ${token}`);
    
    expect(parseFloat(res.body.total_income)).toBe(1000);
  });

  it('TC-US06-03: should respect date range filter', async () => {
    const res = await request(server)
      .get('/api/transactions/summary?from=2026-01-01&to=2026-01-31')
      .set('Authorization', `Bearer ${token}`);
    
    expect(res.status).toBe(200);
    expect(parseFloat(res.body.total_income)).toBe(1000);
    expect(parseFloat(res.body.total_expenses)).toBe(200);
  });

  it('TC-US06-04: should return zeros for user with no transactions', async () => {
    await request(server)
      .post('/api/auth/register')
      .send({ name: 'Empty', email: 'empty@summary.com', password: 'secret123' });
    
    const loginRes = await request(server)
      .post('/api/auth/login')
      .send({ email: 'empty@summary.com', password: 'secret123' });
    
    const res = await request(server)
      .get('/api/transactions/summary')
      .set('Authorization', `Bearer ${loginRes.body.token}`);
    
    expect(res.status).toBe(200);
    expect(parseFloat(res.body.total_income)).toBe(0);
    expect(parseFloat(res.body.total_expenses)).toBe(0);
    expect(parseFloat(res.body.balance)).toBe(0);
    expect(res.body.by_category).toEqual({});
  });

  it('should return 401 without authentication', async () => {
    const res = await request(server)
      .get('/api/transactions/summary');
    
    expect(res.status).toBe(401);
  });
});
