# Tradeasia Mobile

A modern Flutter mobile application for Tradeasia International, showcasing top chemical products with a clean, professional design.

## 📱 Download & Demo

### 🔗 **Ready-to-Install App**

📦 **[Download APK](https://drive.google.com/file/d/1mMuyHCHh33891Q6oxGhVAfO1Niv_RLy5/view?usp=sharing)** - Android installation package ready for testing

### 🎥 **Live Demo Video**

🎬 **[Watch Demo](https://drive.google.com/file/d/1AxOu6We33Vlfbeo4EPjlA_o2_tg5bY5P/view?usp=sharing)** - Complete app walkthrough and features showcase

---

## 🚀 Features

### ✅ **Completed Features**

#### **Core Functionality**

- **Top Products Display**: Grid layout showing chemical products from API
- **Product Details**: Comprehensive product information with rich UI
- **Navigation**: Auto Route navigation between screens
- **State Management**: BLoC pattern for robust state handling

#### **UI/UX Excellence**

- **Modern Design System**: Complete theming with Material 3
- **Dark Mode Support**: Automatic system theme detection
- **Responsive Design**: Works beautifully on all screen sizes
- **Professional Animations**: Smooth transitions and loading states

#### **Advanced Features**

- **Offline Support**: Caching with connectivity monitoring
- **Enhanced Image Loading**: Robust network image handling
- **Error Handling**: Comprehensive error states with retry functionality
- **Loading States**: Beautiful shimmer effects and skeletons

#### **Technical Architecture**

- **Clean Architecture**: Domain, Data, and Presentation layers
- **Dependency Injection**: GetIt service locator
- **Network Layer**: Dio HTTP client with error handling
- **Local Storage**: SharedPreferences for caching

## 🛠️ Tech Stack

- **Framework**: Flutter 3.7.2+
- **State Management**: flutter_bloc
- **Navigation**: auto_route
- **Networking**: dio
- **Image Caching**: cached_network_image
- **Dependency Injection**: get_it + injectable
- **Local Storage**: shared_preferences
- **Connectivity**: connectivity_plus

## 📱 Screens

1. **Top Products Page**

   - Grid layout with product cards
   - Search functionality
   - Pull-to-refresh
   - Connectivity indicator

2. **Product Details Page**
   - Hero image with gradient overlay
   - Complete product information
   - Related products
   - Action buttons (Inquiry, Cart, Download)

## 🏗️ Architecture

```
lib/
├── infrastructure/          # Core infrastructure
│   ├── constants/          # App theme, colors, typography
│   ├── components/         # Reusable UI components
│   ├── services/           # Connectivity, cache services
│   └── architecture/       # Base classes and patterns
├── modules/
│   └── product/           # Product feature module
│       ├── data/          # Data sources, DTOs, repositories
│       ├── domain/        # Entities, use cases, interfaces
│       └── presentation/  # Pages, widgets, cubits
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.7.2 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/Giber05/tradeasia.git
cd tradeasia
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Generate code**

```bash
flutter packages pub run build_runner build
```

4. **Run the app**

```bash
flutter run
```

## 🌐 API Endpoints

- **Base URL**: `https://tradeasia.co`
- **Top Products**: `GET /api/test/topProducts`
- **Product Details**: `GET /api/test/productDetails/{id}`

## 📦 Key Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.6 # State management
  dio: ^5.7.0 # HTTP client
  auto_route: ^9.2.2 # Navigation
  get_it: ^8.0.2 # Dependency injection
  cached_network_image: ^3.4.1 # Image caching
  connectivity_plus: ^6.0.5 # Network connectivity
  shared_preferences: ^2.3.2 # Local storage
```

## 🎨 Design System

### Colors

- **Primary Blue**: #123C69
- **Light Blue**: #1BA2CA
- **Success Green**: #10B981
- **Error Red**: #EF4444

### Typography

- Modern, consistent text styles
- Proper hierarchy and spacing
- Accessibility-compliant contrast ratios

### Components

- Reusable, themed components
- Consistent spacing and borders
- Professional animations and transitions

## 🧪 Testing

Run tests with:

```bash
flutter test
```

## 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12+)
- ✅ **Web** (Chrome, Safari, Firefox)

## 🚀 Deployment

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```
