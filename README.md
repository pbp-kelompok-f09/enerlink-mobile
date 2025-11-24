# 🚀 F09 – Enerlink

## 📝 Apa itu Enerlink?

Enerlink adalah aplikasi komunitas olahraga berbasis web yang dirancang untuk mempertemukan individu dengan semangat olahraga yang sama serta memudahkan penyewaan venue olahraga. Melalui Enerlink, pengguna dapat dengan mudah menemukan teman latihan, membentuk komunitas olahraga baru, sekaligus mengakses informasi terkait berbagai venue olahraga yang tersedia untuk disewa di sekitar mereka.

Enerlink sebagai platform untuk mendorong ekosistem olahraga yang mendorong gaya hidup aktif, sehat, dan sosial. Dengan Enerlink, olahraga tidak lagi sekadar aktivitas individu, melainkan menjadi pengalaman bersama yang lebih menyenangkan dan bermakna.

## 👥 Anggota Kelompok
Enerlink dikembangkan oleh kelompok F09, beranggotakan:
1. Vazha Khayri (2406495911)
2. Nalakrishna Abimanyu Wicaksono (2406407594)
3. Nadine Aisyah Putri Maharani (2406408224)
4. Mahesa Gerrardybhumi (2406417992)
5. Hanif Awiyoso Mahendra (2406439854)
6. Muhammad Geriya Itsa (2406434172)

## 🧩 Modul Utama Aplikasi
Modul Utama dalam Aplikasi
Enerlink menggunakan berbagai modul sebagai (CRUD) untuk menunjang penggunaan aplikasi

1. User Dashboard:

- C: Membuat authentication page
- R: Melihat dashboard berisi informasi tentang informasi user, jadwal kegiatan, daftar komunitas yang diikuti.
- U: Pengguna dapat mengedit profil
- D: menghapus kegiatan ataupun keluar dari komunitas. Jika keluar dari komunitas maka kegiatan yang diikuti di komunitas tersebut akan keluar

2. Community Page:

- C: Pengguna dapat membuat komunitas baru sesuai minat atau kegiatan tertentu, seperti komunitas olahraga, musik, atau hobi lainnya.
- R: Pengguna dapat melihat daftar komunitas yang tersedia beserta kegiatan yang sedang atau akan berlangsung di dalam komunitas tersebut.
- U: Admin komunitas dapat memperbarui kategori, deskripsi komunitas, dan juga mengubah jadwal kegiatan yang diadakan oleh komunitas.
- D: Admin komunitas memiliki hak untuk mengeluarkan anggota (user) dari komunitas atau menghapus komunitas secara keseluruhan jika diperlukan.

3. Create Venue:

- C: Admin dapat membuat atau menambahkan venue baru ke dalam sistem. Misalnya, menambahkan gedung olahraga baru beserta fasilitas dan harganya.
- R: Admin dan pengguna dapat melihat detail venue, seperti rating, deskripsi, harga sewa, lokasi, dan kontak pengelola.
- U: Admin dapat mengubah atau memperbarui informasi venue, misalnya mengganti harga atau memperbarui deskripsi
- D: Admin dapat menghapus venue yang sudah tidak tersedia atau tidak ingin ditampilkan lagi di sistem.

4. Create Event

- C: Admin komunitas dapat membuat kegiatan-kegiatan yang ada
- R: anggota komunitas dapat melihat apa saja kegiatan yang terdapat di dalamnya dan bisa join
- U: Admin komunitas dapat melakukan edit jadwal, deskripsi pada kegiatan yang akan dibuat
- D: Admin komunitas dapat delete kegiatan

5. Admin Dashboard

- C: Menambahkan pengguna baru ke sistem, Membuat komunitas baru untuk ditampilkan di platform.
- R: Melihat daftar pengguna yang terdaftar, Menampilkan daftar komunitas yang tersedia, Menampilkan daftar venue yang dapat digunakan.
- U: Mengubah data pengguna (seperti status, informasi akun, atau komunitas yang diikuti), Mengedit detail komunitas (nama, deskripsi, dsb), Memperbarui informasi venue (nama, harga, atau lokasi).
- D: Menghapus pengguna dari daftar, Menghapus komunitas dari sistem, Menghapus venue

6. Sewa Venue

- C: Pengguna dapat melakukan pemesanan atau sewa venue untuk sesi atau tanggal tertentu.
- R: Pengguna dapat melihat detail venue yang ingin disewa, termasuk informasi ketersediaan dan harga.
- U: Pengguna dapat mengubah jadwal atau tanggal sewa jika ada perubahan rencana.
- D: Pengguna dapat membatalkan penyewaan (cancel booking) sebelum waktu sewa dimulai.

7. Forum Komunitas

- C: Membuat post baru di forum dengan mengisi judul, isi konten, dan kategori/topik yang relevan, Menambahkan elemen pendukung, seperti gambar, tautan, atau tag untuk memperjelas isi postingan.
- R: Melihat daftar semua postingan di forum, biasanya diurutkan berdasarkan waktu, popularitas, atau kategori, Membuka satu postingan untuk membaca isi lengkapnya beserta komentar, Melihat informasi tambahan, seperti nama pembuat, tanggal posting, jumlah komentar, dan jumlah like.
- U: Mengedit judul, isi, tag, atau kategori postingan, Melihat preview sebelum menyimpan perubahan.
- D: Menghapus postingan jika merasa sudah tidak relevan atau ingin menariknya dari publik, Setelah dihapus, postingan akan hilang dari tampilan forum

## 👤 User Persona
1. Pengguna (User):
- Menggunakan Enerlink untuk menelusuri komunitas dan venue yang tersedia
- Bergabung komunitas dan mengikuti berbagai kegiatan atau membuat komunitas
- Melakukan penyewaan venue untuk melaksanakan kegiatan
2. Administrator (Admin):
- Mengelola aplikasi
- Mengelola pengguna, venue, dan komunitas
- Memastikan aplikasi tetap aman dan dapat digunakan
3. Admin Komunitas:
- Membuat komunitas olahraga tergantung kategori
- Membuat kegiatan, forum, dan deskripsi utama forum.

## 🔗 Sumber Dataset Event
Dataset yang digunakan dengan tautan berikut: 
https://docs.google.com/spreadsheets/d/1rV8Sp1PiZAfMyHpalQdoNSx9PKFwjRpR3l188N2coGI/edit?usp=sharing

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

## Alur Integrasi
1. Endpoint API Backend dari https://vazha-khayri-enerlink.pbp.cs.ui.ac.id/
2. Menggunakan dotenv library dari Flutter untuk mengambil link backend dari .env
3. Di Flutter akan melakukan request dan menerima response dari endpoint yang dituju
4. Diagram:
```
Flutter   
  ↓  
Pacil Web Service  
  ↓  
HTTP Request  
  ↓  
Django Framework  
  ↓  
Database Postgres
```

## Link 
- Alur Sheets: https://docs.google.com/spreadsheets/d/1zH-FyHCWx9a6bBGQ5zgjocIm-GUWxTVqYs0H9DE2wIo/edit?gid=0#gid=0
- PWS: https://vazha-khayri-enerlink.pbp.cs.ui.ac.id/