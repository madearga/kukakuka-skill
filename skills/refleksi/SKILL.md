---
name: refleksi
description: "Fasilitasi retrospektif sprint terstruktur — apa yang berjalan baik, apa yang tidak, dan action item berprioritas dengan pemilik dan tenggat. Gunakan saat menjalankan retrospektif, merefleksikan sprint, membuat action item dari umpan balik tim, atau belajar cara menjalankan retro yang efektif."
---

# Fasilitator Retrospektif Sprint

Jalankan retrospektif terstruktur yang mengangkat insight dan menghasilkan perbaikan yang bisa dikerjakan.

## Konteks

Kamu memfasilitasi retrospektif untuk **$ARGUMENTS**.

Bila user memberi berkas (data sprint, grafik velocity, umpan balik tim, atau catatan retro sebelumnya), baca dulu.

## Instruksi

1. **Pilih format retro** berdasarkan konteks (atau biarkan user memilih):

   **Format A — Mulai / Berhenti / Lanjutkan**:
   - **Mulai**: Apa yang sebaiknya mulai kita lakukan?
   - **Berhenti**: Apa yang sebaiknya kita hentikan?
   - **Lanjutkan**: Apa yang sudah berjalan baik dan layak dipertahankan?

   **Format B — 4D (Disukai / Dipetik / Kurang / Diharapkan)**:
   - **Disukai**: Apa yang tim nikmati?
   - **Dipetik**: Pengetahuan baru apa yang didapat?
   - **Kurang**: Apa yang kurang atau tidak ada?
   - **Diharapkan**: Apa yang seandainya kita punya?

   **Format C — Perahu Layar**:
   - **Angin (mendorong kita)**: Apa yang mendorong kita maju?
   - **Jangkar (menahan kita)**: Apa yang memperlambat kita?
   - **Karang (risiko)**: Bahaya apa yang menghadang di depan?
   - **Pulau (tujuan)**: Ke mana kita mencoba sampai?

2. **Bila user memberi masukan mentah** (mis. sticky note, jawaban survei, pesan Slack):
   - Kelompokkan item yang serupa menjadi tema
   - Identifikasi topik yang paling sering disebut
   - Catat pola suasana (frustrasi, energi, kebingungan)

   Bila belum ada masukan, kumpulkan dulu secara anonim sebelum diskusi, agar suara pertama atau yang paling senior tidak menyetir agenda: word cloud atau rating suasana 1–5, dan item tertulis yang bisa divoting untuk apa yang berjalan baik dan apa yang tidak. Skill `live-polls` dan `live-qa` mencakup keduanya.

3. **Analisis performa sprint**:
   - Tujuan sprint: tercapai atau tidak?
   - Velocity vs komitmen (terlalu banyak dikomitmen? terlalu sedikit?)
   - Blocker yang dijumpai dan bagaimana terselesaikannya
   - Pola kolaborasi (apa yang berhasil, apa yang tidak)

4. **Hasilkan action item berprioritas**:

   | Prioritas | Action Item | Pemilik | Tenggat | Metrik Sukses |
   |---|---|---|---|---|
   | 1 | [Perbaikan spesifik dan bisa dikerjakan] | [Nama/Peran] | [Tanggal] | [Cara kita tahu itu berhasil] |

   - Batasi 2-3 action item (lebih banyak tidak akan dikerjakan)
   - Tiap item harus spesifik, bisa dibebankan, dan terukur
   - Rujuk aksi retro sebelumnya bila tersedia — sudah selesai?

5. **Buat ringkasan retro**:
   ```
   ## Retrospektif Sprint [X] — [Tanggal]

   ### Performa Sprint
   - Tujuan: [Tercapai / Sebagian / Meleset]
   - Dikomitmenkan: [X pts] | Tuntas: [Y pts]

   ### Tema Utama
   1. [Tema] — [ringkasan]

   ### Action Item
   1. [Aksi] — [Pemilik] — [Tenggat]

   ### Bawaan dari Retro Sebelumnya
   - [Aksi sebelumnya] — [Status: Selesai / Berjalan / Belum Mulai]
   ```

Simpan sebagai markdown. Jaga nada membangun — tujuannya perbaikan, bukan menyalahkan.

## Adaptasi kuka

- Untuk satu putaran kukajalan, baca juga fakta dari repo: `git log <branch-default>..<branch-fitur> --oneline`, `.kuka/<fitur>/bukti/`, `.kuka/<fitur>/dasar/`, `.scratch/<fitur>/issues/`, dan refleksi putaran sebelumnya.
- Simpan ringkasan di `.kuka/<fitur>/refleksi-<tanggal>.md`.
- Ini bukan review kode (tahap 4, `deslop`) dan bukan pemeriksaan kesehatan fitur (`rawat-skill-verifikasi`).
- Temuan yang butuh kode menjadi tiket baru lewat pintu `bug`, bukan dikerjakan di sini.
- Aksi yang mengubah aturan alur kuka itu sendiri: tawarkan mencatatnya sebagai ADR di lokasi yang dipakai `kukatanya`, sebagai pertanyaan terpisah.
