# 💸 Daily Expenses Tracker

> A premium, modern Flutter application for seamless personal financial management — built with Glassmorphic UI, real-time analytics, smart budget alerts, and Supabase cloud sync.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)
![Version](https://img.shields.io/badge/Version-1.0.0-blue)

---

## ✨ Features

### 🔐 Security & Authentication
- **Secure Login & Registration** — Full authentication flow powered by Supabase Auth.
- **Password Visibility Toggle** — Show/hide password on all input forms.
- **Remember Me** — Persistent session management for returning users.
- **In-App Password Change** — Update credentials with real-time validation.
- **Test / Offline Mode** — Run the app without a database connection using a mock guest profile.

### 👤 Profile Management
- **Edit Profile** — Update full name and email address instantly.
- **Profile Avatars** — Upload custom photos from gallery or use auto-generated initial avatars.
- **Live State Sync** — Profile changes reflect immediately across the entire dashboard.

### 📊 Dashboard & Financial Insights
- **Real-Time Overview** — Instant snapshot of total balance, monthly income, and total expenses.
- **Visual Analytics** — Interactive category pie/bar charts powered by `fl_chart`.
- **Transaction History** — Scrollable, filterable log of all income and expense entries.
- **PDF Export** — Generate and share professional expense reports with one tap.

### 💰 Expense & Income Management
- **Add / Edit / Delete Expenses** — Full CRUD with category tagging and date selection.
- **Add / Edit / Delete Income** — Track multiple income sources seamlessly.
- **Optimistic UI** — Data updates instantly in the UI before cloud sync completes.

### 🎯 Budget Management
- **Set Monthly Budgets** — Define spending limits per category or overall.
- **Progress Indicators** — Visual bars showing how much of each budget is consumed.
- **Smart Alerts** — Automatic warnings when budgets hit 80% usage or are exceeded.

### 🏦 Savings Goals
- **Create Savings Plans** — Define custom savings targets with names and amounts.
- **Track Progress** — Monitor how much has been saved toward each goal.
- **Local-First** — Goals persist locally with optional Supabase sync.

### 🔔 In-App Notification System
- **Real-Time Alerts** — Internal notification center with no external push service required.
- **Smart Triggers**:
  - Budget threshold warnings (80% used, limit exceeded)
  - Low balance alerts
  - Activity logs for new expenses and income
- **Bell Icon with Badge** — Unread count badge on the dashboard navigation bar.
- **Dedicated Notifications Screen** — Full-screen glassmorphic notification center.
- **Mark as Read / Clear All** — Full notification management controls.

### 🎨 Premium UI/UX
- **Glassmorphic Design** — Frosted-glass containers with vibrant gradient backgrounds.
- **Dark-First Aesthetic** — Rich dark color palette with green accent tones.
- **Micro-animations** — Smooth fade-in transitions, scale effects, and animated progress bars.
- **Responsive Layout** — Optimized for various Android screen sizes.
- **Google Fonts** — Modern typography using `Inter` and curated font pairings.

---

## 🏗️ Architecture

The app follows a clean **MVVM (Model-View-ViewModel)** architecture powered by the `provider` package.

```
lib/
├── core/               # App-wide constants, utilities
├── models/             # Data models (Expense, Income, Budget, SavingsGoal, AppNotification)
├── viewmodels/         # Business logic & state (AuthViewModel, ExpenseViewModel,
│                       #   SavingsViewModel, NotificationViewModel)
├── services/           # Supabase service layer & data access
├── ui/
│   ├── screens/        # Feature screens
│   │   ├── auth/           # Login & Registration
│   │   ├── dashboard/       # Main dashboard
│   │   ├── expenses/        # Expense list & form
│   │   ├── income/          # Income list & form
│   │   ├── budget/          # Budget management
│   │   ├── plan/            # Savings goals
│   │   ├── analytics/       # Charts & insights
│   │   ├── wallet/          # Wallet overview
│   │   ├── notifications/   # Notification center
│   │   ├── settings/        # App settings & profile
│   │   └── splash/          # Splash / loading screen
│   └── components/     # Reusable widgets
├── navigation/         # GoRouter app routing (app_router.dart)
├── theme/              # App theme & color tokens
└── main.dart           # Entry point & provider setup
```

---

## 🚀 Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | [Flutter](https://flutter.dev) (Dart 3.x) |
| **State Management** | [Provider](https://pub.dev/packages/provider) |
| **Backend / Auth** | [Supabase](https://supabase.com) |
| **Navigation** | [GoRouter](https://pub.dev/packages/go_router) *(via app_router)* |
| **Charts** | [fl_chart](https://pub.dev/packages/fl_chart) |
| **Typography** | [google_fonts](https://pub.dev/packages/google_fonts) |
| **PDF Reports** | [pdf](https://pub.dev/packages/pdf) + [printing](https://pub.dev/packages/printing) |
| **Image Picker** | [image_picker](https://pub.dev/packages/image_picker) |
| **Localization** | [intl](https://pub.dev/packages/intl) |
| **Storage** | [path_provider](https://pub.dev/packages/path_provider) |

---

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK **≥ 3.x** (Latest Stable recommended)
- Android Studio **or** VS Code with Flutter/Dart extensions
- *(Optional)* A [Supabase](https://supabase.com) project for cloud sync

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ahmedOsman64/Daily-Expenses.git
   cd Daily-Expenses
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase** *(optional — skip for offline/test mode)*:
   - Create a project at [supabase.com](https://supabase.com).
   - Copy your **Project URL** and **Anon Key**.
   - Add them to your environment or `lib/core/` config file.

4. **Run the app:**
   ```bash
   flutter run
   ```

> **💡 Tip:** If no Supabase credentials are configured, the app launches automatically in **Test Mode** with a mock guest user — all data remains local to the session.

---

## 📱 Screenshots

| Dashboard | Expenses | Notifications | Analytics |
|:---------:|:--------:|:-------------:|:---------:|
| *(coming soon)* | *(coming soon)* | *(coming soon)* | *(coming soon)* |

---

## 🗺️ Roadmap

- [ ] iOS support & App Store release
- [ ] Recurring transaction scheduling
- [ ] Multi-currency support
- [ ] Cloud backup & restore
- [ ] Widget support (home screen summary)
- [ ] Dark / Light theme toggle

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

*Built with ❤️ by [Ahmed Osman](https://github.com/ahmedOsman64)*
