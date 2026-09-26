import swaggerJsdoc from 'swagger-jsdoc';
import dotenv from 'dotenv';

dotenv.config();

const baseUrl = process.env.PUBLIC_BASE_URL || 'http://localhost:4000';

const options: swaggerJsdoc.Options = {
  definition: {
    openapi: '3.0.3',
    info: {
      title: 'SecureByPay Auth API',
      version: '1.0.0',
      description:
        'Sign-Up and Login API for the SecureByPay technical assessment. Use "Try it out" to test the endpoints directly.',
      contact: { name: 'Imo' },
    },
    servers: [
      { url: baseUrl, description: 'Current environment' },
      { url: 'http://localhost:4000', description: 'Local development' },
    ],
    tags: [{ name: 'Auth', description: 'Signup, login, and session endpoints' }],
  },
  apis: ['./src/routes/*.ts'],
};

const swaggerSpec = swaggerJsdoc(options);

export default swaggerSpec;