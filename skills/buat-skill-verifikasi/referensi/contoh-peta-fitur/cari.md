# Mencari catatan

Pencarian memungkinkan pengguna menemukan catatan berdasarkan judul atau isi, membuka catatan yang cocok, dan membedakan "tidak ada yang cocok" dari "pencarian tidak tersedia".

## Sub-fitur

- `cari-buka` membuka pencarian dari setiap pintu masuk browser yang didukung.
- `cari-cocok` mengembalikan kecocokan judul dan isi tanpa mengubah data catatan.
- `cari-buka-hasil` membuka satu hasil di editor catatan.
- `cari-kosong` menampilkan keadaan kosong yang lengkap untuk kueri tanpa kecocokan.
- `cari-bersihkan` menghapus kueri dan mengembalikan tampilan catatan terbaru.
- `cari-cli` mengembalikan catatan cocok yang sama dari terminal.

## Cara mencapainya (sudut pandang pengguna)

- Pilih tombol `Cari` di toolbar browser.
- Tekan `/` di browser saat fokus tidak berada di kolom yang bisa diketik.
- Jalankan `catatan cari <kueri>` di terminal.

## Mengendalikannya dengan kontrol-catatan

Prasyarat:

- Catatan sehat di `http://127.0.0.1:4173`.
- Folder data sekali pakai berisi `Rencana kuartal` dengan isi `Draf anggaran`.
- `kontrol-catatan doctor` melaporkan URL dan folder data yang diharapkan.

- **Pintu masuk toolbar.** Pilih tombol `Cari`. Jalankan `kontrol-catatan browser click --role button --name "Cari"`. Dialog bernama `Cari catatan` muncul dengan fokus di kotak pencariannya.
- **Pintu masuk keyboard.** Tutup dialog, fokuskan halaman, lalu tekan `/`. Jalankan `kontrol-catatan browser press --key "/"`. Dialog yang sama muncul dan halaman tidak menyisipkan garis miring.
- **Cocok di judul.** Ketik `kuartal`. Jalankan `kontrol-catatan browser fill --role searchbox --name "Cari catatan" --value "kuartal"`. Daftar `Hasil pencarian` memuat `Rencana kuartal` dan tidak memuat `Daftar belanja`.
- **Cocok di isi.** Ganti kueri menjadi `anggaran`. Jalankan `kontrol-catatan browser fill --role searchbox --name "Cari catatan" --value "anggaran"`. Hasil `Rencana kuartal` tetap terlihat dengan cuplikan kecocokan isi.
- **Buka hasil.** Pilih `Rencana kuartal`. Jalankan `kontrol-catatan browser click --role link --name "Rencana kuartal"`. Dialog tertutup dan heading editor berbunyi `Rencana kuartal`.
- **Keadaan kosong.** Buka lagi pencarian dan masukkan `gunung berapi`. Jalankan `kontrol-catatan browser fill --role searchbox --name "Cari catatan" --value "gunung berapi"`. Status bernama `Tidak ada catatan yang cocok` muncul setelah pencarian selesai.
- **Bersihkan kueri.** Pilih `Bersihkan pencarian`. Jalankan `kontrol-catatan browser click --role button --name "Bersihkan pencarian"`. Kotak pencarian kosong dan area `Catatan terbaru` menggantikan daftar hasil.
- **Cocok via CLI.** Cari dari terminal. Jalankan `kontrol-catatan cli -- catatan cari "kuartal" --format json`. Exit code `0` dan stdout memuat satu objek berjudul `Rencana kuartal`.
- **Tidak cocok via CLI.** Cari nilai yang tidak ada. Jalankan `kontrol-catatan cli -- catatan cari "gunung berapi" --format json`. Exit code `0` dan stdout berisi `[]`.
- **Bukti.** Ambil keadaan hasil yang terisi. Jalankan `kontrol-catatan browser snapshot --aria --path artefak/cari/hasil.aria.txt` dan `kontrol-catatan browser screenshot --path artefak/cari/hasil.png`. Kedua artefak memperlihatkan identitas Catatan, kuerinya, dan `Rencana kuartal`.

## Jebakan

- Menekan `/` saat editor atau kotak pencarian sedang fokus akan menyisipkan teks, bukan membuka pencarian.
- Hasil diperbarui setelah jeda singkat (debounce). Tunggu daftar hasil atau status kosong muncul, jangan pakai sleep tetap.
- Catatan yang diarsipkan tidak ikut kecuali pengguna mengaktifkan `Sertakan arsip`.
- CLI defaultnya mengeluarkan teks untuk dibaca manusia. Pakai `--format json` untuk pemeriksaan yang stabil.
- Membuka hasil mengubah keadaan browser. Buka ulang pencarian sebelum membuktikan kueri lain.
