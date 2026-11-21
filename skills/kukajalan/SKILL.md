---
name: kukajalan
description: "Pemandu alur kerja kuka dari ide sampai PR: kukatanya → spec → tiket → implementasi per tiket → bukti → no-mistakes, dengan gerbang yang dicek skrip dan skill pstack di titik yang tepat. Gunakan saat user meminta kukajalan, 'lanjut', 'langkah berikutnya', 'sekarang di mana', memulai fitur/bug baru dengan alur kuka, atau bertanya what's next / workflow status."
---

# Kukajalan

Kukajalan memandu satu pekerjaan dari ide sampai PR. Ia membaca keadaan repo, menyebut tahap sekarang, memeriksa gerbang, dan menyebut langkah persis berikutnya. Sebagian langkah dikerjakan agen sendiri (spec, tiket, implementasi per tiket); keputusan dan merge tetap milik user.

Pembagian kekuasaan:

- **Urutan** dan **definisi "selesai"** sama-sama milik kuka: tahap selalu berurut seperti tabel di bawah, dan tiket belum selesai sebelum ada bukti dari benda aslinya (lihat skill `prinsip-buktikan-berfungsi`).
- **Disiplin di dalam tahap** milik pstack, hanya skill yang tercantum di [referensi/pstack.md](referensi/pstack.md).

## Langkah pertama, selalu

Jalankan skrip status dari folder skill ini (folder tempat `SKILL.md` ini berada), di root repo proyek:

```bash
<folder-skill>/alat/kuka-status.sh
```

Skrip itu sumber kebenaran tentang tahap. Jangan menebak tahap dari ingatan percakapan: ingatan hilang setiap `/clear`, repo tidak. Bila skrip dan ingatanmu berbeda, skrip yang benar; sebutkan perbedaannya ke user.

Bila skrip tidak bisa dijalankan (tanpa shell, tanpa git), katakan begitu, lalu periksa artefak yang sama secara manual dengan urutan pada tabel tahap di bawah. Jangan berpura-pura sudah menjalankan skrip.

## Mulai baru: pintu dan tingkat

Jika skrip melapor `.kuka/jalan.md` belum ada, tanyakan dua hal kepada user. Jangan memilih sendiri.

1. **Pintu**
   - `fitur`: ide atau kebutuhan baru. Mulai dari tahap 1.
   - `bug`: ada yang rusak, atau issue masuk. Lewati tahap 1–2: triage singkat oleh agen, lalu satu tiket.
2. **Tingkat**
   - `ringan`: satu tiket, perubahan kecil. Tanpa skill pstack berbiaya subagent.
   - `standar`: fitur biasa, berurutan satu tiket per sesi.
   - `berat`: fitur besar atau migrasi. Tambah `architect` (fase A–C, dengan checkpoint), `swarm` per gelombang tiket, `interrogate` di akhir, `show-me-your-work` sepanjang jalan.

Tingkat boleh dinaikkan kemudian dengan persetujuan user. Tidak boleh diturunkan diam-diam.

Lalu tulis `.kuka/jalan.md` dengan format `kunci: nilai` (lengkapnya di [referensi/tiket.md](referensi/tiket.md)):

```
pintu: fitur
tingkat: standar
fitur: <slug-fitur>
```

## Tahap dan gerbang

| Tahap | Yang dikerjakan | Siapa mengerjakan | Gerbang untuk lanjut |
|---|---|---|---|
| 0 Siapkan | `no-mistakes init`, branch fitur | agen | `.kuka/jalan.md` lengkap; branch bukan branch default |
| 1 Gali | `kukatanya` | agen | `label-kukatanya:` di `.kuka/jalan.md` bernilai `selesai` atau `siap untuk implementasi` |
| 2 Spesifikasi | `kukaspek` menulis `.scratch/<fitur>/spec.md` | agen | spec ada dan tidak kosong (dicek hanya sebelum tiket ada; setelah tahap 3 spec tidak dicek ulang). Bagian seam tes di spec tanggung jawab agen, tidak dicek skrip; Seam ditegakkan per tiket di tahap 3 |
| 3 Tiket | `kukatiket` menulis tiket di `.scratch/<fitur>/issues/` | agen | setiap tiket punya **Seam** dan **Bukti selesai**; **Blocked by** berformat sah |
| 4 Per tiket | implementasi (tes dulu), bukti, `tandai` | agen | bukti sah di `.kuka/<fitur>/bukti/` dan perubahan kode sejak SHA dasar, sebelum `tandai` |
| 5 Tutup | `interrogate` (berat), `no-mistakes`, `babysit` | agen + user | `no-mistakes` mencapai `checks-passed`; user yang merge |

