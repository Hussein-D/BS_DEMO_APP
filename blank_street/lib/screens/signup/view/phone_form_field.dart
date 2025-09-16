import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({super.key, this.validator, required this.controller});
  final String? Function(PhoneNumber?)? validator;
  final PhoneController controller;

  @override
  Widget build(BuildContext context) {
    const cream = Color(0xFFFCF7F2);
    const beige = Color(0xFFECDBCB);

    return PhoneFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: cream,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: beige),
        ),
        prefixIcon: const Icon(Icons.phone_iphone),
      ),
      validator: validator,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      enableSuggestions: true,
    );
  }
}
