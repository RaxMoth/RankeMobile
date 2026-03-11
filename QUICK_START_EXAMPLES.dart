/// Quick Start Examples for FlutterBase
/// 
/// Copy code snippets from this file to quickly implement common patterns

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/service_locator.dart';
import 'shared/services/api_service.dart';
import 'shared/services/local_storage_service.dart';
import 'shared/services/logger_service.dart';
import 'shared/services/connectivity_service.dart';
import 'core/extensions/context_extensions.dart';
import 'core/utils/validation_utils.dart';
import 'shared/components/base_layout.dart';
import 'shared/components/app_footer.dart';

// ============================================================
// EXAMPLE 1: API Calls
// ============================================================

class APIExample {
  static Future<void> fetchData() async {
    try {
      final apiService = getIt<ApiService>();
      
      // GET request
      final users = await apiService.get('/users');
      LoggerService.info('Users: $users');
      
      // POST request
      final newUser = await apiService.post('/users', data: {
        'name': 'John Doe',
        'email': 'john@example.com',
      });
      
      // PUT request
      await apiService.put('/users/1', data: {'name': 'Jane Doe'});
      
      // DELETE request
      await apiService.delete('/users/1');
      
    } catch (e) {
      LoggerService.error('API Error', e);
    }
  }
}

// ============================================================
// EXAMPLE 2: Local Storage
// ============================================================

class StorageExample {
  static Future<void> saveAndRetrieve() async {
    final storage = getIt<LocalStorageService>();
    
    // Save string
    await storage.saveString('user_name', 'John Doe');
    
    // Get string
    final name = storage.getString('user_name');
    LoggerService.info('Saved name: $name');
    
    // Save number
    await storage.saveInt('user_age', 30);
    
    // Save boolean
    await storage.saveBool('is_logged_in', true);
    
    // Save list
    await storage.saveList('tags', ['flutter', 'mobile', 'app']);
    
    // Save complex object as JSON
    final userJson = {'id': 1, 'name': 'John', 'email': 'john@example.com'};
    await storage.saveJson('user_data', userJson);
    
    // Remove specific key
    await storage.remove('user_name');
    
    // Clear all storage
    // await storage.clear();
  }
}

// ============================================================
// EXAMPLE 3: Form Validation
// ============================================================

class FormValidationExample extends StatefulWidget {
  @override
  State<FormValidationExample> createState() => _FormValidationExampleState();
}

class _FormValidationExampleState extends State<FormValidationExample> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? emailError;
  String? passwordError;

  void validateAndSubmit() {
    // Validate email
    emailError = ValidationUtils.validateEmail(emailController.text);
    
    // Validate password
    passwordError = ValidationUtils.validatePassword(passwordController.text);
    
    if (emailError == null && passwordError == null) {
      LoggerService.info('Form is valid!');
      // Submit form
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Enter email',
            errorText: emailError,
          ),
        ),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Enter password',
            errorText: passwordError,
          ),
        ),
        ElevatedButton(
          onPressed: validateAndSubmit,
          child: const Text('Login'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

// ============================================================
// EXAMPLE 4: Connectivity Monitoring
// ============================================================

class ConnectivityExample extends StatefulWidget {
  @override
  State<ConnectivityExample> createState() => _ConnectivityExampleState();
}

class _ConnectivityExampleState extends State<ConnectivityExample> {
  late ConnectivityService _connectivity;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _connectivity = getIt<ConnectivityService>();
    _connectivity.startListening(_onConnectionChanged);
  }

  void _onConnectionChanged(bool isConnected) {
    setState(() => _isOnline = isConnected);
    final message = isConnected ? 'Online' : 'Offline';
    LoggerService.info('Connection status: $message');
  }

  @override
  void dispose() {
    _connectivity.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Status: ${_isOnline ? 'Online' : 'Offline'}');
  }
}

// ============================================================
// EXAMPLE 5: Using Context Extensions
// ============================================================

class ContextExtensionsExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Screen width: ${context.screenWidth}'),
        Text('Screen height: ${context.screenHeight}'),
        Text('Is mobile: ${context.isMobile}'),
        Text('Is dark mode: ${context.isDarkMode}'),
        ElevatedButton(
          onPressed: () {
            context.showSnackBar('This is a success message');
            // or
            context.showErrorSnackBar('Something went wrong!');
            context.showSuccessSnackBar('Operation successful!');
          },
          child: const Text('Show SnackBar'),
        ),
      ],
    );
  }
}

// ============================================================
// EXAMPLE 6: Screen with Base Layout
// ============================================================

