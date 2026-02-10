const request = require('supertest');
const app = require('../src/server');
const { pool } = require('../src/config/database');

beforeAll(async () => {
  await pool.query('DROP TABLE IF EXISTS transactions');
  await pool.query('DROP TABLE IF EXISTS users');
});

afterAll(async () => {
  await pool.query('DROP TABLE IF EXISTS transactions');
  await pool.query('DROP TABLE IF EXISTS users');
  await pool.end();
});

describe('GET /health', () => {
  it('TC-US07-03: should not require authentication', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
  });
});
