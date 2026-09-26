import express, { type Request, type Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import dotenv from 'dotenv';

import swaggerSpec from './docs/swagger';
import { getLandingPageHtml } from './docs/landingPage';
import { getSwaggerHtml } from './docs/swaggerPage';
import authRoutes from './routes/auth.routes';
import { notFound, errorHandler } from './middleware/errorHandler';
import { requestLogger } from './utils/logger';

dotenv.config();

const app = express();

app.use(requestLogger);
app.use(
  helmet({
    contentSecurityPolicy: false,
  })
);
app.use(cors());

app.use(express.json({ limit: '4mb' }));

app.get('/health', (_req: Request, res: Response) => {
  res.status(200).json({ success: true, message: 'API is healthy' });
});

app.use('/api/auth', authRoutes);

app.get('/openapi.json', (_req: Request, res: Response) => {
  res.status(200).json(swaggerSpec);
});

app.get('/api/v1/docs/openapi.json', (_req: Request, res: Response) => {
  res.status(200).json(swaggerSpec);
});


app.get('/api/v1/docs', (_req: Request, res: Response) => {
  res.setHeader('Content-Type', 'text/html');
  res.status(200).send(getSwaggerHtml('/api/v1/docs/openapi.json'));
});

app.get('/', (_req: Request, res: Response) => {
  res.setHeader('Content-Type', 'text/html');
  res.status(200).send(getLandingPageHtml());
});

app.use(notFound);
app.use(errorHandler);

export default app;