class ExampleScreen extends StatefulWidget {
  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      headerTitle: 'Example Screen',
      headerActions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => LoggerService.info('Settings tapped'),
        ),
      ],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to FlutterBase',
              style: context.textTheme.displaySmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => APIExample.fetchData(),
              child: const Text('Fetch Data'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => StorageExample.saveAndRetrieve(),
              child: const Text('Save to Storage'),
            ),
          ],
        ),
      ),
      showFooter: true,
      footerItems: [
        FooterItem(icon: Icons.home, label: 'Home'),
        FooterItem(icon: Icons.search, label: 'Search'),
        FooterItem(icon: Icons.favorite, label: 'Favorites'),
        FooterItem(icon: Icons.person, label: 'Profile'),
      ],
      selectedFooterIndex: _selectedIndex,
      onFooterItemTapped: (index) {
        setState(() => _selectedIndex = index);
        LoggerService.info('Footer item tapped: $index');
      },
    );
  }
}

// ============================================================
// EXAMPLE 7: Using Logger Service
// ============================================================

class LoggingExample {
  static void demonstrateLogging() {
    LoggerService.verbose('Verbose message - detailed information');
    LoggerService.debug('Debug message - for debugging');
    LoggerService.info('Info message - general information');
    LoggerService.warning('Warning message - something might be wrong');
    LoggerService.error('Error message', Exception('An error occurred'));
    LoggerService.wtf('WTF message - something is very wrong!');
  }
}

// ============================================================
// EXAMPLE 8: Date/Time Utilities
// ============================================================

import 'core/utils/datetime_utils.dart';

class DateTimeExample {
  static void demonstrateDateTimeUtils() {
    final now = DateTime.now();
    
    // Format dates
    LoggerService.info(DateTimeUtils.formatDate(now));
    LoggerService.info(DateTimeUtils.formatTime(now));
    LoggerService.info(DateTimeUtils.formatDateTime(now));
    
    // Relative time
    final pastDate = now.subtract(const Duration(hours: 2));
    LoggerService.info(DateTimeUtils.getRelativeTime(pastDate)); // "2 hours ago"
    
    // Date checks
    LoggerService.info('Is today: ${DateTimeUtils.isToday(now)}');
    
    // Date arithmetic
    final nextWeek = DateTimeUtils.addDays(now, 7);
    LoggerService.info('Next week: ${DateTimeUtils.formatDate(nextWeek)}');
  }
}

// ============================================================
// EXAMPLE 9: String Extensions
// ============================================================

class StringExtensionsExample {
  static void demonstrateStringExtensions() {
    const email = 'john@example.com';
    const password = '123456';
    const name = 'john doe';
    
    LoggerService.info('Is valid email: ${email.isEmail}');
    LoggerService.info('Is valid phone: "1234567890".isPhoneNumber');
    LoggerService.info('Capitalized: ${name.capitalize}');
    LoggerService.info('Capitalize words: ${name.capitalizeWords}');
    LoggerService.info('Numeric: ${"123".isNumeric}');
  }
}

// ============================================================
// EXAMPLE 10: BLoC Pattern (Simple Counter BLoC)
// ============================================================

// Define events
abstract class CounterEvent {}
class IncrementEvent extends CounterEvent {}
class DecrementEvent extends CounterEvent {}

// Define states
abstract class CounterState {}
class CounterInitial extends CounterState {
  final int count = 0;
}
class CounterUpdated extends CounterState {
  final int count;
  CounterUpdated(this.count);
}

// Create BLoC
// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   int _count = 0;
//
//   CounterBloc() : super(CounterInitial()) {
//     on<IncrementEvent>(_onIncrement);
//     on<DecrementEvent>(_onDecrement);
//   }
//
//   Future<void> _onIncrement(IncrementEvent event, Emitter<CounterState> emit) async {
//     _count++;
//     emit(CounterUpdated(_count));
//   }
//
//   Future<void> _onDecrement(DecrementEvent event, Emitter<CounterState> emit) async {
//     _count--;
//     emit(CounterUpdated(_count));
//   }
// }

// Use in Widget
// class CounterWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CounterBloc, CounterState>(
//       builder: (context, state) {
//         final count = state is CounterUpdated ? state.count : 0;
//         return Column(
//           children: [
//             Text('Count: $count'),
//             ElevatedButton(
//               onPressed: () => context.read<CounterBloc>().add(IncrementEvent()),
//               child: const Text('Increment'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

/// ============================================================
/// GETTING STARTED CHECKLIST
/// ============================================================
/// 
/// 1. Update API_BASE_URL in app_constants.dart
/// 2. Add your API endpoints
/// 3. Create feature folders under features/
/// 4. Register your services in service_locator.dart
/// 5. Create your screens and BLoCs
/// 6. Add routes to router.dart
/// 7. Customize AppTheme colors
/// 8. Test on device
/// 9. Build for release: flutter build apk / flutter build ios
