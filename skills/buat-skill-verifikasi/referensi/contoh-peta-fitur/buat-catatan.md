# Membuat catatan

Membuat catatan memungkinkan pengguna menyimpan catatan berjudul dari browser atau CLI, membatalkan draf yang belum selesai, dan memastikan catatan tersimpan dari tampilan kedua yang dihadapi pengguna.

## Sub-fitur

- `buat-buka` membuka editor kosong dari setiap pintu masuk browser.
- `buat-simpan` menyimpan judul dan isi secara permanen.
- `buat-batal` membuang draf browser yang belum selesai.
- `buat-cli` membuat catatan dengan bentuk yang sama dari terminal.

## Cara mencapainya (sudut pandang pengguna)

- Pilih tombol `Catatan baru` di toolbar browser.
- Tekan `n` di browser saat fokus tidak berada di kolom yang bisa diketik.
- Jalankan `catatan buat --judul <judul> --isi <isi>` di terminal.

## Mengendalikannya dengan kontrol-catatan

Prasyarat:

- Catatan sehat di `http://127.0.0.1:4173`.
- Belum ada catatan berjudul `Daftar rilis`.
- `kontrol-catatan doctor` melaporkan URL yang diharapkan dan folder data sekali pakai.

- **Buka editor.** Pilih `Catatan baru`. Jalankan `kontrol-catatan browser click --role button --name "Catatan baru"`. Form bernama `Editor catatan` muncul dengan fokus di textbox `Judul`.
- **Isi konten.** Ketik judul dan isi. Jalankan `kontrol-catatan browser fill --role textbox --name "Judul" --value "Daftar rilis"` dan `kontrol-catatan browser fill --role textbox --name "Isi" --value "Tag lalu terbitkan"`. Tombol `Simpan catatan` menjadi aktif.
- **Simpan catatan.** Pilih `Simpan catatan`. Jalankan `kontrol-catatan browser click --role button --name "Simpan catatan"`. Status bernama `Catatan tersimpan` muncul dan heading berbunyi `Daftar rilis`.
- **Pastikan persistensi.** Kembali ke daftar catatan dan buka ulang catatannya. Jalankan `kontrol-catatan browser click --role link --name "Semua catatan"` dan `kontrol-catatan browser click --role link --name "Daftar rilis"`. Editor menampilkan kedua nilai yang tersimpan.
- **Batalkan draf.** Buka catatan baru, isi `Buang saya`, lalu pilih `Batal`. Jalankan `kontrol-catatan browser click --role button --name "Catatan baru"`, `kontrol-catatan browser fill --role textbox --name "Judul" --value "Buang saya"`, dan `kontrol-catatan browser click --role button --name "Batal"`. Daftar catatan kembali dan tidak ada tautan `Buang saya`.
- **Pintu masuk CLI.** Buat catatan kedua. Jalankan `kontrol-catatan cli -- catatan buat --judul "Catatan CLI" --isi "Dibuat dari terminal" --format json`. Exit code `0` dan stdout memuat ID dan judul catatan baru.
- **Bukti.** Buka ulang kedua catatan tersimpan dari `Semua catatan`. Jalankan `kontrol-catatan browser snapshot --aria --path artefak/buat-catatan/daftar.aria.txt` dan `kontrol-catatan browser screenshot --path artefak/buat-catatan/daftar.png`. Artefak memperlihatkan `Daftar rilis` dan `Catatan CLI`.

## Jebakan

- Menekan `n` saat textbox sedang fokus akan mengetik huruf itu, bukan membuka editor baru.
- Judul dipangkas spasinya saat disimpan. Periksa judul yang ditampilkan, bukan nilai input draf.
- Status simpan saja bukan bukti yang cukup. Buka ulang catatan dari daftar.
- Hapus `Daftar rilis` dan `Catatan CLI` saat membersihkan data uji, tetapi simpan artefak buktinya.
