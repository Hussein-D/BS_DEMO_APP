# BS_DEMO_APP
Flutter mobile app
# BS – Flutter Demo App

A production-style Flutter demo for a coffee chain: shop discovery, menu, fully
customizable items, cart + local persistence, order placement, and **live order
tracking** on Google Maps via **WebSocket** (with HTTP fallback). Includes nice
UX touches like Shimmer skeletons.

## Features

- Shops (US & UK), menus, and option groups (size/milk/shots/sweet)
- Cart with merge rules & persistence (SharedPreferences)
- Order creation (pickup or delivery w/ destination lat/lon)
- **Live order tracking**: WebSocket streaming (`/ws`) + fallback polling
- Orders list with **Shimmer** loading state
- Clean architecture: **Repository → BLoC → UI**
- Google Maps (shop, destination, courier with bearing/ETA)

## Requirements

- Flutter 3.16+ / Dart 3+
- iOS Simulator NOT Android Emulator
- A running backend (see `coffee-backend/README.md`)

## Getting Started

```bash
flutter pub get
