import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blank_street/models/user.dart';
import 'package:blank_street/screens/home/view/home_screen.dart';
import 'package:blank_street/screens/signup/bloc/signup_bloc.dart';
import 'package:blank_street/screens/signup/view/phone_form_field.dart';
import 'package:blank_street/screens/signup/view/sign_up_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:phone_form_field/phone_form_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final PhoneController _phoneController = PhoneController();
  final TextEditingController _birthdayController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupInitial && (state.message ?? "").isNotEmpty) {
          AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: (state.message ?? "").contains("error")
                ? DialogType.error
                : DialogType.success,

            title: (state.message ?? "").contains("error")
                ? "Error"
                : "Success",
            desc: (state.message ?? ""),
          ).show();
        }
        if (state is SignupInitial && state.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        // appBar: AppBar(
        //   leadingWidth: 50,
        //   leading: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       const SizedBox(width: 20),
        //       GestureDetector(
        //         onTap: () => Navigator.pop(context),
        //         child: Container(
        //           width: 30,
        //           height: 30,
        //           decoration: BoxDecoration(
        //             shape: BoxShape.circle,
        //             color: Theme.of(context).colorScheme.secondary,
        //           ),
        //           child: Icon(
        //             Icons.arrow_back_ios_new_rounded,
        //             color: Colors.white,
        //             size: 18,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign up",
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SignUpTextFormField(
                    controller: _fullNameController,
                    hint: "Full name",
                    validator: (String? value) {
                      if (value == null || (value).length < 3) {
                        return "Please enter your full name";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  SignUpTextFormField(
                    controller: _emailController,
                    hint: "Email",
                    validator: (String? value) {
                      if (value == null || (value).length < 3) {
                        return "Please enter your full name";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  PhoneNumberField(
                    controller: _phoneController,
                    validator: (PhoneNumber? value) {
                      log("value : ${value?.nsn}");
                      if (value?.nsn == null || value!.nsn.isEmpty)
                        return 'Phone is required';
                      return PhoneValidator.validMobile(
                        context,
                        errorText: 'Enter a valid mobile number',
                      )(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  SignUpTextFormField(
                    controller: _birthdayController,
                    hint: "Birthday (Optional)",
                    isReadOnly: true,
                    onTap: () async {
                      final DateTime? result = await showDatePicker(
                        context: context,
                        initialDate: _birthdayController.text.isNotEmpty
                            ? DateTime.tryParse(_birthdayController.text)
                            : DateTime.now(),
                        firstDate: DateTime(1930),
                        lastDate: DateTime.now().add(const Duration(days: 1)),
                      );
                      if (result != null) {
                        setState(() {
                          _birthdayController.text = DateFormat(
                            "yyyy-MM-dd",
                          ).format(DateTime.parse(result.toString()));
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Help us add a spark to your ordinary",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "ADD REFERAL CODE",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile.adaptive(
                    value: _isChecked,
                    onChanged: (v) => setState(() {
                      _isChecked = v ?? false;
                    }),
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "By creating an account, you agree to our ",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          TextSpan(
                            text: "Terms",
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(decoration: TextDecoration.underline),
                          ),
                          TextSpan(
                            text: " & ",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          TextSpan(
                            text: "Privacy Policy",
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        final bool result =
                            _formKey.currentState?.validate() ?? false;
                        if (result) {
                          context.read<SignupBloc>().add(
                            SignupRequest(
                              user: User(fullName: _fullNameController.text),
                            ),
                          );
                        } else {
                          return;
                        }
                      },
                      child: BlocBuilder<SignupBloc, SignupState>(
                        builder: (context, state) {
                          if (state is SignupLoading) {
                            return SpinKitThreeBounce(
                              color: Colors.white,
                              size: 20,
                            );
                          }
                          return Text("Signup");
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(),
                  Container(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {},
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Already have an account? ",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            TextSpan(
                              text: "SIGN IN",
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
