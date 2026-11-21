#!/usr/bin/env bash
# Uji kuka-status.sh pada repo tiruan (tracker lokal) dari tahap 0 sampai 5,
# termasuk kasus yang wajib ditolak. Tidak menyentuh repo mana pun selain direktori sementara.
# Pakai: alat/uji-kukajalan.sh [path-kuka-status.sh]   (bawaan: skrip di skills/kukajalan/alat)
# shellcheck disable=SC2016,SC2015,SC2001  # backtick literal di isi tiket/bukti memang disengaja
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
K="${1:-$ROOT/skills/kukajalan/alat/kuka-status.sh}"
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
cd "$T" || exit 2; git init -q -b main; git config user.email t@t; git config user.name t
git commit -q --allow-empty -m awal
lulus=0; gagal=0
harap(){ # harap <deskripsi> <pola-grep> <kode-keluar> -- perintah...
  local d=$1 pola=$2 kode=$3; shift 4
  out=$("$@" 2>&1); k=$?
  if echo "$out" | grep -qE "$pola" && [ "$k" = "$kode" ]; then lulus=$((lulus+1)); echo "ok    $d"
  else gagal=$((gagal+1)); echo "GAGAL $d (kode $k, harap $kode; pola '$pola')"; echo "$out" | sed 's/^/      /'; fi; }
benar(){ # benar <deskripsi> perintah... (lulus bila perintah sukses)
  local d=$1; shift
  if "$@"; then lulus=$((lulus+1)); echo "ok    $d"; else gagal=$((gagal+1)); echo "GAGAL $d"; fi; }
F=catatan
tiket(){ # tiket NN judul blocked seam bukti   (ke .scratch/$F/issues)
  mkdir -p ".scratch/$F/issues"
  { echo "# $1: $2"; echo; echo "**What to build:** x"; echo; echo "**Blocked by:** $3"; echo
    echo "**Status:** ready-for-agent"; echo; [ -n "$4" ] && echo "**Seam:** $4"; echo
    [ -n "$5" ] && echo "**Bukti selesai:** $5"; } > ".scratch/$F/issues/$1-$2.md"; }
bukti(){ # bukti NN [kesimpulan]   (ke .kuka/$F/bukti/NN.md, format sah)
  mkdir -p ".kuka/$F/bukti"
  printf '# Bukti tiket %s\n\n```\n$ npm run cek\n1 catatan tersimpan\n```\n\nKesimpulan: %s\n' "$1" "${2:-cocok}" > ".kuka/$F/bukti/$1.md"; }
kode(){ echo "$1" >> src.txt; git add -A; git commit -qm "kode $1"; }

# (a) tahap 0 tidak butuh berkas setup eksternal apa pun: jalan.md + branch fitur cukup
harap "tahap 0 tanpa jalan.md"          'pintu \(fitur\|bug\)' 1 -- "$K"
mkdir -p .kuka; printf 'pintu: fitur\ntingkat: standar\n' > .kuka/jalan.md
harap "jalan.md tidak lengkap"          'belum lengkap' 1 -- "$K"
printf 'pintu: fitur\ntingkat: standar\nfitur: catatan\n' > .kuka/jalan.md
# B8: branch default adalah gerbang tahap 0, dicek sebelum tiket ada
harap "B8 branch default = tahap 0"     'TAHAP +0 Siapkan' 1 -- "$K"
harap "B8 pesan branch jelas"           'branch default \(main\).*git switch -c catatan|git switch -c catatan' 1 -- "$K"
git switch -q -c catatan
harap "A tahap 1 tanpa issue-tracker.md" 'TAHAP +1 Gali' 0 -- "$K"
echo 'label-kukatanya: dihentikan' >> .kuka/jalan.md
harap "kukatanya dihentikan = berhenti" 'BERHENTI' 1 -- "$K"
sed -i 's/^label-kukatanya: .*/label-kukatanya: selesai/' .kuka/jalan.md
harap "tahap 2 spec"                    'TAHAP +2 Spesifikasi' 0 -- "$K"
# (b) spec kosong menahan tahap di 2: spec harus ada DAN tidak kosong
mkdir -p .scratch/catatan; : > .scratch/catatan/spec.md
harap "B spec kosong menahan tahap 2"   'TAHAP +2 Spesifikasi' 0 -- "$K"
# (b2) dokumen-keputusan tidak boleh menempati spec.md: daftar keputusan kukatanya bukan spec tahap 2
echo 'dokumen-keputusan: .scratch/catatan/spec.md' >> .kuka/jalan.md
harap "b2 keputusan di spec.md = GAGAL" 'sama dengan spec.md' 1 -- "$K"
harap "b2 tetap ditahan di tahap 2"     'TAHAP +2 Spesifikasi' 1 -- "$K"
sed -i 's|^dokumen-keputusan: .*|dokumen-keputusan: .scratch/catatan/keputusan.md|' .kuka/jalan.md
mkdir -p .scratch/catatan/issues; echo "# Spec" > .scratch/catatan/spec.md
harap "tahap 3 tiket"                   'TAHAP +3 Tiket' 0 -- "$K"

