# Format ADR

ADR tinggal di `docs/adr/` dan memakai penomoran berurutan: `0001-slug.md`, `0002-slug.md`, dst.

Buat direktori `docs/adr/` secara malas: hanya saat ADR pertama dibutuhkan.

## Template

```md
# {Short title of the decision}

{1-3 sentences: what's the context, what did we decide, and why.}
```

Selesai. Sebuah ADR bisa berupa satu paragraf. Nilainya ada di mencatat *bahwa* sebuah keputusan diambil dan *mengapa*, bukan di mengisi bagian-bagian formulir.

## Bagian opsional

Hanya sertakan ini saat mereka benar-benar menambah nilai. Sebagian besar ADR tidak akan membutuhkannya.

- **Status** di frontmatter (`proposed | accepted | deprecated | superseded by ADR-NNNN`): berguna saat keputusan dibuka kembali
- **Considered Options**: hanya saat alternatif yang ditolak layak untuk diingat
- **Consequences**: hanya saat efek hilir yang tidak jelas perlu diangkat

## Penomoran

Pindai `docs/adr/` untuk nomor tertinggi yang sudah ada, lalu tambah satu.

## Kapan menawarkan ADR

Ketiganya harus benar:

1. **Sulit dibalik**: biaya mengubah pikiran nanti terasa signifikan
2. **Mengejutkan tanpa konteks**: pembaca di masa depan akan melihat kodenya dan bertanya-tanya "apa-apaan mereka melakukannya dengan cara ini?"
3. **Hasil trade-off sungguhan**: ada alternatif yang benar-benar layak dan kamu memilih satu karena alasan yang spesifik

Kalau sebuah keputusan mudah dibalik, lewati: kamu tinggal membaliknya nanti. Kalau tidak mengejutkan, tidak akan ada yang bertanya-tanya kenapa. Kalau tidak ada alternatif sungguhan, tidak ada yang perlu dicatat selain "kami melakukan hal yang sudah jelas."

### Apa yang memenuhi syarat

- **Bentuk arsitektural.** "Kami memakai monorepo." "Write model-nya event-sourced, read model-nya diproyeksikan ke Postgres."
- **Pola integrasi antar-context.** "Ordering dan Billing berkomunikasi via domain event, bukan HTTP sinkron."
- **Pilihan teknologi yang membawa lock-in.** Database, message bus, auth provider, deployment target. Bukan semua library: hanya yang butuh satu kuartal untuk ditukar keluar.
- **Keputusan boundary dan scope.** "Data Customer dimiliki oleh context Customer; context lain merujuknya hanya via ID." "Tidak" yang eksplisit sama berharganya dengan "ya".
- **Penyimpangan yang disengaja dari jalan yang sudah jelas.** "Kami memakai SQL manual alih-alih ORM karena X." Apa pun yang akan diasumsikan sebaliknya oleh pembaca yang masuk akal. Ini menghentikan engineer berikutnya dari "memperbaiki" sesuatu yang memang disengaja.
- **Constraint yang tidak terlihat di kode.** "Kami tidak bisa memakai AWS karena requirement compliance." "Response time harus di bawah 200ms karena kontrak API partner."
- **Alternatif yang ditolak, saat penolakannya tidak jelas.** Kalau kamu mempertimbangkan GraphQL dan memilih REST karena alasan halus, catat; kalau tidak, seseorang akan mengusulkan GraphQL lagi enam bulan dari sekarang.
