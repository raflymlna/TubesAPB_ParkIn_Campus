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

  @override
  String get registerVehicleFirst => 'Please register a vehicle first';

  @override
  String get carOnlyArea => 'This parking area is for cars only';

  @override
  String get motorcycleOnlyArea => 'This parking area is for motorcycles only';

  @override
  String get vehicleRegistration => 'Vehicle Registration';

  @override
  String get addNewVehicle => 'Add New Vehicle';

  @override
  String get editVehicle => 'Edit Vehicle';

  @override
  String get car => 'Car';

  @override
  String get motorcycle => 'Motorcycle';

  @override
  String get vehicleBrand => 'Vehicle Brand';

  @override
  String get vehicleModel => 'Vehicle Model';

  @override
  String get vehicleBrandRequired => 'Vehicle brand is required';

  @override
  String get vehicleModelRequired => 'Vehicle model is required';

  @override
  String get vehicleRequired => 'Vehicle plate number is required';

  @override
  String get invalidPlateFormat => 'Invalid plate format. Example: B 1234 AMN';

  @override
  String get saving => 'Saving...';

  @override
  String get addVehicle => 'Add Vehicle';

  @override
  String get update => 'Update';

  @override
  String get registeredVehicles => 'Registered Vehicles';

  @override
  String get noRegisteredVehicle => 'No registered vehicles';

  @override
  String get vehicleAdded => 'Vehicle added successfully';

  @override
  String get vehicleUpdated => 'Vehicle updated successfully';

  @override
  String get vehicleDeleted => 'Vehicle deleted successfully';

  @override
  String get deleteVehicle => 'Delete Vehicle';

  @override
  String deleteVehicleConfirm(Object plate) {
    return 'Are you sure you want to delete $plate?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get viewProfile => 'View Profile';

  @override
  String get manageVehicle => 'Manage Vehicle';

  @override
  String get save => 'Save';

  @override
  String get profileDetail => 'Profile Detail';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get vehicles => 'Vehicles';

  @override
  String get noVehicle => 'No vehicle registered';

  @override
  String get language => 'Language';

  @override
  String get easyToRegister => 'Easy to register';

  @override
  String get easyToUse => 'Easy to use';

  @override
  String get smartSlotFinder => 'Smart Slot Finder';

  @override
  String errorMessage(Object error) {
    return 'Error: $error';
  }

  @override
  String get parkingDatabaseGenerated =>
      'Parking database regenerated successfully.';

  @override
  String get vehicleFound => 'Vehicle Found';

  @override
  String get currentlyParked => 'Currently Parked';

  @override
  String get slot => 'Slot';

  @override
  String get parkedSince => 'Parked Since';

  @override
  String get parkingMap => 'Parking Map';

  @override
  String get navigationActive => 'Navigation Active';

  @override
  String get navigateToSlot => 'Navigate To Slot';

  @override
  String get navigationRoute => 'Navigation Route';

  @override
  String get directions => 'Directions';

  @override
  String get direction1 => '1. Walk straight for 20 meters';

  @override
  String get direction2 => '2. Turn right to Row A';

  @override
  String get direction3 => '3. Your vehicle is located at Slot A-27';

  @override
  String get parkingAvailability => 'Parking Availability';

  @override
  String get noParkingData => 'No parking slot data available.';

  @override
  String get vehicle => 'Vehicle';

  @override
  String get parkInCampusSimple => 'ParkInCampus is simple to use';

  @override
  String get easyToRegisterDesc =>
      'Unlock added benefits when you register on our app. Registering is simple and straightforward. It takes less than 30 seconds.';

  @override
  String get easyToUseDesc =>
      'Get access to parking spots instantly with our seamless interface. No complicated forms or long queues—just open the app, find your spot, and start your journey within seconds.';

  @override
  String get smartSlotFinderDesc =>
      'No more circling around the block. View live parking occupancy through our app and navigate directly to an empty slot, ensuring a stress-free parking experience.';

  @override
  String get weAre => 'We\'re ';

  @override
  String get everywhere => 'everywhere';

  @override
  String get youNeedUs => ' you need us to be';

  @override
  String get home => 'Home';

  @override
  String get qr => 'QR';

  @override
  String get selectVehicle => 'Select Vehicle';

  @override
  String get journeyDescription =>
      'Work. Gym. Class. Hang Out. ParkInCampus is with you on your journey each day. We are available in over 1,000 parking slots at Telkom University. You can choose us to simplify your journey.';

  @override
  String alreadyParkedAt(Object location) {
    return 'You are currently parked at $location';
  }

  @override
  String parkingFull(Object building, Object vehicleType) {
    return '$vehicleType parking at $building is full!';
  }

  @override
  String get ourLocations => 'Our Locations';

  @override
  String helloUser(Object name) {
    return 'Hello, $name';
  }
}
