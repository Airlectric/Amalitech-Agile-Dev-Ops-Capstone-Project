require('dotenv').config();

const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

const runSeed = async () => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    await client.query(`
      INSERT INTO users (name, email, password_hash)
      VALUES 
        ('Test User', 'test@example.com', '$2b$10$testhash'),
        ('Demo User', 'demo@example.com', '$2b$10$demohash')
      ON CONFLICT (email) DO NOTHING;
    `);
    
    console.log('Seed data inserted');
    await client.query('COMMIT');
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Seeding failed:', error);
    throw error;
  } finally {
    client.release();
    await pool.end();
  }
};

runSeed().catch(() => process.exit(1));
