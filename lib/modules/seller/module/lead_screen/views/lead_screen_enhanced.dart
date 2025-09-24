import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';

final List<Map<String, dynamic>> dummyLeads = [
  {
    "name": "Ethan Valdez",
    "email": "ethan.valdez@example.com",
    "phone": "+91 98765 12345",
    "property": {
      "name": "2BHK Apartment in Viman Nagar",
      "type": "Apartment",
      "price": "65 Lakhs",
      "area": "1200 sq ft",
      "image": IMGRes.home1,
      "propertyId": "PROP001",
    },
    "reseller": "RS1",
    "source": "App",
    "stage": "Interested",
    "date": "23 Sep 2025",
  },
  {
    "name": "Sophia Martinez",
    "email": "sophia.m@example.com",
    "phone": "+91 91234 56789",
    "property": {
      "name": "Luxury Villa in Goa",
      "type": "Villa",
      "price": "2.5 Cr",
      "area": "3500 sq ft",
      "image": IMGRes.home2,
      "propertyId": "PROP002",
    },
    "reseller": "RS2",
    "source": "Website",
    "stage": "New Lead",
    "date": "20 Sep 2025",
  },
  {
    "name": "Arjun Sharma",
    "email": "arjun.sharma@example.com",
    "phone": "+91 99887 66554",
    "property": {
      "name": "3BHK Flat in Bandra, Mumbai",
      "type": "Apartment",
      "price": "1.8 Cr",
      "area": "1800 sq ft",
      "image": IMGRes.home3,
      "propertyId": "PROP003",
    },
    "reseller": "RS3",
    "source": "Referral",
    "stage": "Contacted",
    "date": "18 Sep 2025",
  },
  {
    "name": "Liam Johnson",
    "email": "liam.j@example.com",
    "phone": "+91 98770 11223",
    "property": {
      "name": "Office Space in Connaught Place",
      "type": "Commercial",
      "price": "95 Lakhs",
      "area": "2200 sq ft",
      "image": IMGRes.home4,
      "propertyId": "PROP004",
    },
    "reseller": "RS4",
    "source": "Other",
    "stage": "Negotiation",
    "date": "15 Sep 2025",
  },
  {
    "name": "Aarohi Mehta",
    "email": "aarohi.mehta@example.com",
    "phone": "+91 98989 77777",
    "property": {
      "name": "Penthouse in Pune",
      "type": "Penthouse",
      "price": "3.2 Cr",
      "area": "4000 sq ft",
      "image": IMGRes.project_1,
      "propertyId": "PROP005",
    },
    "reseller": "RS5",
    "source": "App",
    "stage": "Site Visit",
    "date": "10 Sep 2025",
  },
];

class LeadScreen extends StatelessWidget {
  const LeadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Leads",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey[50]!, Colors.white],
            ),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dummyLeads.length,
            itemBuilder: (context, index) {
              final lead = dummyLeads[index];
              return LeadCard(
                name: lead['name'],
                email: lead['email'],
                phone: lead['phone'],
                property: lead['property'],
                reseller: lead['reseller'],
                source: lead['source'],
                stage: lead['stage'],
                date: lead['date'],
              );
            },
          ),
        ),
      ),
    );
  }
}

class LeadCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final Map<String, dynamic> property;
  final String reseller;
  final String source;
  final String stage;
  final String date;

  const LeadCard({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.property,
    required this.reseller,
    required this.source,
    required this.stage,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {}, // Handle card tap for viewing details
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Property Image Section
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: AssetImage(property['image']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        property['propertyId'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Lead Details Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildChip(source, Colors.blue[50]!, Colors.blue[700]!),
                      const SizedBox(width: 8),
                      _buildChip(stage, Colors.green[50]!, Colors.green[700]!),

                      // const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Property Details Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property['name'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildPropertyInfo(
                              Icons.home_work,
                              property['type'],
                            ),
                            const SizedBox(width: 16),
                            _buildPropertyInfo(
                              Icons.square_foot,
                              property['area'],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        _buildPropertyInfo(
                          Icons.currency_rupee,
                          property['price'],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(IMGRes.user_2),
                          radius: 25,
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    color: ColorRes.primary,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      email,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[800],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    color: ColorRes.primary,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    phone,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.store_mall_directory_outlined,
                    "Reseller: $reseller",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: ColorRes.primary),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 16,
                color: ColorRes.primary.withOpacity(0.6),
              ),
            ),
            const SizedBox(width: 12),
            Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[800])),
          ],
        ),
        Text(
          date,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
