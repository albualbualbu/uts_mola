# PANDUAN LENGKAP & GUIDE BOOK UTP: CAPCUT CLONE (FLUTTER)

Buku panduan ini disusun khusus untuk persiapan ujian praktikum (UTP) mata kuliah **Mobile Lanjut**. Berisi penjelasan alur kode, struktur arsitektur, konsep Flutter yang diterapkan, serta kisi-kisi tanya jawab saat dievaluasi oleh asisten dosen.

---

## DAFTAR ISI
1. [Penjelasan Error Sebelumnya & Solusinya](#1-penjelasan-error-sebelumnya--solusinya)
2. [Gambaran Umum Proyek](#2-gambaran-umum-proyek)
3. [Struktur Berkas Proyek](#3-struktur-berkas-proyek)
4. [Penjelasan Detail Tiap Halaman](#4-penjelasan-detail-tiap-halaman)
5. [Konsep Flutter yang Diterapkan (Pertemuan 1–7)](#5-konsep-flutter-yang-diterapkan)
6. [Tanya Jawab UTP (Prediksi Pertanyaan Asisten Dosen)](#6-tanya-jawab-utp-prediksi-pertanyaan-asisten-dosen)

---

## 1. PENJELASAN ERROR SEBELUMNYA & SOLUSINYA

### Mengapa Tadi Sempat Terjadi Error Ini?
```text
FileSystemException: writeFrom failed ... (OS Error: There is not enough space on the disk, errno = 112)
The Dart compiler exited unexpectedly.
```

### Penyebab:
Bukan karena kode Flutter atau Dart yang salah, melainkan **kapasitas Drive C: di laptop Anda sempat hampir habis (hanya tersisa 0.09 GB / 90 MB)**. 
Saat Flutter mengompilasi kode ke Web/Desktop, Dart membutuhkan ruang sementara sebesar ~200MB - 500MB di folder `AppData\Local\Temp`. Karena sisa ruang di bawah 100MB, Windows menolak operasi penulisan berkas (`errno = 112`).

### Solusi yang Telah Dilakukan:
1. Dijalankan perintah `flutter clean` untuk menghapus berkas cache build lama.
2. Kapasitas Drive C: berhasil bertambah kembali menjadi **>3.0 GB free**.
3. Kode diuji ulang dengan `flutter analyze` dan `flutter test`, seluruhnya sukses (`0 errors`).
4. Sekarang aplikasi siap dijalankan menggunakan:
   ```powershell
   flutter run -d edge
   # atau
   flutter run -d windows
   ```

---

## 2. GAMBARAN UMUM PROYEK

Aplikasi ini adalah replika antarmuka (UI clone) aplikasi **CapCut Android** yang disederhanakan untuk kebutuhan UTP.

### Karakteristik Desain:
- **Warna Utama**: Hitam, Putih, Abu-abu, dengan aksen toska/cyan khas CapCut (`#00C4CC`).
- **4 Navigasi Utama**:
  1. **Edit**: Pusat pembuatan video baru, edit foto, daftar thumbnail proyek terakhir, dan grid fitur.
  2. **Template**: Katalog template video dengan filter chip kategori dan kolom pencarian real-time.
  3. **Proyek**: Pengelolaan berkas lokal/cloud, banner AI, filter jenis media, dan aksi CRUD (Ganti nama, duplikat, hapus).
  4. **Saya**: Profil akun, status uji coba Standar Pro, menu utilitas, dan pengaturan Dark Mode.
- **Menu Lab AI Dihapus** sesuai instruksi ujian.

---

## 3. STRUKTUR BERKAS PROYEK

```text
lib/
│
├── main.dart                      # Root aplikasi, tema terang/gelap, dan BottomNavigationBar
│
├── models/
│   ├── project_model.dart         # Model data untuk Proyek (id, title, date, size, coverColor)
│   └── template_model.dart        # Model data untuk Template (id, title, author, category, imagePath)
│
├── screens/
│   ├── edit_screen.dart           # Tampilan Tab 1 (Edit)
│   ├── template_screen.dart       # Tampilan Tab 2 (Template)
│   ├── proyek_screen.dart         # Tampilan Tab 3 (Proyek)
│   └── saya_screen.dart           # Tampilan Tab 4 (Saya / Profil)
│
└── widgets/
    └── media_picker_sheet.dart    # BottomSheet reusable untuk simulasi pemilihan foto/video
```

---

## 4. PENJELASAN DETAIL TIAP HALAMAN

### A. Root & Navigasi (`lib/main.dart`)
- **Fungsi**: Membungkus aplikasi dalam `MaterialApp` dan mengatur perpindahan antar-tab.
- **Teknik Kunci**: Menggunakan `IndexedStack`.
  - Mengapa `IndexedStack`? Karena `IndexedStack` menjaga seluruh halaman tetap hidup di memori. Saat berpindah tab, posisi scroll atau teks pencarian tidak akan hilang/ter-reset.
- **State Tema**: Variabel `_isDarkMode` bertipe boolean diatur lewat fungsi `_toggleTheme()` untuk mengganti tema Light/Dark secara instan.

### B. Halaman Edit (`lib/screens/edit_screen.dart`)
- **Tampilan Atas**: Header gradasi biru khas CapCut menggunakan `LinearGradient`.
- **Tombol Utama**: Dua kartu berdampingan ("Video baru" dan "Edit foto").
- **Interaksi**:
  - Klik "Video baru" memicu `MediaPickerSheet.show(...)`.
  - Klik "Edit foto" memunculkan dialog informasi fitur.
  - Klik thumbnail horizontal membuka detail ringkasan proyek.
  - Klik 9 ikon fitur menampilkan `SnackBar` simulasi.

### C. Halaman Template (`lib/screens/template_screen.dart`)
- **Pencarian Real-Time**: `TextField` dengan event `onChanged` memperbarui state `_searchQuery`.
- **Penyaringan Chip**: Kategori (For you, Trending, Selfie, dll.) menyaring daftar template melalui getter `_filteredTemplates`.
- **Katalog Grid**: Menampilkan `GridView` 2 kolom. Kartu template dapat menampilkan gambar foto kustom dari `imagePath` atau warna gradasi fallback jika gambar belum diatur.
- **Gunakan Template**: Menampilkan `showModalBottomSheet` dengan tombol konfirmasi pemilihan klip.

### D. Halaman Proyek (`lib/screens/proyek_screen.dart`)
- **Manajemen Data (CRUD Lokal)**:
  - **Create**: Tombol FAB "+ Buat" membuka media picker dan menambahkan proyek baru ke list.
  - **Read**: Menampilkan daftar proyek beserta durasi dan ukuran file.
  - **Update**: Opsi titik tiga > "Ganti Nama" membuka dialog dengan `TextField`.
  - **Delete**: Opsi titik tiga > "Hapus" membuka konfirmasi `AlertDialog`.
  - **Duplicate**: Menggandakan data proyek menggunakan fungsi `copyWith()`.
- **Mode Pilih**: Tombol "Pilih" memunculkan checkbox pada setiap item proyek.

### E. Halaman Saya (`lib/screens/saya_screen.dart`)
- **Identitas Akun**: Avatar lingkaran, nama `Trcy819`, badge Pro, dan notifikasi merah dengan badge angka 66.
- **Fitur Standar**: Kartu biru muda dengan penawaran uji coba 7 hari.
- **Pengaturan Dark Mode**: Ikon gear membuka dialog dengan `SwitchListTile` untuk mengubah tampilan aplikasi.
- **Banner Tautkan Email**: Banner bawah interaktif yang dapat diisi email atau ditutup dengan tombol silang (X).

---

## 5. KONSEP FLUTTER YANG DITERAPKAN

1. **Stateless vs StatefulWidget**:
   - `StatelessWidget`: Digunakan pada tampilan statis murni yang tidak memerlukan perubahan data lokal secara mandiri.
   - `StatefulWidget`: Digunakan ketika ada variabel yang berubah seiring waktu (contoh: tab aktif, query pencarian, daftar proyek, toggle checkbox).
2. **setState()**:
   - Memberi tahu framework Flutter bahwa data internal telah berubah sehingga widget perlu digambar ulang (`build`).
3. **Lifting State Up**:
   - List `_projects` disimpan di parent (`MainNavigationScreen`) agar halaman Edit dan halaman Proyek dapat berbagi dan menyinkronkan data yang sama secara langsung.
4. **Navigasi Tab (IndexedStack & BottomNavigationBar)**:
   - Menghubungkan indeks tab aktif dengan halaman yang sesuai tanpa rebuild berulang.
5. **Dialog & Modal**:
   - `showDialog()` + `AlertDialog` untuk konfirmasi hapus dan input ganti nama.
   - `showModalBottomSheet()` untuk simulasi antarmuka pemilihan media.
6. **Layouting**:
   - `Row` & `Column` untuk susunan horizontal/vertikal.
   - `Stack` & `Positioned` untuk badge, overlay teks di thumbnail, dan banner melayang.
   - `Expanded` untuk pembagian proporsi ruang yang fleksibel tanpa overflow.
   - `ListView` & `GridView` untuk daftar konten yang bisa di-scroll.

---

## 6. TANYA JAWAB UTP (PREDIKSI PERTANYAAN ASISTEN DOSEN)

### Q1: Mengapa aplikasi menggunakan `IndexedStack` untuk navigasi bawah, bukan `Navigator.push`?
> **Jawaban:**  
> *"IndexedStack digunakan agar keempat halaman utama tetap berada di dalam memori widget tree. Jika menggunakan Navigator.push biasa, setiap kali berpindah tab halaman lama akan dihancurkan (destroyed) dan halaman baru dibuat ulang dari awal, sehingga status scroll atau ketikan di kolom pencarian akan hilang. Dengan IndexedStack, performa lebih cepat dan state setiap tab tetap terjaga."*

---

### Q2: Bagaimana alur penambahan proyek baru saat tombol "Video baru" di Halaman Edit ditekan?
> **Jawaban:**  
> *"Saat tombol Video baru ditekan, fungsi memanggil `MediaPickerSheet.show()`. Ketika pengguna memilih klip dan menekan tombol Tambah, bottom sheet mengeksekusi callback `onConfirmed`. Callback ini mengirim data ke fungsi `_addProject` di `main.dart` yang memanggil `setState()` untuk menyisipkan objek `ProjectModel` baru ke urutan teratas list. Karena list ini dibagikan ke Halaman Edit dan Proyek, kedua halaman langsung ter-update secara bersamaan."*

---

### Q3: Bagaimana fitur pencarian template bekerja secara teknis?
> **Jawaban:**  
> *"Pada file `template_screen.dart`, setiap kali pengguna mengetik di `TextField`, event `onChanged` memperbarui variabel `_searchQuery` melalui `setState()`. Widget kemudian membaca getter `_filteredTemplates` yang menyaring daftar data menggunakan method `.where()`. Getter ini membandingkan apakah judul template atau nama pembuat mengandung teks pencarian (case-insensitive)."*

---

### Q4: Di mana data template disimpan dan bagaimana cara menambahkan foto saya sendiri?
> **Jawaban:**  
> *"Data template disimpan secara lokal di `lib/models/template_model.dart` pada fungsi `getSampleTemplates()`. Untuk menggunakan foto sendiri, kita cukup meletakkan berkas gambar di folder `assets/images/`, mendaftarkan foldernya di `pubspec.yaml`, lalu mengisi properti `imagePath: 'assets/images/nama_foto.jpg'` pada objek `TemplateModel`. Kode sudah dilengkapi `ClipRRect` dan `Image.asset` dengan error builder jika gambar tidak ditemukan."*

---

### Q5: Bagaimana cara kerja tombol Ganti Nama dan Hapus di Halaman Proyek?
> **Jawaban:**  
> *"Untuk Ganti Nama, kita menampilkan dialog `AlertDialog` yang berisi `TextField` dengan `TextEditingController`. Saat tombol Simpan ditekan, teks baru dikirim ke fungsi `_renameProject` untuk mengubah properti `title` berdasarkan `id` proyek.*  
> *Untuk Hapus, kita menampilkan dialog konfirmasi terlebih dahulu untuk mencegah penghapusan tidak sengaja. Jika disetujui, fungsi `_deleteProject` memanggil `projects.removeWhere((p) => p.id == id)` di dalam `setState()`."*

---

### Q6: Bagaimana fitur Mode Gelap diimplementasikan?
> **Jawaban:**  
> *"Di `lib/main.dart`, `MaterialApp` memiliki dua konfigurasi tema: `theme:` (untuk ThemeData Light) dan `darkTheme:` (untuk ThemeData Dark). Properti `themeMode` dikontrol oleh variabel boolean `_isDarkMode`. Di Halaman Saya, terdapat tombol switch yang saat diubah akan memanggil callback `_toggleTheme()` untuk membalik nilai boolean tersebut, sehingga Flutter langsung merender ulang antarmuka dengan palet warna gelap."*
