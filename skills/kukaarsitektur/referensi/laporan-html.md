# Format Laporan HTML

Review arsitektural dirender sebagai satu berkas HTML mandiri di direktori temp OS. Tailwind dan Mermaid sama-sama dari CDN. Mermaid menangani diagram berbentuk graph dengan andal; div buatan tangan dan SVG inline menangani visual yang lebih editorial (diagram massa, penampang lapisan). Campur keduanya: jangan bersandar pada Mermaid untuk semuanya, kelihatan generik.

## Scaffold

```html
<!doctype html>
<html lang="id">
  <head>
    <meta charset="utf-8" />
    <title>Review arsitektur {{nama repo}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      /* lapisan kustom kecil untuk yang tidak rapi ditangani Tailwind:
         garis seam putus-putus, mata panah rasa gambar tangan, dsb. */
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

## Header

Nama repo, tanggal, dan legenda ringkas: kotak solid = module, garis putus-putus = seam, panah merah = kebocoran, kotak gelap tebal = module yang dalam. Tanpa paragraf pembuka. Langsung ke kandidat.

## Kartu kandidat

Diagram yang memikul beban. Prose hemat, polos, dan memakai istilah glossary (dari skill `kukadesain`) tanpa seremoni.

Tiap kandidat satu `<article>`:

- **Judul**: pendek, menamai pendalamannya (mis. "Ciutkan pipeline intake Order").
- **Baris badge**: kekuatan rekomendasi (`Strong` = emerald, `Worth exploring` = amber, `Speculative` = slate), plus tag kategori dependensi (`in-process`, `local-substitutable`, `ports & adapters`, `mock`).
- **Files**: daftar monospaced, `font-mono text-sm`.
- **Before / After diagram**: pusat kartu. Dua kolom, berdampingan. Lihat pola di bawah.
- **Problem**: satu kalimat. Apa yang nyeri.
- **Solution**: satu kalimat. Apa yang berubah.
- **Wins**: bullet, ≤6 kata tiap bullet. mis. "Tes kena satu interface", "Logika harga berhenti bocor", "Hapus 4 pembungkus dangkal".
- **Callout ADR** (bila relevan): satu baris dalam kotak bernuansa amber.

Tanpa paragraf penjelasan. Bila diagram butuh paragraf untuk dipahami, gambar ulang diagramnya.

## Pola diagram

Pilih pola yang cocok untuk kandidatnya. Campur. Jangan buat semua diagram tampak sama. Variasi adalah bagian dari maksudnya.

### Graph Mermaid (kuda beban untuk dependensi / alur panggilan)

Pakai `flowchart` atau `graph` Mermaid bila intinya "X memanggil Y memanggil Z, dan lihat berantakannya." Bungkus dalam kartu ber-style Tailwind agar tidak terasa dijatuhkan dari parasut. Style dengan classDef untuk mewarnai edge kebocoran merah dan module yang dalam gelap. Diagram sekuens cocok untuk "sebelum: 6 round-trip; sesudah: 1."

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.leak.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

### Kotak-dan-panah buatan tangan (saat layout Mermaid melawanmu)

Module sebagai `<div>` berbingkai dan berlabel. Panah sebagai elemen SVG `<line>` atau `<path>` inline yang diposisikan absolut di atas container relative. Jangkau ini bila kamu ingin diagram "sesudah" terasa seperti satu module tebal berbingkai tebal dengan internal yang diredamkan, karena Mermaid tidak merendernya dengan bobot yang tepat.

### Penampang lapisan (cocok untuk kedangkalan berlapis)

Susun band horizontal (`h-12 border-l-4`) untuk memperlihatkan lapisan yang dilewati sebuah panggilan. Sebelum: 6 lapisan tipis yang masing-masing tak berbuat apa-apa. Sesudah: 1 band tebal berlabel tanggung jawab yang dikonsolidasi.

### Diagram massa (cocok untuk "interface selebar implementasi")

Dua persegi panjang per module: satu untuk luas permukaan interface, satu untuk implementasi. Sebelum: persegi interface nyaris setinggi persegi implementasi (dangkal). Sesudah: persegi interface pendek, persegi implementasi tinggi (dalam).

### Kolaps call-graph

Sebelum: pohon panggilan fungsi dirender sebagai kotak bersarang. Sesudah: pohon yang sama diciutkan jadi satu kotak, dengan panggilan yang kini internal ditampilkan pudar di dalamnya.

## Panduan gaya

- Condong editorial, bukan dasbor korporat. Ruang putih lega. Serif opsional untuk judul (`font-serif` cocok dengan stone/slate).
- Warna hemat: satu aksen (emerald atau indigo) plus merah untuk kebocoran dan amber untuk peringatan.
- Jaga diagram tingginya ~320px agar before/after duduk nyaman berdampingan tanpa scroll.
- Pakai `text-xs uppercase tracking-wider` untuk label module di dalam diagram, agar terbaca sebagai skematik, bukan sebagai UI.
- Satu-satunya skrip adalah Tailwind CDN dan import ESM Mermaid. Sisanya laporan statis: tanpa kode aplikasi, tanpa interaktivitas selain rendering Mermaid sendiri.

## Bagian top recommendation

Satu kartu lebih besar. Nama kandidat, satu kalimat alasan, anchor link ke kartunya. Itu saja.

## Nada

Polos, ringkas, tapi kata benda dan kata kerja arsitekturalnya datang langsung dari skill `kukadesain`. Ringkas bukan alasan melenceng.

**Pakai persis:** module, interface, implementation, depth, deep, shallow, seam, adapter, leverage, locality.

**Jangan substitusi:** component, service, unit (untuk module) · API, signature (untuk interface) · boundary (untuk seam) · layer, wrapper (untuk module, saat maksudmu module).

**Frasa yang pas dengan gaya ini:**

- "Modul intake Order dangkal: interface nyaris menyamai implementasi."
- "Pricing bocor melintasi seam."
- "Dalamkan: satu interface, satu tempat menguji."
- "Dua adapter menjadikan seam sah: HTTP di produksi, in-memory di tes."

**Bullet Wins** menamai keuntungan dengan istilah glossary: *"locality: bug memusat di satu module"*, *"leverage: satu interface, N titik panggil"*, *"interface menyusut; implementasi menyerap pembungkusnya"*. Jangan menulis *"lebih mudah dirawat"* atau *"kode lebih bersih"*, karena istilah itu tidak ada di glossary dan tidak membayar tempatnya.

Tanpa mengambang, tanpa pemanasan, tanpa "perlu dicatat bahwa…". Bila sebuah kalimat bisa jadi bullet, jadikan bullet. Bila sebuah bullet bisa dipotong, potong. Bila sebuah istilah tidak ada di glossary `kukadesain`, cari yang ada sebelum mengarang yang baru.
