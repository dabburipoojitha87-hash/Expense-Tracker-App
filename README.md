# 🧾 Simple Expense Tracker

A premium, frontend-only mobile application built with **Flutter** that allows users to track daily expenses, monitor category-based budgets, and calculate savings.

## ✨ Features

- **🧠 Smart Expense Tracking**: Quick entry for amount, title, and category.
- **📊 Spending distribution**: Real-time spending breakdown using interactive Pie Charts.
- **🛡️ Category Budgeting**: Set monthly limits for different categories (Food, Rent, Transport, etc.).
- **💰 Savings Vault**: Automatically calculates savings from unspent budget allocations.
- **🔄 Monthly Reset**: Signature "Reset Cycle" logic that accumulates savings into a lifetime total while clearing monthly spending.
- **🇮🇳 Localized**: Updated currency to **Rupee (₹)** across all screens.
- **💾 Local Persistence**: All data is stored locally using **Hive**, so it works offline and survives app restarts.
- **🎨 Neo-Brutalist Aesthetic**: A clean, high-contrast UI with a cream and black color palette, refined for a premium focused experience.

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [Riverpod](https://riverpod.dev)
- **Local Database**: [Hive](https://pub.dev/packages/hive)
- **Charts**: [fl_chart](https://pub.dev/packages/fl_chart)
- **Icons**: [Lucide Icons](https://lucide.dev)
- **Typography**: Google Fonts (Outfit)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Latest Stable)
- Dart SDK

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/dabburipoojitha87-hash/Expense-Tracker-App
   cd expense_app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate Hive Adapters**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**:
   ```bash
   flutter run
   ```

## 📐 Architecture

The project follows a **Provider-Based Architecture** with Riverpod:
- `/models`: Data structures and Hive TypeAdapters.
- `/providers`: State management and business logic.
- `/screens`: UI views (Dashboard, Add Expense, Budget Management).
- `/widgets`: Reusable Neo-brutalist UI components.
- `/theme`: Centralized design system.

## 🎯 Success Criteria
- [x] Change currency to Rupee (₹)
- [x] Real-time total calculation
- [x] Category-wise budget tracking
- [x] Persistent savings accumulation
- [x] Monthly cycle reset logic

---
Built with ❤️ by Antigravity
