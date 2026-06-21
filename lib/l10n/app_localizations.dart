import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @vehicleInformation.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Information'**
  String get vehicleInformation;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'Parking History'**
  String get history;

  /// No description provided for @scanQR.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scanQR;

  /// No description provided for @findMyRide.
  ///
  /// In en, this message translates to:
  /// **'Find My Ride'**
  String get findMyRide;

  /// No description provided for @registerVehicle.
  ///
  /// In en, this message translates to:
  /// **'Register Vehicle'**
  String get registerVehicle;

  /// No description provided for @licensePlate.
  ///
  /// In en, this message translates to:
  /// **'License Plate'**
  String get licensePlate;

  /// No description provided for @vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleType;

  /// No description provided for @brandModel.
  ///
  /// In en, this message translates to:
  /// **'Brand & Model'**
  String get brandModel;

  /// No description provided for @scanQrParking.
  ///
  /// In en, this message translates to:
  /// **'Scan Parking QR'**
  String get scanQrParking;

  /// No description provided for @invalidQr.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR!'**
  String get invalidQr;

  /// No description provided for @invalidQrFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR format!'**
  String get invalidQrFormat;

  /// No description provided for @unknownQr.
  ///
  /// In en, this message translates to:
  /// **'QR not recognized'**
  String get unknownQr;

  /// No description provided for @parkInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully parked at {building}'**
  String parkInSuccess(Object building);

  /// No description provided for @parkOutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully exited parking at {building}'**
  String parkOutSuccess(Object building);

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @scanInstruction.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Park In / Park Out'**
  String get scanInstruction;

  /// No description provided for @activeParking.
  ///
  /// In en, this message translates to:
  /// **'You still have an active parking session'**
  String get activeParking;

  /// No description provided for @notParked.
  ///
  /// In en, this message translates to:
  /// **'You are not currently parked'**
  String get notParked;

  /// No description provided for @wrongLocation.
  ///
  /// In en, this message translates to:
  /// **'You are parked at {location}'**
  String wrongLocation(Object location);

  /// No description provided for @parkingHistory.
  ///
  /// In en, this message translates to:
  /// **'Parking History'**
  String get parkingHistory;

  /// No description provided for @yourParkingActivity.
  ///
  /// In en, this message translates to:
  /// **'Your Parking Activity'**
  String get yourParkingActivity;

  /// No description provided for @noParkingHistory.
  ///
  /// In en, this message translates to:
  /// **'No parking history yet'**
  String get noParkingHistory;

  /// No description provided for @parkingDetail.
  ///
  /// In en, this message translates to:
  /// **'Parking Detail'**
  String get parkingDetail;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @parkIn.
  ///
  /// In en, this message translates to:
  /// **'Park In'**
  String get parkIn;

  /// No description provided for @parkOut.
  ///
  /// In en, this message translates to:
  /// **'Park Out'**
  String get parkOut;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @parking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get parking;

  /// No description provided for @out.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get out;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get emailRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get passwordRequired;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registerSuccess;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Login to access the parking system'**
  String get loginSubtitle;

  /// No description provided for @pleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Please login to continue.'**
  String get pleaseLogin;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get emailInvalid;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @phoneMinLength.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be at least 10 digits'**
  String get phoneMinLength;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordNotMatch;

  /// No description provided for @resetPasswordSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link has been sent to your email'**
  String get resetPasswordSent;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @registrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please make sure all information is correct.'**
  String get registrationSubtitle;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful'**
  String get registrationSuccess;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidCredentials;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'Account not found'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get wrongPassword;

  /// No description provided for @emailAlreadyUsed.
  ///
  /// In en, this message translates to:
  /// **'Email is already registered'**
  String get emailAlreadyUsed;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get weakPassword;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unknownError;

  /// No description provided for @registerVehicleFirst.
  ///
  /// In en, this message translates to:
  /// **'Please register a vehicle first'**
  String get registerVehicleFirst;

  /// No description provided for @carOnlyArea.
  ///
  /// In en, this message translates to:
  /// **'This parking area is for cars only'**
  String get carOnlyArea;

  /// No description provided for @motorcycleOnlyArea.
  ///
  /// In en, this message translates to:
  /// **'This parking area is for motorcycles only'**
  String get motorcycleOnlyArea;

  /// No description provided for @vehicleRegistration.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Registration'**
  String get vehicleRegistration;

  /// No description provided for @addNewVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add New Vehicle'**
  String get addNewVehicle;

  /// No description provided for @editVehicle.
  ///
  /// In en, this message translates to:
  /// **'Edit Vehicle'**
  String get editVehicle;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @motorcycle.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get motorcycle;

  /// No description provided for @vehicleBrand.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Brand'**
  String get vehicleBrand;

  /// No description provided for @vehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Model'**
  String get vehicleModel;

  /// No description provided for @vehicleBrandRequired.
  ///
  /// In en, this message translates to:
  /// **'Vehicle brand is required'**
  String get vehicleBrandRequired;

  /// No description provided for @vehicleModelRequired.
  ///
  /// In en, this message translates to:
  /// **'Vehicle model is required'**
  String get vehicleModelRequired;

  /// No description provided for @vehicleRequired.
  ///
  /// In en, this message translates to:
  /// **'Vehicle plate number is required'**
  String get vehicleRequired;

  /// No description provided for @invalidPlateFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid plate format. Example: B 1234 AMN'**
  String get invalidPlateFormat;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @addVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get addVehicle;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @registeredVehicles.
  ///
  /// In en, this message translates to:
  /// **'Registered Vehicles'**
  String get registeredVehicles;

  /// No description provided for @noRegisteredVehicle.
  ///
  /// In en, this message translates to:
  /// **'No registered vehicles'**
  String get noRegisteredVehicle;

  /// No description provided for @vehicleAdded.
  ///
  /// In en, this message translates to:
  /// **'Vehicle added successfully'**
  String get vehicleAdded;

  /// No description provided for @vehicleUpdated.
  ///
  /// In en, this message translates to:
  /// **'Vehicle updated successfully'**
  String get vehicleUpdated;

  /// No description provided for @vehicleDeleted.
  ///
  /// In en, this message translates to:
  /// **'Vehicle deleted successfully'**
  String get vehicleDeleted;

  /// No description provided for @deleteVehicle.
  ///
  /// In en, this message translates to:
  /// **'Delete Vehicle'**
  String get deleteVehicle;

  /// No description provided for @deleteVehicleConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {plate}?'**
  String deleteVehicleConfirm(Object plate);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @manageVehicle.
  ///
  /// In en, this message translates to:
  /// **'Manage Vehicle'**
  String get manageVehicle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @profileDetail.
  ///
  /// In en, this message translates to:
  /// **'Profile Detail'**
  String get profileDetail;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @vehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehicles;

  /// No description provided for @noVehicle.
  ///
  /// In en, this message translates to:
  /// **'No vehicle registered'**
  String get noVehicle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @easyToRegister.
  ///
  /// In en, this message translates to:
  /// **'Easy to register'**
  String get easyToRegister;

  /// No description provided for @easyToUse.
  ///
  /// In en, this message translates to:
  /// **'Easy to use'**
  String get easyToUse;

  /// No description provided for @smartSlotFinder.
  ///
  /// In en, this message translates to:
  /// **'Smart Slot Finder'**
  String get smartSlotFinder;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorMessage(Object error);

  /// No description provided for @parkingDatabaseGenerated.
  ///
  /// In en, this message translates to:
  /// **'Parking database regenerated successfully.'**
  String get parkingDatabaseGenerated;

  /// No description provided for @vehicleFound.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Found'**
  String get vehicleFound;

  /// No description provided for @currentlyParked.
  ///
  /// In en, this message translates to:
  /// **'Currently Parked'**
  String get currentlyParked;

  /// No description provided for @slot.
  ///
  /// In en, this message translates to:
  /// **'Slot'**
  String get slot;

  /// No description provided for @parkedSince.
  ///
  /// In en, this message translates to:
  /// **'Parked Since'**
  String get parkedSince;

  /// No description provided for @parkingMap.
  ///
  /// In en, this message translates to:
  /// **'Parking Map'**
  String get parkingMap;

  /// No description provided for @navigationActive.
  ///
  /// In en, this message translates to:
  /// **'Navigation Active'**
  String get navigationActive;

  /// No description provided for @navigateToSlot.
  ///
  /// In en, this message translates to:
  /// **'Navigate To Slot'**
  String get navigateToSlot;

  /// No description provided for @navigationRoute.
  ///
  /// In en, this message translates to:
  /// **'Navigation Route'**
  String get navigationRoute;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @direction1.
  ///
  /// In en, this message translates to:
  /// **'1. Walk straight for 20 meters'**
  String get direction1;

  /// No description provided for @direction2.
  ///
  /// In en, this message translates to:
  /// **'2. Turn right to Row A'**
  String get direction2;

  /// No description provided for @direction3.
  ///
  /// In en, this message translates to:
  /// **'3. Your vehicle is located at Slot A-27'**
  String get direction3;

  /// No description provided for @parkingAvailability.
  ///
  /// In en, this message translates to:
  /// **'Parking Availability'**
  String get parkingAvailability;

  /// No description provided for @noParkingData.
  ///
  /// In en, this message translates to:
  /// **'No parking slot data available.'**
  String get noParkingData;

  /// No description provided for @vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// No description provided for @parkInCampusSimple.
  ///
  /// In en, this message translates to:
  /// **'ParkInCampus is simple to use'**
  String get parkInCampusSimple;

  /// No description provided for @easyToRegisterDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlock added benefits when you register on our app. Registering is simple and straightforward. It takes less than 30 seconds.'**
  String get easyToRegisterDesc;

  /// No description provided for @easyToUseDesc.
  ///
  /// In en, this message translates to:
  /// **'Get access to parking spots instantly with our seamless interface. No complicated forms or long queues—just open the app, find your spot, and start your journey within seconds.'**
  String get easyToUseDesc;

  /// No description provided for @smartSlotFinderDesc.
  ///
  /// In en, this message translates to:
  /// **'No more circling around the block. View live parking occupancy through our app and navigate directly to an empty slot, ensuring a stress-free parking experience.'**
  String get smartSlotFinderDesc;

  /// No description provided for @weAre.
  ///
  /// In en, this message translates to:
  /// **'We\'re '**
  String get weAre;

  /// No description provided for @everywhere.
  ///
  /// In en, this message translates to:
  /// **'everywhere'**
  String get everywhere;

  /// No description provided for @youNeedUs.
  ///
  /// In en, this message translates to:
  /// **' you need us to be'**
  String get youNeedUs;

  /// No description provided for @journeyDescription.
  ///
  /// In en, this message translates to:
  /// **'Work. Gym. Class. Hang Out. ParkInCampus is with you on your journey each day. We are available in over 1,000 parking slots at Telkom University. You can choose us to simplify your journey.'**
  String get journeyDescription;

  /// No description provided for @alreadyParkedAt.
  ///
  /// In en, this message translates to:
  /// **'You are currently parked at {location}'**
  String alreadyParkedAt(Object location);

  /// No description provided for @parkingFull.
  ///
  /// In en, this message translates to:
  /// **'{vehicleType} parking at {building} is full!'**
  String parkingFull(Object building, Object vehicleType);

  /// No description provided for @ourLocations.
  ///
  /// In en, this message translates to:
  /// **'Our Locations'**
  String get ourLocations;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String helloUser(Object name);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
