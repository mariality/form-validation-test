import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/auth_model.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.initial()); // Start with the initial state

  void login(String email, String password) {
    emit(state.copyWith(isLoading: true)); // Show loading state

    // Simulating login process
    Future.delayed(Duration(seconds: 2), () {
      if (email == 'test@gmail.com' && password == 'myPassword123!') {
        print("✅ Auth Success"); //Debug message
        emit(AuthState.success()); // Firs state update (this is correct)
      } else {
        print("❌ Auth Failed");
        emit(AuthState.failure("Invalid email or password"));
      }
    });
  }

// This function toggles password visibility when the user taps on an "eye" icon in the password field
  void togglePasswordVisibility(bool isObscured) {
    // state.copyWith(...) creates a bew instance of AuthState, copying the existing values while changing isObscured
    emit(state.copyWith(isObscured: isObscured));
  }
}
