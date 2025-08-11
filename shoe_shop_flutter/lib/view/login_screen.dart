import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../data/viewModel/auth_view_model.dart';
import '../routes/app_routes.dart';
import '../utils/snack_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoader = false;


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoader = true);

      try {
        final authViewModel = context.read<AuthViewModel>();
        final isSuccess = await authViewModel.login(
          _usernameController.text,
          _passwordController.text,
        );
        if (!mounted) return;
        if (isSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.main,
                (route) => false, 
          );
        } else {
          SnackBarUtil.showSnackBar(context, 'Login failed!', AppColors.red);
        }
      } catch (e) {
        SnackBarUtil.showSnackBar(context, 'Error: $e', AppColors.red);
      } finally {
        if (mounted) {
          setState(() => isLoader = false);
        }
      }
    }
  }

  final googleSignIn = GoogleSignIn(
    scopes: ['email', 'openid'],
    serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID']!,
  );

  Future<void> _handleGoogleLogin() async {
    setState(() => isLoader = true);

    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        if (!mounted) return;
        SnackBarUtil.showSnackBar(context, 'Google Sign-In cancelled', Colors.orange);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await account.authentication;
      final String? idToken = googleAuth.idToken;
      if (idToken == null) {
        if (!mounted) return;
        SnackBarUtil.showSnackBar(context, 'Failed to get Google ID token', Colors.red);
        return;
      }

      if (!mounted) return;
      final authViewModel = context.read<AuthViewModel>();
      final bool isSuccess = await authViewModel.googleLogin(idToken);

      if (!mounted) return;

      if (isSuccess) {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
      } else {
        SnackBarUtil.showSnackBar(context, 'Google login failed', Colors.red);
      }
    } catch (e) {
      print("Error google $e");
      if (mounted) {
        SnackBarUtil.showSnackBar(context, 'Error during Google login: $e', Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => isLoader = false);
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.all(16.w),
          children: [
            IconButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SnackBarUtil.showSnackBar(context, 'No screen to back ', Colors.red);
                }
              },
              icon: Icon(Icons.arrow_back, color: AppColors.black54, size: 24.sp),
              alignment: Alignment.centerLeft,
            ),

            SizedBox(height: 40.h),

            Center(
              child: Lottie.asset(
                'asset/lottie/login.json',
                width: 250.w,
                height: 250.h,
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(height: 40.h),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    style: TextStyle(color: AppColors.black87, fontSize: 16.sp),
                    keyboardType: TextInputType.name,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration("Username", Icons.verified_user),
                    validator: AppValidator.validateUser
                  ),
                  SizedBox(height: 16.h),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(color: AppColors.black87, fontSize: 16.sp),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration("Password", Icons.password),
                    validator: AppValidator.validatePassword
                  ),
                ],
              ),
            ),

            SizedBox(height: 40.h),

            SizedBox(
              height: 50.h,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoader ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  foregroundColor: AppColors.white,
                  textStyle: TextStyle(fontSize: 18.sp),
                ),
                child: isLoader
                    ? Center(
                  child: SizedBox(
                    height: 24.h,
                    width: 24.w,
                    child: const CircularProgressIndicator(color: AppColors.white),
                  ),
                )
                    : Text(
                  "Login",
                  style: TextStyle(color: AppColors.white, fontSize: 25.sp),
                ),
              ),
            ),

            SizedBox(height: 10.h),

            Center(
              child: Text(
                "Or",
                style: TextStyle(
                  color: AppColors.blue,  // màu xanh theo AppColors bạn đang dùng
                  fontSize: 18.sp,
                ),
              ),
            ),

            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              onPressed: isLoader ? null : _handleGoogleLogin,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Continue with",
                    style: TextStyle(color: AppColors.blue, fontSize: 20.sp),
                  ),
                  SizedBox(width: 8.w),
                  Image.asset('asset/images/google_logo.png', height: 35.h),
                ],
              ),
            ),

            SizedBox(height: 15.h),

            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.signUp);
                },
                child: Text(
                  "Create New Account",
                  style: TextStyle(color: AppColors.teal, fontSize: 22.sp),
                ),
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon) {
    return InputDecoration(
      fillColor: AppColors.lightGrey,
      filled: true,
      labelText: label,
      labelStyle: TextStyle(color: AppColors.grey, fontSize: 16.sp),
      floatingLabelStyle: TextStyle(color: AppColors.black87, fontSize: 16.sp),
      suffixIcon: Icon(suffixIcon, color: AppColors.grey, size: 20.sp),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey),
        borderRadius: BorderRadius.circular(10.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.black87),
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}


