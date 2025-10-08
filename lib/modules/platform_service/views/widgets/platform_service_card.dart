import 'package:flutter/material.dart';
import '../../../../data/network/platform_service/platform_service_model.dart';

class PlatformServiceHorizontalList extends StatelessWidget {
  final List<PlatformServiceItem> services;
  final double cardWidth;
  final double cardHeight;
  final void Function(PlatformServiceItem)? onTap;

  const PlatformServiceHorizontalList({
    super.key,
    required this.services,
    this.cardWidth = 250,
    this.cardHeight = 200,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text("No services available")),
      );
    }

    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final service = services[index];
          return GestureDetector(
            onTap: () => onTap?.call(service),
            child: Container(
              width: cardWidth,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon or placeholder
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        service.icon != null
                            ? Image.network(service.icon!, fit: BoxFit.contain)
                            : Icon(Icons.home_work, color: Colors.blue),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    service.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    service.description ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const Spacer(),
                  // Features (optional, show first 2)
                  if (service.features != null && service.features!.isNotEmpty)
                    Row(
                      children:
                          service.features!
                              .take(2)
                              .map(
                                (f) => Container(
                                  margin: const EdgeInsets.only(right: 6),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    f,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
