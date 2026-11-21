---
name: kukaspek
description: "Tulis spesifikasi .scratch/<fitur>/spec.md dari keputusan kukatanya: masalah, solusi, seam tes, di luar cakupan. Gunakan saat user meminta kukaspek, 'tulis spec', atau saat alur kukajalan masuk tahap 2."
---

# Kukaspek

Tulis spesifikasi untuk satu fitur. Bahannya keputusan yang sudah disepakati, bukan tebakan.

Sumber utama: `dokumen-keputusan` dari `.kuka/jalan.md` (hasil `kukatanya`, default `.scratch/<fitur>/keputusan.md`) dan `GLOSSARY.md` untuk istilah. Dipakai sendirian tanpa alur kuka: tanyakan dulu fitur apa dan keputusan apa yang sudah ada. Belum ada keputusan → arahkan ke `kukatanya` dulu, jangan mengarang sepakat.

## Langkah

1. Tulis `.scratch/<fitur>/spec.md` mengikuti templat [referensi/spec.md](referensi/spec.md): masalah, solusi, seam tes, di luar cakupan.
2. Rujuk `dokumen-keputusan` di bagian Masalah atau Solusi.
3. Keputusan berstatus `terbuka` atau `menunggu fakta` ditulis sebagai tertunda, bukan diam-diam dianggap sepakat.
4. Istilah yang dipakai harus konsisten dengan `GLOSSARY.md`.
5. Di dalam alur kuka: jalankan `kuka-status.sh status`. Gerbang tahap 2: spec ada dan tidak kosong, dan `dokumen-keputusan` tidak menunjuk spec.md. Bagian seam tes wajib kamu isi, tapi tidak dicek skrip; skrip menegakkan **Seam** per tiket di tahap 3.

Tunjukkan spec ke user untuk disetujui atau dikoreksi sebelum lanjut ke tiket.
