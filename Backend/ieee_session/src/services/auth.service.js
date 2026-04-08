import { findByEmail, createUser } from "../models/user.model.js";
import { hashPassword, comparePassword } from "../utils/hashPassword.js";
import  generateToken  from "../utils/generateToken.js";

export async function register({ email, name, password }) {
  const exists = await findByEmail(email);
  if (exists) {
    const e = new Error("Email already exists");
    e.statusCode = 409;
    throw e;
  }

  const passwordHash = await hashPassword(password);
  const user = await createUser({ email, name, passwordHash });

  const token = generateToken({ userId: user.id, email: user.email });
  return { user, token };
}

export async function login({ email, password }) {
  const userRow = await findByEmail(email);
  if (!userRow) {
    const e = new Error("Invalid email or password");
    e.statusCode = 401;
    throw e;
  }

  const ok = await comparePassword(password, userRow.password_hash);
  if (!ok) {
    const e = new Error("Invalid email or password");
    e.statusCode = 401;
    throw e;
  }

  const user = { id: userRow.id, email: userRow.email, name: userRow.name };
  const token = generateToken({ userId: user.id, email: user.email });
  return { user, token };
}


export default { register, login };