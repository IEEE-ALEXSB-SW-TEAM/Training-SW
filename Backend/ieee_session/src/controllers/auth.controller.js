import express from 'express';
import { login as loginService, register as registerService } from '../services/auth.service.js';

async function register(req, res, next) {
    try {
        const { email, name, password } = req.body;
        const result = await registerService({ email, name, password });
        res.status(201).json(result);
    } catch (e) {
        e.statusCode = 409;
        next(e);
    }
}

async function login(req, res, next) {
    try {
        const { email, password } = req.body;
        const result = await loginService({ email, password });
        res.json(result);
    } catch (e) {
        next(e);
    }
}

export default { register, login };