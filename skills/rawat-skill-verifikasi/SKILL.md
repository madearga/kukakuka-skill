---
name: rawat-skill-verifikasi
description: "Putaran berkala yang menjaga skill verifikasi proyek dan peta fiturnya tetap jujur: pembaca kode paralel per fitur, satu sesi live yang menjalankan setiap fitur, paling banyak satu PR berisi koreksi yang sudah terbukti. Pakai untuk /rawat-skill-verifikasi, \"audit skill verifikasi\", \"audit the verify skill\", atau /maintain-verification-skill."
menu-description: menyelaraskan ulang skill verifikasi dan peta fiturnya yang sudah melenceng
version: 1.0.0
license: MIT
metadata:
  hermes:
    tags: [verifikasi, perawatan, testing, qa]
    related_skills: [buat-skill-verifikasi, prinsip-buktikan-berfungsi]
---

# Merawat skill verifikasi

Peta fitur mulai basi begitu aplikasinya berubah. Skill ini adalah siklus perawatan untuk skill yang dibuat oleh `/buat-skill-verifikasi` (atau skill verifikasi lokal-proyek lain yang punya peta fitur). Satuan ketelitiannya adalah fitur, bukan setiap kalimat: setiap berkas fitur dibaca dari kode dan setiap fitur dijalankan secara live, tanpa harus mengeksekusi setiap butir di terminal.

**Catatan platform.** Pembaca kode paralel per fitur di bawah dijalankan dengan alat subagent milik runtime: `Agent`/`Task` di Claude Code, `delegate_task(tasks=[...])` di Hermes, `spawn_agent` di Codex. Skill lokal-proyek berada di lokasi skill proyek runtime-mu. Lihat [`platform.md`](referensi/platform.md).

## Hasil

Pilih satu, dan sebutkan yang mana:

- **bersih** — setiap fitur sudah dicakup dari kode dan secara live; tidak ada yang layak dikirim. Tanpa branch, tanpa PR.
- **berubah** — satu PR mengirim koreksi dokumen, harness, atau peta yang sudah terbukti.
- **terblokir** — cakupan tidak bisa diselesaikan, atau perbaikan yang terbukti tidak bisa dikirim dengan aman. Sebutkan persis apa yang memblokirnya.

## Batas suntingan

Hanya sunting folder milik skill verifikasi itu sendiri (SKILL.md-nya, `fitur/`, dan script harness yang dimilikinya). Jangan pernah menyunting kode produk selama putaran ini. Perilaku yang dijelaskan peta tetapi tidak lagi dilakukan aplikasi hanya punya dua kemungkinan: dokumen yang melenceng (perbaiki petanya) atau regresi produk (laporkan, jangan ditutupi di dokumen).

## Putaran

0. **Temukan targetnya.** Cari skill verifikasi yang akan dirawat: skill lokal-proyek yang badannya punya bagian menyalakan/mengendalikan dan peta fitur (biasanya `<folder-skill-proyek>/verifikasi-*/`, atau `verify-*/` untuk skill buatan versi Inggris). Ada beberapa kandidat → tanya yang mana. Tidak ada sama sekali → berhenti dan arahkan ke `/buat-skill-verifikasi`, jangan mengarang target.

1. **Kebersihan indeks.** Baca README peta fitur dan daftar berkas saudaranya. Perbaiki entri yang hilang, berlebih, ganda, atau mati. Ringan saja; tidak perlu inventaris hasil generate.

2. **Gelombang kode.** Satu subagent baca-saja per berkas fitur, diluncurkan bersamaan. Masing-masing menjelaskan "bagaimana fitur yang dihadapi pengguna ini bekerja?" dari kode, menandai dugaan dokumen melenceng beserta kutipan lokasinya, dan mengembalikan satu resep verifikasi live yang ringkas. Subagent tidak pernah mengendalikan aplikasi dan tidak pernah menyunting berkas. Bentuk jawabannya: ringkasan fitur / titik masuk di kode / dugaan melenceng atau tidak ada / satu resep. (Di Hermes, batas paralel default 10 subagent per panggilan; kalau fitur lebih banyak, bagi ke beberapa gelombang.)

