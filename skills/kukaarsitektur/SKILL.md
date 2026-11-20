---
name: kukaarsitektur
description: "Pindai codebase mencari peluang pendalaman (deepening), sajikan sebagai laporan HTML visual, lalu gali habis kandidat yang user pilih. Gunakan saat user meminta kukaarsitektur, review arsitektur, atau perbaikan arsitektur codebase."
disable-model-invocation: true
---

# Kukaarsitektur

Angkat gesekan arsitektural dan usulkan **peluang pendalaman**: refactor yang mengubah modul dangkal menjadi modul dalam. Sasarannya testability dan kemudahan navigasi AI.

Perintah ini _berbasis_ model domain proyek dan memakai kosakata desain bersama:

- Panggil Skill tool dengan "kukadesain" untuk kosakata arsitektur (**module**, **interface**, **depth**, **seam**, **adapter**, **leverage**, **locality**) dan prinsip-prinsipnya (uji penghapusan, "interface adalah permukaan tes", "satu adapter = seam hipotetis, dua = nyata"). Pakai istilah ini persis di setiap usulan, dan jangan melenceng ke "component," "service," "API," atau "boundary."
- Bahasa domain di `GLOSSARY.md` memberi nama pada seam yang baik; ADR di `docs/adr/` mencatat keputusan yang tidak boleh digugat ulang oleh perintah ini.

## Proses

### 1. Jelajahi

**Batasi cakupan sebelum memindai: YAGNI.** Pendalaman modul terbayar dengan memudahkan perubahan mendatang, jadi beri bobot ekstra pada bagian codebase yang baru-baru ini berubah. Putuskan _ke mana_ melihat sebelum melihat:

- Bila user menyebut arah (modul, subsistem, titik nyeri), ambil itu, dan lewati inferensi di bawah.
- Kalau tidak, telusuri rentang yang layak dari riwayat commit (`git log --oneline`) untuk menemukan hot spot codebase — berkas dan area yang terus muncul — dan biarkan path itu menarik perhatianmu lebih dulu. Bila perubahan tersebar tanpa hot spot jelas, perlebar jaring.

Baca dulu glossary domain proyek (`GLOSSARY.md`) dan ADR apa pun di area yang akan kamu sentuh.

Lalu spawn sub-agent dengan context window segar untuk menelusuri codebase. Jangan ikuti heuristik kaku; jelajahi secara organik dan catat di mana kamu mengalami gesekan:

- Di mana memahami satu konsep menuntut melompat-lompat antar banyak modul kecil?
- Di mana modul **dangkal (shallow)**, dengan interface yang nyaris sama kompleksnya dengan implementasinya?
- Di mana fungsi murni diekstrak hanya demi testability, padahal bug sungguhan bersembunyi di cara ia dipanggil (tanpa **locality**)?
- Di mana modul yang erat kopelnya bocor melintasi seam-nya?
- Bagian mana yang tidak teruji, atau sulit diuji lewat interface-nya sekarang?

Terapkan **uji penghapusan** pada apa pun yang kamu curigai dangkal: apakah menghapusnya memusatkan kompleksitas, atau sekadar memindahkannya? "Ya, memusatkan" adalah sinyal yang kamu cari.

### 2. Sajikan kandidat sebagai laporan HTML

Tulis satu berkas HTML mandiri ke direktori temp OS agar tidak ada yang mendarat di repo. Tentukan direktori temp dari `$TMPDIR`, jatuh ke `/tmp` bila kosong (atau `%TEMP%` di Windows), dan tulis ke `<tmpdir>/architecture-review-<timestamp>.html` agar tiap run dapat berkas segar. Buka untuk user (`xdg-open <path>` di Linux, `open <path>` di macOS, `start <path>` di Windows) dan sebutkan path absolutnya.

Laporan memakai **Tailwind via CDN** untuk layout dan styling, dan **Mermaid via CDN** untuk diagram saat graph/flow/sequence mengomunikasikan struktur dengan andal. Campur Mermaid dengan visual CSS/SVG buatan tangan: pakai Mermaid bila hubungannya berbentuk graph (call graph, dependensi, sekuens), dan div/SVG buatan sendiri bila ingin kesan editorial (diagram massa, penampang lapisan, animasi kolaps). Tiap kandidat dapat **visualisasi sebelum/sesudah**. Harus visual.

Untuk tiap kandidat, render kartu berisi:

- **Files**: berkas/modul mana yang terlibat
- **Problem**: mengapa arsitektur sekarang menimbulkan gesekan
- **Solution**: deskripsi polos apa yang akan berubah
- **Benefits**: dijelaskan dengan istilah locality dan leverage, dan bagaimana tes akan membaik
- **Before / After diagram**: berdampingan, digambar khusus, memperlihatkan kedangkalan dan pendalamannya
- **Kekuatan rekomendasi**: salah satu `Strong`, `Worth exploring`, `Speculative`, dirender sebagai badge

Akhiri laporan dengan bagian **Top recommendation**: kandidat mana yang akan kamu kerjakan lebih dulu dan alasannya.

**Pakai kosakata `GLOSSARY.md` untuk domain, dan kosakata `kukadesain` untuk arsitektur.** Bila `GLOSSARY.md` mendefinisikan "Order," bicarakan "modul intake Order," bukan "FooBarHandler," dan bukan "service Order."

**Konflik ADR**: bila sebuah kandidat bertentangan dengan ADR yang ada, angkat hanya bila gesekannya cukup nyata untuk membuka ulang ADR itu. Tandai jelas di kartunya (mis. callout peringatan: _"bertentangan dengan ADR-0007, tapi layak dibuka ulang karena…"_). Jangan mendaftar setiap refactor teoretis yang dilarang ADR.

Lihat [referensi/laporan-html.md](referensi/laporan-html.md) untuk scaffold HTML lengkap, pola diagram, dan panduan styling.

JANGAN mengusulkan interface dulu. Setelah berkas ditulis, tanyakan ke user: "Kandidat mana yang ingin kamu dalami?"

### 3. Loop pendalaman

Begitu user memilih kandidat, panggil Skill tool dengan "kukatanya" untuk menuntun pohon keputusan bersamanya: kendala, dependensi, bentuk modul yang diperdalam, apa yang berada di balik seam, tes mana yang selamat.

Efek samping terjadi seiring keputusan mengkristal; panggil Skill tool dengan "kukadomain" untuk menjaga model domain tetap mutakhir:

- **Menamai modul yang diperdalam dengan konsep yang belum ada di `GLOSSARY.md`?** Tambahkan istilahnya ke `GLOSSARY.md`. Buat berkasnya secara malas bila belum ada.
- **Menajamkan istilah yang kabur selama percakapan?** Perbarui `GLOSSARY.md` di tempat.
- **User menolak kandidat dengan alasan yang menopang?** Tawarkan ADR, dengan bingkai: _"Mau kucatat ini sebagai ADR agar review arsitektur berikutnya tidak mengusulkannya lagi?"_ Hanya tawarkan bila alasannya benar-benar akan dibutuhkan penjelajah berikutnya; lewati alasan sesaat ("tidak worth it sekarang") dan yang sudah jelas.
- **Ingin menjajaki interface alternatif untuk modul yang diperdalam?** Panggil Skill tool dengan "kukadesain" dan pakai pola sub-agent paralel design-it-twice-nya.
