# SecureByPay Frontend (Myafrimall)

The Flutter Web frontend for the SecureByPay technical assessment — a shipping/logistics dashboard built to match the provided Figma design, with full authentication flows wired up to the [SecureByPay backend API](../securebypay-backend).

## Tech Stack

- **Framework:** Flutter (Web target)
- **State management:** [`provider`](https://pub.dev/packages/provider) (`ChangeNotifierProvider` / `AuthState`)
- **HTTP:** `http` package, talking to the Express backend's REST API
- **Image picking:** `image_picker` (profile picture upload, encoded client-side as a base64 data URI)
- **Fonts:** DM Sans, used throughout to match the Figma spec pixel-for-pixel (weights, sizes, line-heights, letter-spacing)
- **Layout:** Fully responsive — desktop, tablet, and mobile breakpoints via a shared `Breakpoints` helper

## Project Structure

```
securebypay_frontend/
├── lib/
│   ├── main.dart                   # App entrypoint, MaterialApp, custom scroll behavior
│   ├── app_theme.dart              # Colors, text styles, shared design tokens
│   ├── models/
│   │   └── user_model.dart         # AppUser model (fromJson/toJson)
│   ├── services/
│   │   └── auth_service.dart       # API client — signup/login/forgot/reset/me/avatar calls
│   ├── state/
│   │   └── auth_state.dart         # ChangeNotifier holding the current session/user
│   └── screens/
│       ├── login_screen.dart
│       ├── signup_screen.dart
│       ├── forgot_password_screen.dart
│       ├── reset_password_screen.dart
│       └── dashboard_screen.dart   # Main dashboard: sidebar, banner, stats, growth chart, shipments
├── assets/
│   └── images/                     # Exported design assets (e.g. shipment_globe.png)
├── pubspec.yaml
└── web/                            # Flutter's generated web runner config
```

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel) with web support enabled:
  ```bash
  flutter config --enable-web
  ```
- The backend running locally or deployed (see the backend README)

## Getting Started (Local Development)

```bash
# 1. Install dependencies
flutter pub get

# 2. Run against a local backend (default: http://localhost:4000)
flutter run -d chrome

# 3. Or point at a deployed backend
flutter run -d chrome --dart-define=API_BASE_URL=https://securebypay.vercel.app/
```

`ApiConfig.baseUrl` in `lib/services/auth_service.dart` resolves the backend URL in this order:
1. The `--dart-define=API_BASE_URL=...` value, if provided
2. `http://localhost:4000` by default (with an Android-emulator special case for `10.0.2.2`)

## Building for Production

```bash
flutter build web --dart-define=API_BASE_URL=https://securebypay.vercel.app/
```

This produces a static site in `build/web/` — plain HTML/CSS/JS with no server-side requirements, ready to deploy to any static host.

## Deploying (Vercel)

```bash
flutter build web --dart-define=API_BASE_URL=https://securebypay.vercel.app/
cd build/web
vercel --prod
```

Vercel serves the `build/web` directory as a static site. Re-run both the `flutter build web` and `vercel --prod` steps any time you change the frontend or need to point it at a different backend URL.

## Features Implemented

- **Authentication**
  - Sign up → redirects to Login on success (does not auto-login)
  - Log in → issues and stores a JWT, redirects to the dashboard
  - Forgot password → auto-navigates to the Reset Password screen after a code is requested (no pre-filled code — the user must type what they received by email)
  - Reset password → sets a new password using the emailed code
  - Friendly error messages (e.g. "Incorrect username or password") instead of raw server/database errors
- **Dashboard**
  - Responsive sidebar navigation with active-state highlighting and a working logout flow
  - Profile avatar: shows initials when no picture is set, tap-to-upload with an image picker, uploads immediately and reflects the new photo
  - Auto-playing, swipeable promotional banner (PageView + dot indicators)
  - Stat cards (Total Shipments / Exports / Import) with trend indicators
  - "Company Growth" chart with a Year/Month/Week toggle and a hand-drawn spline chart
  - Recent Shipments — collapsible cards matching the Figma spec pixel-for-pixel (spacing, colors, fonts, dividers), each independently expandable/collapsible
  - "Coming soon" modal for not-yet-implemented actions (Fund Wallet, Pay Now, View More) so every button gives real feedback instead of doing nothing

## Design Notes

- All typography uses the DM Sans font family with exact weights/sizes/line-heights/letter-spacing taken directly from the Figma file, rather than default Material text styles.
- Card layouts use fixed-width `SizedBox` + `mainAxisAlignment.spaceBetween` (rather than flexible `Expanded` ratios) wherever the design calls for genuinely equal gaps between items of different sizes.
- Responsiveness is handled by branching on a shared `Breakpoints.isMobile(context)` check rather than a full custom layout system, keeping desktop and mobile variants of each widget close together in the same file for easy comparison.