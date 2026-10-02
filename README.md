# Pokémon - Kristall-Edition [![Build Status][ci-badge]][ci]

This is a disassembly of the German version of Pokémon Crystal: Pokémon - Kristall-Edition.

It builds the following ROM:

- Pokemon - Kristall-Edition (Germany).gbc `sha1: accb584293ba056152f1fd908439b019017ff2fe`

To set up the repository, see [INSTALL.md](INSTALL.md).

This repository does not contain a ROM. You need your own copy of the game only to verify the build with `make compare`.


## About

This project is based on [**pret/pokecrystal**][pokecrystal], the disassembly of the English version. It uses the Crystal 1.1 code base, like all European releases, together with the German text, graphics and the code changes of the European localization.

The Spanish disassembly [**erosunica/pokecrystal-es**][pokecrystal-es] was a helpful reference for changes that the European versions share.

This is an unofficial fan project. It is not affiliated with pret, Nintendo, Game Freak or The Pokémon Company.


## Deutsch

Dies ist eine Disassembly der deutschen Pokémon Kristall-Edition. `make` baut daraus eine ROM, die Byte für Byte mit dem Original übereinstimmt. Eine ROM ist nicht enthalten. Anleitung: [INSTALL.md](INSTALL.md).


## See also

Most of the documentation for pokecrystal also applies here:

- [**pokecrystal documentation**][docs]
- [**pokecrystal wiki**][wiki] (includes [tutorials][tutorials])
- [**Other pret projects**][pret]

[pokecrystal]: https://github.com/pret/pokecrystal
[pokecrystal-es]: https://github.com/erosunica/pokecrystal-es
[docs]: https://pret.github.io/pokecrystal/
[wiki]: https://github.com/pret/pokecrystal/wiki
[tutorials]: https://github.com/pret/pokecrystal/wiki/Tutorials
[pret]: https://pret.github.io/
[ci]: https://github.com/metuk/pokecrystal-de/actions
[ci-badge]: https://github.com/metuk/pokecrystal-de/actions/workflows/main.yml/badge.svg
