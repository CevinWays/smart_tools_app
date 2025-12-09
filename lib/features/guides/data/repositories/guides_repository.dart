import 'package:smart_tools_app/features/guides/domain/entities/guide_entity.dart';

class GuidesRepository {
  Future<List<Guide>> getGuides() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      const Guide(
        id: '1',
        title: 'Siaga Banjir',
        description:
            'Panduan lengkap menghadapi bencana banjir, dari persiapan hingga pasca bencana.',
        content: '''
# Siaga Banjir

Banjir adalah salah satu bencana alam yang paling sering terjadi. Berikut adalah langkah-langkah yang harus dilakukan:

## Sebelum Banjir (Kesiapsiagaan)
1.  **Kenali Risiko:** Ketahui apakah wilayah Anda rawan banjir.
2.  **Amankan Dokumen:** Simpan dokumen penting dalam wadah tahan air.
3.  **Siapkan Tas Siaga:** Isi dengan makanan, obat-obatan, senter, dan pakaian ganti.
4.  **Bersihkan Saluran Air:** Pastikan selokan di sekitar rumah tidak tersumbat.

## Saat Banjir
1.  **Pantau Informasi:** Dengarkan radio atau pantau media sosial resmi untuk update cuaca.
2.  **Evakuasi Dini:** Jika air mulai naik, segera evakuasi ke tempat yang lebih tinggi.
3.  **Matikan Listrik:** Segera matikan aliran listrik di rumah untuk menghindari korsleting.
4.  **Hindari Arus:** Jangan berjalan atau berkendara melewati arus air yang deras.

## Pasca Banjir
1.  **Periksa Kerusakan:** Cek kondisi rumah sebelum masuk kembali.
2.  **Bersihkan Lumpur:** Segera bersihkan lumpur dan sampah yang terbawa banjir.
3.  **Waspada Penyakit:** Jaga kebersihan diri dan lingkungan untuk mencegah penyakit kulit dan pencernaan.
        ''',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1509114397022-ed747cca3f65?auto=format&fit=crop&q=80&w=1000',
        category: 'Banjir',
      ),
      const Guide(
        id: '2',
        title: 'Gempa Bumi',
        description:
            'Apa yang harus dilakukan saat terjadi gempa bumi untuk melindungi diri.',
        content: '''
# Gempa Bumi

Gempa bumi terjadi secara tiba-tiba. Kunci keselamatan adalah tidak panik.

## Saat Terjadi Gempa
1.  **DROP (Jatuhkan Diri):** Segera turun ke lantai.
2.  **COVER (Lindungi Kepala):** Berlindung di bawah meja yang kokoh. Jika tidak ada meja, lindungi kepala dengan lengan.
3.  **HOLD ON (Pegangan):** Pegang kaki meja dan tetap di sana sampai guncangan berhenti.

## Jika di Luar Ruangan
1.  **Jauhi Bangunan:** Menjauh dari gedung, tiang listrik, dan pohon.
2.  **Cari Tempat Terbuka:** Pergi ke lapangan atau area terbuka lainnya.

## Jika di Dalam Mobil
1.  **Berhenti:** Pinggirkan mobil di tempat aman, jauh dari jembatan atau pohon.
2.  **Tetap di Dalam:** Jangan keluar sampai guncangan berhenti.
        ''',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1534970028765-38ce47ef7d8d?auto=format&fit=crop&q=80&w=1000',
        category: 'Gempa Bumi',
      ),
      const Guide(
        id: '3',
        title: 'Cuaca Ekstrim',
        description:
            'Tips menghadapi cuaca ekstrim seperti badai, angin puting beliung, dan panas terik.',
        content: '''
# Cuaca Ekstrim

Perubahan iklim menyebabkan cuaca ekstrim semakin sering terjadi.

## Angin Puting Beliung
1.  **Cari Perlindungan:** Masuk ke dalam ruangan yang kokoh, jauhi jendela.
2.  **Waspada Benda Terbang:** Hati-hati terhadap puing-puing yang beterbangan.

## Gelombang Panas
1.  **Minum Banyak Air:** Cegah dehidrasi dengan minum air putih yang cukup.
2.  **Hindari Matahari Langsung:** Gunakan topi atau payung saat di luar ruangan.
3.  **Pakai Pakaian Tipis:** Gunakan pakaian yang longgar dan berwarna terang.
        ''',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1566996694954-90b052c413c4?auto=format&fit=crop&q=80&w=1000',
        category: 'Cuaca Ekstrim',
      ),
      const Guide(
        id: '4',
        title: 'Tsunami',
        description: 'Langkah evakuasi cepat saat ada peringatan dini tsunami.',
        content: '''
# Tsunami

Tsunami biasanya dipicu oleh gempa bumi besar di laut.

## Tanda-Tanda Alam
1.  **Gempa Kuat:** Gempa besar yang berlangsung lama.
2.  **Air Laut Surut:** Air laut tiba-tiba surut jauh dari garis pantai.
3.  **Suara Gemuruh:** Terdengar suara gemuruh keras dari arah laut.

## Tindakan Penyelamatan
1.  **Lari ke Tempat Tinggi:** Segera lari ke bukit atau bangunan tinggi yang kokoh.
2.  **Jangan Menunggu:** Jangan menunggu peringatan resmi jika melihat tanda-tanda alam.
3.  **Jauhi Pantai:** Jangan kembali ke pantai sampai dinyatakan aman oleh pihak berwenang.
        ''',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1534970028765-38ce47ef7d8d?auto=format&fit=crop&q=80&w=1000',
        category: 'Tsunami',
      ),
      const Guide(
        id: '5',
        title: 'Kebakaran Rumah',
        description:
            'Cara mencegah dan menyelamatkan diri dari kebakaran rumah.',
        content: '''
# Kebakaran Rumah

Kebakaran bisa terjadi kapan saja. Pencegahan adalah kunci.

## Pencegahan
1.  **Cek Instalasi Listrik:** Pastikan kabel tidak terkelupas dan tidak menumpuk steker.
2.  **Hati-hati Kompor:** Jangan tinggalkan kompor menyala tanpa pengawasan.
3.  **Sediakan APAR:** Siapkan Alat Pemadam Api Ringan di rumah.

## Saat Kebakaran
1.  **Tetap Tenang:** Jangan panik.
2.  **Merangkak:** Jika banyak asap, merangkaklah di lantai karena udara bersih ada di bawah.
3.  **Keluar Segera:** Segera keluar rumah dan hubungi pemadam kebakaran.
4.  **Jangan Masuk Kembali:** Jangan kembali ke dalam rumah yang terbakar untuk mengambil barang.
        ''',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1509114397022-ed747cca3f65?auto=format&fit=crop&q=80&w=1000',
        category: 'Kebakaran',
      ),
    ];
  }
}
