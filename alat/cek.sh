#!/usr/bin/env bash
# Cek struktur repo: tautan relatif hidup (skills/ dan berkas .md di akar), salinan platform.md identik,
# contoh peta fitur mematuhi kontrak empat H2, setiap skill tercatat di README,
# dan terjemahan setara dengan upstream.
# Pakai: alat/cek.sh [pstack-skills] [mattpocock-skills/skills/engineering] [pm-skills/pm-execution/skills]
#   Commit pembanding: mattpocock/skills abeeaf9, phuryn/pm-skills 9af7bfd. Clone:
#   git clone https://github.com/mattpocock/skills /tmp/up-matt && git -C /tmp/up-matt checkout abeeaf9
#   git clone https://github.com/phuryn/pm-skills /tmp/up-pm && git -C /tmp/up-pm checkout 9af7bfd
#   Perbandingan dilewati (baris "lewati") bila path tidak ada; "lewati" bukan bukti setara.
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; cd "$ROOT" || exit 2
UP="${1:-/root/pstack-claude/plugins/pstack/skills}"
UP_MATT="${2:-/tmp/up-matt/skills/engineering}"
UP_PM="${3:-/tmp/up-pm/pm-execution/skills}"
gagal=0; lapor(){ echo "GAGAL $*"; gagal=1; }

# 1. tautan relatif markdown
while IFS= read -r md; do
  dir=$(dirname "$md")
  # abaikan isi code fence: tautan di dalamnya adalah contoh, bukan tautan sungguhan
  awk '/^```/{dalam=!dalam; next} !dalam' "$md" \
    | grep -oE '\]\([^)#]+\)' | sed 's/^](//;s/)$//' | grep -vE '^(https?:|mailto:)' | while read -r t; do
    [ -e "$dir/$t" ] || echo "GAGAL tautan mati: $md -> $t"
  done
