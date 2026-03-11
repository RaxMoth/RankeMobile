# FlutterBase - Production-Ready Flutter App Base

A comprehensive, feature-rich Flutter base project designed to accelerate mobile app development with best practices, production-ready packages, and reusable components.

## Features

### ✨ Core Architecture
- **Clean Architecture**: Organized folder structure (core, features, shared, config)
- **Dependency Injection**: GetIt service locator for easy dependency management
- **State Management**: BLoC pattern ready (flutter_bloc, bloc)
- **Routing**: GoRouter for modern navigation management
- **Theme Support**: Light and dark theme with Material 3

### 📦 Built-in Components

#### Generic Header (`AppHeader`)
```dart
AppHeader(
  title: 'My App',
  leading: Icon(Icons.menu),
  actions: [Icon(Icons.more_vert)],
  onLeadingPressed: () => Navigator.pop(context),
)
```

#### Generic Footer (`AppFooter`)
Navigation bar with customizable items:
```dart
AppFooter(
  items: [
    FooterItem(icon: Icons.home, label: 'Home'),
    FooterItem(icon: Icons.search, label: 'Search'),
  ],
  selectedIndex: 0,
  onItemTapped: (index) => handleNavigation(index),
)
```

#### Base Layouts
- `BaseLayout`: Simple scaffold with header and footer
- `SafeBaseLayout`: Adds SafeArea and padding
- AppBar variants (SearchHeader, etc.)

#### State Widgets
- `AppLoadingIndicator`: Loading state UI
- `EmptyState`: Empty state UI with retry button
- `ErrorState`: Error state UI with retry option

### 🔧 Services

#### Logger Service
```dart
LoggerService.info('Message');
LoggerService.error('Error message', exception);
LoggerService.debug('Debug info');
```

#### API Service
```dart
final apiService = getIt<ApiService>();
final data = await apiService.get('/endpoint');
final response = await apiService.post('/endpoint', data: payload);
```

#### Local Storage Service
```dart
final storage = getIt<LocalStorageService>();
await storage.saveString('key', 'value');
final value = storage.getString('key');
await storage.saveJson('user', userObject);
```

#### Connectivity Service
```dart
final connectivity = getIt<ConnectivityService>();
final isOnline = await connectivity.isConnected();
connectivity.getConnectionStatusStream().listen((isConnected) {
  // Handle connection changes
});
```

### 🎨 Theme & Styling

#### AppColors
Predefined color palette:
- Primary colors (primary, primaryDark, primaryLight)
- Secondary colors (secondary, secondaryDark, secondaryLight)
- Neutral colors (white, black, grey, greyLight, greyDark)
- Functional colors (success, error, warning, info)

#### AppTheme
- `AppTheme.lightTheme`: Complete light theme
- `AppTheme.darkTheme`: Complete dark theme
- Automatic theme mode detection

### 🛠️ Utilities

#### Validation Utils
```dart
ValidationUtils.validateEmail(email);
ValidationUtils.validatePassword(password);
ValidationUtils.validatePhoneNumber(phone);
ValidationUtils.validateName(name);
ValidationUtils.validateNotEmpty(value, 'Field Name');
```

#### DateTime Utils
```dart
DateTimeUtils.formatDate(dateTime, 'dd/MM/yyyy');
DateTimeUtils.getRelativeTime(dateTime); // e.g., "2 hours ago"
DateTimeUtils.isToday(dateTime);
DateTimeUtils.addDays(dateTime, 7);
```

#### Extensions
- `ContextExtensions`: Screen size, theme, navigation
- `StringExtensions`: capitalize, isEmail, truncate, etc.
- `NumExtensions`: Duration conversions
- `IntExtensions/DoubleExtensions`: Number utilities

### 📱 Packages Included

#### UI & Design
- `cupertino_icons`: iOS style icons
- `google_fonts`: Google Fonts integration
- `animations`: Flutter animations
- `shimmer`: Loading placeholder animations
- `cached_network_image`: Network image caching

#### State Management
- `flutter_bloc`: BLoC pattern
- `bloc`: Core BLoC library
- `provider`: Provider pattern alternative

#### Networking
- `dio`: HTTP client with interceptors
- `http`: Alternative HTTP library
- `retrofit`: API client generator
- `pretty_dio_logger`: Request/response logging
- `connectivity_plus`: Network connectivity checking

#### Database & Storage
- `sqflite`: SQLite database
- `shared_preferences`: Key-value storage
- `path`: Path operations

