---
name: kukadesain
description: Kosakata bersama untuk merancang deep module. Gunakan saat user ingin merancang atau memperbaiki interface sebuah modul, mencari peluang pendalaman (deepening), memutuskan di mana seam diletakkan, membuat kode lebih mudah dites atau lebih mudah dinavigasi AI, atau saat skill lain membutuhkan kosakata deep-module.
---

# Kukadesain

Rancang **deep module**: banyak perilaku di balik interface kecil, diletakkan di seam yang bersih, dan dites lewat interface itu. Pakai bahasa dan prinsip ini di mana pun kode sedang dirancang atau direstrukturisasi. Sasarannya leverage bagi caller, locality bagi maintainer, dan testability bagi semua orang.

## Glosarium

Pakai istilah-istilah ini persis: jangan menggantinya dengan "component," "service," "API," atau "boundary." Konsistensi bahasa adalah inti dari semua ini.

**Module**: apa pun yang punya interface dan implementation. Sengaja dibuat agnostik terhadap skala: bisa sebuah function, class, package, atau slice yang melintasi tier. _Hindari_: unit, component, service.

**Interface**: semua yang harus diketahui caller untuk memakai module dengan benar: type signature-nya, tapi juga invariant, constraint urutan, error mode, configuration yang diwajibkan, dan karakteristik performa. _Hindari_: API, signature (terlalu sempit; keduanya hanya merujuk ke permukaan level tipe).

**Implementation**: apa yang ada di dalam module, badan kodenya. Berbeda dari **Adapter**: sebuah hal bisa berupa adapter kecil dengan implementation besar (sebuah repo Postgres) atau adapter besar dengan implementation kecil (sebuah in-memory fake). Pakai "adapter" saat yang dibahas adalah seam-nya; "implementation" untuk selain itu.

**Depth**: leverage di interface. Seberapa banyak perilaku yang bisa dilatih caller (atau test) per unit interface yang harus mereka pelajari. Sebuah module bersifat **deep** saat banyak perilaku berada di balik interface kecil, dan **shallow** saat interface-nya nyaris sama kompleksnya dengan implementation-nya.

**Seam** _(Michael Feathers)_: tempat di mana kamu bisa mengubah perilaku tanpa mengedit di tempat itu; *lokasi* tempat interface sebuah module hidup. Di mana seam diletakkan adalah keputusan desain tersendiri, terpisah dari apa yang berada di baliknya. _Hindari_: boundary (sudah terlalu penuh makna dengan bounded context milik DDD).

**Adapter**: benda konkret yang memenuhi sebuah interface di sebuah seam. Menjelaskan *peran* (slot apa yang dia isi), bukan substansi (apa yang ada di dalamnya).

**Leverage**: apa yang caller dapatkan dari depth. Lebih banyak kapabilitas per unit interface yang mereka pelajari. Satu implementation membayar dirinya di N call site dan M test.

**Locality**: apa yang maintainer dapatkan dari depth. Perubahan, bug, pengetahuan, dan verifikasi terpusat di satu tempat, bukan tersebar di para caller. Perbaiki sekali, beres di mana-mana.

## Deep vs shallow

**Deep module** = interface kecil + banyak implementation:

```
┌─────────────────────┐
│   Small Interface   │  ← Few methods, simple params
├─────────────────────┤
│                     │
│  Deep Implementation│  ← Complex logic hidden
│                     │
└─────────────────────┘
```

**Shallow module** = interface besar + sedikit implementation (hindari):

```
┌─────────────────────────────────┐
│       Large Interface           │  ← Many methods, complex params
├─────────────────────────────────┤
│  Thin Implementation            │  ← Just passes through
└─────────────────────────────────┘
```

Saat merancang sebuah interface, tanyakan:

- Bisakah jumlah method-nya saya kurangi?
- Bisakah parameter-nya saya sederhanakan?
- Bisakah lebih banyak kompleksitas saya sembunyikan ke dalam?

## Prinsip-prinsip

- **Depth adalah properti interface, bukan implementation.** Sebuah deep module bisa tersusun secara internal dari bagian-bagian kecil yang mockable dan swappable; bagian-bagian itu hanya tidak menjadi bagian dari interface. Sebuah module bisa punya **internal seam** (privat bagi implementation-nya, dipakai oleh test-nya sendiri) maupun **external seam** di interface-nya.
- **Uji penghapusan.** Bayangkan menghapus module itu. Kalau kompleksitasnya menghilang, dia cuma pass-through. Kalau kompleksitas muncul lagi di N caller, dia memang membayar dirinya.
- **Interface adalah permukaan tes.** Caller dan test melintasi seam yang sama. Kalau kamu ingin menguji *melewati* interface, bentuk module-nya kemungkinan besar salah.
- **Satu adapter berarti seam hipotetis; dua adapter berarti seam nyata.** Jangan memperkenalkan seam kecuali memang ada sesuatu yang benar-benar bervariasi melintasinya.

## Merancang untuk testability

Interface yang baik membuat testing terasa alami:

1. **Terima dependencies, jangan buat sendiri.**

   ```typescript
   // Testable
   function processOrder(order, paymentGateway) {}

   // Hard to test
   function processOrder(order) {
     const gateway = new StripeGateway();
   }
   ```

2. **Kembalikan hasil, jangan timbulkan side effect.**

   ```typescript
   // Testable
   function calculateDiscount(cart): Discount {}

   // Hard to test
   function applyDiscount(cart): void {
     cart.total -= discount;
   }
   ```

3. **Area permukaan kecil.** Semakin sedikit method = semakin sedikit test yang dibutuhkan. Semakin sedikit parameter = setup test semakin sederhana.

## Hubungan antar-istilah

- Sebuah **Module** punya tepat satu **Interface** (permukaan yang dia sajikan ke caller dan test).
- **Depth** adalah properti sebuah **Module**, diukur terhadap **Interface**-nya.
- Sebuah **Seam** adalah tempat **Interface** sebuah **Module** hidup.
- Sebuah **Adapter** duduk di sebuah **Seam** dan memenuhi **Interface**-nya.
- **Depth** menghasilkan **Leverage** bagi caller dan **Locality** bagi maintainer.

## Framing yang ditolak

- **Depth sebagai rasio jumlah baris implementation terhadap baris interface** (Ousterhout): ini justru menghargai penggembungan implementation (padding). Kita memakai depth-sebagai-leverage sebagai gantinya.
- **"Interface" sebagai keyword `interface` TypeScript atau method public sebuah class**: terlalu sempit; interface di sini mencakup setiap fakta yang harus diketahui caller.
- **"Boundary"**: sudah terlalu penuh makna dengan bounded context milik DDD. Katakan **seam** atau **interface**.

## Melangkah lebih dalam

- **Memperdalam sebuah cluster beserta dependencies-nya**, lihat [referensi/pendalaman.md](referensi/pendalaman.md): kategori dependency, disiplin seam, dan testing replace-don't-layer.
- **Menjajaki interface alternatif**, lihat [referensi/desain-dua-kali.md](referensi/desain-dua-kali.md): jalankan sub-agent paralel untuk merancang interface dengan beberapa cara yang radikal berbeda, lalu bandingkan dari depth, locality, dan penempatan seam.
