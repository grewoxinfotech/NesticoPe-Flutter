import 'package:flutter/material.dart';

class TrendingAreaCard extends StatelessWidget {
  final List<Map<String, dynamic>> localities = [
    {
      'name': 'Masma',
      'YoY': 0.85,
      'Percentage': '0.85%',
      'price': '₹ 2.6K / sq.ft.',
      'image':
      'https://housing-images.n7net.in/4f2250e8/87e7f7c26184125b0f522223f718b5d5/v0/medium/magna_solitaire-peeramcheru-hyderabad-magna_infra_avenues_llp.jpeg'
    },
    {
      'name': 'Dindoli',
      'YoY': 1.25,
      'Percentage': '1.25%',
      'price': '₹ 3.3K / sq.ft.',
      'image':
      'https://housing-images.n7net.in/4f2250e8/87e7f7c26184125b0f522223f718b5d5/v0/medium/magna_solitaire-peeramcheru-hyderabad-magna_infra_avenues_llp.jpeg'

    },
    {
      'name': 'Vesu',
      'YoY': -4.27,
      'Percentage': '-4.27%',
      'price': '₹ 5.5K / sq.ft.',
      'image':
      'https://housing-images.n7net.in/4f2250e8/87e7f7c26184125b0f522223f718b5d5/v0/medium/magna_solitaire-peeramcheru-hyderabad-magna_infra_avenues_llp.jpeg'
    },
  ];

   TrendingAreaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: localities.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              final locality = localities[index];
              final double yoy = locality['YoY'] as double;
              final bool isPositive = yoy >= 0;

              return Container(
                width: 260,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: ColorRes.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: Image.network(
                        locality['image'],
                        width: 80,
                        height: 130,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 80,
                            height: 130,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 130,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image_not_supported,
                                color: Colors.grey, size: 30),
                          );
                        },
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              locality['name'],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),

                            Row(
                              children: [
                                Icon(
                                  isPositive
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  size: 16,
                                  color: isPositive ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${locality['Percentage']} YoY",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color:
                                    isPositive ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            Text(
                              locality['price'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),

                            Container(
                              height: 1,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),

                            GestureDetector(
                              onTap: () {
                                print(
                                    "View price clicked for ${locality['name']}");
                              },
                              child: const Text(
                                "View price trend >",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
