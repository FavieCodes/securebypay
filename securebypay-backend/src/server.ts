import dotenv from 'dotenv';
import app from './app';

dotenv.config();

const PORT = process.env.PORT || 4000;

app.listen(Number(PORT), '0.0.0.0', () => {
  console.log(`SecureByPay backend running on http://localhost:${PORT}`);
  console.log(`System documentation & GUI sandbox available at http://localhost:${PORT}/`);
  console.log(`Swagger OpenAPI docs available at http://localhost:${PORT}/api/v1/docs`);
});