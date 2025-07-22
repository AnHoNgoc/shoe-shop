import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/viewModel/user_view_model.dart';
import '../routes/app_routes.dart';
import '../utils/snack_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/validator.dart';
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var isLoader = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoader = true);

      try {
        final userViewModel = Provider.of<UserViewModel>(context, listen: false);
        final isSuccess = await userViewModel.changePassword(
          _oldPasswordController.text,
          _newPasswordController.text,
        );

        if (isSuccess) {
          Navigator.pushReplacementNamed(context, AppRoutes.main);
          SnackBarUtil.showSnackBar(context, 'Change password successful', Colors.green);
        } else {
          SnackBarUtil.showSnackBar(context, 'Change password failed!', Colors.red);
        }
      } catch (e) {
        SnackBarUtil.showSnackBar(context, 'Error: $e', Colors.red);
      } finally {
        if (mounted) {
          setState(() => isLoader = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // 👈 giúp tránh tràn khi bàn phím bật
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 👈 để icon nằm trái
              children: [
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerLeft, // 👈 đảm bảo icon nằm trái
                  child: IconButton(
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No screen to back"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black54, size: 24.sp),
                  ),
                ),
                SizedBox(height: 40.h),
                Center(
                  child: Text(
                    "Change Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 80.h),
                TextFormField(
                  controller: _oldPasswordController,
                  style: TextStyle(color: Colors.black87, fontSize: 16.sp),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("Old Password", Icons.lock_outline),
                  validator: AppValidator.validatePassword,
                  obscureText: true,
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _newPasswordController,
                  style: TextStyle(color: Colors.black87, fontSize: 16.sp),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("New Password", Icons.lock),
                  validator: AppValidator.validatePassword,
                  obscureText: true,
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _confirmPasswordController,
                  style: TextStyle(color: Colors.black87, fontSize: 16.sp),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("Confirm New Password", Icons.lock),
                  validator: (value) =>
                      AppValidator.validateConfirmPassword(value, _newPasswordController.text),
                  obscureText: true,
                ),
                SizedBox(height: 40.h),
                SizedBox(
                  height: 50.h,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoader ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 18.sp),
                    ),
                    child: isLoader
                        ? SizedBox(
                      height: 24.h,
                      width: 24.w,
                      child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                        : Text(
                      "Change Password",
                      style: TextStyle(fontSize: 22.sp),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      fillColor: Colors.grey[100],
      filled: true,
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
      floatingLabelStyle: TextStyle(color: Colors.black87, fontSize: 16.sp),
      suffixIcon: Icon(icon, color: Colors.grey, size: 20.sp),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black87),
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}

