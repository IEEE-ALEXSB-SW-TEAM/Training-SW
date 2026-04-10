import express from 'express';
import authRoutes from './routes/auth.routes.js';
import errorMiddleware from './middlewares/error.middleware.js';
import userRoutes from './routes/user.routes.js';
import notFoundMiddleware from './middlewares/notFound.middleware.js';
const app = express();

app.use(express.json());

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK!' });
});
app.use('/api/users', userRoutes);
app.use('/api/auth', authRoutes);
app.use(notFoundMiddleware);
app.use(errorMiddleware);
export default app;

