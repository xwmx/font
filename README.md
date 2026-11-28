
<div align="center">
<table>
<tr>
<td>

<pre><code>  __     ___      ___         .
 / _|   /\  \   /' _ `\     .o8
| |_   /::\  \  /\ \/\ \  .o888oo
|  _| /:/\:\__\ \ \_\ \_\   888
|_|   \:\/:/  /  \/_/\/_/   888
       \::/  /              888 .
        \/__/               "888"</code></pre>

</td>
</tr>
</table>
</div>

<p align="center"></p><!-- spacer -->

<div align="center">
  <a href="https://github.com/xwmx/font/actions" rel="nofollow">
    <img  src="https://img.shields.io/github/actions/workflow/status/xwmx/font/tests.yml?branch=main"
          alt="Build Status"
          style="max-width:100%;">
  </a>
</div>

<br/>

`font` is a command line program for managing fonts on macOS and Linux.

`font` downloads fonts from online sources, installs them into your user font directory, and keeps track of exactly which files were installed, so fonts can be listed, checked, or cleanly removed later using simple, memorable commands.

`font` is designed to be lightweight, easy to use, and contained in a single, portable script that can be `curl`ed into any environment.

<p align="center">&nbsp;</p><!-- spacer -->

<div align="center">
  <h1 align="center" id="font"><code>𝓯𝕠𝖓ⓣ</code></h1>
</div>

<div align="center">
  <a href="#installation">Installation</a>&nbsp;·
  <a href="#usage">Usage</a>&nbsp;&nbsp;
</div>

<p align="center"></p><!-- spacer -->

<div align="center">
  <a href="#help">Help</a>
</div>

<p align="center"></p><!-- spacer -->

<div align="center">
  <a href="#top">&nbsp;↑&nbsp;</a>
</div>

## Installation

<p><sup><a href="#font">↑</a></sup></p>

### Homebrew

<p><sup><a href="#installation">↑</a></sup></p>

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

<p><sup><a href="#installation">↑</a></sup></p>

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

<p><sup><a href="#manual">↑</a></sup></p>

To install with just user permissions, simply add the `font` script to your `$PATH`. If you already have a `~/bin` directory, for example, you can use one of the following commands:

```bash
# download with wget
wget https://raw.github.com/xwmx/font/master/font -O ~/bin/font && chmod +x ~/bin/font

# download with curl
curl -L https://raw.github.com/xwmx/font/master/font -o ~/bin/font && chmod +x ~/bin/font
```

### Requirements

<p><sup><a href="#installation">↑</a></sup></p>

`font` is a Bash script that works on macOS and Linux, including Ubuntu, Debian, Fedora, and Arch. It depends on the following tools:

- `bash`
- `curl`
- `unzip`
- `find`

The `search` subcommand also uses `grep`, `awk`, and `sed` to search the online font catalogs. The `show` subcommand uses `awk`, `sed`, and `od` to read source metadata and encode URLs. These utilities are included with macOS and are available in standard Linux installations. On Linux, `bash` and `find` are almost always present, but `curl` and `unzip` are missing from some minimal installations.

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

<p><sup><a href="#installation">↑</a></sup></p>

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

<p><sup><a href="#font">↑</a></sup></p>

### Installing Fonts

<p><sup><a href="#usage">↑</a></sup></p>

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

<p><sup><a href="#usage">↑</a></sup></p>

`font` currently supports the following sources:

