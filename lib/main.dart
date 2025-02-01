import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validate_flutter/cubit/auth_cubit.dart';
import 'package:validate_flutter/models/auth_model.dart';

void main() {
  runApp(const MyApp()); // Entry point of the Flutter application
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 15, 1, 67)),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => AuthCubit(),
        child: LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Create a global jey that uniquely identifies the Form widget
  // and allowa validation of the form

  final _formKey = GlobalKey<FormState>(); // Unique key for form validation

  // Controllers to get the input values
  // Контроллеры для получения данных из текстовых полей
  final _emailController =
      TextEditingController(); // Stores input from email field
  final _passwordController =
      TextEditingController(); // Stores input from password field

  // Controls the visibility of the password filed

  //bool _isObscured = true;

  // Function to validate email
  // Функция для проверки ввода email
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login From'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      // AuthCubit is likely part of a state management system in Flutter
      // specifically using the Cubit pattern fron the Flutter Block package
      // 🚀 AuthCubit inherits from Cubit<AuthState>
      body: BlocListener<AuthCubit, AuthState>(
        // BlocListener listens for state changes and execute code
        // state is the new state get from Cubit or Bloc
        listener: (context, state) {
          // is a check to determine whether the user is authenticated
          // isAuthenticated is usually a boolean (true or false)
          // and it is stored in state which comes from AuthCubit
          if (state.isAuthenticated) {
            // ScaffoldMessenger works by sitting above all of your Scaffolds as an inherited widget
            //Any time a new Scaffold is initialized
            //It looks up the tree for an ancestor ScaffoldMessenger and subscribes to SnackBar events
            ScaffoldMessenger.of(context).showSnackBar(
              // .showSnackBar() -> tells is to show a snackbar
              //it shows a small message ( Snackbar) at he bottom of the screen
              SnackBar(
                content: Text(
                  "Login Successful!",
                  style: TextStyle(
                    fontSize: 16, // Optional: Change font size
                  ),
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.errorMessage != null) {
            // Finds the ScaffoldMessenger (a helper for showing snackbars)
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // Build a Form widget using the _formKey created above.
          child: Form(
            key: _formKey, // Connect GlobayKey to the Form
            child: Column(
              // The perpendicular deirection to the main axis
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Email Field
                TextFormField(
                  controller:
                      _emailController, // Binds text input to controller
                  decoration: InputDecoration(
                    labelText: 'Email', // Placeholder for input field
                    border:
                        OutlineInputBorder(), //Adds border to the input field
                  ),
                  keyboardType:
                      TextInputType.emailAddress, //Sets keyboard type to email
                  validator: (value) {
                    //Function to validate user input
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email'; // Error message if empty
                    }
                    // pattern
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter you email'; // Error if email format is incorrect
                    }
                    return null; // No error
                  },
                ),
                SizedBox(height: 16),

                // Password Filed
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return TextFormField(
                      controller:
                          _passwordController, // Binds text input to controller
                      // The text entered into the filed will be replaced woth dots or asterisks
                      // (depending on hte platform) to hide the actual context ******
                      // Watch state // Listen to state changes and update obscureText
                      obscureText:
                          state.isObscured, //controls password visibility
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        // suffixion - adds an icon on the right side of a Text
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.isObscured //controls password visibility
                                ? Icons
                                    .visibility // if 'isObscured' is false, show the 'eye' icon (password visible)
                                : Icons
                                    .visibility_off, // if is true ' eye-off and ( password hidden)
                          ),
                          onPressed: () {
                            // When the user taps the ison, toggle the password visibility
                            // Toggles password visibility
                            context
                                .read<
                                    AuthCubit>() // is used to get an instance of AuthCubit and call this methods
                                .togglePasswordVisibility(!state
                                    .isObscured); // it toggles the password visibility between hidden and visible
                          },
                        ),
                      ),
                      // The text entered into the filed will be replaced woth dots or asterisks
                      // (depending on the platform) to hide the actual context ******
                      //obscureText: true,

                      //optionals and dart
                      validator: (value) {
                        // Validates password
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 16),

                // Login Button
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      // Disable the button while loading to prevent multiple requests
                      onPressed: state.isLoading
                          ? null
                          : () {
                              // Validate from before proceeding
                              if (_formKey.currentState!.validate()) {
                                // it checks if the form is valid before submiting
                                // _formKey -> This a uniue key for the form
                                // currentState -> referes to the current state of the form
                                // validate() - > calls the validation function for all from fields
                                String email = _emailController.text;
                                String password = _passwordController.text;

                                // Trigger login proccess
                                context
                                    .read<AuthCubit>()
                                    .login(email, password);
                              }
                            },
                      child: state.isLoading
                          ? CircularProgressIndicator()
                          // Show  a loading indicator while waiting for response
                          : Text('Login'), // Show login button when not loding
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