done < <(find skills -name '*.md'; ls ./*.md) | tee /tmp/cek-tautan.$$; [ -s /tmp/cek-tautan.$$ ] && gagal=1; rm -f /tmp/cek-tautan.$$

# 2. salinan platform.md identik
cmp -s skills/buat-skill-verifikasi/referensi/platform.md skills/rawat-skill-verifikasi/referensi/platform.md || lapor "platform.md tidak identik"

# 3. kontrak empat H2 di setiap berkas fitur contoh
for f in skills/buat-skill-verifikasi/referensi/contoh-peta-fitur/*.md; do
  [ "$(basename "$f")" = README.md ] && continue
  h=$(grep '^## ' "$f" | sed 's/^## //' | sed 's/dengan .*/dengan <harness>/' | paste -sd'|')
  [ "$h" = "Sub-fitur|Cara mencapainya (sudut pandang pengguna)|Mengendalikannya dengan <harness>|Jebakan" ] || lapor "kontrak H2: $f ($h)"
  grep -q '^Prasyarat:' "$f" || lapor "tanpa 'Prasyarat:': $f"
done

# 4. setara dengan upstream: jumlah heading, butir tebal, dan langkah bernomor
pasangan="create-verification-skill:buat-skill-verifikasi maintain-verification-skill:rawat-skill-verifikasi principle-prove-it-works:prinsip-buktikan-berfungsi principle-sequence-verifiable-units:prinsip-urutkan-unit-teruji"
if [ -d "$UP" ]; then
  hitung(){ grep -cE "$1" "$2" || true; }
  for p in $pasangan; do a="$UP/${p%%:*}/SKILL.md"; b="skills/${p##*:}/SKILL.md"
    for pola in '^#{1,3} ' '^- \*\*' '^[0-9]+\. '; do
      x=$(hitung "$pola" "$a"); y=$(hitung "$pola" "$b")
      [ "$x" = "$y" ] || lapor "jumlah '$pola' beda: ${p%%:*}=$x vs ${p##*:}=$y"
    done
  done
  for f in README:README create-note:buat-catatan search:cari; do
    a="$UP/create-verification-skill/references/feature-map-example/${f%%:*}.md"; b="skills/buat-skill-verifikasi/referensi/contoh-peta-fitur/${f##*:}.md"
    x=$(grep -cE '^(- |[0-9]+\. |#)' "$a"); y=$(grep -cE '^(- |[0-9]+\. |#)' "$b")
    [ "$x" = "$y" ] || lapor "jumlah butir beda: ${f%%:*}=$x vs ${f##*:}=$y"
  done
else echo "lewati: upstream tidak ditemukan di $UP"; fi

# 5. setiap folder skill tercatat di README (tautan) dan NOTICE (baris tabel)
for d in skills/*/; do d=${d%/}
  grep -qF "]($d/SKILL.md)" README.md || lapor "README tidak mencantumkan $d"
  grep -qF "\`$d/\`" NOTICE.md || lapor "NOTICE tidak mencantumkan $d"
done

# 6. setiap pemegang hak cipta MIT di NOTICE juga tercantum di LICENSE
grep '| MIT' NOTICE.md | sed 's/.*© [0-9]\{4\} //;s/ |.*//' | sort -u | while read -r p; do
  grep -qF "$p" LICENSE || lapor "pemegang MIT tidak ada di LICENSE: $p"
done

# 6. terjemahan skill MIT lain setara dengan upstream: heading, butir tebal, langkah bernomor, fence,
#    butir, baris tak kosong; plus tidak ada baris prosa (>=5 kata) yang disalin tanpa diterjemahkan.
#    Bagian tambahan lokal mulai dari "## Adaptasi kuka" tidak dibandingkan.
potong(){ awk '/^## Adaptasi kuka/{exit} 1' "$1"; }
setara(){ # setara <upstream> <terjemahan>
  local a=$1 b=$2 pola x y
  [ -f "$a" ] || { lapor "berkas upstream tidak ada: $a"; return; }
  [ -f "$b" ] || { lapor "berkas terjemahan tidak ada: $b"; return; }
  for pola in '^#{1,3} ' '^- \*\*' '^[0-9]+\. ' '^ *```' '^ *- ' '.'; do
    x=$(grep -cE "$pola" "$a" || true); y=$(potong "$b" | grep -cE "$pola" || true)
    [ "$x" = "$y" ] || lapor "jumlah '$pola' beda: $a=$x vs $b=$y"
  done
  awk 'NR==1&&/^---$/{fm=1;next} fm&&/^---$/{fm=0;next} fm{next} /^ *```/{d=!d;next} !d && NF>=5' "$a" \
    | grep -Fxf - "$b" | sed "s#^#GAGAL belum diterjemahkan: $b: #" | tee /tmp/cek-sama.$$
  [ -s /tmp/cek-sama.$$ ] && gagal=1; rm -f /tmp/cek-sama.$$; }
terjemahan_matt="codebase-design/SKILL.md:kukadesain/SKILL.md codebase-design/DEEPENING.md:kukadesain/referensi/pendalaman.md codebase-design/DESIGN-IT-TWICE.md:kukadesain/referensi/desain-dua-kali.md domain-modeling/SKILL.md:kukadomain/SKILL.md domain-modeling/ADR-FORMAT.md:kukadomain/referensi/format-adr.md domain-modeling/GLOSSARY-FORMAT.md:kukadomain/referensi/format-glossary.md improve-codebase-architecture/SKILL.md:kukaarsitektur/SKILL.md improve-codebase-architecture/HTML-REPORT.md:kukaarsitektur/referensi/laporan-html.md"
if [ -d "$UP_MATT" ]; then for p in $terjemahan_matt; do setara "$UP_MATT/${p%%:*}" "skills/${p##*:}"; done
else echo "lewati: upstream mattpocock/skills tidak ditemukan di $UP_MATT"; fi
if [ -d "$UP_PM" ]; then setara "$UP_PM/retro/SKILL.md" skills/refleksi/SKILL.md
else echo "lewati: upstream pm-skills tidak ditemukan di $UP_PM"; fi

[ $gagal = 0 ] && echo "ok    semua cek struktur lolos"; exit $gagal
