import mysql from "mysql2/promise";
import env from "../config/env.js";

export const pool = mysql.createPool({
  host: env.db.host,
  port: env.db.port,
  user: env.db.user,
  password: env.db.password,
  database: env.db.database,
  waitForConnections: true,
  connectionLimit: 10,
});

export async function findByEmail(email) {
  const [rows] = await pool.query(
    "SELECT id, email, name, password_hash FROM users WHERE email = ? LIMIT 1",
    [email]
  );
  return rows[0] || null;
}

export async function findById(id) {
  const [rows] = await pool.query(
    "SELECT id, email, name, created_at FROM users WHERE id = ? LIMIT 1",
    [id]
  );
  return rows[0] || null;
}

export async function createUser({ name, email, passwordHash }) {
  const [result] = await pool.query(
    "INSERT INTO users (name, email, password_hash) VALUES (?, ?, ?)",
    [name, email, passwordHash]
  );
  return {
    id: result.insertId,
    name,
    email,
  };
}