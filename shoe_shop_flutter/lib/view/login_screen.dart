import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../data/viewModel/auth_view_model.dart';
import '../routes/app_routes.dart';
import '../utils/snack_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  var isLoader = false;

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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("No screen to back"),
                      backgroundColor: AppColors.red,
                    ),
                  );
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
                    validator: (value) =>
                    value == null || value.trim().isEmpty ? "Username is required" : null,
                  ),
                  SizedBox(height: 16.h),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(color: AppColors.black87, fontSize: 16.sp),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration("Password", Icons.password),
                    validator: (value) =>
                    value == null || value.length < 6
                        ? "Password must be at least 6 characters"
                        : null,
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

            SizedBox(height: 20.h),

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


