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
//                     color: ColorRes.white,
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
//                                               ? ColorRes.white
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
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/utils/validation.dart';
import 'package:housing_flutter_app/modules/auth/views/widget/city_zip_code_selector.dart';
import 'package:housing_flutter_app/widgets/bar/app_bar/common_bar.dart';
import 'package:housing_flutter_app/widgets/button/button.dart';
import 'package:housing_flutter_app/modules/auth/controllers/auth_controller.dart';

import '../../../app/constants/color_res.dart';
import '../../../app/widgets/snackbar/snackbar.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../widgets/New folder/inputs/text_field.dart';
import '../../../widgets/input/city_selection_widget.dart';
import '../../../widgets/messages/snack_bar.dart';

UserRole? selectedRole;

class RegisterScreen extends StatefulWidget {
  final UserRole role;

  const RegisterScreen({Key? key, required this.role}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final authController = Get.put(AuthController());

  String? _selectedSellerType;
  String? _contractorType;
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
  final _referralCodeController = TextEditingController();
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
          referralCode: _referralCodeController.text.trim(),
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

  Future<void> _sellerRegister() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        _showErrorDialog('Please accept the terms and conditions');
        return;
      }

      if (_selectedSellerType == null) {
        _showErrorDialog('Please select seller type');
        return;
      }

      setState(() => _isLoading = true);

      try {
        final data = {
          "username": _usernameController.text.trim(),
          "firstName": _firstNameController.text.trim(),
          "lastName": _lastNameController.text.trim(),
          "email": _emailController.text.trim(),

          "password": _passwordController.text.trim(),
          // "address": _addressController.text.trim(),
          // "city": _cityController.text.trim(),
          // "state": _stateController.text.trim(),
          // "zip_code": _zipCodeController.text.trim(),
        };

        final success = await authController.sellerRegister(
          context: context,
          username: _usernameController.text.trim(),
          phone: _phoneController.text.trim(),
          referralCode: _referralCodeController.text.trim(),
          sellerType: _selectedSellerType?.toLowerCase() ?? 'owner',
          data: data,
        );

        // if (!success) {
        //   _showErrorDialog(authController.errorMessage.value);
        // } else {
        //   // _showSuccessDialog();
        //   NesticoPeSnackBar.showAwesomeSnackbar(
        //     title: "Success",
        //     message: "OTP sent Successfully",
        //     contentType: ContentType.success,
        //   );
        // }
      } catch (e) {
        _showErrorDialog('Registration failed: ${e.toString()}');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _reSellerRegister() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        _showErrorDialog('Please accept the terms and conditions');
        return;
      }

      setState(() => _isLoading = true);

      try {
        final data = {
          "username": _usernameController.text.trim(),
          "email": _emailController.text.trim(),
          "phone": _phoneController.text.trim(),
          "city": _cityController.text.trim(),
          "password": _passwordController.text.trim(),
          // "firstName": _firstNameController.text.trim(),
          // "lastName": _lastNameController.text.trim(),
          // "address": _addressController.text.trim(),
          // "state": _stateController.text.trim(),
          "zip_code": _zipCodeController.text.trim(),
          "referralCode": _referralCodeController.text.trim(),
        };

        final success = await authController.resellerRegister(
          data: data,
          phone: _phoneController.text.trim(),
          referralCode: _referralCodeController.text.trim(),
        );

        // if (!success) {
        //   _showErrorDialog(authController.errorMessage.value);
        // } else {
        //   // _showSuccessDialog();
        //   NesticoPeSnackBar.showAwesomeSnackbar(
        //     title: "Success",
        //     message: "OTP sent Successfully",
        //     contentType: ContentType.success,
        //   );
        // }
      } catch (e) {
        _showErrorDialog('Registration failed: ${e.toString()}');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _contractorRegister() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        _showErrorDialog('Please accept the terms and conditions');
        return;
      }

      if (_contractorType == null) {
        _showErrorDialog('Please select Contractor type');
        return;
      }

      setState(() => _isLoading = true);

