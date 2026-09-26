# SecureByPay — Myafrimall (Technical Assessment)

A full-stack shipping/logistics dashboard built for the SecureByPay Full Stack Developer technical assessment: a Flutter Web frontend matched pixel-for-pixel to the provided Figma design, backed by a Node.js/Express + Drizzle ORM + PostgreSQL (Neon) API handling authentication and profile data.

This repository contains both halves of the project in one place:

```
securevypay/
├── securebypay-backend/     # Node.js/Express + TypeScript API (Auth, profile, avatar)
├── securebypay_frontend/    # Flutter Web dashboard UI
└── README.md                # You are here
```

Each folder has its own detailed README covering its tech stack, setup, scripts, and structure:
- [`securebypay-backend/README.md`](./securebypay-backend/README.md)
- [`securebypay_frontend/README.md`](./securebypay_frontend/README.md)

## What This Project Does

1. **UI Implementation** — Replicates the provided Figma design (login, signup, forgot/reset password, and the main dashboard) with responsive layouts across desktop, tablet, and mobile.
2. **API Integration** — A real backend handles Sign-Up and Login, plus every other interactive/data-driven element in the design: forgot/reset password, fetching the current profile, and profile-picture upload/removal.
3. **Functionality** — A user can register, log in, recover a forgotten password, and manage their profile picture end to end against a live database.

## Quick Start

You'll need both halves running to use the app locally.

**1. Start the backend:**
```bash
cd securebypay-backend
npm install
cp .env.example .env    
npm run db:migrate
npm run dev            
```

**2. Start the frontend, pointed at the backend:**
```bash
cd securebypay_frontend
flutter pub get
flutter run -d chrome    
```

See each folder's README for full environment variable references, all available scripts, deployment steps, and design notes.

## Live Links

| | Link |
|---|---|
| Hosted frontend (demo) | _add your deployed frontend URL here_ |
| Hosted backend API | https://securebypay.vercel.app/ |
| API documentation & interactive sandbox | `https://securebypay.vercel.app/` |
| Swagger / OpenAPI docs | `https://securebypay.vercel.app/api/v1/docs` |

## Tech Stack Summary

| Layer      | Technology |
|------------|------------|
| Frontend   | Flutter Web, Provider (state management) |
| Backend    | Node.js, Express, TypeScript |
| Database   | PostgreSQL (Neon, serverless) via Drizzle ORM |
| Auth       | JWT (JSON Web Tokens), bcrypt password hashing |
| Image processing | `sharp` (server-side avatar normalization to PNG) |
| API docs   | Swagger UI + a custom interactive HTML sandbox |
| Deployment | Vercel (both frontend static build and backend serverless functions) |

## Repository Notes

- Secrets (`.env` files, database credentials) are excluded via `.gitignore` and must be configured locally or in your hosting provider's environment variable settings — never commit them.
- The backend's OpenAPI spec (`securebypay-backend/src/docs/openapi.generated.json`) is a generated file — run `npm run docs:generate` inside `securebypay-backend` after changing any route's documentation comments, and commit the result before redeploying.