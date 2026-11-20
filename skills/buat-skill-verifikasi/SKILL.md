---
name: buat-skill-verifikasi
description: "Membuat skill verifikasi lokal-proyek yang menjalankan aplikasi seperti pengguna sungguhan — bahasa, framework, atau platform apa pun. Pakai untuk /buat-skill-verifikasi, \"buatkan skill kontrol untuk repo ini\", \"make a control skill for this repo\", /create-verification-skill, atau saat proyek belum punya cara berskrip untuk membuktikan perilaku UI/CLI/layanan."
menu-description: membuat skill verifikasi lokal-proyek beserta peta fiturnya
version: 1.0.0
license: MIT
metadata:
  hermes:
    tags: [verifikasi, testing, bukti, qa]
    related_skills: [rawat-skill-verifikasi, prinsip-buktikan-berfungsi, prinsip-urutkan-unit-teruji]
---

# Membuat skill verifikasi

Setiap proyek serius butuh cara berskrip untuk menjalankan aplikasi yang sebenarnya dan membuktikan perilakunya: nyalakan, jalankan satu fitur seperti pengguna, lalu simpan buktinya. Skill ini menghasilkan cara itu sebagai skill lokal-proyek (`<folder-skill-proyek>/verifikasi-<app>/`) yang disesuaikan dengan repo. Hasilnya kamu tulis untuk agen berikutnya, bukan untuk manusia. Agen itu akan membacanya tanpa bekal apa pun, di tengah tugas, dan belum pernah melihat aplikasinya.

**Catatan platform.** Lokasi skill yang dihasilkan bergantung pada runtime: `.claude/skills/` di Claude Code, `.hermes/skills/` (atau `.agents/skills/`) di Hermes, dan lokasi skill proyek milik runtime lain untuk Codex dan sejenisnya. Alat untuk menjalankan aplikasi (browser/CDP, PTY/tmux, HTTP) tidak bergantung platform. Padanan nama alat ada di [`platform.md`](referensi/platform.md).

## 1. Wawancarai repo, bukan pengguna

Jawab pertanyaan berikut dari kode. Tanyakan ke pengguna hanya yang tidak bisa kamu amati sendiri:

- **Permukaan:** apa yang benar-benar disentuh pengguna? UI web, CLI/TUI, aplikasi desktop, API, aplikasi mobile, bot chat, library? Satu repo bisa punya beberapa. Pilih yang utama, catat sisanya.
- **Menjalankan:** bagaimana aplikasi dinyalakan secara lokal? Utamakan perintah dev yang sudah didokumentasikan repo (script paket, Makefile, quickstart README). Catat port, variabel env, data awal (seed), dan autentikasi.
- **Mengendalikan:** bagaimana agen bisa berinteraksi dengannya lewat program? Utamakan harness yang sudah ada: spec Playwright/Cypress, script expect, helper PTY, endpoint yang bisa di-curl, port debug. Baru setelah itu pilih resep umum: browser/CDP untuk web dan Electron, harness tmux/PTY untuk CLI/TUI, HTTP biasa untuk layanan.
- **Mengamati:** bukti apa yang bisa diambil? Screenshot, transkrip terminal, isi respons, log, exit code, isi database.
- **Mengisolasi:** bisakah dua instance jalan berdampingan (port, folder data, profil berbeda)? Kalau tidak bisa, tulis itu di skill yang dihasilkan. Menolak mengendalikan instance bersama lebih baik daripada merusak sesi milik pengguna.

Kalau checkout tidak bisa di-build atau dinyalakan apa adanya, perbaiki dulu (atau laporkan dengan tepat) sebelum membuat skill. Skill yang ditulis di atas dasar yang rusak akan mengajarkan langkah yang salah. Kalau ada aset tidak relevan yang hilang dan menghalangi startup (folder statis yang tidak pernah dilayani API, contoh config), skill yang dihasilkan boleh membuatnya, dengan tanda jelas sebagai perancah verifikasi, lalu menghapusnya saat pembersihan.

## 2. Hasilkan skill-nya

Tulis `<folder-skill-proyek>/verifikasi-<app>/SKILL.md` dengan frontmatter YAML: `name: verifikasi-<app>` dan `description` yang menyebut nama aplikasi, permukaannya, dan kapan skill ini dipakai. Tanpa frontmatter, skill tidak pernah terdaftar. Isi bagian-bagian berikut, masing-masing berdasarkan temuan wawancara yang nyata, tanpa placeholder tersisa:

