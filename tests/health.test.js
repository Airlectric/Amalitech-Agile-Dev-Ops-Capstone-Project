const request = require('supertest');
const http = require('http');
const app = require('../src/server');

const server = http.createServer(app);

describe('GET /health', () => {
  afterAll(() => {
    server.close();
  });

  it('TC-US07-03: should not require authentication', async () => {
    const res = await request(server).get('/health');
    expect([200, 503]).toContain(res.status);
    expect(res.body).toHaveProperty('status');
    expect(res.body).toHaveProperty('timestamp');
    expect(res.body).toHaveProperty('version');
    expect(res.body).toHaveProperty('database');
  });
});
