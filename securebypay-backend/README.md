# SecureByPay Backend — Auth API

Node.js/Express backend for the SecureByPay Full Stack Developer technical
assessment. Implements Sign-Up and Login with JWT auth, backed by
PostgreSQL, with full interactive Swagger/OpenAPI documentation served at
the base URL.

## Stack

- Node.js + Express
- PostgreSQL (`drizzle`)
- JWT auth (`jsonwebtoken`) + bcrypt password hashing
- `express-validator` for request validation
- `swagger-jsdoc` + `swagger-ui-express` for live API docs
- Deploys to Vercel as a serverless function

## Project structure

```
api/index.js            # Vercel serverless entry point (exports the Express app)
src/
  app.js                 # Express app: middleware, routes, Swagger UI mount
  server.js               # Local dev entry point (app.listen)
  config/db.js             # Postgres connection pool
  models/user.model.js      # SQL queries for the users table
  controllers/auth.controller.js  # Signup / login / me handlers
  routes/auth.routes.js      # Routes + full OpenAPI JSDoc annotations
  middleware/
    validate.middleware.js   # express-validator rules + error formatting
    auth.middleware.js       # JWT verification for protected routes
    errorHandler.js          # 404 + centralized error handler
  utils/
    jwt.js                  # sign/verify helpers
    password.js              # bcrypt hash/compare helpers
  docs/swagger.js           # OpenAPI spec definition
sql/init.sql               # users table schema
scripts/initDb.js           # runs sql/init.sql against DATABASE_URL
```

## 1. Setup

```bash
npm install
cp .env.example .env
# fill in DATABASE_URL and JWT_SECRET in .env
npm run db:init   # creates the users table
```

## 2. Run locally

```bash
npm run dev
```

- System Docs & Interactive GUI Portal: `http://localhost:4000/`
- Interactive Swagger UI: `http://localhost:4000/api/v1/docs`
- Raw OpenAPI JSON: `http://localhost:4000/api/v1/docs/openapi.json`
- Health check: `http://localhost:4000/health`

## 3. Endpoints

| Method | Path              | Auth        | Description              |
|--------|-------------------|-------------|--------------------------|
| POST   | `/api/auth/signup`| —           | Create a new account     |
| POST   | `/api/auth/login` | —           | Log in, returns a JWT    |
| GET    | `/api/auth/me`    | Bearer token| Get the logged-in user   |

Full request/response schemas are in the Swagger docs at `/api/v1/docs` and the GUI portal at `/`.

## 4. Deploying to Vercel

1. Push this repo to GitHub.
2. In Vercel, "Add New Project" → import the repo.
3. Add environment variables in Vercel project settings (Settings → Environment Variables):
   - `DATABASE_URL`
   - `JWT_SECRET`
   - `JWT_EXPIRES_IN` (optional, defaults to `1d`)
   - `PUBLIC_BASE_URL` — set this to your deployed URL (e.g. `https://your-app.vercel.app`) so the Swagger "Try it out" calls hit the right host
   - `NODE_ENV=production`
4. Deploy. Vercel picks up `vercel.json`, which routes every request through `api/index.js`.
5. Once deployed, visiting the base URL (e.g. `https://your-app.vercel.app/`) opens the interactive Swagger docs where signup/login can be tested directly.

**Database note:** Vercel functions are stateless and short-lived, so a
traditional long-running Postgres connection pool can exhaust connections
under load. For this assessment scale it's not an issue, but for
production use a serverless-friendly Postgres provider (e.g. **Neon** or
**Supabase**) — both work as drop-in `DATABASE_URL` values here.

## 5. Testing the flow

```bash
# Signup
curl -X POST http://localhost:4000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Imo","lastName":"Johnson","email":"imo@example.com","phoneNumber":"+1234567890","password":"SuperSecret123"}'

# Login
curl -X POST http://localhost:4000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"imo@example.com","password":"SuperSecret123"}'

# Authenticated profile (replace TOKEN)
curl http://localhost:4000/api/auth/me \
  -H "Authorization: Bearer TOKEN"
```

Or just use the "Try it out" buttons on the Swagger page at `/`.
