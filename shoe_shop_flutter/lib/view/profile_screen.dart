import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shoe_shop_flutter/data/viewModel/cart_view_model.dart';
import 'package:shoe_shop_flutter/view/login_screen.dart';
import '../components/profile_info.dart';
import '../constants/app_colors.dart';
import '../data/model/user_model.dart';
import '../data/viewModel/auth_view_model.dart';
import '../data/viewModel/favorite_view_model.dart';
import '../data/viewModel/user_view_model.dart';
import '../routes/app_routes.dart';
import '../utils/dialog_logout.dart';
import '../utils/snack_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isProfileExpanded = false;
  String? _newProfileImagePath;
  final TextEditingController _usernameController = TextEditingController();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userViewModel = context.read<UserViewModel>();
      await userViewModel.getUser();
      final user = userViewModel.user;
      if (user != null) {
        setState(() {
          _currentUser = user;
          _usernameController.text = user.username;
        });
      }
    });
  }

  void _onUpdateUser() async {
    if (_currentUser == null) return;

    final updatedUsername = _usernameController.text.trim();
    final updatedImage = _newProfileImagePath ?? _currentUser!.profileImage;

    final userViewModel = context.read<UserViewModel>();

    final success = await userViewModel.updateUser(updatedUsername, updatedImage);

    if (!mounted) return;

    if (success) {
      SnackBarUtil.showSnackBar(context, 'Update successful', AppColors.green);
      Navigator.pushReplacementNamed(context, AppRoutes.main);
    } else {
      SnackBarUtil.showSnackBar(context, 'Update failed', AppColors.red);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      if (!mounted) return;
      final userViewModel = context.read<UserViewModel>();
      final uploadedUrl = await userViewModel.uploadProfileImage(imageFile);
      if (uploadedUrl != null) {
        if (!mounted) return;
        setState(() {
          _newProfileImagePath = uploadedUrl;
        });
      } else {
        print("Upload failed.");
      }
    } else {
      print('No photos selected.');
    }
  }

  void _handleLogout(BuildContext context) async {
    final shouldLogout = await DialogLogout.showLogoutConfirmationDialog(context);
    if (!context.mounted) return;

    if (shouldLogout) {
      final authViewModel = context.read<AuthViewModel>();
      final favoriteViewModel = context.read<FavoriteViewModel>();
      final cartViewModel = context.read<CartViewModel>();

      await authViewModel.logout();
      if (!context.mounted) return;

      favoriteViewModel.clearFavorites();
      cartViewModel.clearCart();

      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authProvider, child) {
        if (!authProvider.isLoggedIn) {
          return const LoginScreen();
        }

        final userProvider = context.watch<UserViewModel>();
        final user = userProvider.user;

        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Profile",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.sp,
                            color: AppColors.black,
                          ),
                        ),
                        Icon(
                          Icons.notifications_outlined,
                          size: 35.sp,
                          color: AppColors.black,
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isProfileExpanded = !_isProfileExpanded;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 45.r,
                                backgroundColor: AppColors.black54,
                                backgroundImage: _newProfileImagePath != null
                                    ? NetworkImage(_newProfileImagePath!)
                                    : (user?.profileImage.trim().isNotEmpty == true)
                                    ? NetworkImage(user!.profileImage)
                                    : const AssetImage("asset/images/default_avatar.png") as ImageProvider,
                              ),
                              SizedBox(width: 20.w),
                              Text.rich(
                                TextSpan(
                                  text: "${user?.username ?? "Guest"}\n",
                                  style: TextStyle(fontSize: 20.sp, color: AppColors.black),
                                  children: [
                                    TextSpan(
                                      text: "Show profile",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                _isProfileExpanded ? Icons.expand_less : Icons.arrow_forward_ios,
                                size: 20.sp,
                                color: AppColors.black,
                              ),
                            ],
                          ),

                          if (_isProfileExpanded)
                            Container(
                              margin: EdgeInsets.only(top: 10.h),
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: AppColors.grey100,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadow,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8.h),
                                  ElevatedButton.icon(
                                    onPressed: _pickImage,
                                    icon: const Icon(Icons.upload),
                                    label: const Text("Upload New Avatar"),
                                  ),
                                  SizedBox(height: 15.h),
                                  TextField(
                                    controller: _usernameController,
                                    decoration: const InputDecoration(
                                      labelText: "Username",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                      ),
                                      onPressed: _onUpdateUser,
                                      child: Text(
                                        "Update",
                                        style: TextStyle(color: AppColors.white, fontSize: 16.sp),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Divider(color: AppColors.shadow),
                    SizedBox(height: 10.h),
                    Card(
                      elevation: 4,
                      color: AppColors.white,
                      child: Padding(
                        padding: EdgeInsets.only(left: 25.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text: "Airbnb your place\n\n",
                                  style: TextStyle(
                                    height: 1.0,
                                    fontSize: 18.sp,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "It's simple to get set up and \nstart earning.\n",
                                      style: TextStyle(
                                        height: 1.0,
                                        fontSize: 14.sp,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Image.network(
                              "https://khungtranhre.com/wp-content/uploads/2020/08/khung-anh-png-127-1024x630.jpg",
                              height: 140.h,
                              width: 135.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Divider(color: AppColors.shadow),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/change-password');
                      },
                      child: const ProfileInfo(
                        icon: Icons.security,
                        name: "Change Password",
                      ),
                    ),
                    const ProfileInfo(
                      icon: Icons.notifications_outlined,
                      name: "Notifications",
                    ),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: GestureDetector(
                        onTap: () => _handleLogout(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.logout, color: AppColors.black, size: 28.sp), // OK
                            SizedBox(width: 18.w),
                            Text(
                              "Log out",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 18.sp, // OK
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Divider(color: AppColors.shadow),
                    SizedBox(height: 20.h),
                    Text(
                      "Version 24.34 (28004615)",
                      style: TextStyle(fontSize: 10.sp, color: AppColors.grey),
                    ),
                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
