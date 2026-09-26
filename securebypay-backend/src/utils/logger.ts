import type { Request, Response, NextFunction } from 'express';

const colors = {
  reset: '\x1b[0m',
  info: '\x1b[36m',
  success: '\x1b[32m',
  warn: '\x1b[33m',
  error: '\x1b[31m',
  http: '\x1b[35m',
  dim: '\x1b[2m',
};

const formatTimestamp = (): string => new Date().toISOString();

export const logger = {
  info: (message: string, ...meta: unknown[]): void => {
    console.log(
      `${colors.dim}[${formatTimestamp()}]${colors.reset} ${colors.info}[INFO]${colors.reset} ${message}`,
      ...meta
    );
  },
  warn: (message: string, ...meta: unknown[]): void => {
    console.warn(
      `${colors.dim}[${formatTimestamp()}]${colors.reset} ${colors.warn}[WARN]${colors.reset} ${message}`,
      ...meta
    );
  },
  error: (message: string, ...meta: unknown[]): void => {
    console.error(
      `${colors.dim}[${formatTimestamp()}]${colors.reset} ${colors.error}[ERROR]${colors.reset} ${message}`,
      ...meta
    );
  },
  http: (message: string, ...meta: unknown[]): void => {
    console.log(
      `${colors.dim}[${formatTimestamp()}]${colors.reset} ${colors.http}[HTTP]${colors.reset} ${message}`,
      ...meta
    );
  },
};

export const requestLogger = (
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  const start = Date.now();
  const { method, originalUrl } = req;
  const ip = req.ip || req.socket.remoteAddress || 'unknown';

  res.on('finish', () => {
    const duration = Date.now() - start;
    const status = res.statusCode;
    const statusColor =
      status >= 500
        ? colors.error
        : status >= 400
        ? colors.warn
        : status >= 300
        ? colors.info
        : colors.success;

    logger.http(
      `${method} ${originalUrl} ${statusColor}${status}${colors.reset} - ${duration}ms - IP: ${ip}`
    );
  });

  next();
};
