# SiagaWarga

**SiagaWarga** adalah aplikasi serbaguna yang dirancang untuk membantu dalam situasi darurat dan kebutuhan sehari-hari. Aplikasi ini menggabungkan fitur keselamatan canggih dengan kumpulan alat utilitas yang lengkap.

## Fitur Utama

### 🚨 Keselamatan & Darurat (SOS)
Fitur unggulan untuk kondisi darurat:
- **Tombol Panik (SOS)**: Tombol besar yang mudah diakses di halaman utama.
- **Countdown Timer**: Hitung mundur 3 detik sebelum mengirim sinyal untuk mencegah alarm palsu.
- **Smart Sharing**: Mengirimkan pesan darurat yang berisi:
  - Lokasi terkini (Google Maps link).
  - Data Diri (Nama, Golongan Darah).
  - Kontak Darurat.
  - Riwayat Medis, Alergi, dan Obat Rutin.
- **Quick Actions**: Akses cepat ke Kamera, Perekam Suara, dan Video untuk dokumentasi kejadian.

### 🌤️ Cuaca Terkini (Weather)
Informasi cuaca akurat yang terintegrasi langsung di Home Screen:
- **Compact Widget**: Tampilan ringkas suhu dan kondisi cuaca saat ini.
- **Detail Cuaca**: Halaman detail yang menampilkan:
  - Prakiraan cuaca per jam (Hourly Forecast).
  - Prakiraan cuaca 3 hari ke depan (Daily Forecast).
  - Informasi Kelembaban, Kecepatan Angin, dan Kualitas Udara (AQI).
- **Auto-Location**: Mendeteksi lokasi otomatis untuk data cuaca yang presisi.
- **Powered by Open-Meteo**: Menggunakan API cuaca open-source yang handal.

### 🛠️ Alat Utilitas (Smart Tools)
Kumpulan alat bantu untuk produktivitas dan pengukuran:
- **Kalkulator**: Standard, Scientific, BMI, dan Age Calculator.
- **Pengukur**: Compass, Leveler (Waterpass), Ruler (Penggaris), Sound Meter (Desibel), Speedometer.
- **Scanner**: QR Scanner dan Text Scanner (OCR).
- **Info Perangkat**: Battery Info, Network Speed, System Info.
- **Lainnya**: Flashlight, Stopwatch, Converter.

### 👤 Profil Pengguna
- Manajemen data diri lengkap termasuk informasi medis vital yang digunakan saat SOS.
- Penyimpanan lokal yang aman menggunakan **Hive**.

## Teknologi

Aplikasi ini dibangun menggunakan teknologi modern:
- **Framework**: Flutter
- **State Management**: BLoC / Cubit
- **Local Storage**: Hive
- **API**: Open-Meteo (Weather)
- **Navigation**: GoRouter
- **Location**: Geolocator & Geocoding

## Cara Menjalankan

1.  **Clone Repository**
    ```bash
    git clone https://github.com/CevinWays/smart_tools_app.git
    cd smart_tools_app
    ```

2.  **Install Dependencies**
    ```bash
    flutter pub get
    ```

3.  **Jalankan Aplikasi**
    ```bash
    flutter run
    ```

## Struktur Proyek

- `lib/features/`: Berisi modul-modul fitur (Home, Weather, Profile, Tools, dll).
- `lib/core/`: Komponen inti seperti Router, Theme, dan Utilities.
- `lib/main.dart`: Entry point aplikasi.

## Kontribusi

Kami sangat terbuka untuk kontribusi dari komunitas! Silakan baca [CONTRIBUTING.md](CONTRIBUTING.md) untuk panduan cara berkontribusi, melaporkan bug, atau mengajukan fitur baru.

## Lisensi

Proyek ini dilisensikan di bawah **MIT License**. Lihat file [LICENSE](LICENSE) untuk detail selengkapnya.

---
*Dikembangkan untuk membantu masyarakat agar selalu Siaga.*
