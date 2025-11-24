\documentclass{article}
\usepackage{hyperref}
\usepackage{enumitem}
\usepackage{graphicx}

\title{Enerlink — Dokumentasi Proyek Django \& Flutter}
\date{}

\begin{document}
\maketitle

\section*{Tentang Enerlink}

\subsection*{Apa itu Enerlink?}

Enerlink adalah aplikasi komunitas olahraga berbasis web dan mobile yang dirancang untuk mempertemukan individu dengan semangat olahraga yang sama serta memudahkan penyewaan venue olahraga. Melalui Enerlink, pengguna dapat menemukan teman latihan, membentuk komunitas olahraga baru, serta mengakses informasi venue yang tersedia untuk disewa di sekitar mereka.

Enerlink berfungsi sebagai platform yang mendorong ekosistem olahraga yang aktif, sehat, dan sosial. Dengan Enerlink, olahraga tidak lagi bersifat individual, melainkan pengalaman bersama yang menyenangkan dan bermakna.

\subsection*{Tautan Deployment Django}
\begin{itemize}
    \item Aplikasi Enerlink (Web): \url{https://vazha-khayri-enerlink.pbp.cs.ui.ac.id/}
\end{itemize}

\subsection*{Anggota Kelompok (Proyek Django)}
\begin{enumerate}
    \item Vazha Khayri (2406495911)
    \item Nalakrishna Abimanyu Wicaksono (2406407594)
    \item Nadine Aisyah Putri Maharani (2406408224)
    \item Mahesa Gerrardybhumi (2406417992)
    \item Hanif Awiyoso Mahendra (2406439854)
    \item Muhammad Geriya Itsa (2406434172)
\end{enumerate}

\subsection*{Modul Utama dalam Aplikasi Django Enerlink}

\textbf{1. User Dashboard}
\begin{itemize}[leftmargin=*]
    \item C: Pembuatan halaman autentikasi.
    \item R: Melihat dashboard berisi info user, jadwal kegiatan, dan komunitas.
    \item U: Edit profil.
    \item D: Menghapus kegiatan atau keluar komunitas.
\end{itemize}

\textbf{2. Community Page}
\begin{itemize}[leftmargin=*]
    \item C: Membuat komunitas baru.
    \item R: Melihat daftar komunitas dan aktivitasnya.
    \item U: Edit kategori, deskripsi, jadwal kegiatan.
    \item D: Mengeluarkan anggota atau menghapus komunitas.
\end{itemize}

\textbf{3. Create Venue}
\begin{itemize}[leftmargin=*]
    \item C: Admin membuat venue baru.
    \item R: Melihat detail venue (harga, lokasi, rating).
    \item U: Edit venue.
    \item D: Hapus venue.
\end{itemize}

\textbf{4. Create Event}
\begin{itemize}[leftmargin=*]
    \item C: Admin komunitas membuat event.
    \item R: Anggota melihat dan join event.
    \item U: Edit jadwal dan deskripsi event.
    \item D: Menghapus event.
\end{itemize}

\textbf{5. Admin Dashboard}
\begin{itemize}[leftmargin=*]
    \item C: Menambahkan user dan komunitas.
    \item R: Melihat seluruh data.
    \item U: Mengubah data user/komunitas/venue.
    \item D: Menghapus data.
\end{itemize}

\textbf{6. Sewa Venue}
\begin{itemize}[leftmargin=*]
    \item C: Booking venue.
    \item R: Melihat detail venue dan jadwal.
    \item U: Reschedule.
    \item D: Cancel booking.
\end{itemize}

\textbf{7. Forum Komunitas}
\begin{itemize}[leftmargin=*]
    \item C: Membuat post.
    \item R: Melihat list postingan.
    \item U: Edit post.
    \item D: Hapus post.
\end{itemize}

\subsection*{Dataset}
\url{https://docs.google.com/spreadsheets/d/1rV8Sp1PiZAfMyHpalQdoNSx9PKFwjRpR3l188N2coGI/edit?usp=sharing}

\subsection*{User Persona}
\begin{itemize}
    \item \textbf{Pengguna (User)}: Menelusuri komunitas, venue, bergabung komunitas, menyewa venue.
    \item \textbf{Administrator}: Mengelola pengguna, venue, komunitas.
    \item \textbf{Admin Komunitas}: Membuat komunitas, kegiatan, dan forum.
\end{itemize}

\vspace{1cm}

\section*{Rencana Kerja Proyek Akhir Flutter (17 November – 21 Desember 2025)}

\subsection*{Pekan 1 — Inisialisasi Repo + Design}

\textbf{Kegiatan Kelompok}
\begin{itemize}
    \item Setup repo Flutter, struktur folder, dan memilih state management.
    \item Menyusun design system (warna, font, spacing, komponen dasar).
    \item Membuat wireframe seluruh modul.
    \item Membuat high-fidelity awal masing-masing modul di Figma.
    \item Finalisasi pembagian modul sesuai WBS.
\end{itemize}

\textbf{Kegiatan Per Orang (lebih detail)}
\begin{itemize}
    \item \textbf{Hanif (Dashboard)}: Mendesain komponen profil, kartu jadwal kegiatan, kartu komunitas; menentukan icon, layout, dan warna.
    \item \textbf{Mahesa (Community)}: Mendesain halaman list komunitas, detail komunitas, dan form create komunitas.
    \item \textbf{Geriya (Venue+Sewa)}: Mendesain list venue, detail venue, form create venue, dan form sewa + pemilihan tanggal.
    \item \textbf{Vazha (Events)}: Mendesain list event, detail event, dan form event.
    \item \textbf{Nala (Forum)}: Mendesain list post, detail post, komentar, dan form create/edit post.
    \item \textbf{Nadine (Admin)}: Mendesain dashboard admin, tabel user/komunitas/venue, serta flow edit/hapus.
\end{itemize}


\subsection*{Pekan 2 — Finalisasi Design + Implement UI Statis + Pembuatan Model Data}

\textbf{Kegiatan Kelompok}
\begin{itemize}
    \item Finalisasi Figma untuk semua modul (responsive rules, spacing fix, typography fix).
    \item Implementasi UI statis tiap modul sesuai desain Figma.
    \item Pembuatan theme global \& komponen reusable (card, button, textfield, bottomnav).
    \item \textbf{Membuat model data Dart untuk semua entitas} (User, Komunitas, Event, Venue, Forum) sesuai struktur JSON Django.
\end{itemize}

\textbf{Kegiatan Per Orang (lebih detail)}
\begin{itemize}
    \item \textbf{Hanif}: Implement UI profil user, jadwal kegiatan, daftar komunitas; membuat komponen card jadwal \& profile header.
    \item \textbf{Mahesa}: Implement UI komunitas: list komunitas (card), detail komunitas (anggota, event terkait), dan form create komunitas.
    \item \textbf{Geriya}: Implement UI venue (list venue, detail venue lengkap dengan section fasilitas, harga, lokasi), form create venue, form sewa + kalender.
    \item \textbf{Vazha}: Implement UI event (list event dengan tag kategori, detail event dengan poster), form event dengan field tanggal \& waktu.
    \item \textbf{Nala}: Implement UI forum (card post: avatar, nama, waktu, isi preview), halaman detail post, form editor post (judul, kategori, konten).
    \item \textbf{Nadine}: Implement UI admin (tabel user, komunitas, venue), form edit data, dialog konfirmasi delete.
\end{itemize}


\subsection*{Pekan 3 — Implementasi Fungsionalitas + Integrasi API}

\textbf{Kegiatan Kelompok}
\begin{itemize}
    \item Integrasi GET API untuk seluruh modul.
    \item Implementasi CRUD awal (POST/PUT/DELETE).
    \item Implementasi state management agar UI otomatis update.
\end{itemize}

\textbf{Kegiatan Per Orang (lebih detail)}
\begin{itemize}
    \item \textbf{Hanif}: Integrasi data profil user, jadwal, komunitas; implement edit profil; implement delete kegiatan; testing refresh otomatis.
    \item \textbf{Mahesa}: Integrasi komunitas (GET); implement create/edit komunitas; fitur keluarkan anggota; delete komunitas oleh admin komunitas.
    \item \textbf{Geriya}: Integrasi venue (GET); implement create/edit/delete venue; implement booking venue (create booking), reschedule, dan cancel booking.
    \item \textbf{Vazha}: Integrasi event (GET); implement CRUD event oleh admin komunitas; memastikan event terhubung ke komunitas.
    \item \textbf{Nala}: Integrasi forum (GET); implement create post, edit post, delete post; memastikan komentar \& metadata tampil benar.
    \item \textbf{Nadine}: Integrasi data admin; implement CRUD user, komunitas, dan venue; pastikan perubahan langsung muncul di tabel admin.
\end{itemize}


\subsection*{Pekan 4 — Testing + Polishing}

\textbf{Kegiatan Kelompok}
\begin{itemize}
    \item Testing end-to-end alur aplikasi.
    \item Perbaikan bug UI dan fungsi.
    \item Polishing desain agar konsisten.
\end{itemize}

\textbf{Kegiatan Per Orang}
\begin{itemize}
    \item \textbf{Hanif}: Test flow dashboard (edit profil, hapus kegiatan, keluar komunitas).
    \item \textbf{Mahesa}: Test komunitas (create, edit, remove anggota, delete komunitas).
    \item \textbf{Geriya}: Test venue \& sewa venue.
    \item \textbf{Vazha}: Test event (buat, edit, hapus event).
    \item \textbf{Nala}: Test forum (tambah, edit, delete post).
    \item \textbf{Nadine}: Test admin panel (CRUD lengkap).
\end{itemize}


\subsection*{Pekan 5 — Finalisasi + Build Release}

\textbf{Kegiatan Kelompok}
\begin{itemize}
    \item Build APK melalui Bitrise.
    \item Update README final.
    \item Persiapan presentasi.
\end{itemize}

\textbf{Kegiatan Per Orang}
\begin{itemize}
    \item \textbf{Semua}: Testing final \& polish UI.
    \item \textbf{Hanif}: Finalisasi dashboard.
    \item \textbf{Mahesa}: Finalisasi komunitas.
    \item \textbf{Geriya}: Finalisasi venue \& sewa venue.
    \item \textbf{Vazha}: Finalisasi event.
    \item \textbf{Nala}: Finalisasi forum.
    \item \textbf{Nadine}: Finalisasi admin panel.
\end{itemize}

\subsection*{Alur Integrasi Backend}
\begin{verbatim}
Flutter
  ↓
Pacil Web Service
  ↓
HTTP Request
  ↓
Django Framework
  ↓
Database Postgres
\end{verbatim}

\subsection*{Link}
\begin{itemize}
    \item Alur Sheets:
    \url{https://docs.google.com/spreadsheets/d/1zH-FyHCWx9a6bBGQ5zgjocIm-GUWxTVqYs0H9DE2wIo/edit?gid=0}
    \item PWS:
    \url{https://vazha-khayri-enerlink.pbp.cs.ui.ac.id/}
\end{itemize}

\end{document}