import type { Request, Response, NextFunction } from 'express';
import { logger } from '../utils/logger';

export interface HttpError extends Error {
  status?: number;
}

export const notFound = (req: Request, res: Response): void => {
  logger.warn(`404 Not Found: ${req.method} ${req.originalUrl}`);
  res.status(404).json({
    success: false,
    message: `Route ${req.method} ${req.originalUrl} not found`,
  });
};

export const errorHandler = (
  err: HttpError,
  req: Request,
  res: Response,
  _next: NextFunction
): void => {
  logger.error(`Error handling ${req.method} ${req.originalUrl}:`, err);

  const status = err.status || 500;
  const message =
    status < 500 && err.message ? err.message : 'Something went wrong. Please try again.';

  res.status(status).json({
    success: false,
    message,
  });
};