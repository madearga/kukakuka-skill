---
name: kukadomain
description: Bangun dan asah model domain sebuah proyek. Gunakan saat membahas terminologi codebase, menulis atau menyunting GLOSSARY.md, atau mencatat atau menyunting ADR.
---

# Kukadomain

Bangun dan asah model domain proyek secara aktif selagi kamu merancang. Ini disiplin yang *aktif*: menantang istilah, mengarang skenario edge case, dan menuliskan glossary serta keputusan pada saat mereka mengkristal. (Sekadar *membaca* `GLOSSARY.md` untuk kosakata bukanlah skill ini: itu kebiasaan satu baris yang bisa dilakukan skill mana pun. Skill ini untuk saat kamu mengubah modelnya, bukan sekadar mengonsumsinya.)

## Struktur berkas

Sebagian besar repo punya satu context:

```
/
├── GLOSSARY.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

Kalau ada `GLOSSARY-MAP.md` di root, repo punya beberapa context. Map itu menunjuk ke tempat masing-masing berada:

```
/
├── GLOSSARY-MAP.md
├── docs/
│   └── adr/                          ← system-wide decisions
├── src/
│   ├── ordering/
│   │   ├── GLOSSARY.md
│   │   └── docs/adr/                 ← context-specific decisions
│   └── billing/
│       ├── GLOSSARY.md
│       └── docs/adr/
```

Buat berkas secara malas: hanya saat kamu punya sesuatu untuk ditulis. Kalau belum ada `GLOSSARY.md`, buat saat istilah pertama terselesaikan. Kalau belum ada `docs/adr/`, buat saat ADR pertama dibutuhkan.

## Selama sesi

### Tantang terhadap glossary

Saat user memakai istilah yang berkonflik dengan bahasa yang sudah ada di `GLOSSARY.md`, angkat langsung. "Glossary-mu mendefinisikan 'cancellation' sebagai X, tapi sepertinya yang kamu maksud Y. Mana yang benar?"

### Tajamkan bahasa yang kabur

Saat user memakai istilah yang kabur atau overloaded, usulkan istilah kanonik yang presisi. "Kamu menyebut 'account': yang kamu maksud Customer atau User? Itu dua hal yang berbeda."

### Diskusikan skenario konkret

Saat relasi domain sedang dibahas, stress-test mereka dengan skenario yang spesifik. Karang skenario yang menyondong edge case dan memaksa user presisi soal batas antar-konsep.

### Periksa silang dengan kode

Saat user menyatakan bagaimana sesuatu bekerja, periksa apakah kodenya sependapat. Kalau kamu menemukan kontradiksi, angkat ke permukaan: "Kodemu membatalkan Order utuh, tapi barusan kamu bilang pembatalan parsial itu mungkin. Mana yang benar?"

### Perbarui GLOSSARY.md di tempat

Saat sebuah istilah terselesaikan, perbarui `GLOSSARY.md` di tempat juga. Jangan ditumpuk: tangkap saat terjadi. Pakai format di [referensi/format-glossary.md](referensi/format-glossary.md).

`GLOSSARY.md` harus sepenuhnya bebas dari detail implementation. Jangan memperlakukan `GLOSSARY.md` sebagai spec, scratch pad, atau tempat menyimpan keputusan implementation. Dia adalah glossary dan tidak lebih.

### Tawarkan ADR secara hemat

Hanya tawarkan membuat ADR bila ketiganya benar:

1. **Sulit dibalik**: biaya mengubah pikiran nanti terasa signifikan
2. **Mengejutkan tanpa konteks**: pembaca di masa depan akan bertanya-tanya "kenapa mereka melakukannya dengan cara ini?"
3. **Hasil trade-off sungguhan**: ada alternatif yang benar-benar layak dan kamu memilih satu karena alasan yang spesifik

Kalau salah satu dari ketiganya tidak terpenuhi, lewati ADR-nya. Pakai format di [referensi/format-adr.md](referensi/format-adr.md).
