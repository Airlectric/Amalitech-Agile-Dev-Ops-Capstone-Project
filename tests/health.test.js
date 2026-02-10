const request = require('supertest');
const http = require('http');

describe('GET /health - Comprehensive Tests', () => {
  let server;
  let app;
  let pool;

  beforeAll(async () => {
    app = require('../src/server');
    server = http.createServer(app);
    pool = require('../src/config/database').pool;
  });

  afterAll(async () => {
    await pool.end();
    server.close();
  });

  it('TC-US07-01: should return 200 when healthy', async () => {
    const res = await request(server)
      .get('/health');
    
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('status', 'healthy');
    expect(res.body).toHaveProperty('uptime_seconds');
    expect(res.body).toHaveProperty('timestamp');
    expect(res.body).toHaveProperty('database', 'connected');
    expect(res.body).toHaveProperty('version');
  });

  it('TC-US07-02: should verify database connectivity', async () => {
    const res = await request(server)
      .get('/health');
    
    expect(res.body.database).toBe('connected');
  });

  it('TC-US07-03: should not require authentication', async () => {
    const res = await request(server)
      .get('/health');
    
    expect(res.status).toBe(200);
  });

  it('should return all required fields in response', async () => {
    const res = await request(server)
      .get('/health');
    
    expect(res.body).toHaveProperty('status');
    expect(res.body).toHaveProperty('uptime_seconds');
    expect(res.body).toHaveProperty('timestamp');
    expect(res.body).toHaveProperty('database');
    expect(res.body).toHaveProperty('version');
    
    expect(typeof res.body.uptime_seconds).toBe('number');
    expect(typeof res.body.timestamp).toBe('string');
    expect(res.body.status).toMatch(/^(healthy|unhealthy)$/);
    expect(res.body.database).toMatch(/^(connected|disconnected)$/);
    expect(res.body.version).toMatch(/^\d+\.\d+\.\d+$/);
  });

  it('should return valid ISO timestamp', async () => {
    const res = await request(server)
      .get('/health');
    
    expect(() => new Date(res.body.timestamp)).not.toThrow();
  });
});