      try {
        final data = {
          "username": _usernameController.text.trim(),
          "email": _emailController.text.trim(),
          "phone": _phoneController.text.trim(),
          "contractorType": _contractorType ?? 'Labour',
          "city": _cityController.text.trim(),
          "password": _passwordController.text.trim(),
          // "firstName": _firstNameController.text.trim(),
          // "lastName": _lastNameController.text.trim(),
          // "address": _addressController.text.trim(),
          // "state": _stateController.text.trim(),
          // "zip_code": _zipCodeController.text.trim(),
          "referralCode": _referralCodeController.text.trim(),
        };

        final success = await authController.contractorRegister(
          // username: _usernameController.text.trim(),
          phone: _phoneController.text.trim(),
          // referralCode: _referralCodeController.text.trim(),
          // contractorType: _contractorType?.toLowerCase() ?? 'labour',
          data: data,
        );
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
            backgroundColor: ColorRes.white,
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
                // if (_selectedRole == UserRole.seller) ...[
                //   Text(
                //     "Select Seller Type",
                //     style: const TextStyle(
                //       fontSize: 14,
                //       color: ColorRes.black,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                //   Row(
                //     children: [
                //       _buildRadioOption("Owner"),
                //       const SizedBox(width: 24),
                //       _buildRadioOption("Builder"),
                //     ],
                //   ),
                //   const SizedBox(height: 10),
                // ],
                if (_selectedRole == UserRole.seller)
                  CommonRadioGroup<String>(
                    title: "Select Seller Type",
                    options: const ["Owner", "Builder"],
                    groupValue: _selectedSellerType,
                    labelBuilder: (v) => v,
                    onChanged: (value) {
                      setState(() {
                        _selectedSellerType = value;
                      });
                    },
                  ),

                // if (_selectedRole == UserRole.buyer ||
                //     _selectedRole == UserRole.contractor ||
                //     _selectedRole == UserRole.reseller)...[
                NesticoPeTextField(
                  title: "Username",
                  controller: _usernameController,
                  hintText: 'Enter Username',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
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

                // ],
                if (_selectedRole == UserRole.seller) ...[
                  Row(
                    children: [
                      Expanded(
                        child: NesticoPeTextField(
                          title: "First Name",
                          style: TextStyle(
                            fontSize: AppFontSizes.medium,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.textPrimary,
                          ),
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
                          style: TextStyle(
                            fontSize: AppFontSizes.medium,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.textPrimary,
                          ),

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
                ],

                NesticoPeTextField(
                  title: "Email Address",
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
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
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => phoneValidation(value),
                ),

                const SizedBox(height: 10),

                // if (_selectedRole == UserRole.contractor) ...[
                //   Text(
                //     "Contractor Type",
                //     style: const TextStyle(
                //       fontSize: 14,
                //       color: ColorRes.black,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                //   Row(
                //     children: [
                //       _buildRadioOption("Company"),
                //       const SizedBox(width: 24),
                //       _buildRadioOption("Labour"),
                //     ],
                //   ),
                //   const SizedBox(height: 10),
                // ],
                if (_selectedRole == UserRole.contractor)
                  CommonRadioGroup<String>(
                    title: "Contractor Type",
                    options: const ["Company", "Labour"],
                    groupValue: _contractorType,
                    labelBuilder: (v) => v,
                    onChanged: (value) {
                      setState(() {
                        _contractorType = value;
                      });
                    },
                  ),

                // const SizedBox(height: 10),
                if (_selectedRole == UserRole.contractor) ...[
                  CitySelectionWidget(
                    isEditing: true,
                    controller: _cityController,
                    isRequired: true,

                    color: ColorRes.primary,
                    fillColor: ColorRes.white,
                    onCitySelected: (selectedCity) {
                      debugPrint(
                        "✅ Selected city: ${selectedCity.description}",
                      );
                      _cityController.text = selectedCity.description ?? '';
                    },
                  ),

                  // const SizedBox(height: 10),
                  // NesticoPeTextField(
                  //   hintText: 'Enter Zip Code',
                  //   title: "Zip Code",
                  //   controller: _zipCodeController,
                  //   prefixIcon: Icons.numbers_outlined,
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  //
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please enter zip code';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  const SizedBox(height: 10),
                ],

                if (_selectedRole == UserRole.reseller) ...[
                  CityZipcodeSelector(
                    onSelected: (city, zipcode) {
                      _cityController.text = city ?? '';
                      _zipCodeController.text = zipcode ?? '';
                      print('City: $city, Zipcode: $zipcode');
                    },
                  ),
                  SizedBox(height: 10),
                ],
                NesticoPeTextField(
                  hintText: 'Enter Password',
                  title: "Password",
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  prefixIcon: Icons.lock_outline,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: ColorRes.leadGreyColor,
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
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: ColorRes.leadGreyColor,
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
                const SizedBox(height: 10),
                NesticoPeTextField(
                  hintText: 'Enter Referral Code (Optional)',
                  title: "Referral Code",
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),

                  controller: _referralCodeController,
                  textCapitalization: TextCapitalization.characters,
                  prefixIcon: Icons.numbers_outlined,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            fontSize: AppFontSizes.medium,
                            // fontSize: 14,
                            color: ColorRes.leadGreyColor.shade700,
                          ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: const TextStyle(color: ColorRes.blueColor),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap =
                                        () => _launchUrl('https://grewox.com'),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(color: ColorRes.blueColor),
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

                // NesticoPeButton(
                //   title: 'Create Account',
                //   onTap: _isLoading ? null : switchRole(_selectedRole),
                // ),
                Obx(
                  () => NesticoPeButton(
                    title:
                        authController.isLoading.value
                            ? "Registering..."
                            : "Register",
                    backgroundColor:
                        authController.isLoading.value
                            ? ColorRes.primary.withOpacity(0.6)
                            : ColorRes.primary,
                    onTap:
                        authController.isLoading.value
                            ? null
                            : switchRole(_selectedRole),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: ColorRes.leadGreyColor.shade700),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Login here',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: AppFontWeights.extraBold,
                          // fontWeight: FontWeight.bold,
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

  dynamic switchRole(UserRole role) {
    switch (role) {
      case UserRole.buyer:
        return _register;
      case UserRole.seller:
        return _sellerRegister;
      case UserRole.reseller:
        return _reSellerRegister;
      case UserRole.contractor:
        return _contractorRegister;
    }
  }

  Widget _buildRadioOption(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: label,
          activeColor: ColorRes.primary,
          groupValue: _selectedSellerType,
          onChanged: (value) {
            setState(() {
              _selectedSellerType = value;
            });
          },
        ),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

Widget _buildFieldLabel(String label) {
  return Text(
    label,
    style: const TextStyle(
      fontSize: AppFontSizes.medium,
      fontWeight: AppFontWeights.semiBold,
      color: ColorRes.textPrimary,
    ),
  );
}

class CommonRadioGroup<T> extends StatelessWidget {
  final String title;
  final List<T> options;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final String Function(T value) labelBuilder;
  final double spacing;

  const CommonRadioGroup({
    super.key,
    required this.title,
    required this.options,
    required this.groupValue,
    required this.onChanged,
    required this.labelBuilder,
    this.spacing = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: ColorRes.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children:
              options.map((option) {
                return Padding(
                  padding: EdgeInsets.only(right: spacing),
                  child: CommonRadioOption<T>(
                    value: option,
                    groupValue: groupValue,
                    label: labelBuilder(option),
                    onChanged: onChanged,
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class CommonRadioOption<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final String label;
  final ValueChanged<T?> onChanged;
  final double fontSize;
  final Color? activeColor;

  const CommonRadioOption({
    super.key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
    this.fontSize = 13,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<T>(
          value: value,
          groupValue: groupValue,
          activeColor: activeColor ?? ColorRes.primary,
          onChanged: onChanged,
        ),
        Text(label, style: TextStyle(fontSize: fontSize)),
      ],
    );
  }
}
