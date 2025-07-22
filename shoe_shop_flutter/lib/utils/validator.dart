class AppValidator{

  static String? validateUser(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter a username";
    }

    final trimmed = value.trim();

    if (trimmed.length < 6) {
      return "Username must be at least 6 characters";
    }

    if (trimmed.length > 30) {
      return "Username must be at most 30 characters";
    }
    RegExp usernameRegExp = RegExp(
      r'^[a-zA-Z0-9_]+$',
    );
    if (!usernameRegExp.hasMatch(value)) {
      return "Username can only contain letters, numbers, and underscores";
    }
    return null;
  }

  static String? validatePassword(value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter a password";
    }

    final trimmed = value.trim();

    if (trimmed.length < 6) {
      return "Password must be at least 6 characters";
    }

    if (trimmed.length > 30) {
      return "Password must be at most 30 characters";
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String newPassword) {
    if (value == null || value.isEmpty) {
      return "Please confirm your new password";
    }
    if (value.length < 6 || value.length > 30) {
      return "Password must be between 6 and 30 characters";
    }

    if (value != newPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? isEmptyCheck(String? value) {
    if (value == null || value.isEmpty) {
      return "Please fill details";
    }
    return null;
  }

  static String? validateAddressAndPhone(String address, String phone) {
    if (address.trim().isEmpty || phone.trim().isEmpty) {
      return "⚠️ Please fill in both address and phone number.";
    }

    final phoneRegex = RegExp(r'^\+?\d{9,14}$');
    if (!phoneRegex.hasMatch(phone.trim())) {
      return "📞 Invalid phone number format.";
    }

    return null;
  }

}