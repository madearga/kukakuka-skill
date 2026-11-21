# Format berkas kukajalan

## `.kuka/jalan.md`

Satu baris `kunci: nilai` per kunci. Skrip `kuka-status.sh` hanya membaca kunci di bawah ini; baris lain diabaikan.

| Kunci | Nilai | Ditulis saat |
|---|---|---|
| `pintu` | `fitur` atau `bug` | mulai |
| `tingkat` | `ringan`, `standar`, atau `berat` | mulai |
| `fitur` | slug fitur, sama dengan folder `.scratch/<fitur>/` | mulai |
| `label-kukatanya` | `selesai`, `dihentikan`, atau `siap untuk implementasi` | akhir tahap 1 |
| `dokumen-keputusan` | path dokumen keputusan kukatanya, default `.scratch/<fitur>/keputusan.md`; tidak boleh sama dengan `spec.md` | akhir tahap 1 |

`.kuka/` di-commit bersama kode: status alur dan bukti ikut terlihat di PR. Isinya:

```
.kuka/jalan.md                  satu per repo; pekerjaan yang sedang berjalan
.kuka/<fitur>/dasar/<NN>        SHA dasar tiket, ditulis `mulai`
.kuka/<fitur>/bukti/<NN>.md     bukti tiket, ditulis agen sebelum `tandai`
```

Folder per fitur selaras dengan `.scratch/<fitur>/`, supaya bukti fitur lama tidak pernah lolos sebagai bukti tiket fitur baru yang nomornya sama.

## Tambahan wajib di setiap tiket

Dua baris ini wajib ada di setiap tiket yang agen tulis. Skrip menolak tiket tanpa keduanya.

### Tiket lokal (`.scratch/<fitur>/issues/<NN>-<slug>.md`)

```markdown
# 03: <Judul tiket>

**What to build:** …

**Blocked by:** 01, 02

**Status:** ready-for-agent

**Seam:** <antarmuka publik tempat tes ditulis, sudah disepakati di spec>

**Bukti selesai:** `<perintah yang dijalankan>` → <hasil yang diharapkan dari benda aslinya>

- [ ] Kriteria penerimaan 1
```

Bukti selesai yang baik menyebut perintah yang bisa diulang dan hasil yang bisa dibantah: "`curl -s localhost:3000/catatan?q=apel` → mengembalikan 1 catatan berjudul Apel". Yang buruk: "tes lulus", "fitur berjalan".

## Status tiket

Kosakata status di baris `**Status:**` tiket lokal:

| Arti | `**Status:**` |
|---|---|
| siap dikerjakan | `ready-for-agent` |
| sedang dikerjakan | `claimed` |
| selesai dan terbukti | `resolved` |

Tiket bebas: belum selesai, belum diklaim, dan semua tiket di **Blocked by** sudah selesai. Nomor terkecil menang.

## Format **Blocked by**

Skrip hanya mengenal:

- bebas: kosong, `None` (boleh diikuti keterangan, mis. `None (can start immediately)`), `tidak ada`, atau `-`;
- daftar pemblokir dipisah koma atau spasi, tiap butir berupa nomor tiket (`01`, `1`, `#1`) atau nama berkas tiket (`01-skema.md`, boleh dengan path).

Selain itu, termasuk judul tiket (`Skema catatan`, `Fase 2 migrasi`), ditolak dengan `GAGAL … Blocked by tidak dikenali`. Nomor yang tidak punya berkas tiket di `.scratch/<fitur>/issues/` juga ditolak.

## Berkas bukti (`.kuka/<fitur>/bukti/<NN>.md`)

````markdown
# Bukti tiket 03

```
$ <perintah persis seperti dijalankan>
<keluaran asli, dipangkas seperlunya>
```

Kesimpulan: <cocok / tidak cocok dengan Bukti selesai, dan kenapa>
Tidak dicek: <apa yang tidak dibuktikan>
````

`tandai` memeriksa:

- ada minimal satu blok kode berisi baris `$ <perintah>` yang langsung diikuti minimal satu baris keluaran. Beberapa perintah boleh dalam satu blok, masing-masing dengan keluarannya;
- baris `Kesimpulan:` terisi;
- placeholder tidak dihitung: perintah `<...>`, baris keluaran yang hanya `<...>` atau `...`, dan kesimpulan `<...>`. Templat di atas yang belum diisi ditolak;
- isi berkas berbeda dari versinya di SHA dasar. Bukti yang sudah di-commit sebelum `mulai` dan tidak ditulis ulang ditolak.

Skrip hanya memeriksa bentuk. Kejujuran isinya tetap aturan agen: keluaran disalin dari perintah yang benar-benar dijalankan.
