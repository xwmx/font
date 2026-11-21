```
  __     ___      ___         .
 / _|   /\  \   /' _ `\     .o8
| |_   /::\  \  /\ \/\ \  .o888oo
|  _| /:/\:\__\ \ \_\ \_\   888
|_|   \:\/:/  /  \/_/\/_/   888
       \::/  /              888 .
        \/__/               "888"
```

# font

`font` is a command line program for managing fonts on macOS and Linux.

`font` downloads fonts from online sources, installs them into your user font directory, and keeps track of exactly which files were installed, so fonts can be listed, checked, or cleanly removed later using simple, memorable commands.

`font` is designed to be lightweight, easy to use, and contained in a single, portable script that can be `curl`ed into any environment.

## Installation

### Manual

To install as an administrator, copy and paste one of the following multi-line commands:

```bash
# install using wget
sudo wget https://raw.github.com/xwmx/font/master/font -O /usr/local/bin/font &&
  sudo chmod +x /usr/local/bin/font

# install using curl
sudo curl -L https://raw.github.com/xwmx/font/master/font -o /usr/local/bin/font &&
  sudo chmod +x /usr/local/bin/font
```

###### User-only Installation

To install with just user permissions, simply add the `font` script to your `$PATH`. If you already have a `~/bin` directory, for example, you can use one of the following commands:

```bash
# download with wget
wget https://raw.github.com/xwmx/font/master/font -O ~/bin/font && chmod +x ~/bin/font

# download with curl
curl -L https://raw.github.com/xwmx/font/master/font -o ~/bin/font && chmod +x ~/bin/font
```

### Requirements

`font` is a Bash script that works on macOS and Linux, including Ubuntu, Debian, Fedora, and Arch. It depends on the following tools:

- `bash`
- `curl`
- `unzip`
- `find`

These are included with macOS. On Linux, `bash` and `find` are almost always present, but `curl` and `unzip` are missing from some minimal installations.

On Linux, [fontconfig](https://www.freedesktop.org/wiki/Software/fontconfig/) is also recommended. When `fc-cache` is available, `font` uses it to refresh the font cache after installing or uninstalling fonts, so changes show up in applications right away. Without it, fonts still install, but applications may not see them until the cache is rebuilt or you log out and back in.

```bash
# Ubuntu / Debian
sudo apt install curl unzip fontconfig

# Fedora
sudo dnf install curl unzip fontconfig

# Arch Linux
sudo pacman -S curl unzip fontconfig
```

### Font Directory

Fonts are installed into the following directory by default:

| Platform | Default font directory                          |
|:---------|:------------------------------------------------|
| macOS    | `~/Library/Fonts`                               |
| Linux    | `${XDG_DATA_HOME:-~/.local/share}/fonts`        |

To install somewhere else, set the `FONT_DIR` environment variable. For example, to install system-wide on Linux:

```bash
sudo FONT_DIR=/usr/local/share/fonts font install fontshare satoshi
```

## Usage

### Installing Fonts

To install a font, use `font install` with a source and a font name:

```
> font install fontshare satoshi
Downloading 'satoshi' from fontshare...
Installed 6 font file(s) for 'satoshi' into /Users/example/Library/Fonts
```

On Linux the fonts are installed into `~/.local/share/fonts` instead:

```
> font install fontshare satoshi
Downloading 'satoshi' from fontshare...
Installed 6 font file(s) for 'satoshi' into /home/example/.local/share/fonts
```

Fonts are downloaded as an archive, and every `.otf` and `.ttf` file in the archive is copied into your font directory. On Linux, the font cache is then refreshed with `fc-cache` if it is installed.

### Sources

`font` currently supports the following sources:

| Source      | Font name                                                   | Example                              |
|:------------|:------------------------------------------------------------|:-------------------------------------|
| `fontshare` | The font's slug on [Fontshare](https://www.fontshare.com/)  | `font install fontshare general-sans` |
| `google`    | The family name on [Google Fonts](https://fonts.google.com/) | `font install google "Open Sans"`    |

Quote font names that contain spaces.

```
> font install google "Open Sans"
Downloading 'Open Sans' from google...
Installed 20 font file(s) for 'Open Sans' into /Users/example/Library/Fonts
```

### Listing Fonts

`font list` shows the fonts installed with `font`, followed by all font files found in the system's font directories:

```
> font list
Installed with font:
  fontshare satoshi
  google Open Sans

Installed on the system:
  Arial.ttf
  Helvetica.ttc
  OpenSans-Bold.ttf
  Satoshi-Regular.otf
  ...
