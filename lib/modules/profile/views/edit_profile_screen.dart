import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/font_res.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
import 'package:housing_flutter_app/widgets/button/button.dart';

import '../../../widgets/New folder/inputs/text_field.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each field

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              buildTextField(
                Icons.person_outline,
                "Username",
                controller.usernameController,
              ),
              buildTextField(
                Icons.lock_outline,
                "Password",
                controller.passwordController,
                obscureText: true,
              ),
              buildTextField(
                Icons.email_outlined,
                "Email",
                controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              Text(
                "User Type",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontFamily: FontRes.nuNunitoSans,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              NesticoPeDropdownField(
                title: "Select Role",
                value: controller.selectedUserType,
                items:
                    ['buyer', 'seller']
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => controller.selectedUserType = value);
                  }
                },
              ),

              const SizedBox(height: 20),
              buildTextField(
                Icons.person_outline,
                "First Name",
                controller.firstNameController,
              ),
              buildTextField(
                Icons.person_outline,
                "Last Name",
                controller.lastNameController,
              ),
              buildTextField(
                Icons.phone_outlined,
                "Phone",
                controller.phoneController,
                keyboardType: TextInputType.phone,
              ),
              buildTextField(
                Icons.home_outlined,
                "Address",
                controller.addressController,
              ),
              buildTextField(
                Icons.location_city_outlined,
                "City",
                controller.cityController,
              ),
              buildTextField(
                Icons.numbers_outlined,
                "State",
                controller.stateController,
              ),
              buildTextField(
                Icons.numbers_outlined,
                "ZIP Code",
                controller.zipCodeController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              NesticoPeButton(
                onTap: () {
                  // controller.updateProfile();
                  // if (_formKey.currentState?.validate() ?? false) {
                  //   // TODO: Submit updated profile
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(
                  //       content: Text('Profile updated successfully!'),
                  //     ),
                  //   );
                  // }
                },

                title: "Save Changes",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    IconData icon,
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: NesticoPeTextField(
        hintText: "Enter $label",
        obscureText: obscureText,
        title: label,
        controller: controller,
        prefixIcon: icon,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your city';
          }
          return null;
        },
      ),
      // TextFormField(
      //   controller: controller,
      //   obscureText: obscureText,
      //   keyboardType: keyboardType,
      //   validator:
      //       (value) =>
      //           (value == null || value.isEmpty) ? 'Please enter $label' : null,
      //   decoration: InputDecoration(
      //     labelText: label,
      //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      //   ),
      // ),
    );
  }
}
