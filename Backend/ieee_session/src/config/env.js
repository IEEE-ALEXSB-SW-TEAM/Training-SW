
import dotenv from "dotenv";
dotenv.config();

function must(key) {
  const v = process.env[key];
  if (!v) throw new Error(`Missing env var: ${key}`);
  return v;
}

export default {
  port: Number(must("PORT")),
  nodeEnv: process.env.NODE_ENV || "development",
  db: {
    host: must("DB_HOST"),
    port: Number(must("DB_PORT")),
    user: must("DB_USER"),
    password: must("DB_PASSWORD"),
    database: must("DB_NAME"),
  },
  jwt: {
    secret: must("JWT_SECRET"),
    expiresIn: must("JWT_EXPIRES_IN"),
  },
};