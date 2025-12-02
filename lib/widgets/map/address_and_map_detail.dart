import 'package:flutter/material.dart';

import '../../app/constants/app_font_sizes.dart';

class AddressAndMapDetails extends StatelessWidget {
  final String address;
  final String? city;
  final String? state;
  final String? zipCode;

  const AddressAndMapDetails({
    super.key,
    required this.address,
    this.city,
    this.state,
    this.zipCode,
  });

  @override
  Widget build(BuildContext context) {
    print("Address: $address");

    // Build dynamic address string based on what is available
    final buffer = StringBuffer();

    if (address.isNotEmpty) buffer.write(address);
    if (city?.isNotEmpty ?? false) buffer.write(", ${city}");
    if (state?.isNotEmpty ?? false) buffer.write(", ${state}");
    if (zipCode?.isNotEmpty ?? false) buffer.write(", ${zipCode}");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on_rounded, size: 16),
          const SizedBox(width: 8),

          // Address Text
          Flexible(
            child: Text(
              buffer.toString(),
              style: const TextStyle(
                fontSize: AppFontSizes.caption,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
