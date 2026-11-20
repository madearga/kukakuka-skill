#!/usr/bin/env bash
# kuka-status.sh — membaca keadaan alur kukajalan dari repo, bukan dari ingatan agen.
#
#   kuka-status.sh              laporkan tahap, gerbang, dan langkah berikutnya
#   kuka-status.sh mulai NN     catat SHA dasar tiket NN, tandai sedang dikerjakan
#   kuka-status.sh tandai NN    tandai tiket NN selesai (wajib bukti sah + perubahan kode sejak dasar)
#
# Bukti dan SHA dasar disimpan per fitur: .kuka/<fitur>/bukti/NN.md dan .kuka/<fitur>/dasar/NN.
# `mulai` dan `tandai` menjalankan gerbang yang sama dengan laporan status (tahap 0 dan 3).
# Jalankan dari dalam repo proyek. Kode keluar: 0 gerbang ok, 1 ada gerbang GAGAL, 2 salah pakai.
set -uo pipefail

AKAR=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "GAGAL bukan repo git"; exit 2; }
cd "$AKAR" || exit 2
JALAN=.kuka/jalan.md
gagal=0; DIAM=""
lapor_gagal(){ echo "GAGAL $*"; gagal=1; }
ok(){ [ -n "$DIAM" ] || echo "ok    $*"; }
nilai(){ [ -f "$JALAN" ] && sed -nE "s/^$1:[[:space:]]*//p" "$JALAN" | head -1 | sed 's/[[:space:]]*$//'; }
nn(){ printf '%02d' "$((10#$1))"; }
angka(){ echo "$1" | grep -qE '^#?[0-9]+$'; }

FITUR=$(nilai fitur); PINTU=$(nilai pintu); TINGKAT=$(nilai tingkat)
DIR=".scratch/$FITUR/issues"
KUKA=".kuka/$FITUR"
bukti_f(){ echo "$KUKA/bukti/$1.md"; }
dasar_f(){ echo "$KUKA/dasar/$1"; }

# ---------- akses tiket lokal (.scratch/<fitur>/issues) ----------
baris(){ # baris <berkas> <label> -> isi setelah "**Label:**" atau "Label:"
  [ -f "$1" ] || return 0
  sed -nE "s/^\*{0,2}$2:\*{0,2}[[:space:]]*//p" "$1" | head -1 | sed 's/[[:space:]]*$//'; }
berkas_tiket(){ local f; for f in "$DIR"/"$(nn "$1")"-*.md; do [ -e "$f" ] && { echo "$f"; return; }; done; }
daftar_tiket(){
  local f; for f in "$DIR"/[0-9]*-*.md; do [ -e "$f" ] || continue; b=$(basename "$f"); b=${b%%-*}
    angka "$b" && nn "$b" && echo; done | sort -u; }
status_tiket(){ # -> selesai | dikerjakan | siap | ?
  local f; f=$(berkas_tiket "$1"); [ -n "$f" ] || { echo "?"; return; }
  case "$(baris "$f" Status)" in resolved|selesai) echo selesai;; claimed) echo dikerjakan;; *) echo siap;; esac; }