| Source      | Font name                                                   | Example                              |
|:------------|:------------------------------------------------------------|:-------------------------------------|
| `fontshare` | The font's slug on [Fontshare](https://www.fontshare.com/)  | `font install fontshare general-sans` |
| `google`    | The family name on [Google Fonts](https://fonts.google.com/) | `font install google "Open Sans"`    |
| `homebrew`  | The full cask name from [Homebrew's font casks](https://formulae.brew.sh/cask-font/), macOS only | `font install homebrew font-fira-code` |
| `url`       | A link, or a `file://` URL for a local file, to a `.zip`, `.ttf`, or `.otf` file, see [Installing from URLs](#installing-from-urls) | `font install https://example.com/fonts/Example.zip` |

Quote font names that contain spaces.

```
> font install google "Open Sans"
Downloading 'Open Sans' from google...
Installed 20 font file(s) for 'Open Sans' into /Users/example/Library/Fonts
```

#### Searching Fonts

<p><sup><a href="#usage">↑</a></sup></p>

`font search` searches the online font catalogs from [Homebrew](https://formulae.brew.sh/cask-font/), [Fontshare](https://www.fontshare.com/), and [Google Fonts](https://fonts.google.com/). It matches font names and displays the source-specific install command and catalog page URL for each result:

```bash
font search mont
```

The search is case-insensitive and accepts extended regular expressions, just like `font list`:

```bash
# Search for names containing "space" or "clash"
font search 'space|clash'

# Search for names beginning with "mono"
font search '^mono'

# Search for names ending in "sans"
font search 'sans$'
```

Quote expressions that contain shell characters such as `|`, `(`, `)`, or `$` so the shell passes the expression to `font` unchanged.

Results are grouped by source. Each match includes a ready-to-use install command and a link to the font's catalog page. For example:

```text
Homebrew:
  Font Fira Code
    font install homebrew font-fira-code
    https://formulae.brew.sh/cask/font-fira-code

Fontshare:
  General Sans
    font install fontshare general-sans
    https://www.fontshare.com/fonts/general-sans

Google:
  Montserrat
    font install google Montserrat
    https://fonts.google.com/specimen/Montserrat
```

The search requires an internet connection and `curl`, `grep`, `awk`, and `sed`. It searches the online catalogs; it does not install fonts. Use the install command shown with a result to install a font.

### Homebrew Casks (macOS)

<p><sup><a href="#usage">↑</a></sup></p>

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

<p><sup><a href="#usage">↑</a></sup></p>

Instead of a source and font name, `font install` accepts a URL. `font status`, `font uninstall`, and `font show` accept the same URL forms, so a URL identifies the same font across these commands. These URLs are recognized:

| URL                    | Example                                         | Source      | Font             |
|:-----------------------|:------------------------------------------------|:------------|:-----------------|
| Fontshare page         | `https://www.fontshare.com/fonts/paquito`       | `fontshare` | `paquito`        |
| Google Fonts page      | `https://fonts.google.com/specimen/Montserrat`  | `google`    | `Montserrat`     |
| Homebrew cask page     | `https://formulae.brew.sh/cask/font-fira-code`  | `homebrew`  | `font-fira-code` |
| Direct link to a file  | `https://example.com/fonts/Example.zip`         | `url`       | `Example`        |
| Local file             | `file:///Users/example/Downloads/Example.zip`   | `url`       | `Example`        |

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

<p><sup><a href="#installing-from-urls">↑</a></sup></p>

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
- Two links with the same file name, including `file://` URLs, share one record, so the second install replaces the first.
- `font install url Example` does not work, since the link itself is needed to download or copy the file. Use the URL. `font status`, `font uninstall`, and `font show` can use either form.

#### Local Files

<p><sup><a href="#installing-from-urls">↑</a></sup></p>

A `file://` URL installs a font file or archive that is already on your computer, such as one you downloaded earlier. The path must be absolute, so the URL starts with `file:///`. Special characters are percent-encoded, so a space is `%20`, and `file://localhost/path` is accepted too:

```
> font install file:///Users/example/Downloads/Example.zip
Copying 'Example' from /Users/example/Downloads/Example.zip...
Installed 2 font file(s) for 'Example' into /Users/example/Library/Fonts

> font install "file:///Users/example/Downloads/My%20Fonts/Solo%20Font.otf"
Copying 'Solo Font' from /Users/example/Downloads/My Fonts/Solo Font.otf...
Installed 1 font file(s) for 'Solo Font' into /Users/example/Library/Fonts
```

The file is copied instead of downloaded, so `curl` isn't needed. Local files are recorded under the `url` source like any other direct link, using the file name without its extension as the font name. A file that doesn't exist, a relative path, or an unsupported file type is rejected with an error:

```
> font install file:///Users/example/Downloads/Missing.zip
! File not found: /Users/example/Downloads/Missing.zip
```

### Using Options

<p><sup><a href="#usage">↑</a></sup></p>

`font install`, `font status`, `font uninstall`, and `font show` identify a font with a source and font name, or with a URL. Each of these can also be given as an option with a value:

| Option              | Same as                                    |
|:--------------------|:-------------------------------------------|
| `--source <source>` | The `<source>` argument                    |
| `--font <font>`     | The `<font>` argument                      |
| `--url <url>`       | A [URL](#installing-from-urls) argument    |

These commands are all equivalent:

```
font install google "Open Sans"
font install --source google --font "Open Sans"
font install --font "Open Sans" --source google
font install --source google "Open Sans"
```

as are these:

```
font status https://fonts.google.com/specimen/Montserrat
font status --url https://fonts.google.com/specimen/Montserrat
font status --url=https://fonts.google.com/specimen/Montserrat
```

Options and arguments can be mixed, since each one fills whichever of the source or font is still missing. `--url` is the exception: it identifies the font by itself, so it can't be combined with a source or font, whether given as an option or an argument.

An option without a value, a `--url` value that isn't a URL, or a `--url` combined with a source or font exits with status `1` and an error message:

```
> font install --url https://example.com/fonts/Example.zip --source google
! A URL can't be combined with a source or font.
```

`font list` has its own [`--source` and `--no-source`](#listing-fonts) options, which filter the list.

### Listing Fonts

<p><sup><a href="#usage">↑</a></sup></p>

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

Used without a source, `--source` lists every font that has a recorded source, from all sources:

```
> font list --source
Installed with font:
  fontshare satoshi
  google Open Sans
  homebrew font-fira-code
```

The argument after `--source` is read as its source, so a search string has to come before a `--source` that doesn't have one, as in `font list hack --source`.

To list the fonts that don't have a recorded source, use `--no-source`:

```
> font list --no-source
Without a recorded source:
  Arial.ttf
  Helvetica.ttc
  ...
```

These are the font files in the system's font directories that weren't installed with `font`. Files that `font` installed are left out, as are the links Homebrew font casks create, since Homebrew is their source. `--no-source` can be combined with a search string, as in `font list mono --no-source`. `--source` and `--no-source` can't be used together.

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

<p><sup><a href="#usage">↑</a></sup></p>

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

<p><sup><a href="#usage">↑</a></sup></p>

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

<p><sup><a href="#font">↑</a></sup></p>

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

<p><sup><a href="#usage">↑</a></sup></p>

<p align="center">
  <a href="#font-help">(default) / help</a> •
  <a href="#font-install">install</a> •
  <a href="#font-list">list</a> •
  <a href="#font-search">search</a> •
  <a href="#font-show">show</a> •
  <a href="#font-status">status</a> •
  <a href="#font-subcommands">subcommands</a> •
  <a href="#font-uninstall">uninstall</a> •
  <a href="#font-version">version</a>
</p>

### `font help`

<p><sup><a href="#subcommands">↑</a></sup></p>

```
Usage:
  font help [<subcommand>]

Description:
  Display help information for font or a specified subcommand.
```

### `font install`

<p><sup><a href="#subcommands">↑</a></sup></p>

```
Usage:
  font install <source> <font>
  font install <url>
  font install [--source <source>] [--font <font>] [--url <url>]

Options:
  --font <font>      The font to install, by name.
  --source <source>  The source to install the font from.
  --url <url>        The URL of the font to install.

Description:
  Install a <font> from <source>, or from a font <url>. The options are
  equivalent to the arguments and can be mixed with them, so
  `font install --source google "Open Sans"` also works. --url can't be
  combined with a source or font.

Sources:
  fontshare   A font from Fontshare, by name.
  google      A font family from Google Fonts, by name.
  homebrew    A font cask from Homebrew, by cask name. macOS only.
  url         A link to a .zip, .ttf, or .otf file, or a file:// URL for a
              local file.

URLs:
  Fontshare and Google Fonts pages, Homebrew cask pages, and direct links
  to .zip, .ttf, or .otf files, including file:// URLs for local files,
  are recognized, so a <url> can be used anywhere a <source> and <font>
  are accepted.

Examples:
  font install fontshare paquito
  font install google "Open Sans"
  font install homebrew font-fira-code
  font install https://www.fontshare.com/fonts/paquito
  font install https://fonts.google.com/specimen/Montserrat
  font install https://example.com/fonts/Example.zip
  font install file:///Users/example/Downloads/Example.zip
  font install --source google --font "Open Sans"
  font install --url https://fonts.google.com/specimen/Montserrat

Exit status:
  0   Font successfully installed.
  1   Invalid parameters, unrecognized or unsupported URL, unsupported
      source, missing dependency (curl and unzip, or brew for homebrew),
      or download failure.
```

### `font list`

<p><sup><a href="#subcommands">↑</a></sup></p>

```
Usage:
  font list [--source [<source>] | --no-source] [<search string>]

Options:
  --source [<source>]  Only list fonts with a recorded source. When <source>
                       is given, only fonts installed from <source>.
  --no-source          Only list fonts without a recorded source.

Description:
  List the fonts installed with font, followed by all font files found in
  the system's font directories. When provided with a search string or
  regular expression, only matching entries are listed. Matching is
  case-insensitive.

  When --source is used, only fonts with a recorded source are listed, or
  only fonts installed from <source> when one is given, and the system font
  files are omitted. The argument after --source is read as its <source>, so
  a search string must come before a --source without one.

  When --no-source is used, only font files without a recorded source are
  listed. These are the font files found in the system's font directories
  that were not installed with font or as Homebrew font casks.

Sources:
  fontshare, google, homebrew, url

Examples:
  font list
  font list satoshi
  font list --source
  font list --source google
  font list --source homebrew mono
  font list --no-source
  font list mono --no-source

Exit status:
  0   Success, including when no entries match.
  1   Invalid search pattern, unsupported source, or --source combined
      with --no-source.
```

### `font search`

<p><sup><a href="#subcommands">↑</a></sup></p>

```
Usage:
  font search <string-or-regex>

Description:
  Search the Homebrew font casks, Fontshare, and Google Fonts catalogs for
  font names matching a string or extended regular expression. Matching is
  case-insensitive. Results include the source, install command, and catalog
  URL.

Requirements:
  curl, grep, awk, sed

Examples:
  font search mont
  font search "space grotesk"
  font search '^(space|clash)'
  font search 'mono$'

Exit status:
  0   Search completed, including when no fonts match.
  1   Missing required command, invalid search pattern, or invalid parameters.
```

### `font show`

<p><sup><a href="#subcommands">↑</a></sup></p>

```
Usage:
  font show <source> <font>
  font show <url>
  font show [--source <source>] [--font <font>] [--url <url>]

Options:
  --font <font>      The font to display information about, by name.
  --source <source>  The source the font is available from.
  --url <url>        A font page URL or direct font file URL.

Description:
  Display available information about a font, including its description,
  category, designer, license, styles, statistics, catalog page, download
  URL, and installation status. Available fields depend on the source.

Sources:
  fontshare, google, homebrew, url

Examples:
  font show fontshare satoshi
  font show fontshare "General Sans"
  font show google "Open Sans"
  font show homebrew font-fira-code
  font show https://www.fontshare.com/fonts/paquito
  font show https://fonts.google.com/specimen/Montserrat
  font show https://example.com/fonts/Example.zip

Exit status:
  0   Font information was retrieved successfully.
  1   Invalid parameters, unsupported source or URL, missing dependency,
      or the font could not be found in its source catalog.
```

### `font status`

<p><sup><a href="#subcommands">↑</a></sup></p>

```
Usage:
  font status <source> <font>
  font status <url>
  font status [--source <source>] [--font <font>] [--url <url>]

Options:
  --font <font>      The font to check, by name.
  --source <source>  The source the font was installed from.
  --url <url>        The URL of the font to check.

Description:
  Check whether a <font> from <source>, or a font <url>, is installed. The
  options are equivalent to the arguments and can be mixed with them. --url
  can't be combined with a source or font. For homebrew, Homebrew is asked
  whether the cask is installed.

Exit status:
  0   Font is installed and all files are present.
  1   Font is not installed, or some files are missing.

Examples:
  font status fontshare paquito
  font status homebrew font-fira-code
  font status https://fonts.google.com/specimen/Montserrat
  font status --source fontshare --font paquito
  font status --url https://fonts.google.com/specimen/Montserrat
```

### `font subcommands`

<p><sup><a href="#subcommands">↑</a></sup></p>

```
Usage:
  font subcommands [--raw]

Options:
  --raw  Display the subcommand list without formatting.

Description:
  Display the list of available subcommands.
```

### `font uninstall`

<p><sup><a href="#subcommands">↑</a></sup></p>

```
Usage:
  font uninstall <source> <font>
  font uninstall <url>
  font uninstall [--source <source>] [--font <font>] [--url <url>]

Options:
  --font <font>      The font to uninstall, by name.
  --source <source>  The source the font was installed from.
  --url <url>        The URL of the font to uninstall.

Description:
  Uninstall a <font> from <source>, or a font <url>, by removing the files
  recorded when it was installed. The options are equivalent to the
  arguments and can be mixed with them. --url can't be combined with a
  source or font. For homebrew, the cask is removed with
  `brew uninstall --cask`.

Exit status:
  0   Font successfully uninstalled.
  1   Invalid parameters or no install record found.

Examples:
  font uninstall fontshare paquito
  font uninstall homebrew font-fira-code
  font uninstall https://fonts.google.com/specimen/Montserrat
  font uninstall --source fontshare --font paquito
  font uninstall --url https://fonts.google.com/specimen/Montserrat
```

### `font version`

<p><sup><a href="#subcommands">↑</a></sup></p>

```
Usage:
  font ( version | --version )

Description:
  Display the current program version.
```

---

Copyright (c) 2026 William Melody • See LICENSE for details.

[github.com/xwmx/font](https://github.com/xwmx/font)
