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

### Homebrew

To install with [Homebrew](http://brew.sh/) on macOS or Linux:

```bash
brew tap xwmx/taps
brew install font
```

Or, to install without a separate tap step:

```bash
brew install xwmx/taps/font
```

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

The `homebrew` source works differently. It requires [Homebrew](http://brew.sh/) instead of `curl` and `unzip`, and is only available on macOS. See [Homebrew Casks](#homebrew-casks-macos).

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

`FONT_DIR` does not apply to the `homebrew` source, since Homebrew decides where cask fonts are linked.

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

A URL can be used in place of a source and font name. See [Installing from URLs](#installing-from-urls).

### Sources

`font` currently supports the following sources:

| Source      | Font name                                                   | Example                              |
|:------------|:------------------------------------------------------------|:-------------------------------------|
| `fontshare` | The font's slug on [Fontshare](https://www.fontshare.com/)  | `font install fontshare general-sans` |
| `google`    | The family name on [Google Fonts](https://fonts.google.com/) | `font install google "Open Sans"`    |
| `homebrew`  | The full cask name from [Homebrew's font casks](https://formulae.brew.sh/cask-font/), macOS only | `font install homebrew font-fira-code` |
| `url`       | A direct link to a `.zip`, `.ttf`, or `.otf` file, see [Installing from URLs](#installing-from-urls) | `font install https://example.com/fonts/Example.zip` |

Quote font names that contain spaces.

```
> font install google "Open Sans"
Downloading 'Open Sans' from google...
Installed 20 font file(s) for 'Open Sans' into /Users/example/Library/Fonts
```

#### Homebrew Casks (macOS)

The `homebrew` source installs fonts from [Homebrew's font casks](https://formulae.brew.sh/cask-font/). Use the full cask name, which always starts with `font-`:

```
> font install homebrew font-fira-code
Installing 'font-fira-code' with homebrew...
...
Installed 'font-fira-code' with homebrew
```

Instead of downloading and copying files itself, `font` runs `brew install --cask`. A few things work differently from the other sources:

- It is only available on macOS, and requires `brew` rather than `curl` and `unzip`.
- Only font casks are accepted, so names that don't start with `font-` are rejected. This keeps `font` from installing regular applications.
- Homebrew manages the font files, so [`FONT_DIR`](#font-directory) is ignored.
- `font list`, `font status`, and `font uninstall` ask Homebrew directly, so they work with every installed font cask, including ones you installed with `brew` before using `font`.

### Installing from URLs

Instead of a source and font name, `font install` accepts a URL. `font status` and `font uninstall` do too, so the same URL identifies a font in all three commands. These URLs are recognized:

| URL                    | Example                                         | Source      | Font             |
|:-----------------------|:------------------------------------------------|:------------|:-----------------|
| Fontshare page         | `https://www.fontshare.com/fonts/paquito`       | `fontshare` | `paquito`        |
| Google Fonts page      | `https://fonts.google.com/specimen/Montserrat`  | `google`    | `Montserrat`     |
| Homebrew cask page     | `https://formulae.brew.sh/cask/font-fira-code`  | `homebrew`  | `font-fira-code` |
| Direct link to a file  | `https://example.com/fonts/Example.zip`         | `url`       | `Example`        |

Fontshare and Google Fonts download links are recognized as well. A URL for one of these sources is recorded under that source, exactly as if you had typed the source and font name, so `font install https://www.fontshare.com/fonts/paquito` and `font install fontshare paquito` are equivalent:

```
> font install https://fonts.google.com/specimen/Montserrat
Downloading 'Montserrat' from google...
Installed 18 font file(s) for 'Montserrat' into /Users/example/Library/Fonts

> font status google Montserrat
Installed: 'Montserrat' (google) [18/18 file(s) present]
```

Quote URLs that contain `&` or `?` so your shell doesn't interpret them.

#### Direct Links

A link to any other host is treated as a direct link to a font file. A `.zip` link installs every `.otf` and `.ttf` file in the archive, and a `.ttf` or `.otf` link installs that file. Query strings and fragments are ignored when working out the file type.

Direct links are recorded under the `url` source, using the file name without its extension as the font name:

```
> font install https://example.com/fonts/Example.zip
Downloading 'Example' from https://example.com/fonts/Example.zip...
Installed 2 font file(s) for 'Example' into /Users/example/Library/Fonts

> font status url Example
Installed: 'Example' (url) [2/2 file(s) present]

> font list --source url
Installed with font:
  url Example
```

Some things to keep in mind:

- A URL that isn't recognized, or a direct link to any other type of file, is rejected with an error.
- Two links with the same file name share one record, so the second install replaces the first.
- `font install url Example` does not work, since the link itself is needed to download. Use the URL. `font status` and `font uninstall` can use either form.

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

Each entry in the first section is a `<source> <font>` pair, the same values used with `font status` and `font uninstall`, such as `homebrew font-fira-code`. The second section lists font files by file name, and includes fonts that were not installed with `font`.

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

To list fonts from a single source, use `--source`:

```
> font list --source google
Installed with font:
  google Open Sans

> font list --source homebrew
Installed with font:
  homebrew font-fira-code
  homebrew font-hack
```

`--source` can be combined with a search string, so `font list --source homebrew hack` shows only the Homebrew fonts that match `hack`. The system font files are not listed when `--source` is used, since they aren't associated with a source. The source must be one of `fontshare`, `google`, `homebrew`, or `url`.

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

A [URL](#installing-from-urls) can be used in place of a source and font, as in `font status https://www.fontshare.com/fonts/paquito`.

For the `homebrew` source, `font status` asks Homebrew whether the cask is installed, so there is no file count:

```
> font status homebrew font-fira-code
Installed: 'font-fira-code' (homebrew)
```

### Uninstalling Fonts

`font uninstall` removes only the files that `font` installed for that font:

```
> font uninstall fontshare satoshi
Removed 6 font file(s) for 'satoshi' (fontshare)
```

Install records are kept for the user that ran `font install`, so run `font uninstall` the same way you ran `font install`. For example, a font installed with `sudo` is uninstalled with `sudo`.

A [URL](#installing-from-urls) can be used in place of a source and font, as in `font uninstall https://example.com/fonts/Example.zip`.

Fonts from the `homebrew` source are removed with `brew uninstall --cask`:

```
> font uninstall homebrew font-fira-code
Removed 'font-fira-code' (homebrew)
```

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
  font install <url>

Description:
  Install a <font> from <source>, or from a font <url>.

Sources:
  fontshare   A font from Fontshare, by name.
  google      A font family from Google Fonts, by name.
  homebrew    A font cask from Homebrew, by cask name. macOS only.
  url         A direct link to a .zip, .ttf, or .otf file.

URLs:
  Fontshare and Google Fonts pages, Homebrew cask pages, and direct links
  to .zip, .ttf, or .otf files are recognized, so a <url> can be used
  anywhere a <source> and <font> are accepted.

Examples:
  font install fontshare paquito
  font install google "Open Sans"
  font install homebrew font-fira-code
  font install https://www.fontshare.com/fonts/paquito
  font install https://fonts.google.com/specimen/Montserrat
  font install https://example.com/fonts/Example.zip

Exit status:
  0   Font successfully installed.
  1   Invalid parameters, unrecognized or unsupported URL, unsupported
      source, missing dependency (curl and unzip, or brew for homebrew),
      or download failure.
```

### `font list`

```
Usage:
  font list [--source <source>] [<search string>]

Options:
  --source <source>  Only list fonts installed from <source>.

Description:
  List the fonts installed with font, followed by all font files found in
  the system's font directories. When provided with a search string or
  regular expression, only matching entries are listed. Matching is
  case-insensitive.

  When --source is used, only fonts installed from the specified source are
  listed, and the system font files are omitted.

Sources:
  fontshare, google, homebrew, url

Examples:
  font list
  font list satoshi
  font list --source google
  font list --source homebrew mono

Exit status:
  0   Success, including when no entries match.
  1   Invalid search pattern, unsupported source, or missing source name.
```

### `font status`

```
Usage:
  font status <source> <font>
  font status <url>

Description:
  Check whether a <font> from <source>, or a font <url>, is installed. For
  homebrew, Homebrew is asked whether the cask is installed.

Exit status:
  0   Font is installed and all files are present.
  1   Font is not installed, or some files are missing.

Examples:
  font status fontshare paquito
  font status homebrew font-fira-code
  font status https://fonts.google.com/specimen/Montserrat
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
  font uninstall <url>

Description:
  Uninstall a <font> from <source>, or a font <url>, by removing the files
  recorded when it was installed. For homebrew, the cask is removed with
  `brew uninstall --cask`.

Exit status:
  0   Font successfully uninstalled.
  1   Invalid parameters or no install record found.

Examples:
  font uninstall fontshare paquito
  font uninstall homebrew font-fira-code
  font uninstall https://fonts.google.com/specimen/Montserrat
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
