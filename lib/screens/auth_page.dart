import 'package:flutter/material.dart';
import 'home_page.dart'; // Replace with the correct path to your HomePage file

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true;

  static const Color brandColor = Color(0xFFE86343);

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          alignLabelWithHint: true,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: brandColor),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String text,
    IconData? icon,
    Widget? iconWidget,
    Color iconColor = Colors.black87,
    required VoidCallback onPressed,
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black87,
    bool outlined = false,
  }) {
    final buttonStyle = outlined
        ? OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            foregroundColor: iconColor,
            side: BorderSide(color: iconColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.black12),
            ),
          );

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconWidget ??
            (icon != null
                ? Icon(icon, color: iconColor, size: 20)
                : const SizedBox.shrink()),
        if (iconWidget != null || icon != null) const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: outlined ? iconColor : textColor,
            fontSize: 16,
          ),
        ),
      ],
    );

    return SizedBox(
      width: double.infinity,
      child: outlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: buttonStyle,
              child: content,
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: buttonStyle,
              child: content,
            ),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: brandColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTextField(
          controller: _emailController,
          label: 'Email',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _passwordController,
          label: 'Password',
          isPassword: true,
        ),
        const SizedBox(height: 24),
        _buildPrimaryButton(
          text: 'Sign in',
          onPressed: () {},
        ),
        const SizedBox(height: 24),
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 24),
        _buildSocialButton(
          text: 'Sign in with Facebook',
          icon: Icons.facebook,
          iconColor: Colors.blue,
          onPressed: () {},
          outlined: true,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {},
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              color: brandColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSocialButton(
          text: 'Continue with Google',
          iconWidget: Image.asset(
            'images/googlelogo.webp',
            height: 24,
          ),
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        _buildSocialButton(
          text: 'Continue with Email',
          icon: Icons.mail_outline,
          iconColor: Colors.black87,
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        _buildSocialButton(
          text: 'Continue with Apple',
          icon: Icons.apple,
          iconColor: Colors.black,
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            children: const [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'or',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),
        ),
        _buildSocialButton(
          text: 'Continue with Facebook',
          icon: Icons.facebook,
          iconColor: Colors.blue,
          onPressed: () {},
        ),
        const SizedBox(height: 24),
        _buildPrimaryButton(
          text: 'Sign up',
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brandColor,
      resizeToAvoidBottomInset:
          true, // This ensures the layout adjusts when the keyboard appears.
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: const [
                  Text(
                    'EventMatch',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => setState(() => isLogin = true),
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                color: isLogin ? brandColor : Colors.grey,
                                fontWeight: isLogin
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => setState(() => isLogin = false),
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                color: !isLogin ? brandColor : Colors.grey,
                                fontWeight: !isLogin
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 24),
                          child:
                              isLogin ? _buildSignInForm() : _buildSignUpForm(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: MediaQuery.of(context).viewInsets.bottom == 0
                            ? 16
                            : 0,
                        top: 16,
                      ),
                      child: const Text(
                        'By proceeding, you agree to EventMatch\'s Privacy Policy, User Agreement and T&Cs',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
