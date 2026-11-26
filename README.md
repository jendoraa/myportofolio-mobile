# myportofolio_mobile

Proyek Individu mata kuliah **PBP** Semester Gasal 2026/2027. \
Aplikasi ini adalah perluasan dari website portofolio saya. \
Repositori web berada di link berikut [ini](https://github.com/jendoraa/myportofolio).

![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)
[![CI](https://github.com/jendoraa/myportofolio-mobile/actions/workflows/main.yaml/badge.svg)](https://github.com/jendoraa/myportofolio-mobile/actions/workflows/main.yaml)

## Identitas

| | |
|---|---|
| **Nama** | Rajendra Akbar Mahdiansyah |
| **NPM** | 2506596874 |
| **Kelas** | C |

## Fitur

- Halaman utama dengan kartu aksi dan `LeftDrawer`
- Daftar dan detail **Projects** publik (`GET /api/v1/projects/`) serta tambah proyek terautentikasi (`POST /api/v1/projects/`)
- Daftar dan detail **Experiences** publik (`GET /api/v1/experience/`) menggunakan `FutureBuilder` dan `RefreshIndicator`
- Tambah **Experience** terautentikasi (`POST /api/v1/experience/`) dengan `ensureLoggedIn`, token `AuthState`, dan penanganan `ApiException` (termasuk status `401`)
- Autentikasi login dan logout berbasis token DRF (`TokenAuthentication`)
- Pipeline CI/CD GitHub Actions (`very_good_workflows` dan unggah artefak `app-release-apk`)

## Struktur Proyek

```
myportofolio_mobile/
├── .github/
|   └── workflows/
|       └── main.yaml
├── lib/
|   ├── config.dart
|   ├── main.dart
|   ├── models/
|   |   ├── experience.dart
|   |   └── project.dart
|   ├── screens/
|   |   ├── experience_detail.dart
|   |   ├── experience_form.dart
|   |   ├── experience_list.dart
|   |   ├── login.dart
│   |   ├── menu.dart
|   |   ├── project_detail.dart
|   |   ├── project_form.dart
|   |   └── project_list.dart
|   ├── services/
|   |   ├── api_client.dart
|   |   └── auth_state.dart
│   └── widgets/
|       ├── auth_guard.dart
|       ├── left_drawer.dart
|       └── menu_card.dart
├── tests/
|   └── widget_test.dart
|   ...
├── pubspec.yaml
└── README.md
```

## Cara Menjalankan

**Prasyarat**

- Flutter SDK 3.47.9 dan Dart 3.13.7
- Backend Django dari: \
-- repositori `github.com/jendoraa/myportofolio` yang berjalan secara lokal \
-- URL API yang telah di-deploy `rajendra-akbar-myportofolio.pws.cs.ui.ac.id/`

**Langkah**

```bash
git clone https://github.com/jendoraa/myportofolio-mobile.git
cd myportofolio-mobile
flutter pub get

# Menghasilkan berkas *.g.dart untuk model @JsonSerializable
dart run build_runner build --delete-conflicting-outputs

# Menjalankan di Android Emulator (default API_BASE_URL=http://10.0.2.2:8000)
flutter run

# Menjalankan di Chrome / Web (override API_BASE_URL ke server lokal atau URL deploy)
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
```

**Pemeriksaan Statis & Pengujian**

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

## Progres Mingguan

> **Week 11 ~ 9-16 November**

### Tutorial 8: Basic Flutter
- Instalasi dan konfigurasi Flutter
- Memahami struktur direktori Flutter
- Pengenalan komponen-komponen Flutter

### Tugas 7: Basic Flutter
- Membuat menu aksi
- Mengganti informasi di profil
- Membuat variasi dari komponen-komponen sebelumny

> **Week 12 ~ 16-23 November**

### Tutorial 9: Flutter Navigation, Layouts, Forms, and Input Elements
- Membuat navigasi pada Flutter
- Atur layout pada Flutter
- Membuat Form Project

### Tugas 8: Flutter Navigation, Layouts, Forms, and Input Elements
- Menambah form untuk experience
- Atur layout home
- buat validasi form experience

> **Week 13 ~ 23-30 November**

### Tutorial 10: Flutter Backend Integration, Authentication, and CI/CD
- Integrasi `Project` dengan DRF dan autentikasi token
- Menyiapkan pipeline CI/CD GitHub Actions

### Tugas 9: Flutter Backend Integration, Authentication, and CI/CD
- Membuat model `@JsonSerializable` untuk `Experience`
- Menambahkan `GET` publik dan `POST` terautentikasi untuk `/api/v1/experience/`
- Membangun tampilan di experience serta merefactor `ExperienceFormPage`
- Melengkapi badge CI, instruksi setup, jawaban reflektif, dan *AI disclosure* di `README.md`

<!-- end -->

## Tugas Refleksi

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

3. **Alasan dipilihnya Tata Letak itu**

   Formulir disusun dengan _Form > SingleChildScrollView > Column_. Susunan vertikal cocok untuk layar ponsel karena field mengalir ke bawah satu per satu. `SingleChildScrollView()` penting ketika ruang terbatas, keyboard muncul atau layar sempit, isi form bisa digulir sehingga semua field dan tombol save tetap bisa dijangkau tanpa mengalami overflow.

4. **Peran `GlobalKey<FormState>`, `validator`, dan `validate()`**

   `GlobalKey<FormState>` menghubungkan kode kita ke state Form, sehingga tombol save bisa memanggil `_formKey.currentState!.validate()`.

   `validator` adalah fungsi di tiap field. Hasilnya String _error_ kalau tidak valid, atau _null_ kalau valid.

   `validate()` menjalankan semua `validator` sekaligus. Kalau ada yang mengembalikan pesan, pesannya tampil di kolom terkait dan fungsi mengembalikan false, sehingga dialog tidak muncul. Dialog baru tampil kalau semuanya true.
   
   Contoh nilai yang ditolak: posisi berisi " " (hanya spasi) ditolak karena divalidasi dengan `trim().isEmpty`. Contoh lain: tanggal selesai yang lebih awal dari tanggal mulai. Keyboard teks tetap membolehkan spasi saja, dan date picker tidak tahu hubungan antara dua tanggal, jadi aturan seperti ini hanya bisa dicek lewat `validator`.


### Tugas 9
1. **Penggunaan `@JsonSerializable(fieldRename: FieldRename.snake)` dan `@JsonKey(includeToJson: false)` lebih oke daripada mengirim objek `Map<String, dynamic>` mentah langsung dari widget**

   Menggunakan model `@JsonSerializable` memberikan *type safety* saat kompilasi, menyatukan definisi skema API di satu berkas (`lib/models/experience.dart`), dan secara otomatis menerjemahkan penamaan Dart (`camelCase` seperti `startedAt` dan `endedAt`) ke kunci JSON DRF (`snake_case` seperti `started_at` dan `ended_at`). Sementara itu, `@JsonKey(includeToJson: false)` pada `id` mencegah klien mengirimkan `id: null` atau field hasil komputasi server dalam payload `POST`, karena UUID ditetapkan oleh Django.

   **Contoh bug yang dicegah pada model `Experience`**: saat mengirim `Map<String, dynamic>` mentah dari widget, salah ketik kunci seperti `'startedAt'` alih-alih `'started_at'` akan langsung memicu error `400 Bad Request` di DRF, atau deserialisasi bisa gagal (*runtime type error*) ketika field opsional seperti `thumbnail` bernilai `null` dari backend tanpa `@JsonKey(defaultValue: '')`.

2. **Future yang diteruskan ke FutureBuilder harus diinisialisasi di dalam initState() dan alasan ApiClient sebaiknya melempar ApiException pada respons HTTP non-2xx?**

   Metode `build()` di Flutter bisa dipanggil berkali-kali setiap kali terjadi `setState()`, perubahan orientasi, atau pembaruan tampilan. Jika pemanggilan `apiClient.getExperiences()` diletakkan di dalam `build()`, setiap *rebuild* akan menciptakan `Future` baru dan mengirim permintaan HTTP berulang-ulang tanpa henti. Menginisialisasi `Future` di `initState()` memastikan data hanya diambil sekali saat layar dibuka, lalu diperbarui secara eksplisit lewat `RefreshIndicator` atau tombol `Retry`.

   Melempar `ApiException(statusCode, message)` pada respons non-2xx lebih baik daripada mengembalikan `null` karena `FutureBuilder` dapat langsung menangkap kegagalan melalui `snapshot.hasError` (sehingga UI bisa membedakan daftar kosong `[]` dengan error jaringan/server), dan halaman formulir dapat membaca `e.statusCode` secara spesifik—misalnya menghapus sesi dan meminta login ulang saat menerima status `401 Unauthorized`.

3. **Mengapa myportfolio_mobile menggunakan TokenAuthentication sementara SessionAuthentication tetap diaktifkan pada backend Django?**

   Jika dibentuk dalam bentuk tabel perbandingan sebagai berikut.
   
   | Aspek | **SessionAuthentication** | **TokenAuthentication** |
   |---|---|---|
   | **Mekanisme** | Menggunakan *session cookie* (`sessionid`) di browser dan validasi token CSRF untuk operasi tulis. | Menggunakan header HTTP *stateless* `Authorization: Token <key>` pada setiap permintaan terautentikasi. |
   | **Ketergantungan Klien** | Mengandalkan pengelolaan cookie dan CSRF otomatis milik browser. | Tidak bergantung pada cookie/CSRF, token disimpan oleh klien (di `AuthState`) dan dikirim eksplisit lewat header. |
   | **Penggunaan Utama** | Aplikasi web Django, Browsable API DRF, dan Django Admin di browser. | Aplikasi *mobile* Flutter, CLI, dan klien lintas platform. |

   `myportofolio_mobile` memakai `TokenAuthentication` karena klien Flutter *mobile* tidak mengelola cookie sesi dan CSRF seperti browser, sekaligus bekerja seragam di Android maupun Flutter Web. Sementara itu, `SessionAuthentication` tetap diaktifkan di backend Django agar aplikasi web portofolio dan Django Admin yang diakses lewat browser tetap berfungsi normal.

4. **Peran job build dan build_apk dalam pipeline `.github/workflows/main.yaml`. Alasan berkas `*.g.dart` dimasukkan ke .gitignore meskipun CI membutuhkannya untuk menganalisis dan membangun aplikasi.**

   **Job build (CI)** memanggil reusable workflow `VeryGoodOpenSource/very_good_workflows/.github/workflows/flutter_package.yml@v2` \
   Di balik layar, job ini menjalankan:
   - perintah `setup` (`dart run build_runner build --delete-conflicting-outputs`), 
   - memeriksa pemformatan kode (`dart format --output=none --set-exit-if-changed`),
   - menjalankan analisis statis (`flutter analyze`), 
   - mengeksekusi pengujian (`flutter test`) beserta *coverage* (mengecualikan `**/*.g.dart`),
   - memeriksa ambang `min_coverage`.

   **Job build_apk (CD)** bergantung pada kelulusan job build (`needs: build`) \
   Job ini melakukan beberapa hal seperti, 
   - melakukan *checkout* kode, 
   - memasang Flutter stable, 
   - menjalankan `flutter pub get` dan `build_runner`, 
   - membangun APK rilis (`flutter build apk --release`),
   - mengunggah `build/app/outputs/flutter-apk/app-release.apk` sebagai artefak `app-release-apk` menggunakan `actions/upload-artifact@v4`.
   
   **`*.g.dart` dimasukkan ke `.gitignore`** sebab `*.g.dart` adalah kode hasil generasi otomatis yang sepenuhnya bisa dibuat ulang dari anotasi pada model sumber. Memasukkannya ke `.gitignore` menjaga riwayat Git tetap bersih dan menghindari *merge conflict* pada boilerplate hasil generasi. CI tetap bisa menganalisis dan membangun aplikasi karena kedua job (build lewat `setup:` dan build_apk lewat langkah `run:`) secara otomatis menjalankan `dart run build_runner build --delete-conflicting-outputs` terlebih dahulu.

## AI Disclosure

### Tools yang digunakan
- ChatGPT - Free
- Ai Overview
- Gemini - Hydrogen, Neon

### Strategi prompting
Memberi sebagian kode untuk dipahami kemudian menanyakan konteks dan memahaminya terlebih dahulu sebelum diimplementasikan ke kode, tanyakan lagi jika merasa kurang memahami / hasil ambigu.

### Bagian yang dibantu AI
| Bagian | Bentuk bantuan |
|---|---|
| Struktur README | membuat template README yang profesional |
| Variasi Snackbar | membuat variasi snackbar baru dari tutorial |
| Logout | membuat tombol logout berfungsi |
| Kolom Tanggal | membuat kolom form tanggal yang tinggal pilih tanggal |
| debug CI/CD | membantu debug error di CI/CD |
 
### Log chat / prompt
- https://chatgpt.com/share/6af73808-ff9c-83ec-ad63-c6577b1d2be7 - 11 November 2026
- https://share.google/aimode/oLH1PkMvGldrWXkgV - 22 November 2026
- https://share.gemini.google/U5YiBPAhlZTj - 22 November 2026
- https://share.gemini.google/timbz71eRuEK - 25 November 2026
- https://share.gemini.google/zlIBbsdbMznI - 26 November 2026

### Keterbatasan AI yang saya temui
1. **Menjalankan testing**,  \
   AI tidak bisa menjalankan perintah Flutter secara langsung seperti `build_runner`, `dart format`, dan `flutter analyze`, sehingga seluruh pengujian lokal dan verifikasi ke server Django tetap harus saya jalankan sendiri. 
2. **Overkill** \ 
   Terkadang AI memberi banyak jawaban yang mungkin tidak dibutuhkan spesifikasi program. Ibarat BeAT dikasih Pertamax Turbo

### Perbaikan manual yang saya lakukan
1. **Debug** \
   Menyesuaikan nama import dan berkas agar konsisten dengan struktur proyek, membersihkan logika edit/delete yang tidak dipakai di `ExperienceFormPage`, serta menguji integrasi secara langsung ke backend Django lokal.