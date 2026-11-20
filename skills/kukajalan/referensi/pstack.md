# Skill pstack di dalam kukajalan

Hasil membaca penuh skill pstack v0.14.2 (November 2026). Skill pstack hanya **disebut berdasarkan nama**; pasang dari sumbernya sendiri.

## Dipakai

| Skill | Tahap | Tingkat | Cara pakai | Batasan |
|---|---|---|---|---|
| `principle-experience-first` | 1 | semua | target dan lingkup dari sisi pengguna | — |
| `principle-exhaust-the-design-space` | 1 | semua | 2–3 alternatif sungguhan untuk keputusan UI/arsitektur yang belum ada presedennya | bukan untuk pola yang sudah mapan atau bug fix |
| `architect` | 1 | berat | fase A–C saja, **dengan checkpoint** | bawaannya lanjut tanpa bertanya dan masuk implementasi; keduanya dilarang di sini. Memakai `arena` (≈4 agen) |
| `principle-redesign-from-first-principles` | 2 | semua | rancang utuh di spec, kirim bertahap lewat tiket | — |
| `principle-subtract-before-you-add` | 3 | semua | tiket penghapusan lebih dulu | — |
| `principle-foundational-thinking` | 3, 4 | semua | scaffold dan bentuk data lebih dulu | — |
| `principle-boundary-discipline` | 4 | semua | validasi hanya di batas sistem | — |
| `principle-laziness-protocol` | 4 | semua | diff kecil, hierarki datar | — |
| `principle-never-block-on-the-human` | 4 | semua | kerjakan, lalu tunjukkan | **hanya di dalam tiket**; dilarang di tahap 1–3 |
| `blast-radius` | 4 | standar, berat | fakta keamanan dibuktikan dengan menjalankan sesuatu | lewati langkah arena-nya kecuali perubahan lintas modul |
| `principle-fix-root-causes` | 4 (gagal) | semua | bersama skill `diagnosing-bugs` | — |
| `deslop` | 4 | semua | setelah review sendiri, sebelum `tandai` | menganggap base `main`; sebutkan base yang benar |
| `swarm` | 4 | berat | satu gelombang tiket bebas, satu worktree per tiket | tidak mengenal dependensi dan tidak merge; pemandu yang menghitung gelombang dan merge |
| `show-me-your-work` | semua | berat | log TSV keputusan sepanjang jalan | audit transkrip dan review lintas-model sekali di akhir, bukan per tiket |
| `interrogate` | 5 | berat | sekali atas seluruh branch | 3 reviewer paralel. Bila slug model ditolak ia menyarankan PR untuk mengganti konfigurasi: jangan dibuat |
| `babysit` | 5 | semua | komentar review dan CI setelah PR | jalan di sesi utama; maksimal 3 putaran |
| `make-pr-easy-to-review` | 5 | berat | setelah PR terbuka | penulisan ulang history hanya atas persetujuan |

## Tidak dipakai

| Skill | Alasan |
|---|---|
| `tdd` (pstack) | Khusus bug fix dan opt-in, jadi tidak mengalir di tahap 4. Disiplin tes dulu sudah tertulis langsung di tahap 4: bila tes tidak praktis, tulis alasannya dan pemeriksaan terdekat. |
| `figure-it-out` | Meta-alur yang menyaingi kukajalan: dekomposisinya menduplikasi tahap 3 (tiket), loop-nya menduplikasi tahap 4 (implementasi per tiket). |
| `principle-outcome-oriented-execution` | Membolehkan kerusakan sementara antar fase; bertentangan dengan "tiap tiket hijau". Hanya untuk spec yang dinyatakan migrasi bertahap. |
| `arena` sebagai paralel tiket | Arena menjalankan N salinan untuk satu tugas yang sama (≈4 agen). Untuk paralel tiket pakai `swarm`. |
| `fix-ci` | Sudah tercakup `babysit`, yang punya batas putaran. |
| `thermo-nuclear-code-quality-review` | Hanya atas permintaan user; bertentangan dengan diff kecil. |
| `reflect` | Diganti `/refleksi` (skill repo ini, tanpa subagent). Ia mengubah skill, bukan proyek; 4 agen; bergantung pada transkrip Claude Code. |

## Catatan biaya dan model

- Panel model pstack ada di `models.json`. Bila slug-nya tidak lagi berlaku, jalankan `/setup-pstack` sebelum memakai `architect`, `arena`, atau `interrogate`.
- pstack menyediakan pemetaan alat untuk Codex saja. Di runtime tanpa subagent, skill fan-out turun menjadi satu jalur berurutan.
