class Validators {
  // Функція для перевірки валідності електронної пошти
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    const String emailPattern = r'^[^@]+@[^@]+\.[^@]+$';
    final RegExp regex = RegExp(emailPattern);

    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Функція для перевірки валідності імені
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  // Функція для перевірки валідності прізвища
  static String? validateSurName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your surname';
    }
    return null;
  }
}