### Tahap 0: siapkan

1. Tulis `.kuka/jalan.md` (format di [referensi/tiket.md](referensi/tiket.md)). Tiket memakai tracker lokal: berkas biasa di `.scratch/<fitur>/issues/`, tanpa layanan luar.
2. Segera setelah itu, pastikan branch fitur. Commit per tiket masuk ke branch yang sedang aktif; di branch default, commit itu masuk `main`. Skrip melapor `TAHAP 0 Siapkan` selama masih di branch default (atau HEAD terlepas), dan `mulai`/`tandai` ikut menolak. Usulkan `git switch -c <slug-fitur>`, lalu tunggu user.
3. Untuk tahap 5, `no-mistakes init` harus sudah dijalankan di repo. Sebutkan bila belum; jangan jalankan tanpa persetujuan.
4. `no-mistakes` mendorong branch dan membuka PR, jadi butuh remote. Bila `git remote` kosong, katakan sekarang, bukan di tahap 5. Skrip juga memberi peringatan `awas  repo tanpa remote` di tahap 5.

### Tahap 1: gali (kukatanya)

1. Jalankan skill `kukatanya`. Patuhi aturannya sepenuhnya; kukajalan tidak melonggarkan satu pun.
2. Di tahap ini **bertanya adalah tugas**. `principle-never-block-on-the-human` tidak berlaku di tahap 1–3.
3. Tingkat `berat`: sebelum keputusan arsitektur dikunci, tawarkan `architect` fase A–C saja, dengan checkpoint ke user. Alternatif dan pertanyaan terbuka dari rationale-nya kembali ke daftar keputusan dan ADR kukatanya. Jangan biarkan `architect` masuk fase implementasi.
4. Saat kukatanya selesai, tulis `label-kukatanya:` dan `dokumen-keputusan:` (path `.scratch/<fitur>/keputusan.md`; jangan spec.md) ke `.kuka/jalan.md`. `label-kukatanya` menjadi gerbang; `dokumen-keputusan` jadi rujukan `kukaspek` dan dicek skrip untuk satu hal: nilainya tidak boleh sama dengan `.scratch/<fitur>/spec.md`.
5. Gerbang: label `dihentikan` berarti **berhenti**. Laporkan penghambatnya; jangan lanjut ke tahap 2.

### Tahap 2: spesifikasi

1. Jalankan skill `kukaspek`. Patuhi aturannya sepenuhnya; kukajalan tidak melonggarkan satu pun.
2. Jalankan skrip status. Gerbang skrip: spec ada dan tidak kosong, dan `dokumen-keputusan` tidak menunjuk spec.md (penahan agar tahap 2 tidak terlewat). Pastikan sendiri bagian seam tes sudah terisi (tidak dicek skrip); tanpa seam di spec, tiket di tahap 3 tidak punya rujukan **Seam**.

### Tahap 3: tiket

1. Jalankan skill `kukatiket`. Patuhi aturannya sepenuhnya.
2. Jalankan skrip status. Gerbang tiket gagal berarti tiket diperbaiki dulu; jangan masuk tahap 4.
3. Sekarang user boleh `/clear`.

### Tahap 4: per tiket

Skrip menyebut tiket bebas berikutnya (semua pemblokirnya sudah selesai, nomor terkecil menang). Untuk tiap tiket:

