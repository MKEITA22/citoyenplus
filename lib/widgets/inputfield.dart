import 'package:flutter/material.dart';

Widget inputField(TextEditingController controller, {

  required String label,
  required IconData icon,
  TextInputType? keyboard,
  String? Function(String?)? validator, required bool obscureText, required IconButton suffixIcon,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboard,
      obscureText: icon.toString().contains("lock"),
      validator: validator,
      decoration: InputDecoration(
        icon: Icon(icon, color: Colors.blueAccent),
        labelText: label,
        border: InputBorder.none,
      ),
    ),
  );
}
