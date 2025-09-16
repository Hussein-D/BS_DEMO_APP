import 'package:blank_street/screens/profile/view/row_item.dart';
import 'package:blank_street/screens/profile/view/section_title.dart';
import 'package:blank_street/screens/profile/view/settings_card.dart';
import 'package:blank_street/screens/signup/bloc/signup_bloc.dart';
import 'package:blank_street/screens/signup/view/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const cream = Color(0xFFFCF7F2);
  static const beige = Color(0xFFECDBCB);
  static const beige2 = Color(0xFFF4E7DA);
  static const green = Color(0xFF0E8A5C);
  static const textPrimary = Color(0xFF3B3027);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        height: 50,
        width: double.infinity,
        child: FilledButton(
          onPressed: () async {
            final bool? result = await showDialog(
              context: context,
              builder: (context) => AlertDialog.adaptive(
                title: Text("Logout"),
                content: Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text(
                      "Logout",
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
            if (result != null && result) {
              context.read<SignupBloc>().add(Logout());
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SignupScreen()),
                (Route<dynamic> route) => true,
              );
            }
          },
          child: Text("Logout"),
        ),
      ),
      backgroundColor: cream,
      appBar: AppBar(
        leadingWidth: 44,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            Material(
              color: const Color(0xFFF1E4D8),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.pop(context),
                child: const SizedBox(
                  width: 36,
                  height: 36,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: green,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: BlocBuilder<SignupBloc, SignupState>(
                            builder: (context, state) {
                              String initials = "";
                              if (state is SignupInitial &&
                                  state.user != null) {
                                if ((state.user?.fullName ?? "").isNotEmpty) {
                                  initials += (state.user?.fullName ?? "")[0];
                                  if ((state.user?.fullName ?? "")
                                      .trim()
                                      .contains(" ")) {
                                    initials += (state.user?.fullName ?? "")
                                        .split(" ")
                                        .last[0];
                                  }
                                }
                              }
                              return Text(
                                initials.isNotEmpty ? initials : "User",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 28,
                                  letterSpacing: 1.2,
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Material(
                            color: beige,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(10),
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                  Icons.photo_camera_outlined,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<SignupBloc, SignupState>(
                      builder: (context, state) {
                        return Text(
                          state is SignupInitial && state.user != null
                              ? state.user?.fullName ?? ""
                              : "Hussein Dbouk",
                          style: const TextStyle(
                            color: textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SectionTitle('Profile'),
              SettingsCard(
                children: [
                  RowItem('Account'),
                  RowItem('Payment methods'),
                  RowItem('Wallet'),
                  RowItem('Order history'),
                  RowItem('Dietary preferences'),
                  RowItem('Snake'),
                ],
              ),
              const SizedBox(height: 24),
              SectionTitle('Settings'),
              SettingsCard(
                children: [
                  RowItem('Notifications'),
                  RowItem('Location'),
                  RowItem('Preferred tip'),
                ],
              ),
              const SizedBox(height: 24),
              SectionTitle('Gifting'),
              SettingsCard(children: [RowItem('Gift cards')]),
            ],
          ),
        ),
      ),
    );
  }
}
