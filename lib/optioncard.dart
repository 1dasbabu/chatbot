import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap; // Added onTap callback

  const OptionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap, // Accept onTap callback
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Trigger the onTap callback when the card is tapped
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.lightBlue[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 19, 104, 147),
                child: Icon(icon, size: 20, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
