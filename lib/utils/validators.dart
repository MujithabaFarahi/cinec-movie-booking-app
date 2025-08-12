class Validators {
  static String? password(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (!RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$',
    ).hasMatch(password)) {
      return 'Password must be at least 8 characters,\ninclude upper and lower case letters and a number';
    }
    return null;
  }

  static String? email(String? email) {
    if (email == null || email.trim().isEmpty) {
      return "Email is required";
    }
    if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email)) {
      return "Please use a valid email";
    }
    return null;
  }

  static String? mobileNumber(String? number) {
    if (number == null || number.trim().isEmpty) {
      return "Mobile number is required";
    }
    if (!RegExp(r'^\+?[0-9]{10,12}$').hasMatch(number)) {
      return "Please use a valid mobile number";
    }
    return null;
  }

  static String? name(String? name) {
    if (name == null || name.trim().isEmpty) {
      return "Name is required";
    }

    return null;
  }

  static String? yourMessage(String? message) {
    if (message == null || message.trim().isEmpty) {
      return "Your message is required";
    }

    return null;
  }
}
