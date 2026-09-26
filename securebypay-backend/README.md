# SecureByPay Backend (Myafrimall API)

The backend for the SecureByPay technical assessment — a Node.js/Express + TypeScript REST API backing the Myafrimall shipping/logistics dashboard. It provides authentication (signup, login, forgot/reset password), a protected profile endpoint, profile-picture upload/storage, and self-documenting API docs.

## Tech Stack

- **Runtime:** Node.js (>=18), TypeScript
- **Framework:** Express
- **Database:** PostgreSQL via [Neon](https://neon.tech) (serverless Postgres)
- **ORM:** Drizzle ORM (`drizzle-orm` + `drizzle-kit`)
- **DB driver:** `@neondatabase/serverless` — connects over a WebSocket on port 443 instead of raw TCP on 5432, which is what actually gets past networks/VPNs that block outbound 5432
- **Auth:** JSON Web Tokens (`jsonwebtoken`), password hashing with `bcrypt`
- **Validation:** `express-validator`
- **Image processing:** `sharp` — normalizes every uploaded profile picture (regardless of original format) to a 512×512 PNG
- **Security middleware:** `helmet`, `cors`
- **API docs:** `swagger-jsdoc` (spec generated to a static JSON file at build time) + Swagger UI loaded from a CDN, plus a hand-built interactive HTML sandbox for testing every endpoint from the browser
- **Deployment:** Vercel (serverless functions)

## Project Structure

```
securebypay-backend/
├── api/                        # Vercel serverless entrypoint
├── drizzle/                    # Generated SQL migrations + snapshots
├── scripts/
│   ├── initDb.ts                # Runs pending Drizzle migrations against DATABASE_URL
│   ├── generateOpenApi.ts       # Generates src/docs/openapi.generated.json from route JSDoc
│   └── resetDb.ts               # Destructive — drops and recreates the public schema
├── src/
│   ├── app.ts                   # Express app: middleware, routes, docs, error handling
│   ├── server.ts                # Boots the HTTP server (local dev)
│   ├── db/
│   │   ├── index.ts             # Neon/Drizzle connection setup
│   │   └── schema.ts            # Drizzle table definitions (users, password_reset_tokens)
│   ├── controllers/
│   │   └── auth.controller.ts   # Route handlers: signup, login, forgot/reset password, me, avatar
│   ├── models/
│   │   └── user.model.ts        # DB queries (with read-retry wrapping for transient errors)
│   ├── middleware/
│   │   ├── auth.middleware.ts   # requireAuth — verifies the Bearer JWT
│   │   ├── validate.middleware.ts # express-validator rule sets per endpoint
│   │   └── errorHandler.ts      # Central error handler — never leaks internals to clients
│   ├── utils/
│   │   ├── jwt.ts, password.ts, logger.ts, dbRetry.ts
│   └── docs/
│       ├── landingPage.ts       # Hand-built interactive API doc + sandbox (served at "/")
│       ├── swaggerPage.ts       # CDN-based Swagger UI shell (served at /api/v1/docs)
│       └── openapi.generated.json # Static OpenAPI 3.0 spec — regenerate after route changes
├── drizzle.config.ts
├── tsconfig.json
├── vercel.json
└── package.json
```

## Environment Variables

Create a `.env` file in the project root (never commit this — it's gitignored):

| Variable       | Required | Description                                                                 |
|----------------|----------|-------------------------------------------------------------------------------|
| `DATABASE_URL` | Yes      | Neon Postgres connection string, e.g. `postgres://user:pass@host/db?sslmode=require` |
| `JWT_SECRET`   | Yes      | Secret used to sign/verify auth tokens                                       |
| `PORT`         | No       | Port for the local dev server (defaults to `4000`)                          |

An `.env.example` is provided as a template.

## Getting Started (Local Development)

```bash
# 1. Install dependencies
npm install

# 2. Set up your .env file (see above)
cp .env.example .env

# 3. Run database migrations
npm run db:migrate

# 4. Start the dev server (auto-restarts on file changes)
npm run dev
```

The server starts at `http://localhost:4000` by default. On boot it logs:
- API base: `http://localhost:4000`
- Interactive docs + sandbox: `http://localhost:4000/`
- Swagger UI: `http://localhost:4000/api/v1/docs`

## NPM Scripts

| Script               | What it does                                                              |
|----------------------|-----------------------------------------------------------------------------|
| `npm run dev`        | Starts the server with `tsx watch` (hot reload)                            |
| `npm run build`      | Compiles TypeScript to `dist/`                                             |
| `npm start`          | Runs the compiled server from `dist/` (production)                        |
| `npm run typecheck`  | Type-checks the project without emitting files                            |
| `npm run db:generate`| Generates a new Drizzle migration from schema changes                     |
| `npm run db:migrate` | Applies pending migrations to `DATABASE_URL`                              |
| `npm run db:studio`  | Opens Drizzle Studio (visual DB browser)                                  |
| `npm run docs:generate` | Regenerates `src/docs/openapi.generated.json` from route JSDoc — **run this and commit the result any time `@openapi` comments in `src/routes/*.ts` change**, otherwise Swagger silently serves a stale spec |

## API Endpoints

All routes are prefixed with `/api/auth`.

| Method | Path                     | Auth required | Description                                                        |
|--------|--------------------------|:--------------:|----------------------------------------------------------------------|
| POST   | `/signup`                | No             | Register a new account                                              |
| POST   | `/login`                 | No             | Authenticate and receive a JWT                                      |
| POST   | `/forgot-password`       | No             | Request a password reset code by email                              |
| POST   | `/reset-password`        | No             | Reset password using the emailed code                               |
| GET    | `/me`                    | Yes            | Get the authenticated user's profile                                 |
| POST   | `/me/avatar`             | Yes            | Upload/replace the authenticated user's profile picture (base64 image, normalized server-side to PNG) |
| DELETE | `/me/avatar`             | Yes            | Remove the authenticated user's profile picture                     |
| GET    | `/avatar/:userId`        | No (public)    | Fetch a user's profile picture as a raw PNG                         |

Full request/response schemas are documented at `/api/v1/docs` (Swagger UI) and are directly testable at `/` (the interactive sandbox), including live requests against whichever backend the docs are opened on.

Authenticated requests use a standard bearer token:
```
Authorization: Bearer <jwt-from-login-or-signup>
```

## Error Handling

- Validation errors return `400` with a structured `errors` array (field + message).
- Authentication errors return `401` with a generic "Incorrect username or password" message (never reveals which of email/password was wrong).
- Unexpected server errors return a generic `500` message to the client (`"Something went wrong. Please try again."`) — the real error, including stack trace, is always logged server-side, never leaked to the client.

## Deployment (Vercel)

```bash
vercel --prod
```

The `vercel.json` config routes all traffic to the compiled Express app as a serverless function. Set `DATABASE_URL` and `JWT_SECRET` as environment variables in the Vercel project settings (Project → Settings → Environment Variables) — they are not read from a committed `.env` file in production.

After any change to route JSDoc, remember to run `npm run docs:generate` and commit the updated `openapi.generated.json` before redeploying, or the hosted Swagger docs will be out of date.

## Notes on Design Decisions

- **Neon serverless driver over plain `pg`:** connects over WebSocket (port 443) rather than raw TCP (port 5432), which avoids issues on networks/VPNs that block 5432 outbound, and is also Vercel's recommended approach for serverless Postgres access.
- **Static OpenAPI spec instead of runtime `swagger-jsdoc` scanning:** `swagger-jsdoc`'s file-scanning approach doesn't work reliably once code is bundled for serverless deployment, so the spec is generated once locally and imported as plain JSON at runtime.
- **Profile pictures normalized to PNG:** avoids needing to store/track the original upload's MIME type — every image is decoded and re-encoded as PNG server-side via `sharp`, so retrieval is always a single, predictable format.
- **Read-retry wrapper (`withReadRetry`):** wraps read-only DB queries to transparently retry on transient connection drops (seen especially over WSL2 + VPN setups), without ever retrying writes (where a retry could risk a duplicate operation).