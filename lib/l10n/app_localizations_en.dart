// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get profile => 'Profile';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get vehicleInformation => 'Vehicle Information';

  @override
  String get history => 'Parking History';

  @override
  String get scanQR => 'Scan QR';

  @override
  String get findMyRide => 'Find My Ride';

  @override
  String get registerVehicle => 'Register Vehicle';

  @override
  String get licensePlate => 'License Plate';

  @override
  String get vehicleType => 'Vehicle Type';

  @override
  String get brandModel => 'Brand & Model';

  @override
  String get scanQrParking => 'Scan Parking QR';

  @override
  String get invalidQr => 'Invalid QR!';

  @override
  String get invalidQrFormat => 'Invalid QR format!';

  @override
  String get unknownQr => 'QR not recognized';

  @override
  String parkInSuccess(Object building) {
    return 'Successfully parked at $building';
  }

  @override
  String parkOutSuccess(Object building) {
    return 'Successfully exited parking at $building';
  }

  @override
  String get info => 'Information';

  @override
  String get ok => 'OK';

  @override
  String get scanInstruction => 'Scan QR Park In / Park Out';

  @override
  String get activeParking => 'You still have an active parking session';

  @override
  String get notParked => 'You are not currently parked';

  @override
  String wrongLocation(Object location) {
    return 'You are parked at $location';
  }

  @override
  String get parkingHistory => 'Parking History';

  @override
  String get yourParkingActivity => 'Your Parking Activity';

  @override
  String get noParkingHistory => 'No parking history yet';

  @override
  String get parkingDetail => 'Parking Detail';

  @override
  String get location => 'Location';

  @override
  String get parkIn => 'Park In';

  @override
  String get parkOut => 'Park Out';

  @override
  String get close => 'Close';

  @override
  String get parking => 'Parking';

  @override
  String get out => 'Out';

  @override
  String get now => 'Now';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get createAccount => 'Create Account';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get emailRequired => 'Email cannot be empty';

  @override
  String get passwordRequired => 'Password cannot be empty';

  @override
  String get loginSuccess => 'Login successful';

  @override
  String get registerSuccess => 'Registration successful';

  @override
  String get welcome => 'Welcome';

  @override
  String get loginSubtitle => 'Login to access the parking system';

  @override
  String get pleaseLogin => 'Please login to continue.';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get enterEmail => 'Enter email';

  @override
  String get cancel => 'Cancel';

  @override
  String get send => 'Send';

  @override
  String get emailInvalid => 'Invalid email format';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get fullNameRequired => 'Full name is required';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneMinLength => 'Phone number must be at least 10 digits';

  @override
  String get confirmPasswordRequired => 'Confirm password is required';

  @override
  String get passwordNotMatch => 'Passwords do not match';

  @override
  String get resetPasswordSent =>
      'Password reset link has been sent to your email';

  @override
  String get createNewAccount => 'Create New Account';

  @override
  String get registration => 'Registration';

  @override
  String get registrationSubtitle =>
      'Please make sure all information is correct.';

  @override
  String get registrationSuccess => 'Registration Successful';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get userNotFound => 'Account not found';

  @override
  String get wrongPassword => 'Incorrect password';

  @override
  String get emailAlreadyUsed => 'Email is already registered';

  @override
  String get weakPassword => 'Password is too weak';

  @override
  String get unknownError => 'An unexpected error occurred';
}
