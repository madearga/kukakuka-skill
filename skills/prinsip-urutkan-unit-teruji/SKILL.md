---
name: prinsip-urutkan-unit-teruji
description: "Terapkan pada pekerjaan banyak langkah (sapuan, migrasi, rangkaian suntingan serupa) dan pada cara menumpuk commit serta PR. Pecah pekerjaan menjadi unit kecil yang masing-masing berakhir di keadaan yang bisa diperiksa, cek tiap unit sebelum lanjut, dan urutkan pengiriman supaya rangkaiannya membuktikan dirinya kepada peninjau."
user-invocable: false
version: 1.0.0
license: MIT
metadata:
  hermes:
    tags: [prinsip, verifikasi, commit, migrasi]
    related_skills: [prinsip-buktikan-berfungsi]
---

# Urutkan pekerjaan menjadi unit yang bisa diverifikasi

Susun pekerjaan sebagai rangkaian unit kecil, masing-masing berakhir di keadaan yang bisa kamu periksa, dan jangan maju sampai unit saat ini hijau. Disiplin yang sama berlaku di dua tingkat: cara kamu mengerjakan dan cara kamu mengirimkan.

**Mengapa:** Kerusakan yang tertangkap di unit penyebabnya murah untuk dilokalisasi. Kerusakan yang tertangkap setelah satu batch terkubur, dan kamu sudah membangun lebih jauh di atas dasar yang rusak. Mengurutkan unit-unit yang sama menjadi kiriman yang bisa diputar ulang peninjau mengubah "percayalah" menjadi "lihat ia merah, lalu hijau".

**Pengerjaan.** Dalam sapuan, migrasi, atau rangkaian suntingan serupa apa pun, verifikasi setiap perubahan sebelum memulai yang berikutnya. Jangan pernah mengumpulkan suntingan lalu memverifikasi sekali di akhir. Setiap unit adalah kurung sebelum/sesudah: keadaan yang diketahui baik, satu perubahan, jalankan cek, baru lanjut. Rebase ke trunk yang bersih lebih dulu supaya setiap cek mengukur terhadap baseline yang sebenarnya. Kalau suntingannya dikerjakan oleh alat bantu (script, codemod, generator), cek per unit hampir gratis; jalankan tetap.

**Pengiriman.** Tumpuk commit dan PR dalam urutan yang membuktikan pekerjaannya. Bentuk bakunya: tes yang gagal dulu, lalu perbaikan di atasnya. Unit pertama menunjukkan bug-nya nyata (merah), unit berikutnya menunjukkan sudah teratasi (hijau), sehingga peninjau melihat masalah sekaligus buktinya. Urutan cerita lain: pengurangan sebelum pembentukan ulang, rekam baseline sebelum perlakuan, perancah sebelum fitur. Setiap commit bisa berdiri sendiri dan rangkaiannya terbaca sebagai argumen.

**Pola:**
- Pilih unit terkecil yang berakhir dengan cek: satu suntingan plus tesnya, atau satu commit yang berdiri sendiri.
- Verifikasi sebelum maju. Merah ke hijau per unit, tidak pernah ditunda ke batch terakhir.
- Urutkan unit supaya rangkaiannya membangun keyakinan dengan sendirinya, bagimu saat mengerjakan dan bagi peninjau yang membaca tumpukannya.

Pelengkap urutan untuk prinsip **prinsip-buktikan-berfungsi**, yang menjaga setiap cek tetap nyata. Pasangannya yang lain: kalau cek per unit terasa mahal, bangun dulu alat yang membuatnya murah (script, fixture, harness) sebelum mulai menyapu.
