import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/core/widgets/button_widget.dart';
import 'package:instagram/core/widgets/text_input_widget.dart';
import 'package:instagram/r.dart';
import 'package:instagram/routes/app_router.dart';

@RoutePage()
class SignUpEmailPages extends StatefulWidget {
  const SignUpEmailPages({super.key});

  @override
  State<SignUpEmailPages> createState() => _SignUpEmailPagesState();
}

class _SignUpEmailPagesState extends State<SignUpEmailPages> {
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
              _inputWidget(context),
              _signUpWidget(context),
              _buttonWidget(),
              _orWidget(),
              _signUpWithFacebook(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48.0, bottom: 24.0),
      child: Column(
        children: [
          TextInputWidget(controller: _usernameController, hintText: 'Email'),
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
        ],
      ),
    );
  }

  Widget _buttonWidget() {
    return ButtonWidget(
      text: 'Sign Up',
      onPressed: () {},
      color: const Color(0xFF1877F2),
    );
  }

  Widget _orWidget() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 46.0),
      child: Row(
        children: [
          Expanded(child: Divider()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Or'),
          ),
          Expanded(child: Divider()),
        ],
      ),
    );
  }

  Widget _signUpWithFacebook() {
    return ButtonWidget(
      text: 'Sign Up with Facebook',
      onPressed: () {},
      icon: AssetIcons.iconFacebook,
    );
  }

  Widget _signUpWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Center(
        child: GestureDetector(
          onTap: () {
            context.router.push(const SignInRoute());
          },
          child: RichText(
            text: const TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF6D6D6D),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF23244F),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
