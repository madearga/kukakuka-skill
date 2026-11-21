# kukakuka-skill

Kumpulan skill agen berbahasa Indonesia. Format `SKILL.md` (Agent Skills), dipakai di Pi, Claude Code, Hermes, dan agen lain yang membaca format ini.

| Skill | Gunanya | Dipanggil |
|---|---|---|
| [`kukajalan`](skills/kukajalan/SKILL.md) | Pemandu alur kerja dari ide sampai PR: `kukatanya` → spec → tiket → implementasi per tiket → bukti → `no-mistakes`. Tahap dibaca dari repo oleh `kuka-status.sh`; tiket tidak bisa ditandai selesai tanpa berkas bukti. Tiga tingkat (ringan/standar/berat) menentukan skill pstack mana yang ikut. | `/kukajalan` atau otomatis ("lanjut", "langkah berikutnya") |
| [`kukatanya`](skills/kukatanya/SKILL.md) | Tanya jawab mendalam tentang ide dalam beberapa round (maks 5 per lingkup), sambil mencatat istilah ke `GLOSSARY.md` dan keputusan ke `docs/adr/`. Belum menulis kode sebelum tanya jawab selesai. | `/kukatanya` atau otomatis |
| [`kukaspek`](skills/kukaspek/SKILL.md) | Tulis `.scratch/<fitur>/spec.md` dari keputusan kukatanya: masalah, solusi, seam tes, di luar cakupan. Bisa dipakai sendirian. | `/kukaspek`, otomatis di tahap 2, atau "tulis spec" |
| [`kukatiket`](skills/kukatiket/SKILL.md) | Pecah spec jadi tiket `NN-<slug>.md` ber-**Seam**, **Bukti selesai**, **Blocked by**. Bisa dipakai sendirian. | `/kukatiket`, otomatis di tahap 3, atau "pecah jadi tiket" |
| [`kukaarsitektur`](skills/kukaarsitektur/SKILL.md) | Pindai codebase mencari peluang pendalaman modul, laporan HTML visual (sebelum/sesudah), lalu gali kandidat pilihan user. Bekerja bersama `kukadesain`, `kukatanya`, dan `kukadomain`. | manual `/kukaarsitektur` |
| [`kukadesain`](skills/kukadesain/SKILL.md) | Kosakata bersama untuk merancang modul yang dalam (deep modules): module, interface, depth, seam, adapter, leverage, locality + prinsip uji penghapusan dan pendalaman. Plus referensi pendalaman klaster dan desain-dua-kali. | otomatis saat merancang/merestrukturisasi kode |
| [`kukadomain`](skills/kukadomain/SKILL.md) | Bangun dan asah model domain proyek: `GLOSSARY.md` sebagai ubiquitous language, ADR untuk keputusan. Format ADR dan glossary ada di referensinya. | otomatis saat diskusi istilah/keputusan domain |
| [`refleksi`](skills/refleksi/SKILL.md) | Retrospektif terstruktur: tiga format retro (Mulai/Berhenti/Lanjutkan, 4D, Perahu Layar), analisis performa, action item maks 2-3 dengan pemilik-tenggat-metrik, ringkasan tersimpan. Plus adaptasi kuka. | `/refleksi` atau otomatis ("retro", "evaluasi putaran") |
| [`buat-skill-verifikasi`](skills/buat-skill-verifikasi/SKILL.md) | Membuat skill `verifikasi-<app>` lokal-proyek: menyalakan, doctor, mengendalikan, bukti, pembersihan, plus peta fitur. Wajib dibuktikan sekali dari awal sampai akhir sebelum diserahkan. | manual (`/buat-skill-verifikasi`) |
| [`rawat-skill-verifikasi`](skills/rawat-skill-verifikasi/SKILL.md) | Putaran perawatan: subagent baca-saja per fitur, satu putaran live, hasil `bersih` / `berubah` / `terblokir`, paling banyak satu PR. Tidak pernah menyunting kode produk. | manual (`/rawat-skill-verifikasi`) |
| [`prinsip-buktikan-berfungsi`](skills/prinsip-buktikan-berfungsi/SKILL.md) | Jangan menyatakan selesai sebelum memeriksa benda aslinya, bukan proksi atau laporan diri. | otomatis |
| [`prinsip-urutkan-unit-teruji`](skills/prinsip-urutkan-unit-teruji/SKILL.md) | Pecah pekerjaan jadi unit kecil yang masing-masing dicek; urutkan commit merah → hijau. | otomatis |

`kukajalan` hanya **menyebut** pstack berdasarkan nama; pasang dari sumbernya. Daftar dan alasannya: [`referensi/pstack.md`](skills/kukajalan/referensi/pstack.md).

Empat skill verifikasi adalah terjemahan utuh (tidak diringkas) dari pstack, lihat [NOTICE.md](NOTICE.md).

## Memasang

Setiap folder di `skills/` berdiri sendiri (tidak ada tautan ke luar folder), jadi boleh disalin satu per satu.

```bash
git clone --depth 1 https://github.com/madearga/kukakuka-skill.git /tmp/kukakuka-skill
```

- **Pi:** `pi install git:github.com/madearga/kukakuka-skill`, atau salin folder ke `~/.pi/agent/skills/`.
- **Hermes, satu profil:** salin ke `~/.hermes/profiles/<profil>/skills/` (atau `~/.hermes/skills/` untuk profil default).
- **Hermes, khusus satu repo:** salin ke `<repo>/.hermes/skills/`, lalu `hermes skills trust <repo>`.
- **Claude Code:** salin ke `~/.claude/skills/` atau `<repo>/.claude/skills/`.
- **Agen lain:** `~/.agents/skills/` (terverifikasi untuk Pi; agen lain cek dokumentasinya).

Padanan alat per runtime untuk skill verifikasi: [`platform.md`](skills/buat-skill-verifikasi/referensi/platform.md).

## Prasyarat alur penuh

`kukajalan` tahap 4–5 memanggil skill pstack yang tidak ikut paket ini: `deslop` dan `diagnosing-bugs` (tahap 4), `no-mistakes` dan `babysit` (tahap 5). Pasang dari sumbernya — daftar dan alasannya di [`referensi/pstack.md`](skills/kukajalan/referensi/pstack.md). Tanpa mereka, alur berhenti di skill yang disebutnya; kukajalan tidak menggantinya dengan improvisasi.

## Memeriksa

```bash
alat/cek.sh          # tautan, kontrak peta fitur, kesetaraan jumlah heading/butir/langkah dengan upstream pstack
alat/cek-hermes.sh   # validator SKILL.md milik Hermes sendiri, untuk semua skill
alat/uji-kukajalan.sh  # kuka-status.sh pada repo tiruan, tahap 0 sampai 5 + kasus yang wajib ditolak
```

`cek.sh` membandingkan terjemahan dengan clone upstream; siapkan dulu (commit di header skrip):

```bash
git clone https://github.com/michael-denyer/pstack-claude && git -C pstack-claude checkout c2ade4b
git clone https://github.com/mattpocock/skills /tmp/up-matt && git -C /tmp/up-matt checkout abeeaf9
git clone https://github.com/phuryn/pm-skills /tmp/up-pm && git -C /tmp/up-pm checkout 9af7bfd
bash alat/cek.sh pstack-claude/plugins/pstack/skills   # arg. 2–3 bawaan: /tmp/up-matt/..., /tmp/up-pm/...
```

## Lisensi

Campuran, per folder: `kukatanya`, `kukajalan`, `kukaspek`, `kukatiket` semua hak dilindungi; delapan skill terjemahan MIT. Rincian di [NOTICE.md](NOTICE.md).