#### Firebase
- `firebase_core`: Firebase integration
- `firebase_auth`: Firebase authentication

#### Maps & Location
- `flutter_map`: Map widget
- `latlong2`: Latitude/longitude utilities

#### QR Code
- `qr_flutter`: QR code generation
- `mobile_scanner`: QR code scanning

#### Device & Permissions
- `device_info_plus`: Device information
- `permission_handler`: Permission management

#### Utilities
- `get_it`: Service locator
- `uuid`: UUID generation
- `logger`: Advanced logging
- `equatable`: Value equality
- `dartz`: Functional programming
- `intl`: Internationalization & formatting
- `freezed_annotation`: Data classes
- `json_serializable`: JSON serialization

#### Dev Tools
- `build_runner`: Code generation
- `freezed`: Data class generation
- `retrofit_generator`: API client generation

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   ├── extensions/
│   │   ├── context_extensions.dart
│   │   ├── string_extensions.dart
│   │   └── num_extensions.dart
│   └── utils/
│       ├── validation_utils.dart
│       └── datetime_utils.dart
├── shared/
│   ├── components/
│   │   ├── app_header.dart
│   │   ├── app_footer.dart
│   │   ├── base_layout.dart
│   │   └── app_states.dart
│   ├── services/
│   │   ├── logger_service.dart
│   │   ├── api_service.dart
│   │   ├── local_storage_service.dart
│   │   └── connectivity_service.dart
│   └── models/
│       └── app_models.dart
├── features/
│   └── home/
│       └── home_screen.dart
├── config/
│   ├── router.dart
│   └── service_locator.dart
└── main.dart
```

## Getting Started

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Run the App
```bash
flutter run
```

## Configuration

### Update API Base URL
Edit `lib/core/constants/app_constants.dart`:
```dart
static const String apiBaseUrl = 'https://your-api.com';
```

### Adding New Routes
Edit `lib/config/router.dart`:
```dart
GoRoute(
  path: '/your-route',
  name: 'your_route_name',
  builder: (context, state) => YourScreen(),
),
```

### Register Services
Edit `lib/config/service_locator.dart`:
```dart
getIt.registerSingleton<YourService>(YourService());
```

## Usage Examples

### Using Base Layout
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      headerTitle: 'My Screen',
      body: Center(child: Text('Content')),
      showFooter: true,
      footerItems: [...],
    );
  }
}
```

### API Calls
```dart
final apiService = getIt<ApiService>();
try {
  final data = await apiService.get('/users');
  print(data);
} catch (e) {
  LoggerService.error('API Error', e);
}
```

### Local Storage
```dart
final storage = getIt<LocalStorageService>();
await storage.initialize();
await storage.saveString('user_name', 'John');
final name = storage.getString('user_name');
```

### Form Validation
```dart
final error = ValidationUtils.validateEmail(emailValue);
if (error != null) {
  // Show error
}
```

## Best Practices

1. **Use Extensions**: Leverage context and string extensions for cleaner code
2. **Service Locator**: Always use GetIt for dependency access
3. **Logging**: Use LoggerService instead of print()
4. **Error Handling**: Use custom exception types (AppException, NetworkException, etc.)
5. **Constants**: Use AppConstants for all magic strings and numbers
6. **Colors**: Use AppColors instead of hardcoding colors
7. **Theme**: Access theme through context extensions

## Production Checklist

- [ ] Update app name in pubspec.yaml
- [ ] Configure API base URL
- [ ] Set up Firebase (if needed)
- [ ] Update app icons
- [ ] Update splash screen
- [ ] Configure app signing for Android/iOS
- [ ] Test on multiple devices
- [ ] Set up error tracking (Sentry, etc.)
- [ ] Configure app versioning
- [ ] Test on real devices before release

## Next Steps

1. Create feature folders under `lib/features/`
2. Create data, domain, and presentation layers
3. Implement repositories for API calls
4. Create BLoCs for state management
5. Add more screens and navigation
6. Customize theme colors for your brand
7. Add Firebase authentication if needed

## Contributing

When adding new components:
1. Follow the existing folder structure
2. Use meaningful names
3. Add documentation
4. Use extensions where applicable
5. Maintain consistency with existing code style

## License

This project is provided as a base template for your Flutter applications.

## Support

For issues or questions, refer to the Flutter documentation:
- https://flutter.dev/docs
- https://pub.dev/packages

---

Happy coding! 🚀
