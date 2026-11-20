---
name: prinsip-buktikan-berfungsi
description: "Terapkan setelah menyelesaikan tugas, sebelum menyatakan selesai. Verifikasi pada artefak yang sebenarnya (jalankan fiturnya, baca nilai aslinya, periksa diff), bukan pada proksi, laporan diri, atau 'sudah bisa dikompilasi'."
user-invocable: false
version: 1.0.0
license: MIT
metadata:
  hermes:
    tags: [prinsip, verifikasi, bukti]
    related_skills: [prinsip-urutkan-unit-teruji, buat-skill-verifikasi]
---

# Buktikan bahwa ia berfungsi

Verifikasi setiap hasil tugas dengan memeriksa benda aslinya secara langsung. Jangan menyimpulkan dari proksi, laporan diri, atau "sudah bisa dikompilasi".

**Mengapa:** Pekerjaan yang belum diverifikasi kebenarannya tidak diketahui. Verifikasi tidak langsung (waktu ubah berkas, kesegaran output, laporan diri agen, screenshot dari cache) terasa lebih murah daripada pengamatan langsung. Bertindak berdasarkan simpulan yang salah jauh lebih mahal daripada memeriksa sumbernya.

**Pola:** Setelah menyelesaikan tugas apa pun, tanyakan: "bagaimana saya membuktikan ini benar-benar berfungsi?"

Periksa benda aslinya, bukan proksinya:
- Periksa apakah proses hidup secara langsung, bukan lewat keadaan turunan
- Baca nilai yang sebenarnya, bukan representasi dari cache atau turunan
- Saat verifikasi gagal, curigai cara mengamatinya dulu sebelum mencurigai sistemnya

Kode dan fitur:
1. Build (perlu, tapi tidak cukup)
2. Jalankan dan lalui jalur fitur yang sebenarnya
3. Periksa seluruh rantai: apakah data mengalir dari input sampai output?
4. Untuk integrasi, uji seluruh jalur komunikasi dari ujung ke ujung

Delegasi: percayai artefak, bukan laporan diri.
Saat memverifikasi pekerjaan yang didelegasikan, periksa artefak output yang sebenarnya (git diff, isi berkas, perilaku saat berjalan), bukan ringkasan dari delegasinya. Agen melaporkan apa yang mereka niatkan, tidak selalu apa yang terjadi.

## Jadikan pemeriksaan sebagai script bila bisa

Bukti terkuat adalah script deterministik yang menjalankan ulang perbandingan yang sama, bukan sekali lirik mata. Tulis script-nya, jalankan, dan simpan outputnya sebagai artefak yang bisa dijalankan ulang peninjau alih-alih memercayai kata-katamu. Script yang membandingkan output kompilasi lama dan baru menangkap apa yang terlewat oleh sekilas pandang.

Biarkan artefaknya terlihat oleh manusia. Commit hanya untuk pekerjaan besar atau rumit yang jejaknya harus bisa diaudit belakangan, seperti port atau migrasi besar: simpan script dan outputnya di repo bersama perubahan, dengan catatan singkat cara menjalankannya ulang. Kebanyakan pekerjaan cukup dibuat terlihat, tidak perlu di-commit.
