# Peta verifikasi Catatan

Folder ini adalah sumber yang dirawat untuk memverifikasi perilaku Catatan yang dihadapi pengguna. Baca indeks ini sebelum mengendalikan aplikasi, lalu pakai berkas fitur yang cocok sebagai resep.

## Prasyarat dasar

- Nyalakan Catatan di `http://127.0.0.1:4173` dengan folder data sekali pakai.
- Set `CATATAN_DATA_DIR=/tmp/catatan-verifikasi-$RUN_ID` supaya putaran yang berjalan bersamaan tidak berbagi keadaan.
- Isi data awal: catatan berjudul `Rencana kuartal` dan `Daftar belanja`.
- Pastikan `kontrol-catatan` dan CLI `catatan` ada di `PATH`.
- Jalankan `kontrol-catatan doctor` dan wajibkan URL, folder data, dan revisi build sesuai harapan.
- Jangan pernah mengendalikan instance yang tidak dinyalakan oleh putaran verifikasi ini.

## Konvensi pengendalian

- Mulai setiap resep dari keadaan dasar kecuali prasyaratnya menyebut lain.
- Utamakan role ARIA dan nama yang dapat diakses daripada selector CSS atau posisi DOM.
- Perlakukan setiap perintah secara harfiah. Nama dan flag dalam tanda kutip jangan diubah.
- Jalankan tindakan browser lewat `kontrol-catatan browser`.
- Jalankan tindakan terminal lewat `kontrol-catatan cli -- <perintah>`.
- Kembalikan data awal setelah ada perubahan data. Jangan hapus artefak bukti saat pembersihan.

## Pelaporan bukti dan yang dilewati

- Ambil tindakan pengguna dan keadaan yang dihasilkan, bukan hanya layar terakhir.
- Bukti UI mencakup snapshot ARIA dan screenshot dengan identitas aplikasi terlihat.
- Bukti CLI mencakup perintah, stdout, stderr, dan exit code.
- Bukti perubahan data mencakup tampilan kedua yang baca-saja atas nilai yang tersimpan.
- Catat ID fitur dan pintu masuk yang dipakai di setiap artefak.
- Laporkan jalur yang tidak bisa dicapai beserta perintah yang dicoba dan prasyarat yang tidak terpenuhi.
- Jangan laporkan pintu masuk yang dilewati sebagai terverifikasi lewat jalur lain.

## Kontrak entri fitur

Setiap berkas fitur dimulai dengan judul H1 dan satu paragraf yang menjelaskan perilaku yang terlihat pengguna. Setelah itu ada tepat empat bagian H2 dengan urutan ini.

1. `Sub-fitur` mencantumkan ID pendek dengan satu baris per perilaku.
2. `Cara mencapainya (sudut pandang pengguna)` mencantumkan setiap pintu masuk pengguna.
3. `Mengendalikannya dengan <harness>` dimulai dengan `Prasyarat:` dan memakai butir berlabel yang memasangkan setiap tindakan pengguna dengan perintah persis dan hasil yang teramati.
4. `Jebakan` mencantumkan hal yang bisa membuang waktu atau membatalkan putaran verifikasi.

Jauhkan detail implementasi dari peta. Sebut hanya jalur pengguna, pegangan stabil, keadaan yang dibutuhkan, perintah, dan bukti yang teramati.

## Fitur

- [Membuat catatan](./buat-catatan.md) mencakup pembuatan lewat browser dan CLI, pembatalan, persistensi, dan pembersihan.
- [Mencari catatan](./cari.md) mencakup pencarian lewat toolbar, keyboard, dan CLI dengan keadaan cocok, kosong, dan dibersihkan.
