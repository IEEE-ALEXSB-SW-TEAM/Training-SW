import jwt from "jsonwebtoken";
import env from "../config/env.js";

export default function authMiddleware(req, res, next) {
    const header = req.headers.authorization;
    const [type, token] = header ? header.split(' ') : [null, null];

    if (type !== 'Bearer' || !token) {
        return res.status(401).json({ error: 'Unauthorized: missing Bearer token' });
    }

    try {
        const decoded = jwt.verify(token, env.jwt.secret);
        req.user = decoded; //{userId, email}
        next();
    } catch (e) {
        return res.status(401).json({ error: 'Unauthorized: invalid token' });
    }
}