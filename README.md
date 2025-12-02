# Smart Tools App

Ringkasan singkat proyek ini.

**Overview**
- **Nama proyek**: `smart_tools_app`
- **Deskripsi**: Aplikasi Flutter yang berisi kumpulan fitur utilitas (tooling) untuk perangkat mobile dan web. Kode sumber utama berada di `lib/` dan konfigurasi platform berada di folder `android/`, `ios/`, `linux/`, `macos/`, dan `web/`.
- **Entry point**: `lib/main.dart`.

**Prerequisites**
- **Flutter SDK**: versi yang kompatibel dengan `pubspec.yaml` (jalankan `flutter --version`).
- **Android**: Android SDK + Android Studio (untuk emulator dan signing). Pastikan `ANDROID_SDK_ROOT`/`ANDROID_HOME` ter-set di `local.properties` atau environment.
- **iOS**: macOS dengan Xcode (hanya bila membuild untuk iOS).
- **Web/Desktop**: Chrome untuk web; toolchain desktop (Linux/Mac/Windows) jika ingin build desktop.

**Persiapan awal (sekali saja)**
1. Clone repo:

   `git clone https://github.com/CevinWays/smart_tools_app.git`
2. Masuk ke folder proyek:

   `cd smart_tools_app`
3. Install dependencies:

   `flutter pub get`
4. (Opsional) Periksa setup environment:

   `flutter doctor`  

**Menjalankan aplikasi (development)**

- Jalankan pada perangkat/emulator Android yang terhubung:

  `flutter run`  

- Menjalankan di device spesifik (list devices terlebih dahulu):

  `flutter devices`
  `flutter run -d <device-id>`

- Menjalankan di web (Chrome):

  `flutter run -d chrome`

**Build release**

- Android APK (release):

  `flutter build apk --release`

- Android App Bundle (untuk Play Store):

  `flutter build appbundle --release`

  Catatan: untuk signing, atur `key.properties` dan `signingConfigs` di `android/app/build.gradle.kts` atau ikuti panduan resmi Flutter untuk signing.

- iOS (hanya di macOS):

  1. Buka workspace Xcode: `open ios/Runner.xcworkspace`
  2. Atur signing di Xcode, lalu jalankan/arsipkan atau jalankan:

     `flutter build ios --release`

- Web (release):

  `flutter build web --release`

- Desktop (Linux/Mac/Windows):

  `flutter build linux`  
  `flutter build macos`  
  `flutter build windows`

**Debug & troubleshooting singkat**
- Jika dependency bermasalah: `flutter pub get` lalu `flutter clean` kemudian `flutter pub get` lagi.
- Jika ada plugin native yang berubah, jalankan `flutter pub get` dan rebuild platform native (contoh: `flutter build apk`).
- Periksa log saat menjalankan: gunakan terminal yang menjalankan `flutter run` atau `adb logcat` untuk log Android.

**Catatan penting**
- File konfigurasi platform ada di `android/` dan `ios/`. Jika membuild di mesin baru, pastikan `local.properties` berisi path SDK yang benar.
- Beberapa plugin memerlukan izin runtime (contoh: kamera, storage). Pastikan permission ditambahkan di manifest/Info.plist sesuai plugin.

--
Jika Anda ingin, saya bisa:
- menambahkan bagian CI/CD (GitHub Actions) untuk otomatis build.
- menulis panduan signing APK/AAB secara lengkap.

Terima kasih! Beritahu saya jika mau ditambahkan detail lain atau terjemahan bahasa Inggris.
# smart_tools_app

A new Flutter project.