1. `alat/kuka-status.sh mulai <NN>`: mencatat SHA dasar di `.kuka/<fitur>/dasar/<NN>` dan menandai tiket sedang dikerjakan. Skrip menjalankan gerbang tahap 0 dan 3 dulu, menolak tiket yang masih diblokir, dan menolak tiket yang sudah selesai (perbaikan atas tiket selesai menjadi tiket baru). `mulai` atas tiket yang sedang dikerjakan tidak menimpa SHA dasarnya.
2. **Implementasi.** Kerjakan sendiri dengan disiplin yang sama di setiap tiket:
   - baca tiket dan seam-nya; seam sudah disepakati di spec, jangan tanyakan ulang;
   - tulis tes dulu pada seam itu dan lihat merah, lalu tulis kode sampai hijau;
   - jalankan tes penuh proyek, bukan hanya tes baru;
   - review sendiri diff sejak SHA dasar di `.kuka/<fitur>/dasar/<NN>`; perbaiki temuan sebelum lanjut;
   - commit; pesan commit memuat path tiket (mis. `Refs .scratch/<fitur>/issues/03-hapus.md`) supaya mudah ditelusuri.
3. **Bukti.** Jalankan perintah di **Bukti selesai** terhadap benda aslinya, plus `blast-radius` untuk perubahan yang menyentuh lebih dari satu modul. Simpan perintah, keluaran, dan kesimpulan ke `.kuka/<fitur>/bukti/<NN>.md` dengan format di [referensi/tiket.md](referensi/tiket.md#berkas-bukti-kukafiturbuktinnmd): setiap perintah ditulis sebagai baris `$ <perintah>` di dalam blok kode, langsung diikuti keluaran aslinya, lalu baris `Kesimpulan:`. Placeholder `<...>` tidak dihitung. Bila proyek punya skill `verifikasi-<app>`, pakai itu. Bila tes atau bukti otomatis tidak praktis, tulis alasannya dan pemeriksaan terdekat yang dijalankan.
4. **Gagal?** Jalankan `diagnosing-bugs` dengan `principle-fix-root-causes`. Perbaikannya commit baru, bukan amend. Ulangi langkah 3.
5. `deslop` atas diff tiket ini, setelah review. Perilaku tidak boleh berubah.
6. `alat/kuka-status.sh tandai <NN>`. Skrip menolak bila gerbang tahap 0 atau 3 gagal, bukti tidak ada, formatnya tidak sah, bukti tidak berubah sejak SHA dasar, atau sejak SHA dasar tidak ada commit yang mengubah berkas di luar `.kuka/` dan `.scratch/`.
7. **Commit catatan alur.** `mulai` dan `tandai` mengubah berkas tanpa commit: `.kuka/<fitur>/dasar/<NN>`, `.kuka/<fitur>/bukti/<NN>.md`, dan baris **Status** tiket lokal. Commit setelah `tandai` dalam satu commit terpisah, mis. `git add .kuka .scratch && git commit -m "kuka: tiket <NN> selesai"`. Commit ini tidak dihitung sebagai perubahan kode tiket mana pun.
8. Minta user `/clear`, lalu `kukajalan` lagi untuk tiket berikutnya.

Di dalam tiket, `principle-never-block-on-the-human` berlaku: kerjakan, lalu tunjukkan. Tindakan yang tidak bisa dibalik (force-push, data produksi, pesan keluar) tetap minta konfirmasi.

Tingkat `berat`: tiket-tiket bebas dalam satu gelombang boleh dikerjakan paralel dengan `swarm` (mode *slices*, satu worktree per tiket). Brief tiap pekerja wajib memuat langkah 2–5. Bukti, `tandai`, dan merge dikerjakan pemandu, satu per satu. `arena` bukan alat paralel tiket; pakai hanya untuk satu tiket berisiko tinggi, atas persetujuan user.

### Tahap 5: tutup

1. Tingkat `berat`: `interrogate` sekali atas seluruh branch (`git diff <branch-default>...HEAD`). Temuan *Act on* menjadi tiket perbaikan, kembali ke tahap 4.
2. `no-mistakes`: `--intent` disusun dari spec dan daftar keputusan kukatanya. Pintu `bug` tidak punya spec: susun dari brief triage di tiket bug. Repo tanpa remote: minta user menambah remote dulu. Patuhi aturan skill `no-mistakes` (temuan `ask-user` diteruskan apa adanya, berhenti di `checks-passed`).
3. `babysit` di sesi utama, bukan di subagent, untuk komentar review dan CI (`fix-ci` sudah tercakup).
4. Bila skill `verifikasi-<app>` ada, sarankan `rawat-skill-verifikasi` setelah merge.
5. Opsional atas permintaan user: `/refleksi` (skill repo ini) untuk memperbaiki alur kuka sendiri.

User yang merge. Kukajalan tidak pernah merge.

## Jalur bug (pintu `bug`)

1. **Triage singkat oleh agen**, tiga pertanyaan: apa gejalanya, apa penyebabnya, apa perbaikan terkecilnya. Jawabannya menjadi brief tiket.
2. Tulis brief itu sebagai satu tiket `.scratch/<fitur>/issues/01-<slug>.md` dengan format [referensi/tiket.md](referensi/tiket.md) (brief masuk ke **What to build**).
3. Tambahkan **Seam** dan **Bukti selesai** ke tiket itu.
4. Masuk tahap 4. Tingkat `ringan` boleh langsung ke `no-mistakes` setelah `tandai`; intent-nya dari brief triage di tiket, bukan spec.

## Kerja arsitektur

`kukaarsitektur` adalah pintu sendiri di luar alur fitur/bug: memindai codebase mencari peluang pendalaman, menyajikan laporan HTML, lalu menggali kandidat pilihan user bersama `kukatanya`. Kandidat yang disepakati tidak dikerjakan di sana: jadikan fitur kecil lewat pintu `fitur` (spec singkat dari `kukaspek`, tiket dari `kukatiket`), atau tiket lewat pintu `bug` bila berupa perbaikan. Gerbang skrip tidak berubah.

## Fitur atau bug berikutnya

`.kuka/jalan.md` hanya satu per repo dan selalu menggambarkan pekerjaan yang sedang berjalan. Setelah PR sebelumnya dibuka (atau di-merge):

1. Pindah ke branch baru dari branch default yang terbaru: `git switch <branch-default> && git pull && git switch -c <slug-baru>`.
2. Tanyakan pintu dan tingkat lagi, lalu tulis ulang `.kuka/jalan.md` dengan `fitur: <slug-baru>`. Hapus kunci milik pekerjaan lama (`label-kukatanya`, `dokumen-keputusan`).
3. Slug baru berarti folder baru: `.scratch/<slug-baru>/` dan `.kuka/<slug-baru>/`. Bukti dan SHA dasar pekerjaan lama tetap di folder lamanya sebagai riwayat dan tidak pernah dipakai ulang. Jangan memakai slug yang sudah pernah dipakai.

## Larangan

- Jangan mengaku mengerjakan langkah yang belum selesai: spec belum ditulis, tiket belum ada, tes belum jalan, bukti belum dijalankan — sebut apa adanya dan kerjakan; jangan lompati gerbang.
- Jangan menandai tiket selesai tanpa berkas bukti. Jangan menulis bukti yang tidak berasal dari perintah yang benar-benar dijalankan.
- Jangan masuk tahap 4 di branch default.
- Jangan memakai `figure-it-out` atau `principle-outcome-oriented-execution` dalam alur ini (alasannya di [referensi/pstack.md](referensi/pstack.md)), kecuali user menyatakan spec ini migrasi bertahap.
- Jangan memakai skill pstack berbiaya subagent (`architect`, `swarm`, `arena`, `interrogate`, `reflect`) di tingkat `ringan` atau `standar` tanpa persetujuan user.

## Laporan setiap giliran

Akhiri setiap giliran kukajalan dengan blok ini:

```
Tahap: <0–5> <nama> · Tingkat: <ringan|standar|berat> · Tiket: <selesai>/<total>
Gerbang: <ok | GAGAL: apa yang kurang>
Berikutnya: <perintah persis untuk diketik user, atau tindakan agen>
```

Padanan cara memanggil di Claude Code, Pi, dan Hermes: [referensi/platform.md](referensi/platform.md).
