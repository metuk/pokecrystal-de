# pokecrystal-de: Projektnotizen

Ziel: bit-genaue Disassembly von **Pokémon - Kristall-Edition (Germany)**, Rev 0, Header-ID `BYTD`.
Ziel-SHA1: `accb584293ba056152f1fd908439b019017ff2fe` (siehe `roms.sha1`).

## Bauen und vergleichen

```sh
make -j$(nproc) RGBDS=../rgbds-1.0.4/          # baut pokecrystal-de.gbc
make RGBDS=../rgbds-1.0.4/ compare             # SHA1-Prüfung
tools/romdiff.py                               # Übereinstimmung pro Bank + erste Abweichungen (Label/Section)
tools/romdiff.py -b 0x0a -n 50                 # nur Bank $0a
tools/romdiff.py -s [-b 0x01]                  # nicht passende Sections mit Prozent
tools/romdiff.py -l LabelName                  # Hexdump eines Labels: built vs. base
```

- rgbds 1.0.4 liegt lokal in `../rgbds-1.0.4/`. Systemweit ist nur 0.9.1 installiert, das zu alt ist.
- `baserom.gbc` ist ein Symlink auf `../Pokemon - Kristall-Edition (Germany).gbc`. Ist durch `*.gbc` gitignored und darf **nie** committet werden.

## Portierungs-Pipeline (tools/de/)

Iterativ ausführen (jede Runde findet mehr, weil die Build-ROM näher am Original ist):

```sh
make -j$(nproc) RGBDS=../rgbds-1.0.4/
python3 tools/de/locate.py     # Build-Code im baserom finden -> de_syms.json, de_unmatched.json
python3 tools/de/retext.py     # text/line/para-Blöcke durch deutschen Text ersetzen
python3 tools/de/restring.py   # li/dname/db-Strings, Beschreibungen, Dex-Einträge, Trainernamen
python3 tools/de/todo.py [FILE]  # Dateien nach nicht passenden Bytes sortiert
python3 tools/de/show.py FILE [-d] # englischer Quelltext neben deutschen Bytes (disassembliert / -d als Daten)
python3 tools/de/regfx.py LABEL... | --all  # Grafiken (PNG) / Binärdateien aus baserom übernehmen, LZ-Flags suchen
python3 tools/de/layout.py       # Section-Startadressen Build vs. DE
```

- `locate.py`: zerlegt Sections an Labels in Stücke. Zeiger-Bytes (Patches aus den .o-Dateien) sind Platzhalter.
  Stücke werden eindeutig gesucht, sequentiell weitergeführt (kurze Stücke nur innerhalb derselben Quelldatei oder wenn beide Nachbarn übereinstimmen),
  Zeigerwerte aus gefundenen Stücken liefern Adressen der Ziele (iterativ, mit Banks über BANK(sym), BANK("Section") oder Section-Mehrheit).
- `retext.py` lernt unbekannte `text_far`-Ziele aus dem englischen Block (de_syms_learned.json).
- `restring.py` lässt Zeilen unverändert, wenn die deutschen Bytes gleich den Build-Bytes sind; überspringt `pushc ascii`-Bereiche; setzt `{d:CONST}` wieder ein.

## Referenzen (außerhalb des Repos, `../referenz/`)

- `pokecrystal/`: pret/pokecrystal, Englisch, Basis dieses Repos. Git-Remote `pret`.
- `pokecrystal-es/`: erosunica/pokecrystal-es, bit-genaue **spanische** Disassembly (rgbds 0.3.9, alte Syntax).
  Gleiche EU-Lokalisierungsbasis wie DE, daher die wichtigste Vorlage für EU-Codeänderungen, Charmap (Umlaute), Bank-Layout und Textstruktur.

## Konventionen

- pret-Stil beibehalten (STYLE.md, Tabs, englische Labels/Kommentare), damit eine spätere Einreichung bei pret möglich bleibt.
- Die Git-Historie von pret/pokecrystal ist eingemergt.

## Stand

- 2026-10-01: Setup. Makefile auf ein Ziel `pokecrystal-de.gbc` umgestellt (`-i BYTD -n 0`). EN-Quellcode baut, Übereinstimmung **61,74 %**.
  Weitgehend identisch: Grafik- und Musikbänke (u. a. $48–$5a, $2a–$2d, $3a–$3d, $7a–$7f).
  Stark abweichend: Code, Texte, Karten (Verschiebungen durch längere Texte).

- 2026-10-02: Crystal-1.1-Codebasis (`-D _CRYSTAL11`, EU basiert auf 1.1). Texte, Strings, Dex-Einträge per Pipeline übernommen.
  Map Scripts 26–28 in Bänken $75/$76/$79 (wie ES). Struktur 97,4 % gefunden, positionsgenau 86,3 %.

- 2026-10-02 (später): Grafiken übernommen (Logo, Tilesets, Diplom, Pokédex, Trainerpass, Schriften ...).
  Viele DE-Grafiken sind "literal-only" LZ-komprimiert (Flags in gfx/lz.mk). Zwei Intro-Tilemaps sind mit einem
  nicht reproduzierbaren Verfahren komprimiert und als `gfx/intro/*.de.lz` eingecheckt.
  Struktur 99,2 % gefunden, positionsgenau 86,8 %. Rest: ~14 KB in ~360 Stücken (`tools/de/todo.py`).

- 2026-10-02 (abends): **bit-genau** (`make compare` OK, auch nach `make clean`).
  Wichtige Erkenntnisse: deutsche LZ-Grafiken brauchen meist `--literal-only --align 1`;
  `tools/stadium --european`; Radio hat zusätzlichen Zustand OAKS_POKEMON_TALK_INTRO_4;
  Credits mit europäischem Team; Pokédex-Größe 1 Byte (dm), Magikarp-Länge in mm;
  Zeichen `<SHY>` ($1e), `<-LF>` ($1d), `ß` ($be).

## Mögliche nächste Schritte

1. Aufräumen für eine Einreichung bei pret: `tools/de/` auslagern oder entfernen, englische Kommentare prüfen
   (z. B. „English“-Hinweise, `; unreferenced`-Markierungen), Labelnamen von englischen Texten passend umbenennen
   (z. B. US_VERSION_STAFF -> GERMAN_VERSION_STAFF).
2. CI (`.github/workflows/main.yml`) auf `make compare` umstellen ist nicht möglich ohne baserom; `make` genügt.
