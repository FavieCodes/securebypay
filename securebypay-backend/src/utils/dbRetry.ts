import { inspect } from 'node:util';

const isTransientConnectionError = (err: unknown): boolean => {
  const text = inspect(err, { depth: 6 }).toLowerCase();
  return (
    text.includes('etimedout') ||
    text.includes('econnreset') ||
    text.includes('epipe') ||
    text.includes('connection terminated') ||
    text.includes('websocket')
  );
};

export const withReadRetry = async <T>(
  fn: () => Promise<T>,
  retries = 2,
  delayMs = 300
): Promise<T> => {
  let lastErr: unknown;
  for (let attempt = 0; attempt <= retries; attempt++) {
    try {
      return await fn();
    } catch (err) {
      lastErr = err;
      if (attempt === retries || !isTransientConnectionError(err)) {
        throw err;
      }
      await new Promise((resolve) => setTimeout(resolve, delayMs * (attempt + 1)));
    }
  }

  throw lastErr;
};