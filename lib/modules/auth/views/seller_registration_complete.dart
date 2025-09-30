import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/validation.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';

import '../../../widgets/New folder/inputs/text_field.dart';
import '../../dashboard/views/dashboard_screen.dart';
import '../controllers/auth_controller.dart';

class SellerRegistrationComplete extends StatefulWidget {
  const SellerRegistrationComplete({super.key});

  @override
  State<SellerRegistrationComplete> createState() =>
      _SellerRegistrationComplete();
}

class _SellerRegistrationComplete extends State<SellerRegistrationComplete> {
  bool isObSecure = true;
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      final user = await SecureStorage.getUserData();
      if(user!=null && user.user != null ){
        _usernameController.text = user.user!.username!;
        _passwordController.text = user.user!.password!;
        _emailController.text = user.user!.firstName!;
        _lastNameController.text = user.user!.lastName!;
        _addressController.text = user.user!.address!;
        _cityController.text = user.user!.city!;
        _stateController.text = user.user!.state!;
        _zipCodeController.text = user.user!.zipCode!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Seller Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                NesticoPeTextField(
                  isRequired: true,
                  title: "Username",
                  controller: _usernameController,
                  hintText: "Enter Username",
                  validator:
                      (value) => value!.isEmpty ? 'Enter username' : null,
                ),
                SizedBox(height: 12),
                NesticoPeTextField(
                  controller: _passwordController,
                  isRequired: true,
                  title: "Password",
                  hintText: "Enter Password",
                  obscureText: isObSecure,
                  suffixIcon: IconButton(
                      icon: _togglePassword(),
                      onPressed: () {
                        setState(() {
                          isObSecure = !isObSecure;
                        });
                      }),
                  validator:
                      (value) => value!.isEmpty ? 'Enter password' : null,
                ),
                SizedBox(height: 12),
                NesticoPeTextField(
                  controller: _emailController,
                  isRequired: true,
                  title: "Email",
                  hintText: "Enter Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => emailValidation(value!),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: NesticoPeTextField(
                        controller: _firstNameController,
                        isRequired: true,
                        title: "First Name",
                        hintText: "Enter First Name",
                        validator:
                            (value) =>
                        value!.isEmpty
                            ? 'Enter first name'
                            : null,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: NesticoPeTextField(
                        controller: _lastNameController,
                        isRequired: true,
                        title: "Last Name",
                        hintText: "Enter Last Name",
                        validator:
                            (value) =>
                        value!.isEmpty
                            ? 'Enter last name'
                            : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                NesticoPeTextField(
                  controller: _addressController,
                  isRequired: true,
                  title: "Address",
                  hintText: "Enter Address",
                  validator: (value) => value!.isEmpty ? 'Enter address' : null,
                ),
                SizedBox(height: 12),
                NesticoPeTextField(
                  controller: _cityController,
                  isRequired: true,
                  title: "City",
                  hintText: "Enter City",
                  validator: (value) => value!.isEmpty ? 'Enter city' : null,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: NesticoPeTextField(
                        controller: _stateController,
                        isRequired: true,
                        title: "State",
                        hintText: "Enter State",
                        validator: (value) =>
                        value!.isEmpty
                            ? 'Enter state'
                            : null,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: NesticoPeTextField(
                        controller: _zipCodeController,
                        isRequired: true,
                        title: "Zip code",
                        hintText: "Enter Zip code",
                        keyboardType: TextInputType.number,
                        validator:
                            (value) => value!.isEmpty ? 'Enter zip code' : null,
                      ),
                    ),
                  ],
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

  Widget _togglePassword() {
    return Icon(
      isObSecure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
      color: ColorRes.primary,
      size: 18,
    );
  }

}
