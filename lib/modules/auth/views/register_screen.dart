// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/widgets/bar/app_bar/common_bar.dart';
// import 'package:housing_flutter_app/widgets/button/button.dart';
// import 'package:housing_flutter_app/modules/auth/controllers/auth_controller.dart';
// import 'package:housing_flutter_app/widgets/input/custom_text_field.dart';
// import 'package:housing_flutter_app/modules/auth/views/login_screen.dart';
//
// import '../../../widgets/New folder/inputs/text_field.dart';
//
// enum UserRole { buyer, seller, reseller }
//
// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({Key? key}) : super(key: key);
//
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _stateController = TextEditingController();
//   final _zipCodeController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;
//   bool _isLoading = false;
//   bool _acceptTerms = false;
//   UserRole _selectedRole = UserRole.buyer;
//
//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _cityController.dispose();
//     _stateController.dispose();
//     _zipCodeController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   void _togglePasswordVisibility() {
//     setState(() {
//       _isPasswordVisible = !_isPasswordVisible;
//     });
//   }
//
//   void _toggleConfirmPasswordVisibility() {
//     setState(() {
//       _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
//     });
//   }
//
//   Future<void> _register() async {
//     if (_formKey.currentState!.validate()) {
//       if (!_acceptTerms) {
//         _showErrorDialog('Please accept the terms and conditions');
//         return;
//       }
//
//       setState(() => _isLoading = true);
//
//       try {
//         final authController = Get.find<AuthController>();
//         final success = await authController.register(
//           context: context,
//           username: _usernameController.text.trim(),
//           password: _passwordController.text.trim(),
//           email: _emailController.text.trim(),
//           firstName: _firstNameController.text.trim(),
//           lastName: _lastNameController.text.trim(),
//           phone: _phoneController.text.trim(),
//           address: _addressController.text.trim(),
//           city: _cityController.text.trim(),
//           state: _stateController.text.trim(),
//           zipCode: _zipCodeController.text.trim(),
//           userType: _roleToString(_selectedRole),
//         );
//
//         if (!success) {
//           _showErrorDialog(authController.errorMessage.value);
//         }
//       } catch (e) {
//         _showErrorDialog('Registration failed: ${e.toString()}');
//       } finally {
//         if (mounted) setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   String _roleToString(UserRole role) {
//     switch (role) {
//       case UserRole.buyer:
//         return 'buyer';
//       case UserRole.seller:
//         return 'seller';
//       case UserRole.reseller:
//         return 'reseller';
//     }
//   }
//
//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Registration Successful'),
//             content: const Text(
//               'Your account has been created successfully. Please login to continue.',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(builder: (context) => LoginScreen()),
//                   );
//                 },
//                 child: const Text('Login'),
//               ),
//             ],
//           ),
//     );
//   }
//
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Registration Error'),
//             content: Text(message),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//     );
//   }
//
//   String _roleToDisplayText(UserRole role) {
//     switch (role) {
//       case UserRole.buyer:
//         return 'Buyer';
//       case UserRole.seller:
//         return 'Seller';
//       case UserRole.reseller:
//         return 'Reseller';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     Get.lazyPut(() => AuthController());
//
//     return Scaffold(
//       appBar: CommonNesticoPeAppBar(
//         title: 'Create Account',
//         showBackArrow: true,
//         leadingIcon: Icons.arrow_back,
//       ),
//       // appBar: AppBar(
//       //   title: const Text('Create Account'),
//       //   centerTitle: true,
//       //   elevation: 0,
//       // ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           // padding: const EdgeInsets.all(24.0),
//           padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
//
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text(
//                   'Select Account Type',
//                   style: theme.textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Row(
//                     children:
//                         UserRole.values.map((role) {
//                           return Expanded(
//                             child: GestureDetector(
//                               onTap: () => setState(() => _selectedRole = role),
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 12,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color:
//                                       _selectedRole == role
//                                           ? theme.colorScheme.primary
//                                           : Colors.transparent,
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     _roleToDisplayText(role),
//                                     style: TextStyle(
//                                       color:
//                                           _selectedRole == role
//                                               ? Colors.white
//                                               : Colors.black87,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                   ),
//                 ),
//
//                 Row(
//                   children: [
//                     SizedBox(
//                       height: 24,
//                       width: 24,
//                       child: Checkbox(
//                         value: _acceptTerms,
//                         onChanged: (value) {
//                           setState(() {
//                             _acceptTerms = value ?? false;
//                           });
//                         },
//                         activeColor: theme.colorScheme.primary,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'I agree to the Terms and Conditions and Privacy Policy',
//                         style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//                 NesticoPeButton(
//                   title: 'Create Account',
//                   onTap: _isLoading ? null : _register,
//                 ),
//                 const SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Already have an account?',
//                       style: TextStyle(color: Colors.grey[700]),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: Text(
//                         'Login here',
//                         style: TextStyle(
//                           color: theme.colorScheme.primary,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/widgets/bar/app_bar/common_bar.dart';
import 'package:housing_flutter_app/widgets/button/button.dart';
import 'package:housing_flutter_app/modules/auth/controllers/auth_controller.dart';

import '../../../app/widgets/snackbar/snackbar.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../widgets/New folder/inputs/text_field.dart';

UserRole? selectedRole;

class RegisterScreen extends StatefulWidget {
  final UserRole role;
  const RegisterScreen({Key? key, required this.role}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;
  UserRole _selectedRole = UserRole.buyer;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.role;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() => _isPasswordVisible = !_isPasswordVisible);
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        _showErrorDialog('Please accept the terms and conditions');
        return;
      }

      setState(() => _isLoading = true);

      try {
        final authController = Get.find<AuthController>();
        final success = await authController.register(
          context: context,
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
          email: _emailController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          city: _cityController.text.trim(),
          state: _stateController.text.trim(),
          zipCode: _zipCodeController.text.trim(),
          userType: _roleToString(_selectedRole),
        );

        if (!success) {
          _showErrorDialog(authController.errorMessage.value);
        } else {
          // _showSuccessDialog();
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: "Success",
            message: "OTP sent Successfully",
            contentType: ContentType.success,
          );
        }
      } catch (e) {
        _showErrorDialog('Registration failed: ${e.toString()}');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  String _roleToString(UserRole role) {
    switch (role) {
      case UserRole.buyer:
        return 'buyer';
      case UserRole.seller:
        return 'seller';
      case UserRole.reseller:
        return 'reseller';
      case UserRole.contractor:
        return 'contractor';
    }
  }

  void _showSuccessDialog() {
    NesticoPeSnackBar.showAwesomeSnackbar(
      title: "Success",
      message: "OTP sent Successfully",
      contentType: ContentType.success,
    );
    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(const SnackBar(content: Text('Registration Successful!')));
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (context) => const LoginScreen()),
    // );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Registration Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  String _roleToDisplayText(UserRole role) {
    switch (role) {
      case UserRole.buyer:
        return 'Buyer';
      case UserRole.seller:
        return 'Seller';
      case UserRole.reseller:
        return 'Reseller';
      case UserRole.contractor:
        return 'contractor';
    }
  }

  void _launchUrl(String url) {
    // You can use url_launcher here
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Get.lazyPut(() => AuthController());

    return Scaffold(
      appBar: CommonNesticoPeAppBar(
        title: 'Create ${_roleToDisplayText(_selectedRole)} Account',
        showBackArrow: true,
        leadingIcon: Icons.arrow_back,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Text(
                //   'Select Account Type',
                //   style: theme.textTheme.titleLarge?.copyWith(
                //     fontWeight: FontWeight.w600,
                //     color: Colors.black,
                //     fontSize: 16
                //   ),
                // ),
                //const SizedBox(height: 16),
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(30),
                //   ),
                //   child: Row(
                //     children:
                //         UserRole.values.map((role) {
                //           return Expanded(
                //             child: GestureDetector(
                //               onTap: () => setState(() => _selectedRole = role),
                //               child: Container(
                //                 padding: const EdgeInsets.symmetric(
                //                   vertical: 12,
                //                 ),
                //                 decoration: BoxDecoration(
                //                   color:
                //                       _selectedRole == role
                //                           ? theme.colorScheme.primary
                //                           : Colors.transparent,
                //                   borderRadius: BorderRadius.circular(30),
                //                 ),
                //                 child: Center(
                //                   child: Text(
                //                     _roleToDisplayText(role),
                //                     style: TextStyle(
                //                       color:
                //                           _selectedRole == role
                //                               ? Colors.white
                //                               : Colors.black87,
                //                       fontWeight: FontWeight.bold,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           );
                //         }).toList(),
                //   ),
                // ),

//                const SizedBox(height: 15),
                NesticoPeTextField(
                  title: "Username",
                  controller: _usernameController,
                  hintText: 'Enter Username',
                  prefixIcon: Icons.person_outline,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: NesticoPeTextField(
                        title: "First Name",
                        controller: _firstNameController,
                        hintText: 'Enter First Name',
                        prefixIcon: Icons.person_outline,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: NesticoPeTextField(
                        title: "Last Name",
                        controller: _lastNameController,
                        hintText: 'Enter Last Name',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter last name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                NesticoPeTextField(
                  title: "Email Address",
                  controller: _emailController,
                  hintText: 'Enter Email Address',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),
                NesticoPeTextField(
                  hintText: 'Enter Phone Number',
                  title: "Phone Number",
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),
                NesticoPeTextField(
                  hintText: 'Enter Address',
                  title: "Address",
                  controller: _addressController,
                  prefixIcon: Icons.home_outlined,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  validator: (value) {

                    if (value == null || value.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: NesticoPeTextField(
                        hintText: 'Enter City',
                        title: "City",
                        controller: _cityController,
                        prefixIcon: Icons.location_city_outlined,
                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter city';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: NesticoPeTextField(
                        hintText: 'Enter State',
                        title: "State",
                        controller: _stateController,
                        prefixIcon: Icons.map_outlined,
                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter state';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                NesticoPeTextField(
                  hintText: 'Enter Zip Code',
                  title: "Zip Code",
                  controller: _zipCodeController,
                  prefixIcon: Icons.numbers_outlined,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter zip code';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),
                NesticoPeTextField(
                  hintText: 'Enter Password',
                  title: "Password",
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  prefixIcon: Icons.lock_outline,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),
                NesticoPeTextField(
                  hintText: 'Enter Confirm Password',
                  title: "Confirm Password",
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged:
                          (val) => setState(() => _acceptTerms = val ?? false),
                      activeColor: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: const TextStyle(color: Colors.blue),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap =
                                        () => _launchUrl('https://grewox.com'),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                               text: 'Privacy Policy',
                              style: const TextStyle(color: Colors.blue),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap =
                                        () => _launchUrl('https://grewox.com'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                NesticoPeButton(
                  title: 'Create Account',
                  onTap: _isLoading ? null : _register,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Login here',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
