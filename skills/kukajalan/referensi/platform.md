# Kukajalan per runtime

| Hal | Claude Code | Pi | Hermes |
|---|---|---|---|
| Memanggil kukajalan | `/kukajalan` atau otomatis | `/skill:kukajalan` atau otomatis | `/kukajalan` atau otomatis |
| Mengosongkan konteks | `/clear` | sesi baru | `/new` |
| Menjalankan `kuka-status.sh` | Bash | bash | terminal tool |
| Subagent (`swarm`, `interrogate`) | Agent tool | tergantung ekstensi | delegasi Hermes; belum diuji |
| Bertanya ke user | AskUserQuestion atau teks | teks | teks atau `clarify` |

Skill yang harus terpasang agar alur lengkap: `kukatanya`, `prinsip-buktikan-berfungsi`, `prinsip-urutkan-unit-teruji`, `diagnosing-bugs` (tiket gagal di tahap 4), `no-mistakes`, dan skill pstack di [pstack.md](pstack.md) sesuai tingkat.

Bila satu skill tidak terpasang, kukajalan menyebut namanya dan berhenti di tahap itu. Jangan mengganti skill yang hilang dengan improvisasi diam-diam.
