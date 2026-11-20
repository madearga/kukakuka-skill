# Templat spec

Spec ditulis agen di tahap 2, satu berkas per fitur: `.scratch/<fitur>/spec.md`. Gerbang skrip hanya memeriksa spec ada dan tidak kosong; isinya tetap tanggung jawab agen. Sumbernya keputusan kukatanya: dokumen keputusan (`dokumen-keputusan` di `.kuka/jalan.md`) dirujuk di bagian Masalah atau Solusi. Keputusan berstatus `terbuka` atau `menunggu fakta` ditulis sebagai tertunda, bukan diam-diam dianggap sepakat.

Tulis dengan templat ini; tidak boleh ada placeholder tersisa:

```markdown
# <fitur>: <judul>

## Masalah

<apa yang salah atau belum bisa dilakukan, dari sisi pengguna. Rujuk dokumen keputusan kukatanya bila ada.>

## Solusi

<pendekatan yang dipilih dan kenapa; alternatif yang ditolak cukup satu baris. Keputusan yang masih terbuka ditandai jelas sebagai tertunda.>

## Seam tes

<antarmuka publik tempat tes ditulis: fungsi, endpoint, atau CLI. Disepakati di sini sebelum tiket ditulis; tiap tiket merujuk seam di bagian ini.>

## Di luar cakupan

<yang sengaja tidak dikerjakan fitur ini, satu butir per baris.>
```