tiket 01 skema "None (can start immediately)" "simpanCatatan()" '`npm run cek` → 1 catatan'
tiket 02 cari  "01" "" '`curl /cari?q=a` → 1 hasil'
tiket 03 hapus "01, 02" "hapusCatatan()" '<isi nanti>'
harap "gerbang: tiket tanpa Seam"       'tiket 02 tanpa Seam' 1 -- "$K"
harap "gerbang: Bukti placeholder"      'tiket 03 tanpa Bukti selesai' 1 -- "$K"
harap "gerbang tiket = tahap 3"         'TAHAP +3 Tiket' 1 -- "$K"
# B1: mulai/tandai menjalankan gerbang yang sama dengan status
harap "B1 mulai ditolak: tiket lain tanpa Seam" 'tiket 02 tanpa Seam' 1 -- "$K" mulai 01
benar "B1 mulai yang ditolak tidak mengubah status" grep -q 'ready-for-agent' .scratch/catatan/issues/01-skema.md
tiket 02 cari  "01" "cariCatatan()" '`curl /cari?q=a` → 1 hasil'
tiket 03 hapus "01, 02" "hapusCatatan()" '`npm run hapus` → 0 catatan'
git switch -q main
harap "B1 mulai ditolak di branch default" 'branch default' 1 -- "$K" mulai 01
harap "B1 tandai ditolak di branch default" 'branch default' 1 -- "$K" tandai 01
git switch -q catatan
# B4 + B6: format Blocked by tegas; rujukan ke tiket yang tidak ada ditolak dengan jelas
tiket 03 hapus "Skema catatan" "hapusCatatan()" '`npm run hapus` → 0 catatan'
harap "B4 Blocked by berupa judul ditolak" "tiket 03: Blocked by tidak dikenali: 'Skema catatan'" 1 -- "$K"
tiket 03 hapus "Fase 2 migrasi" "hapusCatatan()" '`npm run hapus` → 0 catatan'
harap "B4 judul berangka tidak dibaca sebagai 02" "Blocked by tidak dikenali: 'Fase 2 migrasi'" 1 -- "$K"
tiket 03 hapus "99" "hapusCatatan()" '`npm run hapus` → 0 catatan'
harap "B6 Blocked by tiket tak ada"     'tiket 03: Blocked by merujuk tiket 99 yang tidak ada' 1 -- "$K"
harap "B6 tanpa galat sed"              '^TAHAP +3 Tiket' 1 -- bash -c "\"$K\" 2>&1 | grep -v \"can't read\"; exit \${PIPESTATUS[0]}"
tiket 03 hapus "01-skema.md, #2" "hapusCatatan()" '`npm run hapus` → 0 catatan'
harap "B4 nama berkas dan #N diterima"  'menunggu: 02\(← 01\) 03\(← 01, 02\)' 0 -- "$K"
harap "B6 mulai abc ditolak jelas"      "nomor tiket tidak sah: 'abc'" 2 -- "$K" mulai abc
harap "B6 mulai 99 tidak ditemukan"     'tiket 99 tidak ditemukan' 1 -- "$K" mulai 99
git add -A; git commit -qm tiket
harap "tahap 4 tiket bebas = 01"        'mulai 01' 0 -- "$K"
harap "02 masih diblokir"               'menunggu: 02\(← 01\)' 0 -- "$K"
benar "tanpa spasi ganda di baris info" bash -c "\"$K\" | sed -n 's/^info  //p' | grep -qv '  '"
harap "mulai 02 ditolak (diblokir)"     'masih diblokir 01' 1 -- "$K" mulai 02
harap "mulai 01"                        'tiket 01 dimulai.*\.kuka/catatan/dasar/01' 0 -- "$K" mulai 01
benar "B5 SHA dasar per fitur"          test -s .kuka/catatan/dasar/01
harap "status menunjuk tiket berjalan"  'lanjutkan tiket 01.*\.kuka/catatan/bukti/01\.md' 0 -- "$K"
harap "tandai tanpa bukti ditolak"      'bukti belum ada: \.kuka/catatan/bukti/01\.md' 1 -- "$K" tandai 01
# B3: bukti wajib berisi perintah + keluaran, placeholder ditolak
mkdir -p .kuka/catatan/bukti; echo "Perintah: npm run cek" > .kuka/catatan/bukti/01.md
harap "B3 bukti tanpa \$ perintah ditolak" 'bukti tidak sah.*\$ <perintah>' 1 -- "$K" tandai 01
printf '# Bukti tiket 01\n\n```\n$ <persis seperti dijalankan>\n<keluaran asli>\n```\n\nKesimpulan: <cocok / tidak cocok>\n' > .kuka/catatan/bukti/01.md
harap "B3 templat placeholder ditolak"  'bukti tidak sah' 1 -- "$K" tandai 01
printf '# Bukti tiket 01\n\n```\n$ npm run cek\n```\n\nKesimpulan: cocok\n' > .kuka/catatan/bukti/01.md
harap "B3 perintah tanpa keluaran ditolak" 'bukti tidak sah' 1 -- "$K" tandai 01
bukti 01 '<isi nanti>'
harap "B3 kesimpulan placeholder ditolak" 'Kesimpulan' 1 -- "$K" tandai 01
bukti 01
harap "tandai tanpa commit ditolak"     'belum ada commit' 1 -- "$K" tandai 01
# B2: commit yang hanya menyentuh .kuka/ dan Status tiket tidak dihitung
git add -A; git commit -qm "kuka: status + bukti"
harap "B2 commit hanya .kuka/.scratch ditolak" 'hanya mengubah \.kuka/ atau \.scratch/' 1 -- "$K" tandai 01
kode 01
harap "tandai 01"                       'ditandai selesai' 0 -- "$K" tandai 01
grep -q '^\*\*Status:\*\* resolved' .scratch/catatan/issues/01-skema.md && { lulus=$((lulus+1)); echo "ok    status 01 = resolved"; } || { gagal=$((gagal+1)); echo "GAGAL status 01 tidak resolved"; }
# B7: tiket selesai tidak dibuka lagi dan SHA dasarnya tidak ditimpa
dasar01=$(cat .kuka/catatan/dasar/01); git commit -qam "kuka: 01 selesai"
harap "B7 mulai tiket selesai ditolak"  'tiket 01 sudah selesai' 1 -- "$K" mulai 01
benar "B7 SHA dasar 01 tidak ditimpa"   test "$(cat .kuka/catatan/dasar/01)" = "$dasar01"
benar "B7 status 01 tetap resolved"     grep -q '^\*\*Status:\*\* resolved' .scratch/catatan/issues/01-skema.md
harap "B7 tandai tiket selesai ditolak" 'tiket 01 sudah selesai' 1 -- "$K" tandai 01
harap "berikutnya 02"                   'mulai 02' 0 -- "$K"
for n in 02 03; do "$K" mulai $n >/dev/null; bukti $n; kode $n; "$K" tandai $n >/dev/null; done
git commit -qam "kuka: 02 03 selesai"
harap "tahap 5 standar"                 'TAHAP +5 Tutup.*' 0 -- "$K"
harap "laporan 3/3"                     'tiket 3/3 selesai' 0 -- "$K"
harap "tahap 5 fitur: intent dari spec" 'intent dari spec' 0 -- "$K"
harap "repo tanpa remote diperingatkan" 'tanpa remote' 0 -- "$K"
sed -i 's/^tingkat: .*/tingkat: berat/' .kuka/jalan.md
harap "tahap 5 berat = interrogate"     'interrogate' 0 -- "$K"

