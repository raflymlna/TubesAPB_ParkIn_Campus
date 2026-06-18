// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get profile => 'Profil';

  @override
  String get logout => 'Keluar';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Nomor Telepon';

  @override
  String get vehicleInformation => 'Informasi Kendaraan';

  @override
  String get history => 'Riwayat Parkir';

  @override
  String get scanQR => 'Scan QR';

  @override
  String get findMyRide => 'Cari Kendaraan';

  @override
  String get registerVehicle => 'Registrasi Kendaraan';

  @override
  String get licensePlate => 'Plat Nomor';

  @override
  String get vehicleType => 'Jenis Kendaraan';

  @override
  String get brandModel => 'Merek & Model';

  @override
  String get scanQrParking => 'Scan QR Parkir';

  @override
  String get invalidQr => 'QR tidak valid!';

  @override
  String get invalidQrFormat => 'Format QR salah!';

  @override
  String get unknownQr => 'QR tidak dikenali';

  @override
  String parkInSuccess(Object building) {
    return 'Berhasil masuk parkir di $building';
  }

  @override
  String parkOutSuccess(Object building) {
    return 'Berhasil keluar parkir di $building';
  }

  @override
  String get info => 'Informasi';

  @override
  String get ok => 'OK';

  @override
  String get scanInstruction => 'Scan QR Park In / Park Out';

  @override
  String get activeParking => 'Masih ada parkir aktif';

  @override
  String get notParked => 'Anda belum parkir';

  @override
  String wrongLocation(Object location) {
    return 'Anda sedang parkir di $location';
  }

  @override
  String get parkingHistory => 'Riwayat Parkir';

  @override
  String get yourParkingActivity => 'Aktivitas Parkir Anda';

  @override
  String get noParkingHistory => 'Belum ada riwayat parkir';

  @override
  String get parkingDetail => 'Detail Parkir';

  @override
  String get location => 'Lokasi';

  @override
  String get parkIn => 'Jam Masuk';

  @override
  String get parkOut => 'Jam Keluar';

  @override
  String get close => 'Tutup';

  @override
  String get parking => 'Parkir';

  @override
  String get out => 'Keluar';

  @override
  String get now => 'Sekarang';

  @override
  String get password => 'Kata Sandi';

  @override
  String get confirmPassword => 'Konfirmasi Kata Sandi';

  @override
  String get fullName => 'Nama Lengkap';

  @override
  String get forgotPassword => 'Lupa Password?';

  @override
  String get dontHaveAccount => 'Belum punya akun?';

  @override
  String get alreadyHaveAccount => 'Sudah punya akun? Login';

  @override
  String get createAccount => 'Buat Akun';

  @override
  String get signIn => 'Masuk';

  @override
  String get signUp => 'Daftar';

  @override
  String get emailRequired => 'Email tidak boleh kosong';

  @override
  String get passwordRequired => 'Password tidak boleh kosong';

  @override
  String get loginSuccess => 'Berhasil masuk';

  @override
  String get registerSuccess => 'Registrasi berhasil';

  @override
  String get welcome => 'Selamat Datang';

  @override
  String get loginSubtitle => 'Login untuk masuk ke sistem parkir';

  @override
  String get pleaseLogin => 'Silakan login untuk melanjutkan.';

  @override
  String get login => 'Masuk';

  @override
  String get register => 'Daftar';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get enterEmail => 'Masukkan email';

  @override
  String get cancel => 'Batal';

  @override
  String get send => 'Kirim';

  @override
  String get emailInvalid => 'Format email tidak valid';

  @override
  String get passwordMinLength => 'Password minimal 6 karakter';

  @override
  String get fullNameRequired => 'Nama lengkap wajib diisi';

  @override
  String get phoneRequired => 'Nomor telepon wajib diisi';

  @override
  String get phoneMinLength => 'Nomor telepon minimal 10 karakter';

  @override
  String get confirmPasswordRequired => 'Konfirmasi password wajib diisi';

  @override
  String get passwordNotMatch => 'Password tidak sama';

  @override
  String get resetPasswordSent => 'Link reset password telah dikirim ke email';

  @override
  String get createNewAccount => 'Buat Akun Baru';

  @override
  String get registration => 'Registrasi';

  @override
  String get registrationSubtitle => 'Pastikan data yang dimasukkan benar.';

  @override
  String get registrationSuccess => 'Registrasi Berhasil';

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
