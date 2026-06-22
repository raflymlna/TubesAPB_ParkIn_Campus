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
  String get invalidCredentials => 'Email atau password salah';

  @override
  String get userNotFound => 'Akun tidak ditemukan';

  @override
  String get wrongPassword => 'Password salah';

  @override
  String get emailAlreadyUsed => 'Email sudah terdaftar';

  @override
  String get weakPassword => 'Password terlalu lemah';

  @override
  String get unknownError => 'Terjadi kesalahan';

  @override
  String get registerVehicleFirst =>
      'Silakan registrasikan kendaraan terlebih dahulu';

  @override
  String get carOnlyArea => 'Area parkir ini hanya untuk mobil';

  @override
  String get motorcycleOnlyArea => 'Area parkir ini hanya untuk motor';

  @override
  String get vehicleRegistration => 'Registrasi Kendaraan';

  @override
  String get addNewVehicle => 'Tambah Kendaraan Baru';

  @override
  String get editVehicle => 'Edit Kendaraan';

  @override
  String get car => 'Mobil';

  @override
  String get motorcycle => 'Motor';

  @override
  String get vehicleBrand => 'Merk Kendaraan';

  @override
  String get vehicleModel => 'Model Kendaraan';

  @override
  String get vehicleBrandRequired => 'Merk kendaraan wajib diisi';

  @override
  String get vehicleModelRequired => 'Model kendaraan wajib diisi';

  @override
  String get vehicleRequired => 'Nomor kendaraan wajib diisi';

  @override
  String get invalidPlateFormat =>
      'Format plat tidak valid. Contoh: B 1234 AMN';

  @override
  String get saving => 'Menyimpan...';

  @override
  String get addVehicle => 'Tambah Kendaraan';

  @override
  String get update => 'Perbarui';

  @override
  String get registeredVehicles => 'Kendaraan Terdaftar';

  @override
  String get noRegisteredVehicle => 'Belum ada kendaraan terdaftar';

  @override
  String get vehicleAdded => 'Kendaraan berhasil ditambahkan';

  @override
  String get vehicleUpdated => 'Kendaraan berhasil diubah';

  @override
  String get vehicleDeleted => 'Kendaraan berhasil dihapus';

  @override
  String get deleteVehicle => 'Hapus Kendaraan';

  @override
  String deleteVehicleConfirm(Object plate) {
    return 'Yakin hapus $plate?';
  }

  @override
  String get delete => 'Hapus';

  @override
  String get edit => 'Ubah';

  @override
  String get viewProfile => 'Lihat Profil';

  @override
  String get manageVehicle => 'Kelola Kendaraan';

  @override
  String get save => 'Simpan';

  @override
  String get profileDetail => 'Detail Profil';

  @override
  String get editProfile => 'Ubah Profil';

  @override
  String get nameRequired => 'Nama wajib diisi';

  @override
  String get profileUpdated => 'Profil berhasil diperbarui';

  @override
  String get vehicles => 'Kendaraan';

  @override
  String get noVehicle => 'Belum ada kendaraan terdaftar';

  @override
  String get language => 'Bahasa';

  @override
  String get easyToRegister => 'Mudah untuk Mendaftar';

  @override
  String get easyToUse => 'Mudah Digunakan';

  @override
  String get smartSlotFinder => 'Pencari Slot Pintar';

  @override
  String errorMessage(Object error) {
    return 'Terjadi kesalahan: $error';
  }

  @override
  String get parkingDatabaseGenerated =>
      'Database parkir berhasil dibuat ulang.';

  @override
  String get vehicleFound => 'Kendaraan Ditemukan';

  @override
  String get currentlyParked => 'Sedang Terparkir';

  @override
  String get slot => 'Slot';

  @override
  String get parkedSince => 'Parkir Sejak';

  @override
  String get parkingMap => 'Peta Parkir';

  @override
  String get navigationActive => 'Navigasi Aktif';

  @override
  String get navigateToSlot => 'Navigasi ke Slot';

  @override
  String get navigationRoute => 'Rute Navigasi';

  @override
  String get directions => 'Petunjuk Arah';

  @override
  String get direction1 => '1. Jalan lurus sejauh 20 meter';

  @override
  String get direction2 => '2. Belok kanan ke Baris A';

  @override
  String get direction3 => '3. Kendaraan Anda berada di Slot A-27';

  @override
  String get parkingAvailability => 'Ketersediaan Parkir';

  @override
  String get noParkingData => 'Belum ada data slot parkir di Firebase.';

  @override
  String get vehicle => 'Kendaraan';

  @override
  String get parkInCampusSimple => 'ParkInCampus Mudah Digunakan';

  @override
  String get easyToRegisterDesc =>
      'Dapatkan berbagai manfaat tambahan setelah mendaftar di aplikasi kami. Proses pendaftaran sederhana dan hanya membutuhkan waktu kurang dari 30 detik.';

  @override
  String get easyToUseDesc =>
      'Dapatkan akses ke tempat parkir secara instan melalui antarmuka yang mudah digunakan. Tidak perlu proses yang rumit, cukup buka aplikasi, temukan slot parkir, dan mulai perjalanan Anda.';

  @override
  String get smartSlotFinderDesc =>
      'Tidak perlu lagi berkeliling mencari tempat parkir. Lihat ketersediaan parkir secara langsung melalui aplikasi dan navigasikan kendaraan Anda ke slot kosong terdekat.';

  @override
  String get weAre => 'Kami hadir ';

  @override
  String get everywhere => 'di mana saja';

  @override
  String get youNeedUs => ' yang Anda butuhkan';

  @override
  String get home => 'Beranda';

  @override
  String get qr => 'QR';

  @override
  String get selectVehicle => 'Pilih Kendaraan';

  @override
  String get journeyDescription =>
      'Kerja. Gym. Kuliah. ParkInCampus menemani perjalanan Anda setiap hari. Tersedia lebih dari 1.000 slot parkir di Telkom University untuk membantu perjalanan Anda menjadi lebih mudah.';

  @override
  String alreadyParkedAt(Object location) {
    return 'Anda sedang parkir di $location';
  }

  @override
  String parkingFull(Object building, Object vehicleType) {
    return 'Parkiran $vehicleType di $building penuh!';
  }

  @override
  String get ourLocations => 'Lokasi Kami';

  @override
  String helloUser(Object name) {
    return 'Halo, $name';
  }
}
