const request = require('supertest');
const http = require('http');
const app = require('../src/server');

const server = http.createServer(app);

describe('POST /api/auth/register', () => {
  afterAll(() => {
    server.close();
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

  it('TC-US01-08: should return 400 for password shorter than 6 characters', async () => {
    const res = await request(server)
      .post('/api/auth/register')
      .send({ name: 'Test', email: 'test@example.com', password: '12345' });
    
    expect(res.status).toBe(400);
    expect(res.body).toHaveProperty('error');
  });
});
