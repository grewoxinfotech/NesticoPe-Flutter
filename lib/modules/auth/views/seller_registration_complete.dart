import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../dashboard/views/dashboard_screen.dart';
import '../controllers/auth_controller.dart';

class SellerRegistrationComplete extends StatefulWidget {
  const SellerRegistrationComplete({super.key});

  @override
  State<SellerRegistrationComplete> createState() =>
      _SellerRegistrationComplete();
}

class _SellerRegistrationComplete extends State<SellerRegistrationComplete> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final userData = {
        "username": _usernameController.text,
        "password": _passwordController.text,
        "email": _emailController.text,
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "address": _addressController.text,
        "city": _cityController.text,
        "state": _stateController.text,
        "zipCode": _zipCodeController.text,
      };

      Get.lazyPut(() => AuthController());
      final authController = Get.find<AuthController>();

      // Await the API call
      final success = await authController.completeSellerRegistration(userData);

      // Check if token is received
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful!')),
        );
        Get.offAll(() => DashboardScreen());
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Registration Failed!')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator:
                      (value) => value!.isEmpty ? 'Enter username' : null,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator:
                      (value) => value!.isEmpty ? 'Enter password' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) return 'Enter email';
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value))
                      return 'Enter valid email';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator:
                      (value) => value!.isEmpty ? 'Enter first name' : null,
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator:
                      (value) => value!.isEmpty ? 'Enter last name' : null,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) => value!.isEmpty ? 'Enter address' : null,
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) => value!.isEmpty ? 'Enter city' : null,
                ),
                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(labelText: 'State'),
                  validator: (value) => value!.isEmpty ? 'Enter state' : null,
                ),
                TextFormField(
                  controller: _zipCodeController,
                  decoration: const InputDecoration(labelText: 'Zip Code'),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) => value!.isEmpty ? 'Enter zip code' : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
