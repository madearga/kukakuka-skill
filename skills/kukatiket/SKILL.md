---
name: kukatiket
description: "Pecah spec menjadi tiket .scratch/<fitur>/issues/NN-<slug>.md dengan baris Seam, Bukti selesai, dan Blocked by. Gunakan saat user meminta kukatiket, 'pecah jadi tiket', atau saat alur kukajalan masuk tahap 3."
---

# Kukatiket

Pecah satu spesifikasi menjadi tiket-tiket kecil yang masing-masing bisa dibuktikan sendiri. Satu tiket = satu sesi kerja; kalau lebih, pecah lagi.

Bahan: `.scratch/<fitur>/spec.md` (dari `kukaspek`). Belum ada spec → arahkan ke `kukaspek` dulu.

## Langkah

1. Tulis tiket di `.scratch/<fitur>/issues/NN-<slug>.md`, nomor dua digit (`01`, `02`, ...).

   ```
   # <judul singkat, kata kerja>

   ## Apa
   <perubahan yang dibuat, 1-3 kalimat>

   Seam: <titik uji yang disepakati di spec>

   Bukti selesai: <perintah/pengecekan yang membuktikan tiket ini selesai>

   Blocked by: <nomor tiket saja (01, 02) / nama berkas tiket / None>
   ```

2. Baris wajib tiap tiket: **Seam** dan **Bukti selesai**. **Blocked by** hanya boleh nomor tiket, nama berkas tiket, atau `None` — judul tiket ditolak skrip.
3. Urutan: tiket penghapusan dan scaffold lebih dulu (`principle-subtract-before-you-add`, `principle-foundational-thinking`), lalu irisan vertikal. Tiap tiket satu unit yang bisa dibuktikan sendiri (`prinsip-urutkan-unit-teruji`).
4. Hindari blokir melingkar; kalau terpaksa berantai, pastikan ada tiket bebas di awal.
5. Di dalam alur kuka: jalankan `kuka-status.sh status`. Gerbang tahap 3 gagal berarti tiket diperbaiki dulu; jangan masuk tahap 4.

Format lengkap dan aturan `Blocked by`: `skills/kukajalan/referensi/tiket.md`. Tunjukkan daftar tiket ke user untuk disetujui sebelum `/clear`.