# B5: fitur berikutnya (pintu bug) tidak memakai ulang bukti fitur lama
printf 'pintu: bug\ntingkat: ringan\nfitur: bugx\n' > .kuka/jalan.md
harap "pintu bug: triage agen, tiket lokal" 'triage.*\.scratch/bugx/issues/01-' 0 -- "$K"
F=bugx; tiket 01 x "None" "a()" '`x` → y'
harap "B5 mulai bug 01"                 '\.kuka/bugx/dasar/01' 0 -- "$K" mulai 01
kode bug01
harap "B5 bukti fitur lama tidak dipakai" 'bukti belum ada: \.kuka/bugx/bukti/01\.md' 1 -- "$K" tandai 01
bukti 01; harap "B5 tandai bug dengan bukti baru" 'ditandai selesai' 0 -- "$K" tandai 01
# B5: bukti yang sudah ada sebelum mulai (tidak diperbarui) ditolak
tiket 02 y "None" "b()" '`y` → z'; bukti 02; git add -A; git commit -qm "bukti basi"
"$K" mulai 02 >/dev/null; kode bug02
harap "B5 bukti basi ditolak"           'tidak berubah sejak SHA dasar' 1 -- "$K" tandai 02
bukti 02 'cocok, dijalankan ulang'; harap "B5 bukti diperbarui diterima" 'ditandai selesai' 0 -- "$K" tandai 02
harap "tahap 5 bug: intent dari brief triage" 'intent dari brief triage' 0 -- "$K"

