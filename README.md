# myportofolio_mobile

Proyek Individu mata kuliah **PBP** Semester Gasal 2026/2027. \
Aplikasi ini adalah perluasan dari website portofolio saya. \
Repositori web berada di link berikut [ini](https://github.com/jendoraa/myportofolio-mobile.git).

![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)

## Identitas

| | |
|---|---|
| **Nama** | Rajendra Akbar Mahdiansyah |
| **NPM** | 2506596874 |
| **Kelas PBP** | C |

## Fitur

- Tampilan Menu

## Struktur Proyek

```
myportofolio_mobile/
|   ...
├── lib/
│   ├── main.dart    # Bootstrap aplikasi (MaterialApp)
│   └── menu.dart    # MyHomePage
|   ...
├── pubspec.yaml
└── README.md
```

## Cara Menjalankan

**Prasyarat**

Flutter SDK 3.47.9 dan Dart 3.13.7

**Langkah**

```bash
git clone https://github.com/jendoraa/myportofolio-mobile.git
cd myportofolio_mobile
flutter pub get
flutter run
```

## Progres Mingguan

### Tutorial 8: Basic Flutter
- Instalasi dan konfigurasi Flutter
- Memahami struktur direktori Flutter
- Pengenalan komponen-komponen Flutter

### Tugas 7: Basic Flutter
- Membuat menu aksi
- Mengganti informasi di profil
- Membuat variasi dari komponen-komponen sebelumny

<!-- Minggu berikutnya, ### Tugas 8: [Topik - ... -->

---

### Tugas 7

1. **Widget tree dan hubungan parent-child**

   Semua yang tampil di Flutter adalah widget. Widget ini  disusun membentuk sebuah pohon gitu (tree SDA). Parent menentukan batasan, posisi, dan style childnya, sedangkan child hanya mengurus bagiannya sendiri (dibuat style terpisah, biar ga seragam). Kalau parent diubah, child juga ikut berubah.

2. **Widget yang digunakan dan fungsinya**

   | Widget | Fungsi |
   |---|---|
   | `MaterialApp` | wrapper utama aplikasi |
   | `Scaffold` | kerangka halaman |
   | `AppBar` | semacam panel, yang bagian atas |
   | `Column` / `Row` | susun child (horizontal/vertikal) |
   | `Card` | Kotak kartu berisi InfoCard |
   | `Icon` | Tampilin ikon |
   | `InkWell` | Buat area bisa ditekan |
   | `SnackBar` | pesan singkat setelah aksi |

3. **Fungsi `MaterialApp` dan alasan jadi root widget**

   Sebagai wrapper utama dari aplikasi, widget ini menyediakan beberapa kebutuhan aplikasi seperti tema, judul, halaman, dan navigasinya. Widget seperti AppBar, Card, SnackBar memperlukannya agar bisa berjalan dengan baik.

4. **`StatelessWidget` vs `StatefulWidget`**

   StatelessWidget: data yang digunakan tidak berubah-ubah, sehingga tampilannya tetap. \
   StatefulWidget :datanya bisa berubah-ubah, tampilan selalu menyesuaikan dari data terbaru.

   Tips memilih: Pilih StatelessWidget kalau dirasa datanya tetap, ga perlu update data. Sedangkan StatefulWidget dipilih kalau misal emang perlu melakukan update data / ada yang perlu diubah.

5. **`BuildContext`**

   Sebagai penanda posisi gitu dk dalem widget. Dari parameternya BuildContext juga perlu agar memudahkan pembuatan kode.


6. **Hot reload vs hot restart**

    Hot reload:membawa perubahan kode ke aplikasi yang sedang jalan, tanpa mengulang dari awal, cepat, dan state aplikasinya tetap tersimpan. \
    Hot restart: menjalankan ulang aplikasi dari awal di Flutter, sehingga semua state kembali ke kondisi awal. Lebih lambat dari hot reload, tapi lebih cepat dari build penuh.


## AI Disclosure

### Tools yang digunakan
- ChatGPT - Free

### Strategi prompting
Memberi sebagian kode untuk dipahami kemudian menanyakan konteks dan memahaminya terlebih dahulu sebelum diimplementasikan ke kode, tanyakan lagi jika merasa kurang memahami / hasil ambigu.

### Bagian yang dibantu AI
| Bagian | Bentuk bantuan |
|---|---|
| [Struktur README] | membuat template README yang profesional |
| [Variasi Snackbar] | membuat variasi snackbar baru dari tutorial |

### Log chat / prompt
- https://chatgpt.com/share/6af73808-ff9c-83ec-ad63-c6577b1d2be7 - 11 November 2026

### Keterbatasan AI yang saya temui
1. (ga ada si, lagi jago)

### Perbaikan manual yang saya lakukan
1. 