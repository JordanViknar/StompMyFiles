*One day, [Jordan](https://github.com/JordanViknar) decided he had enough of wasting storage space on files he barely used.*

*What if a tool existed that could **easily** crush anything in its path ? And thus came onto the world...*

---

# StompMyFiles

Universal file compression utility, aiming for brute strength (at the cost of time) and ease of use. Made in Lua.

![License](https://img.shields.io/github/license/JordanViknar/StompMyFiles?color=orange)
![Top language](https://img.shields.io/github/languages/top/JordanViknar/StompMyFiles?color=blue)
![Commit activity](https://img.shields.io/github/commit-activity/m/JordanViknar/StompMyFiles?color=orange)
![Repo size](https://img.shields.io/github/repo-size/JordanViknar/StompMyFiles)

(Currently) available for :

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Manjaro](https://img.shields.io/badge/manjaro-35BF5C?style=for-the-badge&logo=manjaro&logoColor=white)

## Goals

StompMyFiles aims to be :
- **Powerful**, no matter the cost : StompMyFiles' first aim is to compress files given to it as hard as it can, under the best known method available depending on the file's type.
- **Extremely simple to use** : You give it a file, it replaces it with its compressed version if possible. There's **nothing** more to it.
- **Lossless** : Every single piece of data originally present must be able to be restored from StompMyFiles, with just the compressed file itself.

*Note : StompMyFiles focuses so heavily on compression strength that it's pretty CPU and RAM intensive, and may even be slow in a few cases. As such, it may not always be the best fit for your use case.*

## Installation

### Arch Linux-based distributions

StompMyFiles can be installed from Arch Linux through the provided [PKGBUILD](https://github.com/JordanViknar/StompMyFiles/blob/main/install/archlinux/PKGBUILD).

**Always** download the latest version of the PKGBUILD, then use **makepkg** in its directory.

It will eventually be made available on the AUR once the program is complete enough.

### I want to add support for my own distribution !

Here are informations which might be useful to you :

StompMyFiles is meant to be installed in `/usr/share/stomp-my-files` (except `smf` which goes into `/usr/bin`).

It depends on :
- Lua 5.4 *(5.3 and 5.2 MIGHT work)*
- [LuaFileSystem](https://github.com/lunarmodules/luafilesystem)
- [LuaSocket](https://github.com/lunarmodules/luasocket) + [LuaSec](https://github.com/lunarmodules/luasec)
- Common tools such as : *which*, *tar*, *grep*, *xz*

And optionally :
- 7-zip / p7zip : If the system doesn't provide them, StompMyFiles will download them if possible.
- Dolphin Emulator : StompMyFiles uses *dolphin-tool* to compress Nintendo Wii/GameCube games.

### Manual local installation (not recommended except for development)

Install the aforementioned dependencies on your system, clone the repository, and run `./smf`, assuming you're in the program's directory.

## Usage

```
smf [OPTIONS] FILES ...
```

Available options :
- `--help` : Displays StompMyFiles' help page
- `--verbose` : Used for debugging. Makes StompMyFiles more explicit about what it's doing.
- `--version` : Reports StompMyFiles' version and shows a small description.

ISO file specific options (if none of these are specified, StompMyFiles will skip them) :
- `--iso` : Tells StompMyFiles to treat ISO files normally.
- `--wii-gc` : Tells StompMyFiles to treat ISO files as Wii/GameCube games.

## Support

| Tool | Local Download | Compression / Decompression | Used for |
| ---- | -------------- | --------------------------- | -------- |
| 7z | ✅ | ✅ | Folders |
| xz | ❌ | ✅ | Default choice for single files |
| dolphin-tool | ❌ | ✅ | Nintendo Wii / GameCube games (requires Dolphin Emulator to be installed) |
| nsz | *Planned* | ✅ | Nintendo Switch games |
| upx | *Planned ?* | *Planned ?* | Executables |

## Compression Test Results

### Personal Files

| Up-to-date | File(s) | Tool | Original Size | SMF Output | Percentage |
| ---------- | ------- | ---- | ------------- | ---------- | ---------- |
| ✅ | First Year of Pre-Engineering | 7z | 579.8 Mo | 431.1 Mo | 74 % |
| ✅ | Second Year of Pre-Engineering | 7z | 1.1 Go | 731.9 Mo | 67 % |

### Applications / Games

| Up-to-date | Application | Type | Tool | Original Size | SMF Output | Percentage |
| ---------- | ----------- | ---- | ---- | ------------- | ---------- | ---------- |
| ✅ | Celeste | Steam Game (Linux) | 7z | 1.2 Go | 770.6 Mo | 64 % |
| ✅ | Um Jammer Lammy | PlayStation 1 Game | xz | 743.5 Mo | 499.5 Mo | 67 % |
| ✅ | Super Smash Bros. Brawl | Wii Game |  dolphin-tool | 8.5 Go | 5.8 Go | 68 % |
| ✅ | Rayman Redemption | Windows Game | 7z | 1.3 Go | 879.8 Mo | 68 % |
| ✅ | Pizza Tower | Steam Game (Windows) | 7z | 256.8 Mo | 185.4 Mo | 72 % |

## Bug Reports / Contributions / Suggestions
You can report bugs or suggest features by making an issue, or you can contribute to this program directly by forking it and then sending a pull request.

Any help will be very much appreciated. Thank you.