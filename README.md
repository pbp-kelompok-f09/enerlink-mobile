# Rencana Kerja Proyek Akhir (17 November – 21 Desember 2025)

## Pekan 1 — Inisialisasi Repo + Design

### Kegiatan Kelompok

* Setup repo Flutter, struktur folder, dan memilih state management.
* Menyusun design system (warna, font, spacing, komponen dasar).
* Membuat wireframe seluruh modul.
* Membuat high-fidelity awal masing-masing modul di Figma.
* Finalisasi pembagian modul sesuai WBS.

### Kegiatan Per Orang (lebih detail)

* **Hanif (Dashboard):** Mendesain komponen profil, kartu jadwal kegiatan, kartu komunitas; menentukan icon, layout, dan warna.
* **Mahesa (Community):** Mendesain halaman list komunitas, detail komunitas, dan form create komunitas.
* **Geriya (Venue+Sewa):** Mendesain list venue, detail venue, form create venue, dan form sewa + pemilihan tanggal.
* **Vazha (Events):** Mendesain list event, detail event, dan form event.
* **Nala (Forum):** Mendesain list post, detail post, komentar, dan form create/edit post.
* **Nadine (Admin):** Mendesain dashboard admin, tabel user/komunitas/venue, serta flow edit/hapus.

## Pekan 2 — Finalisasi Design + Implement UI Statis + Pembuatan Model Data

### Kegiatan Kelompok

* Finalisasi Figma untuk semua modul (responsive rules, spacing fix, typography fix).
* Implementasi UI statis tiap modul sesuai desain Figma.
* Pembuatan theme global & komponen reusable (card, button, textfield, bottomnav).
* **Membuat model data Dart untuk semua entitas** (User, Komunitas, Event, Venue, Forum) sesuai struktur JSON Django.

### Kegiatan Per Orang (lebih detail)

* **Hanif:** Implement UI profil user, jadwal kegiatan, daftar komunitas; membuat komponen card jadwal & profile header.
* **Mahesa:** Implement UI komunitas: list komunitas (card), detail komunitas (anggota, event terkait), dan form create komunitas.
* **Geriya:** Implement UI venue (list venue, detail venue lengkap dengan section fasilitas, harga, lokasi), form create venue, form sewa + kalender.
* **Vazha:** Implement UI event (list event dengan tag kategori, detail event dengan poster), form event dengan field tanggal & waktu.
* **Nala:** Implement UI forum (card post: avatar, nama, waktu, isi preview), halaman detail post, form editor post (judul, kategori, konten).
* **Nadine:** Implement UI admin (tabel user, komunitas, venue), form edit data, dialog konfirmasi delete.

## Pekan 3 — Implementasi Fungsionalitas + Integrasi API

### Kegiatan Kelompok

* Integrasi GET API untuk seluruh modul.
* Implementasi CRUD awal (POST/PUT/DELETE).
* Implementasi state management agar UI otomatis update.

### Kegiatan Per Orang (lebih detail)

* **Hanif:** Integrasi data profil user, jadwal, komunitas; implement edit profil; implement delete kegiatan; testing refresh otomatis.
* **Mahesa:** Integrasi komunitas (GET); implement create/edit komunitas; fitur keluarkan anggota; delete komunitas oleh admin komunitas.
* **Geriya:** Integrasi venue (GET); implement create/edit/delete venue; implement booking venue (create booking), reschedule, dan cancel booking.
* **Vazha:** Integrasi event (GET); implement CRUD event oleh admin komunitas; pastikan event terhubung ke komunitas.
* **Nala:** Integrasi forum (GET); implement create post, edit post, delete post; memastikan komentar & metadata tampil benar.
* **Nadine:** Integrasi data admin; implement CRUD user, komunitas, dan venue; pastikan perubahan langsung muncul di tabel admin.

## Pekan 4 — Testing + Polishing — Testing + Polishing

### Kegiatan Kelompok

* Testing end‑to‑end alur aplikasi.
* Perbaikan bug UI dan fungsi.
* Polishing desain agar konsisten.

### Kegiatan Per Orang

* **Hanif:** Test flow dashboard (edit profil, hapus kegiatan, keluar komunitas).
* **Mahesa:** Test komunitas (create, edit, remove anggota, delete komunitas).
* **Geriya:** Test venue & sewa venue.
* **Vazha:** Test event (buat, edit, hapus event).
* **Nala:** Test forum (tambah, edit, delete post).
* **Nadine:** Test admin panel (CRUD lengkap).

---

## Pekan 5 — Finalisasi + Build Release

### Kegiatan Kelompok

* Build APK melalui Bitrise.
* Update README final.
* Persiapan presentasi.

### Kegiatan Per Orang

* **Semua:** Testing final & polish UI.
* **Hanif:** Finalisasi dashboard.
* **Mahesa:** Finalisasi komunitas.
* **Geriya:** Finalisasi venue & sewa venue.
* **Vazha:** Finalisasi event.
* **Nala:** Finalisasi forum.
* **Nadine:** Finalisasi admin panel.