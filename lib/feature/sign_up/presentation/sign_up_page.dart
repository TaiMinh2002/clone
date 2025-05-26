import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/core/widgets/button_widget.dart';
import 'package:instagram/r.dart';
import 'package:instagram/routes/app_router.dart';

@RoutePage()
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _body(context)),
            _signInWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AssetIcons.logosInstagram),
          const Padding(
            padding: EdgeInsets.only(top: 25.0, bottom: 100),
            child: Text(
              'Sign up to see photos videos and reels from your friends.',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
            ),
          ),
          _loginWithFacebook(),
          _orWidget(),
          _signUpWithPhoneOrEmail(context),
        ],
      ),
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

  Widget _loginWithFacebook() {
    return ButtonWidget(
      text: 'Continue with Minh',
      onPressed: () {},
      icon: AssetIcons.iconFacebook,
    );
  }

  Widget _signUpWithPhoneOrEmail(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.push(const SignUpEmailRoutes());
      },
      child: const Text(
        'Sign Up With Phone or Email',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _signInWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      width: double.infinity,
      color: const Color(0xffF4F4F4),
      child: Center(
        child: GestureDetector(
          onTap: () {
            context.router.push(const SignInRoute());
          },
          child: const Text(
            'Already have an account? Sign in',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
