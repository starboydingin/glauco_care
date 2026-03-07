<div align="center">

# 👁️ GlaucoCare — Aplikasi Pemantau Kesehatan Mata

**Aplikasi Flutter untuk membantu penderita glaukoma memantau kondisi mata,<br/>kepatuhan obat, dan gejala secara mandiri.**

<br/>

![Flutter](https://img.shields.io/badge/Frontend-Flutter%203.9%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Language-Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Provider](https://img.shields.io/badge/State-Provider-7C5CBF?style=for-the-badge)
![fl_chart](https://img.shields.io/badge/Chart-fl__chart-5A3D9E?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-4CAF50?style=for-the-badge)

</div>

---

## 📖 Deskripsi Singkat

GlaucoCare dirancang khusus untuk membantu penderita **glaukoma** dalam mengelola kesehatan mata sehari-hari. Aplikasi ini menyediakan pemantauan **tekanan intraokular (IOP)**, pencatatan **jadwal obat**, **self-assessment gejala**, dan konten **edukasi klinis**, semuanya dalam satu platform dengan tampilan modern dark/light mode.

---

## ✨ Sorotan Fitur

- **Dashboard real-time**: ringkasan tekanan mata terkini, grafik tren 7 hari, log obat hari ini, dan CTA self-assessment.
- **Pemantauan Tekanan Mata (IOP)**: catat tekanan mata kiri & kanan, riwayat otomatis, grafik tren per mata.
- **Log Obat**: jadwal obat harian dengan checkbox, progress kepatuhan, tambah/hapus jadwal, animasi swipe-to-delete.
- **Self-Assessment Gejala**: 10 pertanyaan klinis terstandar, skor otomatis, rekomendasi personal, dan breakdown per pertanyaan.
- **Edukasi Glaukoma**: 6 kartu materi klinis + FAQ + profil efek samping obat Timolol & Latanoprost.
- **Dark & Light Mode**: toggle tema adaptif, tersimpan antar sesi via `ThemeProvider`.

---

## 🧱 Stack Utama

| Layer | Teknologi |
|---|---|
| Frontend | Flutter 3.9+, Dart |
| State Management | Provider 6.x (`ChangeNotifier`) |
| Navigasi | go_router 14.x |
| Chart | fl_chart 0.70.x |
| Internationalisasi | intl (locale `id`) |
| Tema | google_fonts, custom `AppTheme` dark/light |
| Platform | Android, iOS, Web, Windows |

---

## 🗂️ Struktur Folder

```
glauco_care/
├── lib/
│   ├── main.dart                        # Entry point, MultiProvider setup
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart          # Seluruh warna & gradien
│   │   │   └── app_strings.dart         # Seluruh string teks aplikasi
│   │   ├── providers/
│   │   │   ├── theme_provider.dart      # Dark/Light mode state
│   │   │   ├── iop_provider.dart        # Data tekanan mata (shared)
│   │   │   └── medication_provider.dart # Data jadwal obat (shared)
│   │   ├── router/
│   │   │   └── app_router.dart          # go_router konfigurasi
│   │   └── theme/
│   │       └── app_theme.dart           # ThemeData dark & light
│   └── presentation/
│       ├── screens/
│       │   ├── splash/                  # Splash screen
│       │   ├── home/                    # HomeScreen + bottom nav bar
│       │   ├── dashboard/               # Dashboard utama
│       │   ├── medication/              # Log obat harian
│       │   ├── eye_pressure/            # Catat & lihat tekanan mata
│       │   ├── assessment/              # Self-assessment 10 pertanyaan
│       │   └── education/               # Edukasi glaukoma & obat
│       └── widgets/
│           ├── eye_logo.dart            # GlaucoEyeLogo CustomPainter
│           └── gradient_card.dart       # Reusable gradient card widget
├── pubspec.yaml
└── README.md
```

---

## 🚀 Instalasi & Menjalankan

### Prasyarat

- Flutter SDK `^3.9.2` — [Install Flutter](https://docs.flutter.dev/get-started/install)
- Dart SDK (sudah termasuk dalam Flutter)
- Android Studio / VS Code dengan ekstensi Flutter

### Langkah-langkah

1. **Clone repositori**
   ```bash
   git clone https://github.com/starboydingin/glauco_care.git
   cd glauco_care
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi**
   ```bash
   # Android / iOS emulator
   flutter run

   # Web browser
   flutter run -d chrome

   # Windows desktop
   flutter run -d windows
   ```

4. **Build release**
   ```bash
   flutter build apk --release        # Android APK
   flutter build appbundle --release  # Android App Bundle
   flutter build web --release        # Web
   ```

---

## 📱 Panduan Penggunaan Fitur

### 1. Dashboard

Dashboard adalah halaman utama yang terbuka setelah splash screen.

| Bagian | Keterangan |
|---|---|
| Kartu Tekanan Mata Terkini | Menampilkan nilai IOP terakhir mata kanan & kiri beserta badge Normal/Tinggi |
| Grafik Tren 7 Hari | Grafik garis interaktif yang otomatis diperbarui saat data baru dicatat |
| Log Obat Hari Ini | Menampilkan progress obat hari ini (diambil langsung dari halaman Obat) |
| Cek Kondisi Mata | CTA card untuk membuka Self-Assessment langsung dari dashboard |
| Toggle Tema | Ikon matahari/bulan di AppBar kanan atas untuk ganti dark/light mode |

---

### 2. Log Obat (Tab Obat)

Halaman untuk mencatat kepatuhan minum/tetes obat harian.

**Cara penggunaan:**

1. **Menandai obat sudah diminum** — ketuk lingkaran checkbox di sebelah kiri nama obat. Nama akan dicoret dan progress bar berubah.
2. **Menambah jadwal obat baru** — ketuk tombol **+** (lingkaran gradien) di pojok kanan atas, lalu isi:
   - *Nama Obat* (contoh: `Timolol 0.5%`)
   - *Waktu* — ketuk kolom waktu untuk membuka time picker
   - *Catatan* (opsional, contoh: `Mata kiri & kanan`)
   - Ketuk **Tambah Jadwal** untuk menyimpan
3. **Menghapus jadwal** — geser tile obat ke kiri, lalu tombol hapus merah akan muncul
4. **Progress kepatuhan** — kartu biru di bagian atas menampilkan jumlah obat diminum / total dan persentase hari ini

> **Catatan:** Data obat otomatis tersinkron ke kartu "Log Obat Hari Ini" di Dashboard.

---

### 3. Catat Tekanan Mata (Tab Tekanan)

Halaman untuk merekam pengukuran tekanan intraokular (IOP).

**Cara penggunaan:**

1. Masukkan nilai tekanan **Mata Kanan** (mmHg) pada kolom pertama
2. Masukkan nilai tekanan **Mata Kiri** (mmHg) pada kolom kedua
3. Ketuk tombol **Simpan** — data tersimpan dan grafik dashboard diperbarui otomatis
4. Riwayat pengukuran ditampilkan dalam daftar di bawah form
5. Grafik tren per mata dapat dilihat langsung di halaman ini

> **Rentang Normal:** 10–21 mmHg. Nilai di atas 21 mmHg akan menampilkan badge **Tinggi** di dashboard.

---

### 4. Self-Assessment Gejala

Tersedia melalui tombol **"Mulai Self-Assessment"** di Dashboard, atau di AppBar beranda. Assessment ini membantu mengenali perubahan gejala yang mungkin berkaitan dengan glaukoma.

**Cara penggunaan:**

1. **Halaman Landing** — baca deskripsi singkat, lalu ketuk **Mulai Self-Assessment**
2. **10 Pertanyaan** — untuk setiap pertanyaan, pilih satu jawaban yang paling sesuai kondisimu:
   - Setiap pertanyaan memiliki 4 pilihan (skor 0–3)
   - Ketuk **Selanjutnya** untuk lanjut ke pertanyaan berikutnya
   - Progress bar di atas menunjukkan nomor pertanyaan saat ini
3. **Lihat Hasil** — setelah pertanyaan ke-10, ketuk **Lihat Hasil**
4. **Halaman Hasil** menampilkan:
   - **Status kondisi** dengan warna dan ikon
   - **Rekomendasi personal** berdasarkan skor
   - **Breakdown skor** per 10 pertanyaan dengan progress bar
   - Tombol **Kembali ke Dashboard** untuk kembali
   - Tombol **Ulangi Asesmen** untuk mengisi ulang

**Interpretasi skor:**

| Total Skor | Status | Arti |
|---|---|---|
| 0 – 9 | 🟢 Kondisi Stabil | Gejala dalam batas normal |
| 10 – 19 | 🟡 Perlu Dipantau | Ada gejala yang patut diperhatikan |
| 20 – 30 | 🔴 Konsultasi Dokter | Gejala signifikan, segera hubungi dokter |

> **Disclaimer:** Self-assessment ini bukan pengganti diagnosis dokter. Hasil hanya sebagai panduan awal.

---

### 5. Edukasi Glaukoma (Tab Edukasi)

Berisi konten klinis terstruktur untuk membantu pengguna memahami glaukoma dan pengobatannya.

**Konten tersedia:**

| Kartu | Isi |
|---|---|
| Apa itu Glaukoma? | Definisi, mekanisme kerusakan saraf optik akibat tekanan tinggi |
| Faktor Risiko | Riwayat keluarga, usia, tekanan mata tinggi, kondisi komorbid |
| Cara Penggunaan Obat Tetes | Langkah benar meneteskan obat, interval antar obat berbeda |
| Pentingnya Kontrol Rutin | Frekuensi pemeriksaan, tes lapang pandang, OCT |
| Gaya Hidup & Glaukoma | Aktivitas yang perlu dihindari, pola tidur, nutrisi |
| Apakah Glaukoma Bisa Disembuhkan? (FAQ) | Penjelasan kondisi kronis, target terapi, prognostik |

**Profil Efek Samping Obat:**
- Ketuk kartu **Timolol** atau **Latanoprost** untuk melihat detail efek samping yang perlu diwaspadai

---

### 6. Dark / Light Mode

- Ketuk ikon **matahari** ☀️ (light mode) atau **bulan** 🌙 (dark mode) di AppBar kanan atas
- Tema tersimpan otomatis dan konsisten di seluruh halaman

---

## 🎨 Panduan Warna

| Warna | Hex | Digunakan untuk |
|---|---|---|
| Primary Dark | `#5A3D9E` | Elemen utama, gradient, tombol |
| Primary Light | `#7C5CBF` | Aksen, ikon aktif |
| Status Sehat | `#1DE9B6` | Badge Normal, checkbox tercentang |
| Status Pantau | `#FFAB40` | Badge Perlu Dipantau |
| Status Bahaya | `#E85B5B` | Badge Tinggi / Konsultasi Dokter |
| Background Dark | `#0A0B1A` | Latar belakang mode gelap |

---

## 🤝 Kontribusi

1. Fork repositori ini
2. Buat branch baru: `git checkout -b fitur/nama-fitur`
3. Commit perubahan: `git commit -m "feat: deskripsi singkat"`
4. Push ke branch: `git push origin fitur/nama-fitur`
5. Buat Pull Request ke branch `main`

---

## 📄 Lisensi

Proyek ini dikembangkan untuk keperluan tugas/proyek akademik. Dilarang dipublikasikan ulang tanpa izin.
