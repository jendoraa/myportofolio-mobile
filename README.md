# myportofolio_mobile

Proyek Individu mata kuliah **PBP** Semester Gasal 2026/2027. \
Aplikasi ini adalah perluasan dari website portofolio saya. \
Repositori web berada di link berikut [ini](https://github.com/jendoraa/myportofolio).

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
|   ├── screens/
|   |   ├── experience_form.dart
│   |   ├── menu.dart
|   |   └── project_form.dart
|   ├── widgets/
|   |   ├── left_drawer.dart
|   |   └── project_card.dart
│   └── main.dart
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

### Tutorial 09: Flutter Navigation, Layouts, Forms, and Input Elements
- Membuat navigasi pada Flutter
- Atur layout pada Flutter
- Membuat Form Project

### Tugas 8: Flutter Navigation, Layouts, Forms, and Input Elements
- Menambah form untuk experience
- Atur layout home
- buat validasi form experience

<!-- Minggu berikutnya, ### Tugas 9: [Topik - ... -->

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


### Tugas 8

1. **Perbedaan `Navigator.push()`, `Navigator.pushReplacement()`, dan `Navigator.pop()`**

   -> `push()` menaruh halaman baru di atas halaman yang sedang tampil. Halaman lama tetap ada di stack, jadi pengguna bisa kembali. \
   -> `pushReplacement()` mengganti halaman yang sedang tampil dengan halaman baru. Halaman lama dibuang dari stack, jadi tidak bisa kembali ke sana. \
   -> `pop()` membuang halaman paling atas dan kembali ke halaman di bawahnya. Dipakai juga untuk menutup dialog.
   
   Untuk membuka formulir dari kartu aksi aku pakai `push()`, supaya pengguna bisa kembali ke halaman utama dengan tombol kembali bawaan. Opsi Home di drawer memakai `pushReplacement()` ke `MyHomePage()`, jadi halaman formulir yang sedang terbuka digantikan oleh halaman utama.

2. **Susunan Struktur Halaman Tetap Konsisten**

   _Scaffold_ jadi kerangka tiap halaman, sehingga setiap halaman punya struktur yang sama. _AppBar_ menjaga identitas visual di bagian atas, dan _LeftDrawer_ adalah widget yang dipakai ulang di _MyHomePage_, _ProjectFormPage_, dan _ExperienceFormPage_, jadi menu navigasinya selalu sama dan cukup diubah di satu tempat. Contoh warna tema: warna Colors.indigo dipakai di _AppBar_ halaman formulir, header drawer, dan tombol save.

3. Alasan dipilihnya Tata Letak itu

   Formulir disusun dengan _Form > SingleChildScrollView > Column_. Susunan vertikal cocok untuk layar ponsel karena field mengalir ke bawah satu per satu. `SingleChildScrollView()` penting ketika ruang terbatas, keyboard muncul atau layar sempit, isi form bisa digulir sehingga semua field dan tombol save tetap bisa dijangkau tanpa mengalami overflow.

4. Peran `GlobalKey<FormState>`, `validator`, dan `validate()`

   `GlobalKey<FormState>` menghubungkan kode kita ke state Form, sehingga tombol save bisa memanggil `_formKey.currentState!.validate()`.

   `validator` adalah fungsi di tiap field. Hasilnya String _error_ kalau tidak valid, atau _null_ kalau valid.

   `validate()` menjalankan semua `validator` sekaligus. Kalau ada yang mengembalikan pesan, pesannya tampil di kolom terkait dan fungsi mengembalikan false, sehingga dialog tidak muncul. Dialog baru tampil kalau semuanya true.
   
   Contoh nilai yang ditolak: posisi berisi " " (hanya spasi) ditolak karena divalidasi dengan `trim().isEmpty`. Contoh lain: tanggal selesai yang lebih awal dari tanggal mulai. Keyboard teks tetap membolehkan spasi saja, dan date picker tidak tahu hubungan antara dua tanggal, jadi aturan seperti ini hanya bisa dicek lewat `validator`.

## AI Disclosure

### Tools yang digunakan
- ChatGPT - Free
- Ai Overview
- Gemini - Hydrogen

### Strategi prompting
Memberi sebagian kode untuk dipahami kemudian menanyakan konteks dan memahaminya terlebih dahulu sebelum diimplementasikan ke kode, tanyakan lagi jika merasa kurang memahami / hasil ambigu.

### Bagian yang dibantu AI
| Bagian | Bentuk bantuan |
|---|---|
| Struktur README | membuat template README yang profesional |
| Variasi Snackbar | membuat variasi snackbar baru dari tutorial |
| Logout | membuat tombol logout berfungsi |
| Kolom Tanggal | membuat kolom form tanggal yang tinggal pilih tanggal |

### Log chat / prompt
- https://chatgpt.com/share/6af73808-ff9c-83ec-ad63-c6577b1d2be7 - 11 November 2026
- https://share.google/aimode/oLH1PkMvGldrWXkgV - 22 November 2026
- https://share.gemini.google/U5YiBPAhlZTj - 22 November 2026

### Keterbatasan AI yang saya temui
1. **Menjalankan testing**, 
   
   AI tidak bisa menjalankan testing seperti `flutter analyze`, sehingga kita tetap perlu mengujinya secara mandiri. 
### Perbaikan manual yang saya lakukan
1. **Debug**,

   menyesuaikan nama import, file yang hasilnya berbeda dari ai generated