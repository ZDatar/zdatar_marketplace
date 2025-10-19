# ZDatar Marketplace

A decentralized blockchain-based personal data exchange marketplace built with Flutter. This application allows users to monetize their mobile data while maintaining privacy and control through encryption and blockchain technology.

## Features

### 🏪 Marketplace
- Browse and search datasets by category, price, and region
- Advanced filtering and sorting options
- Dataset previews and sample data
- Detailed dataset information and seller profiles
- Rating and review system

### 💰 Seller Features
- Upload and monetize personal data
- Multi-step dataset upload process with validation
- Pricing in multiple cryptocurrencies (SOL, USDC, ZDTR)
- Analytics and earnings tracking
- Dataset management dashboard

### 🛒 Buyer Features
- Secure dataset purchasing with cryptocurrency
- Encrypted data delivery
- Purchase history and management
- Data decryption and download

### 💳 Wallet Integration
- Multi-token support (SOL, USDC, ZDTR)
- Send, receive, and swap functionality
- Transaction history
- Staking rewards for ZDTR tokens

### 🏛️ DAO Governance
- Decentralized governance participation
- Proposal creation and voting
- Treasury management
- Staking-based voting power

## Tech Stack

- **Framework**: Flutter 3.10+
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Blockchain**: Solana integration
- **Storage**: Hive (local), encrypted cloud storage
- **Charts**: FL Chart, Syncfusion Charts
- **UI**: Material Design 3

## Project Structure

```
lib/
├── core/
│   ├── app.dart                 # Main app configuration
│   ├── constants/
│   │   └── app_constants.dart   # App-wide constants
│   ├── router/
│   │   └── app_router.dart      # Navigation configuration
│   └── theme/
│       └── app_theme.dart       # App theming
├── features/
│   ├── dao/                     # DAO governance
│   ├── home/                    # Home screen
│   ├── marketplace/             # Dataset marketplace
│   ├── profile/                 # User profile
│   ├── seller/                  # Seller features
│   └── wallet/                  # Wallet functionality
├── models/                      # Data models
│   ├── dataset.dart
│   ├── transaction.dart
│   └── user.dart
├── shared/                      # Shared components
└── main.dart                    # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK 3.10 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code with Flutter extensions
- A Solana wallet (Phantom, Solflare) for testing

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd zdatar_marketplace
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add font files**
   - Download Inter font family from Google Fonts
   - Place font files in `assets/fonts/`:
     - `Inter-Regular.ttf`
     - `Inter-Medium.ttf`
     - `Inter-SemiBold.ttf`
     - `Inter-Bold.ttf`

4. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

1. **Blockchain Configuration**
   - Update Solana RPC endpoints in `lib/core/constants/app_constants.dart`
   - Configure wallet connection settings

2. **Storage Configuration**
   - Set up encrypted storage endpoints
   - Configure IPFS or cloud storage for dataset files

## Key Components

### Data Models

- **Dataset**: Represents sellable data with metadata, pricing, and encryption info
- **User**: User profiles with wallet addresses, ratings, and verification status
- **Transaction**: Blockchain transactions for purchases and sales

### Core Features

1. **Dataset Upload Flow**
   - File selection and validation
   - Metadata input (title, description, category, tags)
   - Pricing configuration
   - Preview and publishing

2. **Marketplace Browsing**
   - Category-based filtering
   - Search functionality
   - Price range and date filters
   - Sort by popularity, price, rating

3. **Purchase Process**
   - Wallet connection
   - Cryptocurrency payment
   - Encrypted file delivery
   - Decryption key transfer

4. **DAO Governance**
   - Token staking for voting power
   - Proposal creation and voting
   - Treasury management
   - Governance statistics

## Security Features

- **End-to-end encryption** for all dataset files
- **Blockchain-based** transaction verification
- **Decentralized storage** for data files
- **Smart contract** escrow for secure payments
- **Privacy-first** design with minimal data collection

## Development

### Adding New Features

1. Create feature directory under `lib/features/`
2. Implement presentation layer (pages, widgets, providers)
3. Add data models if needed
4. Update routing in `app_router.dart`
5. Add navigation in `main_scaffold.dart`

### Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

### Building

```bash
# Build for Android
flutter build apk --release

# Build for iOS
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under a **Proprietary License with Custom EULA**.

**Key License Terms:**

- ✅ **Use**: You may use the ZDatar Marketplace app for personal or business purposes
- ❌ **Redistribution**: Redistribution of the software is strictly forbidden
- ❌ **Modification**: Creating derivative works or modifications is not permitted
- ❌ **Commercial Distribution**: Selling, licensing, or distributing the software is prohibited
- 🏪 **App Store Distribution**: Official distribution through app stores (Apple App Store, Google Play) only

This is a **closed-source** application with proprietary technology. Users have rights to use the app but cannot redistribute, modify, or create derivative works. Perfect for official app store distribution as "ZDatar Official App".

See the [LICENSE](LICENSE) file for complete terms and conditions.

## Support

For support and questions:
- Create an issue on GitHub
- Join our Discord community
- Check the documentation wiki

## Roadmap

- [ ] Advanced analytics dashboard
- [ ] Multi-chain support (Ethereum, Polygon)
- [ ] Mobile data collection SDK
- [ ] API marketplace for developers
- [ ] Advanced privacy features (zero-knowledge proofs)
- [ ] Cross-platform desktop app
