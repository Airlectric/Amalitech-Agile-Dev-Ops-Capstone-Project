const request = require('supertest');
const http = require('http');

describe('GET /api/transactions', () => {
  let server;
  let app;
  let pool;
  let token;
  let token2;
  let testUserEmail = 'list@test.com';
  let testUser2Email = 'other@test.com';

  beforeAll(async () => {
    app = require('../src/server');
    server = http.createServer(app);
    pool = require('../src/config/database').pool;
    
    await pool.query('DELETE FROM transactions');
    await pool.query('DELETE FROM users');
    
    await request(server)
      .post('/api/auth/register')
      .send({ name: 'List Test User', email: testUserEmail, password: 'secret123' });
    
    const loginRes = await request(server)
      .post('/api/auth/login')
      .send({ email: testUserEmail, password: 'secret123' });
    token = loginRes.body.token;
    
    await request(server)
      .post('/api/auth/register')
      .send({ name: 'Other User', email: testUser2Email, password: 'secret123' });
    
    const loginRes2 = await request(server)
      .post('/api/auth/login')
      .send({ email: testUser2Email, password: 'secret123' });
    token2 = loginRes2.body.token;
    
    await request(server)
      .post('/api/transactions')
      .set('Authorization', `Bearer ${token}`)
      .send({ type: 'expense', amount: 100, category: 'groceries', date: '2026-01-01' });
    
    await request(server)
      .post('/api/transactions')
      .set('Authorization', `Bearer ${token}`)
      .send({ type: 'expense', amount: 50, category: 'transport', date: '2026-02-01' });
    
    await request(server)
      .post('/api/transactions')
      .set('Authorization', `Bearer ${token}`)
      .send({ type: 'income', amount: 5000, category: 'salary', date: '2026-01-15' });
    
    await request(server)
      .post('/api/transactions')
      .set('Authorization', `Bearer ${token2}`)
      .send({ type: 'expense', amount: 200, category: 'food', date: '2026-01-10' });
  });

  afterAll(async () => {
    await pool.query('DELETE FROM transactions');
    await pool.query('DELETE FROM users');
    await pool.end();
    server.close();
  });

  it('TC-US04-01: should return only authenticated user transactions', async () => {
    const res = await request(server)
      .get('/api/transactions')
      .set('Authorization', `Bearer ${token}`);
    
    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(3);
    const categories = res.body.map(tx => tx.category);
    expect(categories).not.toContain('food');
  });

  it('TC-US04-02: should sort transactions by date descending', async () => {
    const res = await request(server)
      .get('/api/transactions')
      .set('Authorization', `Bearer ${token}`);
    
    expect(res.status).toBe(200);
    expect(res.body[0].date).toContain('2026-02-01');
    expect(res.body[1].date).toContain('2026-01-15');
    expect(res.body[2].date).toContain('2026-01-01');
  });

  it('TC-US04-03: should return empty array for user with no transactions', async () => {
    await request(server)
      .post('/api/auth/register')
      .send({ name: 'New User', email: 'newuser@test.com', password: 'secret123' });
    
    const loginRes = await request(server)
      .post('/api/auth/login')
      .send({ email: 'newuser@test.com', password: 'secret123' });
    
    const res = await request(server)
      .get('/api/transactions')
      .set('Authorization', `Bearer ${loginRes.body.token}`);
    
    expect(res.status).toBe(200);
    expect(res.body).toEqual([]);
  });

  it('TC-US04-04: should return 401 without authentication', async () => {
    const res = await request(server)
      .get('/api/transactions');
    
    expect(res.status).toBe(401);
  });

  it('TC-US05-01: should filter by type', async () => {
    const res = await request(server)
      .get('/api/transactions?type=expense')
      .set('Authorization', `Bearer ${token}`);
    
    expect(res.status).toBe(200);
    res.body.forEach(tx => {
      expect(tx.type).toBe('expense');
    });
  });

  it('TC-US05-02: should filter by category (case-insensitive)', async () => {
    const res = await request(server)
      .get('/api/transactions?category=GROCERIES')
      .set('Authorization', `Bearer ${token}`);
    
    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(1);
    expect(res.body[0].category.toLowerCase()).toBe('groceries');
  });

  it('TC-US05-03: should filter by date range', async () => {
    const res = await request(server)
      .get('/api/transactions?from=2026-01-01&to=2026-01-31')
      .set('Authorization', `Bearer ${token}`);
    
    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(2);
    res.body.forEach(tx => {
      expect(new Date(tx.date).getMonth()).toBe(0);
    });
  });

  it('TC-US05-04: should combine multiple filters', async () => {
    const res = await request(server)
      .get('/api/transactions?type=expense&category=groceries')
      .set('Authorization', `Bearer ${token}`);
    
    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(1);
    expect(res.body[0].type).toBe('expense');
    expect(res.body[0].category).toBe('groceries');
  });

  it('TC-US05-05: should return empty array if no matches', async () => {
    const res = await request(server)
      .get('/api/transactions?category=nonexistent')
      .set('Authorization', `Bearer ${token}`);
    
    expect(res.status).toBe(200);
    expect(res.body).toEqual([]);
  });
});