- **Menyalakan:** perintah persis untuk menyalakan aplikasi demi verifikasi, dan cara mengetahui aplikasi sudah siap (baris log, port menjawab, prompt muncul). Sertakan cara mematikannya. Untuk CLI atau TUI yang berumur pendek tidak ada server yang perlu dijaga hidup: menyalakan berarti build binary (atau pasang dependensi) sekali, lalu setiap putaran pengendalian dimulai di sesi PTY atau tmux tersendiri yang terisolasi.
- **Doctor:** satu cek baca-saja yang menjawab "apakah instance ini layak dikendalikan?": proses hidup, versi/build benar, port memang milik kita, autentikasi valid. Agen menjalankannya lebih dulu setiap kali ada yang terlihat janggal.
- **Mengendalikan:** resep harness dengan selector/perintah asli dari repo ini, bukan contoh. Utamakan pegangan yang stabil (label ARIA, atribut data, string prompt, path route) daripada koordinat dan urutan tab.
- **Bukti:** apa yang diambil sebagai bukti dan di mana disimpan. Tuliskan standar buktinya: jalankan jalur pengguna yang sebenarnya, bukan setter internal atau endpoint khusus tes; ambil tindakannya dan keadaan yang dihasilkan, bukan hanya layar terakhir; periksa efek samping (berkas tertulis, baris masuk ke tabel, pesan terkirim) di samping yang terlihat; mock hanya boleh di tempat yang memang sudah diisolasi oleh batas produksi. Kalau jalur aman berupa dry-run atau mode tes, periksa apa yang benar-benar dilewatinya dengan mengamati (berkas, jaringan, ref git), jangan percaya pada namanya. Ada dry-run yang tetap menyentuh jaringan atau membuka browser.
- **Pembersihan:** cara mematikan instance yang dibuat putaran ini. Jangan pernah membunuh proses berdasarkan nama; matikan yang kamu nyalakan. Pembersihan menghapus instance dan data sementara, tidak pernah bukti. Artefak bukti tetap ada setelah pembersihan, di lokasi yang disebut oleh skill.
- **Helper:** setiap script yang ikut dalam skill harus bisa dieksekusi, dan cara memanggilnya ditulis di badan skill. Helper yang harus dibongkar dulu oleh pembacanya bukan helper.

## 3. Isi awal peta fitur

Buat `<folder-skill-proyek>/verifikasi-<app>/fitur/README.md` plus satu berkas per fitur yang dihadapi pengguna yang bisa kamu temukan (mulailah dengan 3–5 teratas, dari route, perintah, menu, atau dokumentasi). Ikuti bentuk di [`referensi/contoh-peta-fitur/`](referensi/contoh-peta-fitur/): satu README sebagai indeks dan satu berkas per fitur. Setiap berkas menjawab, dari sudut pandang pengguna: apa fitur itu, cara mencapainya, cara mengendalikannya dengan harness, dan keadaan akhir teramati apa yang membuktikan fitur itu berfungsi. Empat H2-nya adalah `Sub-fitur`, `Cara mencapainya (sudut pandang pengguna)`, `Mengendalikannya dengan <harness>`, dan `Jebakan`. Peta ini adalah sumber verifikasi yang dirawat untuk repo tersebut. Bukti yang hanya menjalankan satu pintu masuk yang paling gampang belum lengkap kalau peta mencantumkan pintu masuk lain.

## 4. Buktikan skill yang dihasilkan sebelum diserahkan

Jalankan instruksinya sendiri dari awal sampai akhir sekali: nyalakan, doctor, kendalikan SATU fitur yang ada di peta (satu cukup; peta ada supaya putaran berikutnya bisa mencakup sisanya), ambil bukti, bersihkan. Setelah pembersihan, pastikan bukti masih ada di lokasi yang disebut. Pembersihan yang ikut memakan bukti berarti langkah ini gagal. Perbaiki yang gagal, dan jalankan pembersihan yang dihasilkan setiap kali satu percobaan gagal juga, supaya percobaan rusak tidak meninggalkan proses dan port yang tertinggal. Skill hasil yang belum pernah dijalankan masih draf, bukan hasil kerja.

## 5. Tawarkan siklus perawatan

Arahkan pengguna ke `/rawat-skill-verifikasi` untuk menjaga peta tetap jujur seiring aplikasi berubah. Sarankan jadwal hanya kalau mereka bertanya.
