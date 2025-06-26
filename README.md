```markdown
# My Phones Store App
### Halaman Beranda
![Teks Alternatif]([/images/beranda.png](https://github.com/GieKA21/finalppb/blob/main/images/addproduk.png))
[![tampilan](/images/beranda.png)]
[![Tampilan Beranda]([[https://github.com/GieKA21/finalppb/blob/main/images/beranda.png]])]	/images/beranda.png
*Menampilkan daftar produk utama.*

### Halaman Login

[![Tampilan Login](images/login.png)](images/login.png)
*Pengguna dapat masuk ke akun mereka.*

### Semua Produk

[![Daftar Semua Produk](images/allprodduk.png)](images/allprodduk.png)
*Menampilkan daftar lengkap semua produk yang tersedia.*

### Panel Admin

[![Panel Admin](images/adminpanel.png)](images/adminpanel.png)
*Dasbor untuk admin mengelola aplikasi.*

### Manajemen Produk

[![Manajemen Produk](images/manajemenproduk.png)](images/manajemenproduk.png)
*Admin dapat menambah, mengedit, dan menghapus produk.*

### Konfirmasi Pesanan

[![Konfirmasi Pesanan](images/konfirmpesanan.png)](images/konfirmpesanan.png)
*Admin dapat melihat dan mengkonfirmasi pesanan pengguna.*

### Pengajuan Produk

[![Pengajuan Produk](images/pengajuanproduk.png)](images/pengajuanproduk.png)
*Pengguna dapat mengajukan produk baru untuk ditinjau admin.*

### Tambah Produk

[![Tambah Produk](images/addprodduk.png)](images/addprodduk.png)
*Formulir bagi admin untuk menambahkan produk baru.*

### Registrasi Pengguna

[![Registrasi Pengguna](images/regist.png)](images/regist.png)
*Pengguna baru dapat membuat akun.*

### Lupa Kata Sandi

[![Lupa Kata Sandi](images/forgotpass.png)](images/forgotpass.png)
*Opsi untuk pengguna yang lupa kata sandi mereka.*
## Deskripsi Proyek

"My Phones Store" adalah aplikasi mobile e-commerce sederhana yang dibangun dengan Flutter. Aplikasi ini mensimulasikan fungsionalitas dasar sebuah toko ponsel, memungkinkan pengguna untuk menelusuri produk, mendaftar/masuk, mengelola profil mereka, bahkan mengajukan produk baru. Admin memiliki kontrol penuh atas manajemen produk dan konfirmasi pesanan/pengajuan.

Proyek ini dibangun sebagai demonstrasi berbagai konsep pengembangan aplikasi Flutter, termasuk manajemen state lokal, interaksi database lokal (SQLite), navigasi, autentikasi dasar, dan alur kerja multi-peran (pengguna & admin).

## Fitur Utama

Aplikasi ini mencakup fungsionalitas inti berikut:

* **Autentikasi Pengguna:**
    * **Pendaftaran Akun Baru:** Pengguna dapat mendaftar dengan nama lengkap, email, dan password.
    * **Login Pengguna:** Pengguna dapat masuk menggunakan kredensial yang terdaftar.
    * **Login Admin (Dev-only):** Admin dapat login dengan kredensial hardcode (lihat bagian **Catatan Keamanan**).
    * **Lupa Kata Sandi:** Simulasi fitur reset password via email.
* **Manajemen Produk:**
    * **Daftar Produk:** Halaman beranda yang menampilkan daftar produk (horizontal) dan halaman terpisah untuk semua produk (vertikal).
    * **Detail Produk:** Menampilkan informasi detail tentang setiap produk (harga, deskripsi, perusahaan, gambar).
* **Manajemen Profil Konsumen:**
    * Pengguna dapat melihat dan memperbarui nama lengkap, email, dan mengubah password mereka sendiri.
* **Pengajuan Produk oleh Pengguna:**
    * Pengguna biasa dapat **mengajukan produk baru** dengan mengisi detail produk dan **mengunggah gambar langsung dari galeri perangkat**.
    * Pengajuan ini akan berstatus 'pending' dan tidak langsung tampil di beranda utama.
* **Panel Admin (Fitur Eksklusif):**
    * **Manajemen Produk (CRUD):** Admin dapat menambah, melihat, memperbarui, dan menghapus produk yang tampil di beranda aplikasi.
    * **Review Pengajuan Produk:** Admin dapat melihat daftar pengajuan produk dari pengguna, dan memiliki opsi untuk **menyetujui** atau **menolak** pengajuan tersebut.
        * Jika disetujui, produk akan ditambahkan ke daftar produk live.
        * Jika ditolak, pengajuan akan dihapus.
    * **Konfirmasi Pesanan:** Admin dapat melihat pesanan yang diajukan oleh pengguna dan **mengkonfirmasinya**.
        * Ketika pesanan dikonfirmasi, produk yang bersangkutan secara otomatis **dihapus dari daftar produk live**, mensimulasikan bahwa produk tersebut telah terjual.
* **Penyimpanan Data Lokal:**
    * Pengguna, Produk, Pengajuan Produk, dan Pesanan semuanya disimpan di database **SQLite** lokal perangkat menggunakan library `sqflite`.
* **User Interface (UI) & User Experience (UX):**
    * Desain gelap yang konsisten di seluruh aplikasi.
    * Animasi transisi sederhana pada layar Login dan Splash Screen.
    * Validasi form dasar untuk input pengguna.
    * Navigasi Drawer yang intuitif.

## Tumpukan Teknologi

* **Flutter:** Framework UI untuk membangun aplikasi mobile native.
* **Dart:** Bahasa pemrograman yang digunakan oleh Flutter.
* **sqflite:** Plugin Flutter untuk menggunakan database SQLite lokal.
* **shared_preferences:** Plugin Flutter untuk menyimpan data key-value sederhana secara persisten.
* **image_picker:** Plugin Flutter untuk memilih gambar dari galeri atau kamera.
* **path_provider:** Plugin Flutter untuk mendapatkan lokasi umum di sistem file perangkat.

## Struktur Proyek

Struktur direktori `lib/` diatur secara modular untuk pemisahan tanggung jawab:

```

