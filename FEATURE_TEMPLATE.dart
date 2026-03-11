/// Feature Template - Copy this structure for new features
/// 
/// Create a new feature folder under lib/features/
/// Example: lib/features/users/
/// 
/// Folder structure:
/// features/
/// ├── [feature_name]/
/// │   ├── presentation/
/// │   │   ├── bloc/ (or cubit/)
/// │   │   ├── pages/
/// │   │   └── widgets/
/// │   ├── data/
/// │   │   ├── models/
/// │   │   ├── datasources/
/// │   │   └── repositories/
/// │   └── domain/
/// │       ├── entities/
/// │       ├── repositories/
/// │       └── usecases/

// ============ DOMAIN LAYER ============

// 1. Entity (Plain Dart object)
class UserEntity {
  final String id;
  final String name;
  final String email;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
  });
}

// 2. Repository Interface
abstract class UserRepository {
  Future<List<UserEntity>> getUsers();
  Future<UserEntity> getUserById(String id);
  Future<void> createUser(UserEntity user);
  Future<void> updateUser(UserEntity user);
  Future<void> deleteUser(String id);
}

// 3. Use Case
class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<UserEntity>> call() async {
    return await repository.getUsers();
  }
}

// ============ DATA LAYER ============

// 1. Model (extends Entity)
class UserModel extends UserEntity {
  UserModel({
    required String id,
    required String name,
    required String email,
  }) : super(id: id, name: name, email: email);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

// 2. Data Source (Interface and Implementation)
abstract class RemoteUserDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUserById(String id);
}

class RemoteUserDataSourceImpl implements RemoteUserDataSource {
  final ApiService apiService;

  RemoteUserDataSourceImpl(this.apiService);

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await apiService.get('/users');
    return (response['data'] as List)
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<UserModel> getUserById(String id) async {
    final response = await apiService.get('/users/$id');
    return UserModel.fromJson(response['data']);
  }
}

// 3. Repository Implementation
class UserRepositoryImpl implements UserRepository {
  final RemoteUserDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<UserEntity>> getUsers() async {
    return await remoteDataSource.getUsers();
  }

  @override
  Future<UserEntity> getUserById(String id) async {
    return await remoteDataSource.getUserById(id);
  }

  @override
  Future<void> createUser(UserEntity user) async {
    // Implementation
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    // Implementation
  }

  @override
  Future<void> deleteUser(String id) async {
    // Implementation
  }
}

// ============ PRESENTATION LAYER ============

// 1. BLoC or Cubit State
abstract class UserState {}

class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserSuccess extends UserState {
  final List<UserEntity> users;
  UserSuccess(this.users);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

// 2. BLoC or Cubit Event
abstract class UserEvent {}

class GetUsersEvent extends UserEvent {}

// 3. BLoC Implementation
// class UserBloc extends Bloc<UserEvent, UserState> {
//   final GetUsersUseCase getUsersUseCase;
//
//   UserBloc(this.getUsersUseCase) : super(UserInitial()) {
//     on<GetUsersEvent>(_onGetUsers);
//   }
//
//   Future<void> _onGetUsers(GetUsersEvent event, Emitter<UserState> emit) async {
//     emit(UserLoading());
//     try {
//       final users = await getUsersUseCase();
//       emit(UserSuccess(users));
//     } catch (e) {
//       emit(UserError(e.toString()));
//     }
//   }
// }

// 4. Screen/Page
// class UsersScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BaseLayout(
//       headerTitle: 'Users',
//       body: BlocBuilder<UserBloc, UserState>(
//         builder: (context, state) {
//           if (state is UserLoading) {
//             return AppLoadingIndicator();
//           } else if (state is UserSuccess) {
//             return ListView.builder(
//               itemCount: state.users.length,
//               itemBuilder: (context, index) {
//                 return UserTile(user: state.users[index]);
//               },
//             );
//           } else if (state is UserError) {
//             return ErrorState(message: state.message);
//           }
//           return EmptyState(title: 'No users found');
//         },
//       ),
//     );
//   }
// }

// 5. Widget
// class UserTile extends StatelessWidget {
//   final UserEntity user;
//
//   const UserTile({required this.user});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(user.name),
//       subtitle: Text(user.email),
//     );
//   }
// }

/// ============ SETUP IN SERVICE LOCATOR ============
/// 
/// Add to lib/config/service_locator.dart:
/// 
/// // Remote Data Source
/// getIt.registerSingleton<RemoteUserDataSource>(
///   RemoteUserDataSourceImpl(getIt<ApiService>()),
/// );
/// 
/// // Repository
/// getIt.registerSingleton<UserRepository>(
///   UserRepositoryImpl(getIt<RemoteUserDataSource>()),
/// );
/// 
/// // Use Case
/// getIt.registerSingleton<GetUsersUseCase>(
///   GetUsersUseCase(getIt<UserRepository>()),
/// );
/// 
/// // BLoC
/// getIt.registerSingleton<UserBloc>(
///   UserBloc(getIt<GetUsersUseCase>()),
/// );

/// ============ ADD ROUTE ============
/// 
/// Add to lib/config/router.dart:
/// 
/// GoRoute(
///   path: '/users',
///   name: 'users',
///   builder: (context, state) => const UsersScreen(),
/// ),