```

Each entry in the first section is a `<source> <font>` pair, the same values used with `font status` and `font uninstall`. The second section lists font files by file name, and includes fonts that were not installed with `font`.

`font list` called with a string or regular expression will show only matching entries. Matching is case-insensitive and uses extended regular expressions:

```
> font list satoshi
Installed with font:
  fontshare satoshi

Installed on the system:
  Satoshi-Bold.otf
  Satoshi-Regular.otf

> font list '^open.*bold'
Installed with font:
  (no matches)

Installed on the system:
  OpenSans-Bold.ttf
  OpenSans-BoldItalic.ttf
```

In the first section the search string is matched against the source and font name, so `font list google` shows everything installed from Google Fonts. In the second section it is matched against file names.

The system section searches the following directories, skipping any that don't exist. `$FONT_DIR` is always included.

On macOS:

- `~/Library/Fonts`
- `/Library/Fonts`
- `/System/Library/Fonts`

On Linux:

- `${XDG_DATA_HOME:-~/.local/share}/fonts`
- `~/.fonts`
- `/usr/local/share/fonts`
- `/usr/share/fonts`

`.otf`, `.ttf`, `.ttc`, `.otc`, and `.dfont` files are included.

### Checking Status

`font status` reports whether a font is installed. It exits with status `0` when every recorded file is present and `1` otherwise, so it can be used in scripts:

```
> font status fontshare satoshi
Installed: 'satoshi' (fontshare) [6/6 file(s) present]

> font status fontshare general-sans
Not installed: 'general-sans' (fontshare)
```

If some of the installed files have been deleted by hand, `font status` reports the font as incomplete:

```
> font status fontshare satoshi
Incomplete or missing: 'satoshi' (fontshare) [4/6 file(s) present]
```

### Uninstalling Fonts

`font uninstall` removes only the files that `font` installed for that font:

```
> font uninstall fontshare satoshi
Removed 6 font file(s) for 'satoshi' (fontshare)
```

Install records are kept for the user that ran `font install`, so run `font uninstall` the same way you ran `font install`. For example, a font installed with `sudo` is uninstalled with `sudo`.

## Help

```
Usage:
  font <subcommand> [--subcommand-options] [<arguments>]
  font -h | --help
  font --version

Options:
  -h --help  Display this help information.
  --version  Display version information.

Help:
  font help [<subcommand>]
```

For full usage, run:

```
font help
```

For help with a particular subcommand, try:

```
font help <subcommand name>
```

## Subcommands

<p align="center">
  <a href="#font-help">(default) / help</a> •
  <a href="#font-install">install</a> •
  <a href="#font-list">list</a> •
  <a href="#font-status">status</a> •
  <a href="#font-subcommands">subcommands</a> •
  <a href="#font-uninstall">uninstall</a> •
  <a href="#font-version">version</a>
</p>

### `font help`

```
Usage:
  font help [<subcommand>]

Description:
  Display help information for font or a specified subcommand.
```

### `font install`

```
Usage:
  font install <source> <font>

Description:
  Install a <font> from <source>.

Sources:
  fontshare   Download from Fontshare.
  google      Download from Google Fonts.

Exit status:
  0   Font successfully installed.
  1   Invalid parameters, unsupported source, missing dependency
      (curl or unzip), or download failure.
```

### `font list`

```
Usage:
  font list [<search string>]

Description:
  List the fonts installed with font, followed by all font files found in
  the system's font directories. When provided with a search string or
  regular expression, only matching entries are listed. Matching is
  case-insensitive.

Exit status:
  0   Success, including when no entries match.
  1   Invalid search pattern.
```

### `font status`

```
Usage:
  font status <source> <font>

Description:
  Check whether a <font> from <source> is installed.

Exit status:
  0   Font is installed and all files are present.
  1   Font is not installed, or some files are missing.
```

### `font subcommands`

```
Usage:
  font subcommands [--raw]

Options:
  --raw  Display the subcommand list without formatting.

Description:
  Display the list of available subcommands.
```

### `font uninstall`

```
Usage:
  font uninstall <source> <font>

Description:
  Uninstall a <font> from <source> by removing the files recorded when
  it was installed.

Exit status:
  0   Font successfully uninstalled.
  1   Invalid parameters or no install record found.
```

### `font version`

```
Usage:
  font ( version | --version )

Description:
  Display the current program version.
```

---

Copyright (c) 2026 William Melody • See LICENSE for details.

[github.com/xwmx/font](https://github.com/xwmx/font)