lib/
├── models/             \# Definisi kelas data (Product, User, Order, ProductSubmission)
├── pages/              \# Halaman-halaman yang lebih spesifik (ProductDetailScreen)
├── screens/            \# Layar-layar utama aplikasi (Login, Register, Home, Admin Panel, Profile, dll.)
├── services/           \# Logika bisnis dan interaksi database (DatabaseHelper, ProductService, OrderService, ProductSubmissionService, AuthManager)
└── main.dart           \# Titik masuk utama aplikasi

````

## Cara Menjalankan Aplikasi

Ikuti langkah-langkah di bawah untuk mendapatkan salinan proyek yang berjalan di mesin lokal Anda untuk tujuan pengembangan dan pengujian.

### Prasyarat

* [Flutter SDK](https://flutter.dev/docs/get-started/install) terinstal.
* [Android Studio](https://developer.android.com/studio) terinstal (untuk AVD Manager dan `adb`).
* Pastikan `adb` sudah ditambahkan ke variabel PATH sistem Anda.
* Pastikan Anda memiliki koneksi internet untuk mengunduh dependensi.

### Instalasi

1.  **Kloning Repositori:**
    ```bash
    git clone [https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git](https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git)
    cd YOUR_REPO_NAME
    ```
    *(Ganti `YOUR_USERNAME/YOUR_REPO_NAME` dengan detail repositori Anda yang sebenarnya)*

2.  **Dapatkan Dependensi:**
    ```bash
    flutter pub get
    ```

3.  **Buat Emulator Android (jika belum ada):**
    * Buka Android Studio.
    * Pergi ke `Tools > Device Manager` (atau klik ikon AVD Manager di toolbar).
    * Buat "Virtual Device" baru (misalnya Pixel 7 dengan API 30+).

4.  **Hapus Aplikasi Lama (Penting untuk Skema DB):**
    Jika Anda sebelumnya telah menginstal versi aplikasi ini atau versi lain dengan nama paket yang sama, sangat disarankan untuk **menghapus instalasi lama secara bersih** agar database dibuat ulang dengan skema terbaru:
    * Secara manual: Tekan lama ikon aplikasi di emulator/perangkat dan pilih "Uninstall".
    * Via `adb`:
        ```bash
        adb uninstall com.example.final_project # Ganti dengan applicationId Anda di android/app/build.gradle
        ```

5.  **Jalankan Aplikasi di Emulator/Perangkat:**
    * Mulai emulator Android Anda dari AVD Manager atau pastikan perangkat fisik terhubung via USB.
    * Dari terminal di root proyek Anda:
        ```bash
        flutter run
        ```
    * Ini akan menginstal dan menjalankan aplikasi dalam mode debug.

### Kredensial Login Dev-Only

Untuk menguji fitur admin:

* **Email Admin:** `admin@example.com`
* **Password Admin:** `admin2172`

## Catatan Keamanan Penting (KRITIS)

Proyek ini dibangun untuk tujuan demonstrasi dan pembelajaran. Sebagai hasilnya, ada beberapa **kerentanan keamanan yang disengaja** yang **HARUS diperbaiki** sebelum aplikasi ini digunakan dalam lingkungan produksi nyata:

* **Password Disimpan Tanpa Hash:** Saat ini, password pengguna dan admin disimpan dalam bentuk `plain text` di database SQLite lokal. Ini adalah praktik yang sangat tidak aman. Untuk produksi, password harus selalu di-hash (misalnya, menggunakan BCrypt atau Argon2) sebelum disimpan, dan diverifikasi dengan membandingkan hash yang dimasukkan pengguna.
* **Login Admin Hardcode:** Kredensial admin hardcode di dalam kode. Ini harus diganti dengan sistem autentikasi yang lebih aman yang melibatkan database dan, idealnya, otorisasi berbasis peran yang lebih canggih.

## Pengembangan Selanjutnya (Potensi Peningkatan)

* **Implementasi Hashing Password:** Integrasikan library hashing (misalnya `argon2_ffi_base` atau `bcrypt`) untuk mengamankan password.
* **Backend Cloud:** Migrasikan penyimpanan data produk, pesanan, dan bahkan pengguna ke layanan backend cloud (misalnya Firebase Firestore/Authentication, AWS Amplify, atau REST API kustom) untuk skalabilitas, keamanan, dan fungsionalitas sinkronisasi data antar perangkat.
* **Notifikasi Real-time:** Implementasikan notifikasi push (Firebase Cloud Messaging) untuk update pesanan atau pengajuan produk.
* **Fitur Keranjang Belanja:** Kembangkan fungsionalitas keranjang belanja dan alur checkout.
* **Filter & Sorting Lanjutan:** Tambahkan opsi filter dan sorting produk yang lebih detail.
* **Penanganan Error yang Lebih Robust:** Implementasikan penanganan error global dan umpan balik pengguna yang lebih baik untuk skenario yang tidak terduga.
* **Desain UI/UX Lanjutan:** Perbaikan visual dan pengalaman pengguna yang lebih kaya.

## Kontribusi

Kontribusi disambut baik! Jika Anda memiliki saran atau ingin meningkatkan proyek ini, silakan:

1.  Fork repositori ini.
2.  Buat branch fitur baru (`git checkout -b feature/AmazingFeature`).
3.  Lakukan perubahan Anda.
4.  Commit perubahan Anda (`git commit -m 'Add some AmazingFeature'`).
5.  Push ke branch (`git push origin feature/AmazingFeature`).
6.  Buka Pull Request.


---

## Tentang Penulis

* **[As Shadiq Nur]** (Shadiq)
* [[instagram](https://www.instagram.com/hidhithere/)]

---
````
