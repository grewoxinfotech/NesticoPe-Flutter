import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/utils/validation.dart';
import 'package:nesticope_app/widgets/New folder/inputs/text_field.dart';
import 'package:nesticope_app/widgets/button/button.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../controllers/auth_controller.dart';

class SellerRegistrationDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const SellerRegistrationDetailsScreen({super.key, this.initialData});

  @override
  State<SellerRegistrationDetailsScreen> createState() =>
      _SellerRegistrationDetailsScreenState();
}

class _SellerRegistrationDetailsScreenState
    extends State<SellerRegistrationDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.initialData?['firstName']?.toString() ?? '';
    _lastNameController.text = widget.initialData?['lastName']?.toString() ?? '';
    _emailController.text = widget.initialData?['email']?.toString() ?? '';
    _passwordController.text = widget.initialData?['password']?.toString() ?? '';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final authController = Get.find<AuthController>();
      final payload = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'sellerType': widget.initialData?['sellerType']?.toString(),
      };

      final success = await authController.completeSellerRegistration(payload);
      if (!success) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: 'Failed to complete registration.',
          contentType: ContentType.failure,
        );
        return;
      }

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Success',
        message: 'Registration completed successfully!',
        contentType: ContentType.success,
      );
        // 2️⃣ Save auth data
    
      authController.navigateToUserPanel();
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: e.toString().replaceAll('Exception:', '').trim(),
        contentType: ContentType.failure,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorRes.primary),
        title: const Text(
          'Complete Registration',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: ColorRes.primary,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: ColorRes.white,
          image: DecorationImage(
            image: AssetImage('assets/images/apartment1.png'),
            fit: BoxFit.cover,
            repeat: ImageRepeat.repeat,
            opacity: 0.08,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'One last step',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your account details to finish seller registration.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  NesticoPeTextField(
                    controller: _firstNameController,
                    hintText: 'First Name',
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'First name is required'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  NesticoPeTextField(
                    controller: _lastNameController,
                    hintText: 'Last Name',
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Last name is required'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  NesticoPeTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => emailValidation(value ?? ''),
                  ),
                  const SizedBox(height: 12),
                  NesticoPeTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() {
                        _obscurePassword = !_obscurePassword;
                      }),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: ColorRes.primary,
                        size: 18,
                      ),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().length < 6)
                            ? 'Password must be at least 6 characters'
                            : null,
                  ),
                  const SizedBox(height: 24),
                  NesticoPeButton(
                    title: _isSubmitting ? 'Submitting...' : 'Continue',
                    onTap: _isSubmitting ? null : _submit,
                    height: 48,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
