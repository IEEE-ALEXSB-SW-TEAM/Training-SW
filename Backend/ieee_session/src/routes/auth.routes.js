import express from 'express';
import authController from '../controllers/auth.controller.js';
import requireBody from '../middlewares/validation.middleware.js';
const router = express.Router();

router.post('/register', requireBody(['email', 'password', 'name']), authController.register);
router.post('/login', requireBody(['email', 'password']), authController.login);

export default router;