# Padanan platform

Isi skill ini netral runtime. Tabel ini memetakan istilah yang dipakai di skill ke alat nyata di tiap runtime. (Salinan yang sama ada di `buat-skill-verifikasi` dan `rawat-skill-verifikasi` supaya tiap skill tetap utuh saat disalin sendirian; `alat/cek.sh` memastikan keduanya identik.)

| Istilah di skill | Claude Code | Hermes | Codex |
|---|---|---|---|
| `<folder-skill-proyek>` | `.claude/skills/` | `.hermes/skills/` atau `.agents/skills/` di root repo (perlu `hermes skills trust` sekali per repo) | lokasi skill proyek Codex (lihat dokumentasi Codex) |
| Skill level profil/pengguna | `~/.claude/skills/` | `~/.hermes/skills/` (profil default) atau `~/.hermes/profiles/<profil>/skills/` | lokasi skill pengguna Codex |
| Subagent baca-saja paralel | alat `Agent`/`Task` (beberapa panggilan dalam satu giliran) | `delegate_task(tasks=[...])`; default maks 10 per panggilan (`delegation.max_concurrent_children`); subagent daun tidak bisa mendelegasikan lagi | beberapa `spawn_agent` dalam satu respons |
| Menjalankan perintah | `Bash` | `terminal`, `process_manage` untuk proses latar | `shell` |
| Browser/CDP | MCP browser atau CLI (Playwright, chrome-devtools) | `browser_exec`, `browser_cdp` | MCP browser atau CLI |
| Memanggil skill | `/nama-skill` | `/nama-skill`, atau `skill_view` | skill dimuat otomatis; ikuti instruksinya |
| Membuka PR | `gh pr create` | `gh pr create` lewat `terminal` | `gh pr create` |

## Catatan Hermes

- Skill proyek baru dimuat setelah repo dipercaya: `hermes skills trust <path-repo>`. Skill proyek punya prioritas tertinggi (`project → local → create_dir → external_dirs`), jadi `verifikasi-<app>` milik repo menang atas skill bernama sama di profil.
- Kurator skill Hermes tidak menyunting skill proyek, jadi peta fitur hanya berubah lewat `rawat-skill-verifikasi` atau tangan manusia — sesuai batas suntingan.
- Untuk sistem yang dikendalikan lewat bot chat (Telegram dsb.), "permukaan" adalah percakapan bot: kendalikan lewat akun/bot uji dan grup terpisah, jangan lewat chat produksi.
- Field `user-invocable` di frontmatter dipakai Claude Code. Perilaku Hermes terhadap field ini belum diuji di repo ini; `alat/cek-hermes.sh` memeriksa skill tetap terbaca.
