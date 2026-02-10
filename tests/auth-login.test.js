const request = require('supertest');
const http = require('http');
const jwt = require('jsonwebtoken');

describe('POST /api/auth/login', () => {
  let server;
  let app;
  let pool;

  beforeAll(async () => {
    app = require('../src/server');
    server = http.createServer(app);
    pool = require('../src/config/database').pool;
    await pool.query('DELETE FROM transactions');
    await pool.query('DELETE FROM users');
    
    await request(server)
      .post('/api/auth/register')
      .send({ name: 'Login Test', email: 'login@example.com', password: 'secret123' });
  });

  afterAll(async () => {
    await pool.query('DELETE FROM transactions');
    await pool.query('DELETE FROM users');
    await pool.end();
    server.close();
  });

  it('TC-US02-01: should return 200 with JWT token on valid login', async () => {
    const res = await request(server)
      .post('/api/auth/login')
      .send({ email: 'login@example.com', password: 'secret123' });
    
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('token');
    expect(typeof res.body.token).toBe('string');
  });

  it('TC-US02-03: should include userId and email in JWT payload', async () => {
    const res = await request(server)
      .post('/api/auth/login')
      .send({ email: 'login@example.com', password: 'secret123' });
    
    const decoded = jwt.decode(res.body.token);
    expect(decoded).toHaveProperty('userId');
    expect(decoded).toHaveProperty('email', 'login@example.com');
  });

  it('TC-US02-04: should return 401 for non-existent email', async () => {
    const res = await request(server)
      .post('/api/auth/login')
      .send({ email: 'nonexistent@example.com', password: 'secret123' });
    
    expect(res.status).toBe(401);
    expect(res.body).toHaveProperty('error', 'Invalid credentials');
  });

  it('TC-US02-05: should return 401 for wrong password', async () => {
    const res = await request(server)
      .post('/api/auth/login')
      .send({ email: 'login@example.com', password: 'wrongpassword' });
    
    expect(res.status).toBe(401);
    expect(res.body).toHaveProperty('error', 'Invalid credentials');
  });

  it('TC-US02: should return 400 when email is missing', async () => {
    const res = await request(server)
      .post('/api/auth/login')
      .send({ password: 'secret123' });
    
    expect(res.status).toBe(400);
  });

  it('TC-US02: should return 400 when password is missing', async () => {
    const res = await request(server)
      .post('/api/auth/login')
      .send({ email: 'login@example.com' });
    
    expect(res.status).toBe(400);
  });
});
