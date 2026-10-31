# 🛍️ Shopping List

[![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Theme: Dark & Light](https://img.shields.io/badge/Theme-Dark%20%26%20Light-10B981)](#-dark--light-luxury-theme)

An intelligent, privacy-first shopping list and universal retail aggregator Android application built with Flutter. Add everyday checklist items and instantly discover matching products across **31+ top e-commerce, quick-commerce, and official brand stores** with smart deep-linking and in-app web search.

---

## ✨ Key Features

- **🌐 Universal 31+ Store Aggregator**: Compares and searches across Amazon, Flipkart, Myntra, Ajio, Meesho, Nykaa, Blinkit, Zepto, Swiggy Instamart, BigBasket, Croma, Reliance Digital, Decathlon, Nike, Apple, and more.
- **⚡ Smart Prioritization Engine**: Automatically analyzes item keywords, brands, and product departments. Searching `"tongue cleaner"` shows grocery & personal care marketplaces (Blinkit, Zepto, Meesho, Myntra) while hiding non-matching single-brand stores (like Nike or Apple).
- **📱 Installed App First**: Detects native apps installed on your device and prominently surfaces them so you can check out directly in your favorite app.
- **🎨 Dark & Light Luxury Theme**: Custom Obsidian Titanium dark palette and clean Porcelain slate light palette with a 1-tap toggle in the navigation bar.
- **⭐ Add Any Custom Store**: Paste any shopping website domain (e.g. `decathlon.in`, `etsy.com`); the app automatically parses the domain, fetches the brand logo, builds the search template, and integrates it.
- **🔒 100% Private & Local**: All shopping checklists, quantities, and preferences stay on your device local storage. Zero third-party telemetry, tracking, or remote database storage.
- **💎 Universal Affiliate Monetization**: Configurable affiliate engine supporting Cuelinks universal multi-store tracking (`pub_id`), Amazon Associates (`tag`), and Flipkart (`affid`), with transparent FTC / Google Play compliance disclosures.

---

## 🏗️ Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev) (Material 3)
- **Language**: [Dart](https://dart.dev)
- **State Management**: [`Provider`](https://pub.dev/packages/provider) (`MultiProvider`, `ChangeNotifierProvider`)
- **Persistence**: [`shared_preferences`](https://pub.dev/packages/shared_preferences)
- **Navigation & URL Launching**: [`url_launcher`](https://pub.dev/packages/url_launcher)
- **Design System**: Champagne Gold & Obsidian Luxury Design Language with Google Fonts (`Plus Jakarta Sans`)

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.24.0 or higher)
- Android SDK with NDK 28+ installed
- Java JDK 17

### Running Locally
```bash
# Clone the repository
git clone https://github.com/subhasishpanigrahy/shopping-list.git
cd shopping-list

# Fetch dependencies
flutter pub get

# Run test suite
flutter test

# Launch on connected Android device or emulator
flutter run
```

### Building Release Binaries
```bash
# Build split-per-abi Release APKs (arm64-v8a, armeabi-v7a, x86_64)
flutter build apk --split-per-abi --release

# Build Google Play App Bundle (.aab)
cd android
./gradlew bundleRelease
```

---

## 📄 Privacy Policy & Compliance

Shopping List complies with FTC affiliate disclosure guidelines and Google Play privacy policies:
- User shopping items and lists are stored 100% locally on the device.
- Outbound store links may carry affiliate tags to support open-source development at zero additional cost to the shopper.
- See [PRIVACY_POLICY.md](PRIVACY_POLICY.md) for full privacy statements.

---

## 👤 Author

**Subhasish Panigrahy**
- GitHub: [@subhasishpanigrahy](https://github.com/subhasishpanigrahy)

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