urai_blocked(){ # satu baris per pemblokir, "NN" atau "!<teks tak dikenali>"
  # Aturan: kosong / None / tidak ada / - berarti bebas. Selain itu hanya daftar nomor tiket
  # (01, 1, #1) atau nama berkas tiket (01-skema.md, boleh dengan path), dipisah koma atau spasi.
  b=$(baris "$(berkas_tiket "$1")" "Blocked by")
  echo "$b" | grep -qiE '^(none|tidak ada|-|—|)$|^(none|tidak ada)[^[:alnum:]]' && return
  local x xs; read -ra xs <<< "$(echo "$b" | tr ',;' '  ')"
  for x in "${xs[@]}"; do
    if [[ "$x" =~ ^#?([0-9]+)$ ]] || [[ "$x" =~ ^(.*/)?([0-9]+)-[A-Za-z0-9._-]+$ ]]; then
      nn "${BASH_REMATCH[${#BASH_REMATCH[@]}-1]}"; echo
    else echo "!$b"; return; fi
  done; }
pemblokir(){ urai_blocked "$1" | grep -v '^!'; } # nomor tiket yang memblokir (yang formatnya sah)
punya_bidang(){ # punya_bidang <tiket> <Seam|Bukti selesai>
  local v; v=$(baris "$(berkas_tiket "$1")" "$2"); [ -n "$v" ] && ! echo "$v" | grep -qE '^<.*>$'; }
set_status(){ # set_status <tiket> <claimed|resolved>
  local f; f=$(berkas_tiket "$1")
  if grep -qE '^\*{0,2}Status:' "$f"; then sed -i -E "s/^(\*{0,2}Status:\*{0,2}[[:space:]]*).*/\1$2/" "$f"
  else printf '\n**Status:** %s\n' "$2" >> "$f"; fi; }
ada_tiket(){ [ -n "$(berkas_tiket "$1")" ]; }

# ---------- bukti ----------
cek_bukti(){ # cek_bukti <berkas> -> diam bila sah, selain itu cetak alasannya dan kembalikan 1
  awk '
    /^[[:space:]]*```/ { blok = !blok; cmd = 0; next }
    blok && /^\$[[:space:]]+[^[:space:]]/ { c = $0; sub(/^\$[[:space:]]+/, "", c); cmd = (c !~ /^<.*>$/); next }
    blok && cmd && NF && $0 !~ /^[[:space:]]*<[^>]*>[[:space:]]*$/ && $0 !~ /^[[:space:]]*(\.\.\.|…)[[:space:]]*$/ { keluar = 1 }
    /^\*{0,2}Kesimpulan:/ { k = $0; sub(/^\*{0,2}Kesimpulan:\*{0,2}[[:space:]]*/, "", k); if (k != "" && k !~ /^<.*>$/) kes = 1 }
    END {
      if (!keluar) { print "tidak ada blok kode berisi baris `$ <perintah>` diikuti keluarannya (placeholder <...> tidak dihitung)"; exit 1 }
      if (!kes) { print "baris `Kesimpulan:` kosong atau masih placeholder"; exit 1 }
    }' "$1"; }

# ---------- gerbang ----------
tahap=""; berikut=""
selesai_dengan(){ tahap="$1"; berikut="$2"; }

gerbang_siapkan(){ # tahap 0: jalan.md, branch. Kembali 1 bila GAGAL (tahap sudah diisi).
  if [ ! -f "$JALAN" ]; then
    lapor_gagal "$JALAN belum ada"
    selesai_dengan "0 Siapkan" "tanyakan pintu (fitur|bug) dan tingkat (ringan|standar|berat), lalu tulis $JALAN"; return 1
  elif [ -z "$FITUR" ] || [ -z "$PINTU" ] || [ -z "$TINGKAT" ]; then
    lapor_gagal "$JALAN belum lengkap (pintu, tingkat, fitur wajib)"
    selesai_dengan "0 Siapkan" "lengkapi $JALAN"; return 1
  fi
  local salah=""
  [[ "$FITUR" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] || salah="fitur '$FITUR' bukan slug (huruf, angka, . _ -)"
  case "$PINTU" in fitur|bug) ;; *) salah="pintu '$PINTU' (harus fitur atau bug)";; esac
  case "$TINGKAT" in ringan|standar|berat) ;; *) salah="tingkat '$TINGKAT' (harus ringan, standar, atau berat)";; esac
  if [ -n "$salah" ]; then lapor_gagal "$JALAN: nilai tidak dikenal: $salah"; selesai_dengan "0 Siapkan" "perbaiki $JALAN"; return 1; fi
  ok "pintu $PINTU · tingkat $TINGKAT · fitur $FITUR"
  cabang=$(git branch --show-current)
  bawaan=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')
  if [ -z "$cabang" ]; then
    lapor_gagal "HEAD terlepas (detached), bukan di branch fitur"
    selesai_dengan "0 Siapkan" "user mengetik: git switch -c $FITUR"; return 1
  fi
  case "$cabang" in "${bawaan:-main}"|main|master)
    lapor_gagal "di branch default ($cabang); commit per tiket akan masuk ke sana. Buat branch fitur dulu"
    selesai_dengan "0 Siapkan" "user mengetik: git switch -c $FITUR"; return 1;;
  esac
  ok "branch $cabang"; return 0; }

gerbang_kukatanya(){ # pintu fitur wajib lolos kukatanya sebelum tiket dikerjakan
  [ "$PINTU" = fitur ] || return 0
  case "$(nilai label-kukatanya)" in selesai|"siap untuk implementasi") return 0;; esac
  lapor_gagal "kukatanya belum selesai (label-kukatanya: $(nilai label-kukatanya))"; return 1; }

gerbang_tiket(){ # tahap 3: Seam, Bukti selesai, dan format Blocked by setiap tiket
  local t x g=0
  for t in $TIKET; do
    punya_bidang "$t" Seam || { lapor_gagal "tiket $t tanpa Seam"; g=1; }
    punya_bidang "$t" "Bukti selesai" || { lapor_gagal "tiket $t tanpa Bukti selesai"; g=1; }
    while IFS= read -r x; do
      if [ "${x#!}" != "$x" ]; then
        lapor_gagal "tiket $t: Blocked by tidak dikenali: '${x#!}'. Pakai nomor tiket (01, 02) atau nama berkas (01-skema.md), atau None"; g=1
      elif ! ada_tiket "$x"; then
        lapor_gagal "tiket $t: Blocked by merujuk tiket $x yang tidak ada di $DIR"; g=1
      fi
    done < <(urai_blocked "$t")
  done
  return $g; }

# ---------- subperintah ----------
case "${1:-}" in
  mulai|tandai)
    [ -n "${2:-}" ] || { echo "pakai: $0 $1 NN"; exit 2; }
    angka "$2" || { echo "GAGAL nomor tiket tidak sah: '$2' (pakai angka, mis. 01)"; exit 2; }
    DIAM=1
    gerbang_siapkan || { echo "TAHAP     $tahap"; echo "BERIKUTNYA $berikut"; exit 1; }
    gerbang_kukatanya || { echo "GAGAL selesaikan tahap 1 dulu (jalankan kuka-status.sh)"; exit 1; }
    T=$(nn "$2"); ada_tiket "$T" || { echo "GAGAL tiket $T tidak ditemukan di $DIR"; exit 1; }
    TIKET=$(daftar_tiket)
    gerbang_tiket || { echo "GAGAL perbaiki gerbang tiket di atas sebelum $1"; exit 1; }
    S=$(status_tiket "$T"); D=$(dasar_f "$T"); B=$(bukti_f "$T")
    [ "$S" = selesai ] && { echo "GAGAL tiket $T sudah selesai; tidak dibuka lagi. Untuk perbaikan, buat tiket baru"; exit 1; }
    if [ "$1" = mulai ]; then
      if [ "$S" = dikerjakan ] && [ -s "$D" ]; then echo "ok    tiket $T sudah dimulai; SHA dasar tetap $(cat "$D") ($D)"; exit 0; fi
      for p in $(pemblokir "$T"); do [ "$(status_tiket "$p")" = selesai ] || { echo "GAGAL tiket $T masih diblokir $p"; exit 1; }; done
      H=$(git rev-parse -q --verify HEAD) || { echo "GAGAL repo belum punya commit; SHA dasar tidak bisa dicatat"; exit 1; }
      mkdir -p "$(dirname "$D")"; echo "$H" > "$D"; set_status "$T" claimed
      echo "ok    tiket $T dimulai; SHA dasar $H di $D"; exit 0
    fi
    [ -s "$D" ] || { echo "GAGAL tiket $T belum dimulai (jalankan: $0 mulai $T)"; exit 1; }
    DS=$(cat "$D"); git cat-file -e "$DS^{commit}" 2>/dev/null || { echo "GAGAL SHA dasar di $D tidak dikenal git: $DS"; exit 1; }
    [ -f "$B" ] || { echo "GAGAL bukti belum ada: $B"; exit 1; }
    alasan=$(cek_bukti "$B") || { echo "GAGAL bukti tidak sah ($B): $alasan"; exit 1; }
    if git cat-file -e "$DS:$B" 2>/dev/null && git show "$DS:$B" | cmp -s - "$B"; then
      echo "GAGAL bukti $B tidak berubah sejak SHA dasar; jalankan ulang Bukti selesai dan tulis hasilnya"; exit 1; fi
    [ "$(git rev-list --count "$DS"..HEAD)" -gt 0 ] || { echo "GAGAL belum ada commit sejak SHA dasar tiket $T"; exit 1; }
    [ -n "$(git diff --name-only "$DS" HEAD -- . ':(exclude).kuka' ':(exclude).scratch')" ] || {
      echo "GAGAL commit sejak SHA dasar tiket $T hanya mengubah .kuka/ atau .scratch/; belum ada perubahan kode"; exit 1; }
    set_status "$T" resolved; echo "ok    tiket $T ditandai selesai"; exit 0 ;;
  ""|status) ;;
  *) echo "pakai: $0 [status | mulai NN | tandai NN]"; exit 2 ;;
esac

# ---------- laporan tahap ----------
if gerbang_siapkan; then
  LABEL=$(nilai label-kukatanya)
  SPEC_ADA=0; [ -s ".scratch/$FITUR/spec.md" ] && SPEC_ADA=1
  TIKET=$(daftar_tiket)

  if [ "$PINTU" = fitur ] && [ "$LABEL" = dihentikan ]; then
    lapor_gagal "kukatanya berlabel dihentikan"
    selesai_dengan "1 Gali" "BERHENTI: laporkan penghambat kukatanya ke user"
  elif [ "$PINTU" = fitur ] && [ "$LABEL" != selesai ] && [ "$LABEL" != "siap untuk implementasi" ]; then
    selesai_dengan "1 Gali" "jalankan kukatanya; setelah selesai tulis label-kukatanya dan dokumen-keputusan"
  elif [ "$PINTU" = fitur ] && [ $SPEC_ADA = 0 ] && [ -z "$TIKET" ]; then
    ok "kukatanya: $LABEL"
    selesai_dengan "2 Spesifikasi" "tulis spec di .scratch/$FITUR/spec.md (skill kukaspek)"
  elif [ -z "$TIKET" ]; then
    if [ "$PINTU" = bug ]; then selesai_dengan "3 Tiket" "triage singkat oleh agen (gejala, penyebab, perbaikan terkecil), lalu tulis brief-nya sebagai tiket $DIR/01-<slug>.md beserta Seam dan Bukti selesai"
    else selesai_dengan "3 Tiket" "tulis tiket di $DIR (templat referensi/tiket.md milik skill kukajalan); tiap tiket wajib Seam dan Bukti selesai"; fi
  else
    gerbang_tiket
    total=0; beres=0; dikerjakan=""; bebas=""; macet=""
    for t in $TIKET; do
      total=$((total+1)); s=$(status_tiket "$t")
      case "$s" in
        selesai) beres=$((beres+1)) ;;
        dikerjakan) dikerjakan="$dikerjakan $t" ;;
        siap) blok=""; for p in $(pemblokir "$t"); do [ "$(status_tiket "$p")" = selesai ] || blok="${blok:+$blok, }$p"; done
              if [ -z "$blok" ]; then bebas="$bebas $t"; else macet="$macet $t(← $blok)"; fi ;;
        *) lapor_gagal "status tiket $t tidak terbaca" ;;
      esac
    done
    echo "info  tiket $beres/$total selesai${dikerjakan:+ · dikerjakan:$dikerjakan}${bebas:+ · bebas:$bebas}${macet:+ · menunggu:$macet}"

    if [ $gagal = 1 ]; then
      selesai_dengan "3 Tiket" "perbaiki gerbang yang GAGAL sebelum tahap 4"
    elif [ -n "$dikerjakan" ]; then
      t=${dikerjakan# }; t=${t%% *}
      if [ -f "$(bukti_f "$t")" ] && cek_bukti "$(bukti_f "$t")" >/dev/null; then selesai_dengan "4 Per tiket" "deslop bila belum, lalu: kuka-status.sh tandai $t"
      else selesai_dengan "4 Per tiket" "lanjutkan tiket $t: tes dulu, kode, jalankan tes, review sendiri, commit (bila belum), lalu tulis bukti ke $(bukti_f "$t") (dasar: $(cat "$(dasar_f "$t")" 2>/dev/null || echo '?'))"; fi
    elif [ -n "$bebas" ]; then
      t=${bebas# }; t=${t%% *}
      ref=$(berkas_tiket "$t")
      selesai_dengan "4 Per tiket" "kuka-status.sh mulai $t, lalu kerjakan $ref: tes dulu, kode sampai tes hijau, review sendiri, commit"
    elif [ $beres -lt $total ]; then
      lapor_gagal "tidak ada tiket bebas tapi $((total-beres)) belum selesai (cek siklus Blocked by)"
      selesai_dengan "4 Per tiket" "periksa dependensi tiket"
    else
      if [ "$PINTU" = bug ]; then intent="brief triage di tiket bug"; else intent="spec + daftar keputusan"; fi
      langkah="no-mistakes (intent dari $intent), lalu babysit"
      [ "$TINGKAT" = berat ] && langkah="interrogate atas seluruh branch, lalu $langkah"
      if [ -z "$(git remote)" ]; then
        echo "awas  repo tanpa remote: no-mistakes butuh remote untuk push dan PR"
        langkah="tambahkan remote dulu (git remote add origin <url>), lalu $langkah"
      fi
      selesai_dengan "5 Tutup" "$langkah"
    fi
  fi
fi

echo "TAHAP     $tahap"
echo "BERIKUTNYA $berikut"
exit $gagal
