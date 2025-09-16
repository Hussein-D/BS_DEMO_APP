import 'package:flutter/material.dart';

class SignUpTextFormField extends StatelessWidget {
  const SignUpTextFormField({
    super.key,
    required this.controller,
    this.hint,
    this.validator,
    this.isReadOnly,
    this.onTap,
  });
  final TextEditingController controller;
  final String? hint;
  final String? Function(String?)? validator;
  final bool? isReadOnly;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const cream = Color(0xFFFCF7F2);
    const beige = Color(0xFFECDBCB);
    return TextFormField(
      onTap: onTap,
      controller: controller,
      validator: validator,
      readOnly: isReadOnly ?? false,
      decoration: InputDecoration(
        hintText: hint,
        fillColor: cream,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: beige),
        ),
      ),
    );
  }
}
