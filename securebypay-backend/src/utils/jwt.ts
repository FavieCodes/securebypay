import jwt, { type SignOptions } from 'jsonwebtoken';
import dotenv from 'dotenv';

dotenv.config();

// --- JWT -----------------------------------------------------
export interface AuthTokenPayload {
  sub: string;
  email: string;
}

const JWT_SECRET = process.env.JWT_SECRET as string;
const JWT_EXPIRES_IN = (process.env.JWT_EXPIRES_IN || '1d') as SignOptions['expiresIn'];

export const signToken = (payload: AuthTokenPayload): string =>
  jwt.sign(payload, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN });

export const verifyToken = (token: string): AuthTokenPayload =>
  jwt.verify(token, JWT_SECRET) as AuthTokenPayload;