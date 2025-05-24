import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/core/widgets/button_widget.dart';
import 'package:instagram/core/widgets/text_input_widget.dart';
import 'package:instagram/r.dart';
import 'package:instagram/routes/app_router.dart';

@RoutePage()
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AssetIcons.logosInstagram),
              const SizedBox(height: 48),
              TextInputWidget(
                controller: _usernameController,
                hintText: 'Username',
              ),
              const SizedBox(height: 16),
              TextInputWidget(
                controller: _passwordController,
                hintText: 'Password',
                isPassword: true,
                obscureText: _obscurePassword,
                onToggleObscure: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              const SizedBox(height: 24),
              ButtonWidget(
                text: 'Log in',
                onPressed: () {
                  context.router.push(const DashboardRoute());
                },
                color: const Color(0xFF1877F2),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
