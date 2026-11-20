# Desain dua kali (Design It Twice)

Saat user ingin menjajaki interface alternatif untuk kandidat pendalaman yang dipilih, pakai pola sub-agent paralel ini. Berbasis "Design It Twice" (Ousterhout): kemungkinan besar ide pertamamu bukan yang terbaik.

Memakai kosakata di [SKILL.md](../SKILL.md): **module**, **interface**, **seam**, **adapter**, **leverage**.

## Proses

### 1. Bingkai ruang masalah

Sebelum men-spawn sub-agent, tulis penjelasan yang menghadap user tentang ruang masalah untuk kandidat yang dipilih:

- Constraint yang harus dipenuhi oleh interface baru mana pun
- Dependencies yang akan dia andalkan, dan masuk kategori yang mana (lihat [pendalaman.md](pendalaman.md))
- Sketsa kode kasar sebagai ilustrasi untuk meng-grounding constraint — bukan proposal, hanya cara membuat constraint-nya konkret

Tunjukkan ini ke user, lalu langsung lanjut ke Langkah 2. User membaca dan berpikir sementara sub-agent bekerja secara paralel.

### 2. Spawn sub-agent

Spawn 3+ sub-agent secara paralel, masing-masing dengan context window segar. Setiap satu harus menghasilkan interface yang **radikal berbeda** untuk module yang didalamkan.

Beri tiap sub-agent sebuah technical brief terpisah (path berkas, detail coupling, kategori dependency dari [pendalaman.md](pendalaman.md), apa yang berada di balik seam). Brief ini independen dari penjelasan ruang masalah yang menghadap user di Langkah 1. Beri tiap agent constraint desain yang berbeda:

- Agent 1: "Kecilkan interface: targetkan 1–3 entry point maksimal. Maksimalkan leverage per entry point."
- Agent 2: "Maksimalkan fleksibilitas: dukung banyak use case dan ekstensi."
- Agent 3: "Optimalkan untuk caller yang paling umum: buat kasus default menjadi trivial."
- Agent 4 (kalau relevan): "Rancang di sekitar ports & adapters untuk dependency lintas-seam."

Sertakan kosakata [SKILL.md](../SKILL.md) maupun kosakata GLOSSARY.md di dalam brief, agar tiap sub-agent menamai sesuatu secara konsisten dengan bahasa arsitektur dan bahasa domain proyek.

Tiap sub-agent menghasilkan output:

1. Interface (types, methods, params, plus invariant, ordering, error modes)
2. Contoh pemakaian yang memperlihatkan cara caller memakainya
3. Apa yang disembunyikan implementation di balik seam
4. Strategi dependency dan adapter (lihat [pendalaman.md](pendalaman.md))
5. Trade-off: di mana leverage tinggi, di mana leverage tipis

### 3. Sajikan dan bandingkan

Sajikan desain-desain secara berurutan agar user bisa mencerna masing-masing, lalu bandingkan dalam prosa. Kontraskan dari **depth** (leverage di interface), **locality** (di mana perubahan terpusat), dan **penempatan seam**.

Setelah membandingkan, berikan rekomendasimu sendiri: desain mana yang menurutmu terkuat dan mengapa. Kalau elemen-elemen dari desain yang berbeda bisa dikombinasikan dengan baik, usulkan hybrid. Berpendapatlah tegas: user menginginkan penilaian yang tegas, bukan sekadar menu.