printf 'pintu: bug\ntingkat: ringan\nfitur: bugz\n' > .kuka/jalan.md
F=bugz; tiket 01 x "01" "a()" '`x` → y'
harap "siklus dependensi terdeteksi"    'masih diblokir 01|tidak ada tiket bebas' 1 -- "$K"

# (c) tidak ada jejak penulis atau skill upstream di mana pun selain NOTICE.md dan LICENSE (alat pembanding dikecualikan)
#     dan alat/cek.sh (pembanding terjemahan wajib menyebut path upstream). Berkas uji ini juga dikecualikan.
cari_luar(){ grep -rniwE "$1" "$ROOT" --exclude-dir=.git --exclude-dir=node_modules \
  --exclude=NOTICE.md --exclude=LICENSE --exclude=README.md --exclude=cek.sh --exclude=uji-kukajalan.sh; }
P="m""att|poc""ock|hur""yn|phur""yn|lau""ren"
benar "C nama penulis upstream hanya di NOTICE/LICENSE" bash -c "$(declare -f cari_luar); ROOT='$ROOT'; ! cari_luar '$P'"
P="to-sp""ec|to-ti""ckets|codebase-""design|domain-""modeling|improve-codebase-""architecture|gril""ling|grill-""me|setup-m""att-pocock-skills"
benar "C nama skill upstream hanya di NOTICE" bash -c "$(declare -f cari_luar); ROOT='$ROOT'; ! cari_luar '$P'"

# (d) refleksi: skill ada, kukajalan merujuknya, retro tak lagi disarankan
benar "C refleksi ada dan dirujuk kukajalan" bash -c "test -f '$ROOT/skills/refleksi/SKILL.md' && grep -q '/refleksi' '$ROOT/skills/kukajalan/SKILL.md' && ! grep -qw retro '$ROOT/skills/kukajalan/SKILL.md'"

# (e) kukaspek, kukatiket, kukaarsitektur: ada dan terhubung ke alur
benar "C kukaspek dan kukatiket dirujuk" bash -c "test -f '$ROOT/skills/kukaspek/SKILL.md' && test -f '$ROOT/skills/kukaspek/referensi/spec.md' && test -f '$ROOT/skills/kukatiket/SKILL.md' && grep -q kukaspek '$ROOT/skills/kukajalan/SKILL.md' && grep -q kukatiket '$ROOT/skills/kukajalan/SKILL.md'"
benar "C kukaarsitektur ada dan disebut" bash -c "test -f '$ROOT/skills/kukaarsitektur/SKILL.md' && test -f '$ROOT/skills/kukaarsitektur/referensi/laporan-html.md' && grep -q kukaarsitektur '$ROOT/skills/kukajalan/SKILL.md'"
benar "C kukadesain dan kukadomain ada" bash -c "test -f '$ROOT/skills/kukadesain/SKILL.md' && test -f '$ROOT/skills/kukadesain/referensi/pendalaman.md' && test -f '$ROOT/skills/kukadesain/referensi/desain-dua-kali.md' && test -f '$ROOT/skills/kukadomain/SKILL.md' && test -f '$ROOT/skills/kukadomain/referensi/format-adr.md' && test -f '$ROOT/skills/kukadomain/referensi/format-glossary.md'"

# (f) gerbang di dokumen = gerbang yang ditegakkan skrip. Skrip tidak memeriksa bagian Seam tes pada spec
#     (kasus "B spec kosong" dan "tahap 3 tiket" di atas: spec tanpa bagian Seam tes tetap lolos); Seam
#     ditegakkan per tiket di tahap 3. dokumen-keputusan dicek skrip untuk satu hal: tidak boleh sama
#     dengan spec.md (kasus b2). Setiap kalimat gerbang yang menyebut seam tes wajib menyatakan
#     "tidak dicek skrip".
benar "D gerbang seam-spec jujur" bash -c "! grep -nEi '(^\| 2 |gerbang).*seam tes' '$ROOT/skills/kukajalan/SKILL.md' '$ROOT/skills/kukaspek/SKILL.md' | grep -v 'tidak dicek skrip'"

echo "---- $lulus lulus, $gagal gagal"; [ $gagal = 0 ]
