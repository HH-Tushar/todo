
import 'package:flutter/material.dart';


class CustomTaskCard extends StatelessWidget {
  const CustomTaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'High',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const Text(
                '82%',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Salon App Wireframe',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Row(
          //   children: const [
          //     Icon(Icons.access_time, color: Colors.grey, size: 16),
          //     SizedBox(width: 8),
          //     Text('10:00 AM - 06:00 PM', style: TextStyle(color: Colors.grey)),
          //   ],
          // ),
          Text(
            "data jsadf kasjd fkajsdn fkajsnd fkjasn dfkjasn dkjnask djfnkasjn dfkljsan dfkjand jas fjsd. kjsd fkasjdfkajsd jfkash dfjk hasjdhfbjash fdj",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Due Date: August 25',
                style: TextStyle(color: Colors.grey),
              ),
              // Simple Avatars Placeholder
              SizedBox(
                width: 50,
                height: 30,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blueGrey.shade800,
                    ),
                    Positioned(
                      left: 15,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.brown.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
