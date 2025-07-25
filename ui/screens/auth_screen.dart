// =======================================================================
// FILE: lib/ui/screens/auth_screen.dart
// DESCRIPTION: A screen for handling user login and registration.
// =======================================================================
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  void _trySubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState?.save();
      setState(() {
        _isLoading = true;
      });
      try {
        if (_isLogin) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        } else {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        }
      } on FirebaseAuthException catch (err) {
        var message = 'An error occurred, please check your credentials!';
        if (err.message != null) {
          message = err.message!;
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        print(err);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      _isLogin ? 'Login to Discover Bahrain' : 'Create Account',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: const ValueKey('email'),
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email Address'),
                      onSaved: (value) {
                        _email = value ?? '';
                      },
                    ),
                    TextFormField(
                      key: const ValueKey('password'),
                      validator: (value) {
                        if (value == null || value.length < 7) {
                          return 'Password must be at least 7 characters long.';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onSaved: (value) {
                        _password = value ?? '';
                      },
                    ),
                    const SizedBox(height: 12),
                    if (_isLoading) const CircularProgressIndicator(),
                    if (!_isLoading)
                      ElevatedButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogin ? 'Login' : 'Signup'),
                      ),
                    if (!_isLoading)
                      TextButton(
                        child: Text(_isLogin ? 'Create new account' : 'I already have an account'),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
