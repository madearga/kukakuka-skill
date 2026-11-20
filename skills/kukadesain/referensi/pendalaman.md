# Pendalaman

Cara memperdalam sebuah cluster berisi shallow module secara aman, dengan memperhitungkan dependencies-nya. Mengasumsikan kosakata di [SKILL.md](../SKILL.md): **module**, **interface**, **seam**, **adapter**.

## Kategori dependency

Saat menilai sebuah kandidat untuk didalamkan, klasifikasikan dependencies-nya. Kategorinya menentukan bagaimana module yang didalamkan dites melintasi seam-nya.

### 1. In-process

Komputasi murni, state in-memory, tanpa I/O. Selalu bisa didalamkan: gabungkan module-module-nya dan tes langsung melalui interface yang baru. Tidak perlu adapter.

### 2. Local-substitutable

Dependencies yang punya stand-in lokal untuk test (PGLite untuk Postgres, filesystem in-memory). Bisa didalamkan selama stand-in-nya ada. Module yang didalamkan dites dengan stand-in yang berjalan di test suite. Seam-nya internal; tidak ada port di external interface module.

### 3. Remote tapi dimiliki sendiri (Ports & Adapters)

Service milikmu sendiri di seberang network boundary (microservice, API internal). Definisikan sebuah **port** (interface) di seam. Deep module memegang logikanya; transport di-inject sebagai sebuah **adapter**. Test memakai adapter in-memory. Production memakai adapter HTTP/gRPC/queue.

Bentuk rekomendasi: *"Definisikan port di seam, implementasikan adapter HTTP untuk production dan adapter in-memory untuk testing, sehingga logika berada di satu deep module meskipun dia di-deploy melintasi network."*

### 4. External sungguhan (Mock)

Service pihak ketiga (Stripe, Twilio, dll.) yang tidak kamu kendalikan. Module yang didalamkan menerima dependency eksternalnya sebagai port yang di-inject; test menyediakan mock adapter.

## Disiplin seam

- **Satu adapter berarti seam hipotetis; dua adapter berarti seam nyata.** Jangan memperkenalkan port kecuali setidaknya dua adapter benar-benar beralasan (biasanya production + test). Seam dengan satu adapter hanyalah indirection.
- **Internal seam vs external seam.** Sebuah deep module bisa punya internal seam (privat bagi implementation-nya, dipakai oleh test-nya sendiri) maupun external seam di interface-nya. Jangan mengekspos internal seam lewat interface hanya karena test memakainya.

## Strategi testing: replace, don't layer

- Unit test lama pada shallow module menjadi sampah begitu ada test di interface module yang didalamkan; hapus saja.
- Tulis test baru di interface module yang didalamkan. **Interface adalah permukaan tes**.
- Test meng-assert pada hasil yang teramati melalui interface, bukan pada state internal.
- Test harus selamat dari refactor internal, karena mereka mendeskripsikan perilaku, bukan implementation. Kalau sebuah test harus berubah saat implementation berubah, dia sedang menguji melewati interface.
