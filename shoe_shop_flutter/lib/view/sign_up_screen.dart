import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../data/viewModel/auth_view_model.dart';
import '../routes/app_routes.dart';
import '../utils/snack_bar.dart';
import '../utils/validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var isLoader = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      try {
        final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
        final isSuccess = await authViewModel.register(
          _usernameController.text,
          _passwordController.text,
        );

        if (isSuccess) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
          SnackBarUtil.showSnackBar(context, 'Create new account successfully!', AppColors.green);
        } else {
          SnackBarUtil.showSnackBar(context, 'Create new account failed!', AppColors.red);
        }
      } catch (e) {
        SnackBarUtil.showSnackBar(context, 'Error: $e',  AppColors.red);
      } finally {
        if (mounted) {
          setState(() {
            isLoader = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.w),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            SizedBox(height: 40.h),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("No screen to back"),
                        backgroundColor: AppColors.red,
                      ),
                    );
                  }
                },
                icon: Icon(Icons.arrow_back, color: AppColors.black54, size: 24.sp),
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Lottie.asset(
                'asset/lottie/register.json',
                width: 250.w,
                height: 250.h,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 50.h),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _usernameController,
                    style: TextStyle(color: AppColors.black87, fontSize: 16.sp),
                    keyboardType: TextInputType.name,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration("Username", Icons.verified_user),
                    validator: AppValidator.validateUser,
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _passwordController,
                    style: TextStyle(color: AppColors.black87, fontSize: 16.sp),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration("Password", Icons.password),
                    validator: AppValidator.validatePassword,
                    obscureText: true,
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _confirmPasswordController,
                    style: TextStyle(color: AppColors.black87, fontSize: 16.sp),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration("Re-enter password", Icons.password),
                    validator: (value) => AppValidator.validateConfirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    obscureText: true,
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
                          ? const Center(child: CircularProgressIndicator(color: AppColors.white))
                          : Text(
                        "Sign Up",
                        style: TextStyle(color: AppColors.white, fontSize: 25.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.login);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: AppColors.teal,
                          fontSize: 22.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon) {
    return InputDecoration(
      fillColor: AppColors.grey100,
      filled: true,
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.grey),
      floatingLabelStyle: const TextStyle(color: AppColors.black87),
      suffixIcon: Icon(suffixIcon, color: AppColors.grey),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.grey),
        borderRadius: BorderRadius.circular(10.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.black87),
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}

