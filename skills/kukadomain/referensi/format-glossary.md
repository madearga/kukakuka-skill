# Format GLOSSARY.md

## Struktur

```md
# {Context Name}

{One or two sentence description of what this context is and why it exists.}

## Language

**Order**:
{A one or two sentence description of the term}
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request

**Customer**:
A person or organization that places orders.
_Avoid_: Client, buyer, account
```

## Aturan

- **Bersikap tegas.** Saat ada beberapa kata untuk konsep yang sama, pilih yang terbaik dan daftarkan yang lain di bawah `_Avoid_`.
- **Jaga definisi tetap padat.** Maksimal satu atau dua kalimat. Definisikan apa DIA itu, bukan apa yang dia lakukan.
- **Hanya sertakan istilah yang spesifik untuk context proyek ini.** Konsep pemrograman umum (timeout, error type, pola utility) tidak termasuk, meski proyek memakainya secara ekstensif. Sebelum menambah sebuah istilah, tanyakan: apakah ini konsep yang unik untuk context ini, atau konsep pemrograman umum? Hanya yang pertama yang berhak masuk.
- **Kelompokkan istilah di bawah subjudul** saat muncul cluster yang alami. Kalau semua istilah termasuk satu area yang kohesif, daftar datar sudah cukup.

## Repo single vs multi-context

**Single context (sebagian besar repo):** Satu `GLOSSARY.md` di root repo.

**Multiple context:** Sebuah `GLOSSARY-MAP.md` di root repo mendaftar context-context, di mana masing-masing berada, dan bagaimana mereka saling berhubungan:

```md
# Glossary Map

## Contexts

- [Ordering](./src/ordering/GLOSSARY.md): receives and tracks customer orders
- [Billing](./src/billing/GLOSSARY.md): generates invoices and processes payments
- [Fulfillment](./src/fulfillment/GLOSSARY.md): manages warehouse picking and shipping

## Relationships

- **Ordering → Fulfillment**: Ordering emits `OrderPlaced` events; Fulfillment consumes them to start picking
- **Fulfillment → Billing**: Fulfillment emits `ShipmentDispatched` events; Billing consumes them to generate invoices
- **Ordering ↔ Billing**: Shared types for `CustomerId` and `Money`
```

Skill ini menyimpulkan struktur mana yang berlaku:

- Kalau `GLOSSARY-MAP.md` ada, bacalah untuk menemukan context
- Kalau hanya ada `GLOSSARY.md` di root, single context
- Kalau keduanya tidak ada, buat `GLOSSARY.md` di root secara malas saat istilah pertama terselesaikan

Saat ada beberapa context, simpulkan context mana yang berhubungan dengan topik saat ini. Kalau tidak jelas, tanyakan.
