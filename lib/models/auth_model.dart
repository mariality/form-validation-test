// Represents the authentication state
class AuthState {
  // Indicates where the user is authenticated
  final bool isAuthenticated;

  final bool isObscured;

  // Holds an erroe message in case of authentication failure
  final String? errorMessage;
  final bool isLoading;
  final String name = 'Maria';

// his is a constructor with named parameters in Dart
  AuthState(
      {required this.isAuthenticated,
      this.isObscured = true,
      this.errorMessage,
      this.isLoading = false});

// Factory constructors with parametrs which controls the state
// The factory constructor AuthState.initatil() creates a new AuthSatte object
// So every time you call AuthState.initial(), yo get an AuthState object with the same starting value
  factory AuthState.initial() =>
      AuthState(isAuthenticated: false, isObscured: true, isLoading: false);

  factory AuthState.loading() =>
      AuthState(isAuthenticated: false, isObscured: true, isLoading: true);

  // Factory constructor for successful login
  factory AuthState.success() => AuthState(
      isAuthenticated: true,
      isObscured: true,
      isLoading: false,
      errorMessage: null);

  // Factory constructor for failed login
  factory AuthState.failure(String error) => AuthState(
      isAuthenticated: false,
      isObscured: true,
      isLoading: false,
      errorMessage: error);

// I need to create a new instance with the updated values
// Without copyWith, you would have to rebuild the entire state manually
// copyWith allows you to updat eonly the specific fields, keeping the rest unchanged
// clone
  AuthState copyWith(
      {bool? isAuthenticated,
      bool? isObscured,
      String? errorMessage,
      bool? isLoading}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      // if 'isAuthenticated' is provided, use it. Otherwise, keep the existing value

      isObscured: isObscured ?? this.isObscured,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