3. **Rekonsiliasi.** Setiap berkas fitur harus punya ringkasan yang kembali. Gabungkan resep yang tumpang tindih ke sesedikit mungkin keadaan aplikasi. Periksa acak dugaan melenceng yang dikutip; jangan membuktikan ulang klaim yang bersih. Sisir perubahan terbaru untuk mencari permukaan pengguna yang belum ada di peta. Wajib ada path kode yang konkret sebelum menyebut satu fitur hilang dari peta.

4. **Putaran live.** Wajib, bahkan saat kode terlihat bersih. Koordinator memegang seluruh pengendalian. Ikuti model menyalakan milik skill verifikasi itu sendiri: satu instance berumur panjang yang dikendalikan berurutan untuk server dan UI, atau sesi baru yang terisolasi per putaran untuk CLI berumur pendek (bagian Menyalakan di skill itu yang menentukan, bukan skill ini). Jalankan setiap fitur minimal sekali, dan pegang tiga invarian sepanjang putaran, apa pun kegagalannya:
   1. Jangan pernah mengendalikan instance yang belum dicek kesehatannya sejak terakhir kali ia melakukan sesuatu yang mengejutkan. Doctor sebelum pengendalian pertama, doctor di setiap sesi baru bila sesi adalah satuannya, doctor lagi setelah setiap pengendalian yang gagal. Kalau doctor tidak bisa melihat kegagalannya (UI macet di proses yang sehat), reset ke keadaan yang diketahui atau nyalakan ulang, jangan berharap.
   2. Bukti yang sudah diambil tetap selamat melewati setiap pembersihan. Ini diperiksa di lokasi yang disebut, bukan diasumsikan.
   3. Tidak ada yang dinyalakan oleh satu pengendalian yang hidup melebihi masa gunanya. Sisa percobaan gagal dibersihkan, entah sesinya macet, sudah keluar, atau dipakai bersama (untuk instance bersama, bersihkan sisanya, bukan instance-nya).

   Kegagalan doctor yang disebabkan skill yang melenceng adalah dokumen melenceng: perbaiki dalam batas suntingan dan coba ulang sekali — nyalakan ulang hanya yang tidak berlaku lagi karena perbaikan itu, tidak lebih — sebelum menyebut putaran `terblokir`. Fitur yang tidak bisa dicapai baru boleh disebut `terverifikasi-tak-tercapai` bila disertai prasyarat konkretnya (autentikasi, hak akses, OS, keadaan eksternal) dan rute yang dicoba; kalau peta tidak menyebut prasyarat itu, itu juga dokumen melenceng. Setiap perbaikan harness dari triase dijalankan ulang secara live sebelum dikirim. Pembersihan akhir dilakukan setelah pengendalian terakhir dalam putaran — termasuk pembuktian ulang tadi — sehingga tidak ada yang hidup melebihi putarannya (bukti tetap disimpan, sesuai skill).

5. **Triase.** Deskripsi sudut pandang pengguna yang salah atau hilang → dokumen melenceng, perbaiki. Perilaku yang berfungsi tetapi tidak bisa dikendalikan harness → celah harness, perbaiki; perbaikan harness mengikuti aturan helper yang sama dengan saat pembuatan (script bisa dieksekusi, cara memanggilnya ditulis di badan skill). Perilaku aplikasi yang memang rusak → celah produk; catat untuk pengguna, keluarkan dari PR ini.

6. **Kirim atau berhenti.** Untuk hasil berubah: satu PR berisi koreksi yang terbukti, baca ulang setiap berkas yang diubah lebih dulu. Untuk hasil bersih atau terblokir: tanpa PR, laporkan hasil dan cakupannya dengan jujur.

Simpan catatan putaran yang ringkas (fitur yang dicakup, prasyarat yang tak tercapai, dokumen melenceng yang terkonfirmasi, hasil) di lokasi sementara; jangan di-commit.
