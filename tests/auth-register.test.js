const request = require('supertest');
const http = require('http');

const createApp = () => {
  return require('../src/server');
};

describe('POST /api/auth/register', () => {
  let server;
  let app;
  let pool;

  beforeAll(async () => {
    app = createApp();
    server = http.createServer(app);
    pool = require('../src/config/database').pool;
    await pool.query('DELETE FROM transactions');
    await pool.query('DELETE FROM users');
  });

  afterAll(async () => {
    await pool.query('DELETE FROM transactions');
    await pool.query('DELETE FROM users');
    await pool.end();
    server.close();
  });

  it('TC-US01-01: should register user with valid data', async () => {
    const res = await request(server)
      .post('/api/auth/register')
      .send({ name: 'John Doe', email: 'john@example.com', password: 'secret123' });
    
    expect(res.status).toBe(201);
    expect(res.body).toHaveProperty('id');
    expect(res.body).toHaveProperty('name', 'John Doe');
    expect(res.body).toHaveProperty('email', 'john@example.com');
    expect(res.body).toHaveProperty('created_at');
    expect(res.body).not.toHaveProperty('password');
    expect(res.body).not.toHaveProperty('password_hash');
  });

  it('TC-US01-07: should return 409 for duplicate email', async () => {
    await request(server)
      .post('/api/auth/register')
      .send({ name: 'First User', email: 'duplicate@example.com', password: 'secret123' });
    
    const res = await request(server)
      .post('/api/auth/register')
      .send({ name: 'Second User', email: 'duplicate@example.com', password: 'secret456' });
    
    expect(res.status).toBe(409);
    expect(res.body).toHaveProperty('error', 'Email already registered');
  });

  it('TC-US01-03: should return 400 if name is missing', async () => {
    const res = await request(server)
      .post('/api/auth/register')
      .send({ email: 'test@example.com', password: 'secret123' });
    
    expect(res.status).toBe(400);
    expect(res.body).toHaveProperty('error');
  });

  it('TC-US01-04: should return 400 if email is missing', async () => {
    const res = await request(server)
      .post('/api/auth/register')
      .send({ name: 'Test User', password: 'secret123' });
    
    expect(res.status).toBe(400);
    expect(res.body).toHaveProperty('error');
  });

  it('TC-US01-05: should return 400 if password is missing', async () => {
    const res = await request(server)
      .post('/api/auth/register')
      .send({ name: 'Test User', email: 'test@example.com' });
    
    expect(res.status).toBe(400);
    expect(res.body).toHaveProperty('error');
  });

  it('TC-US01-06: should return 400 for invalid email format', async () => {
    const res = await request(server)
      .post('/api/auth/register')
      .send({ name: 'Test', email: 'not-an-email', password: 'secret123' });
    
    expect(res.status).toBe(400);
    expect(res.body).toHaveProperty('error');
  });

  it('TC-US01-08: should return 400 for password shorter than 6 characters', async () => {
    const res = await request(server)
      .post('/api/auth/register')
      .send({ name: 'Test', email: 'test@example.com', password: '12345' });
    
    expect(res.status).toBe(400);
    expect(res.body).toHaveProperty('error');
  });
});
