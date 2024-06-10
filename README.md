# scli
`scli` is a simple terminal user interface for [Signal](https://signal.org). It uses [signal-cli](https://github.com/AsamK/signal-cli) and [urwid](http://urwid.org/).

## Features

- Vim-like navigation (`j`, `k`, `g`, `G`, etc), command entry with `:`.
- Optional emacs-like `readline` bindings for input.
- External `$EDITOR` support.

### Limitations

- Not yet supported by [signal-cli](https://github.com/AsamK/signal-cli/issues):
	- Quoting a message ([#875](https://github.com/AsamK/signal-cli/issues/875))
	- Adding @-mentions in sent messages ([#875](https://github.com/AsamK/signal-cli/issues/875))
	- Voice calls ([#80](https://github.com/AsamK/signal-cli/issues/80))

- *Sending* read receipts for received messages.
- "View once" and "expiring" messages.
- See also: open [issues](https://github.com/isamert/scli/issues).

## Installation
### Automatic
The following methods are supported by community and may be outdated.

[![Packaging status](https://repology.org/badge/vertical-allrepos/scli-signal-cli.svg)](https://repology.org/project/scli-signal-cli/versions)

- [Debian / Ubuntu](https://gitlab.com/packaging/scli/)

### Manual

Clone the repo

```
git clone https://github.com/isamert/scli
```

or download a [release](https://github.com/isamert/scli/releases).

#### Dependencies

- [`signal-cli`](https://github.com/AsamK/signal-cli) `>=v0.11.0`.

	Download and unpack a [release](https://github.com/AsamK/signal-cli/releases), and place the `signal-cli` executable somewhere on the `$PATH`.

	Or compile from source: see [install](https://github.com/AsamK/signal-cli#Installation) section of `signal-cli` readme for instructions.

- [`urwid`](https://github.com/urwid/urwid)

	Availble on PyPI:

	```
	pip install urwid
	```

	and in some distributions' package managers, see repology [(1)](https://repology.org/project/urwid/versions), [(2)](https://repology.org/project/python:urwid/versions).

- [`urwid_readline`](https://github.com/rr-/urwid_readline/) (optional)

	For GNU readline-like keybinds on the input line (emacs-like only).

	```
	pip install urwid-readline
	```

	Also in a few [package managers](https://repology.org/project/python:urwid-readline/versions).

- [DBus](https://www.freedesktop.org/wiki/Software/dbus/)

	Pre-installed on most linux distributions and BSDs with desktop environments. On macOS, the `dbus` package is available from homebrew, see [signal-cli's wiki](https://github.com/AsamK/signal-cli/wiki/DBus-service#user-content-dbus-on-macos). See also the wiki's [troubleshooting](https://github.com/AsamK/signal-cli/wiki/DBus-service#user-content-troubleshooting) section.

- [Python](https://www.python.org/downloads/) `>=3.7`


### Registering or linking your device

Before running `scli`, `signal-cli` needs to be registered with the signal servers. You can either register a [new device](https://github.com/AsamK/signal-cli/wiki/Quickstart#user-content-set-up-an-account), or [link](https://github.com/AsamK/signal-cli/wiki/Linking-other-devices-(Provisioning)) `signal-cli` with an already registered device (e.g. your phone).

Linking can be done interactively with `scli link`, see the [next section](#linking-with-scli-link).

For more information, see: `signal-cli` [usage](https://github.com/AsamK/signal-cli#Usage), [man page](https://github.com/AsamK/signal-cli/blob/master/man/signal-cli.1.adoc), and [wiki](https://github.com/AsamK/signal-cli/wiki).

#### Linking with `scli link`

Linking with an existing account can be done interactively with

```
scli link [--name DEVICE_NAME]
```

and following instructions on the screen. The `DEVICE_NAME` is optional, `scli` is used by default.

This requires [pyqrcode](https://github.com/mnooner256/pyqrcode) package (available on [PyPI](https://pypi.org/project/PyQRCode/) and other [repositories](https://repology.org/project/python:pyqrcode/versions))

#### Verifying setup

After registering or linking, verify that the following commands work:

```
signal-cli -u USERNAME receive
```

and

```
signal-cli -u USERNAME daemon
```

where `USERNAME` is the phone number you have used (starting with the "+" sign followed by the country calling code). Stop the latter process (`Ctrl+C`) after verifying that it starts successfully and does not throw any errors.

Now you can run

```
scli
```

(if you have put it on your system's `$PATH`; alternatively, specify the full `/path/to/executable/scli`).


## Usage

### Key bindings
For the full list of key bindings, press `?` in scli.

- `F1` opens the help window.
- `Tab` / `Shift+Tab` cycle through focusable UI elements.
- `j`/`k` (or `↓`/`↑`) move the cursor down/up in a conversation and the contacts list.
- `g` focuses first contact/message.
- `G` focuses last contact/message.
- `Alt+J` / `Alt+K` (and `Alt+↓` / `Alt+↑`) open next / previous conversation.
- `enter` on a message opens attachment or URL if there is one; moves the focus to the quoted message, if it exists.
- `y` on a message puts it into system clipboard. (needs `xclip` or `wl-clipboard`; see `--clipboard-put-command` [option](#configuration)).
- `e` or `R` on a message opens an emoji picker and sends it as a reaction. Sending an 'empty' reaction removes the previously set reaction.
- `d` deletes the message locally (from the current device's history).
- `D` remote-deletes the message (for everyone in the conversation).
- `i` shows a message info pop-up with the message's details.
- `Alt+Enter` in the input window inserts a newline.
- `Esc` closes opened dialogs, clears search filters, removes notifications from the status line.

If [`urwid_readline`](https://github.com/rr-/urwid_readline/) module is installed, all of its keybindings are available in the input widgets.


#### Modifying key bindings
Key bindings can be re-mapped with a `--key-bind` option. For example:

	scli --key-bind show_message_info:s --key-bind reaction_emoji_picker:e,R,!,'ctrl r'

The syntax is

	--key-bind ACTION:KEY[,KEY[,…]]

where `ACTION` is one of the action names (press `?` in `scli` to show the full list of action names and their default key bindings), and `KEY` is the name of a key or key combo in urwid's syntax (see the table in [Keyboard input](https://urwid.org/manual/userinput.html#keyboard-input) section of urwid manual). Keys for several actions can be re-assigned by passing multiple `--key-bind` arguments to `scli`. Multiple keys can be assigned to a single action by separating `KEY`s with commas.


### Commands
Commands are entered by typing `:` followed by a command name and arguments. For example:

```
:attach ~/photo.jpg Here is a picture
:read /etc/crontab
```

Some of the available commands are listed below; to see the full list, use `:help commands` in scli.

- `:help [keys|commands]` shows help. Unambiguous abbreviations of its argument is also allowed, e.g. `:help comm`, `:help c`, etc. When no argument provided, the general help window is shown.
- `:attach FILE_PATH [MESSAGE]` or `:a …` sends `MESSAGE` with `FILE_PATH` as an attachment.
- `:edit [MESSAGE | FILE_PATH]` or `:e […]` opens in external `$EDITOR` the contents of file `FILE_PATH` or the text `MESSAGE`. If `MESSAGE` and `FILE_PATH` are absent, opens an empty temporary file. See also: `--editor-command` [config option](#configuration).
- `:read FILE | !COMMAND` sends the contents of `FILE` or the output of `COMMAND`.

Command names are case insensitive, i.e. `:edit` and `:eDiT` do the same thing.


#### Modifying contacts
Modifying contacts from `scli` is possible if the account has been _registered_ with `signal-cli` as a "primary device" (rather than [_linked_](#registering-or-linking-your-device) with the phone app).

- `:addContact NUMBER [NAME]` adds a new contact to the contact list. Added contacts' names are local (not synced with signal servers).
- `:renameContact [ID] NEW_NAME` renames contact `ID` to `NEW_NAME`. `ID` can be either contact's phone number or contact's or group's name. If `ID` is not given, the contact from the currently opened conversation is used. Individual contacts' renames are local (not synced with the signal servers).

### Searching
Filtering messages in a conversation is done by typing `/` followed by the search string. Pressing `enter` (or `l`) on a message when the search is on removes the filter (i.e. shows all the messages in a conversation) while keeping the focus on the message. Pressing `Esc` clears the search. Searching through contacts is analogous.

### Configuration
Configuration options can be passed to `scli` as command-line arguments or added to the configuration file in `~/.config/sclirc`. Run `scli --help` to show all available options.

#### Configuration file
Empty lines and lines starting with `#` are ignored. Config lines have the format `OPTION = VALUE`, where `OPTION`s are the long forms of command-line arguments, with the leading `--` omitted (e.g. `enable-notifications`). `VALUE`s for the optional arguments (a.k.a. "flags" or "switches") like `--enable-notifications` can be any of: `true`, `t`, `yes`, `y` (case insensitive, i.e. with any capitalization).

#### Example

```sh
scli --enable-notifications -w 80
```

Configuration file equivalent of the above command is:

```ini
enable-notifications = true
wrap-at = 80
### Short option forms (w = 80) are not valid in config file.
```

#### History

Conversations history can be enabled with `--save-history` or `-s` flag. The file will be saved in plain text (to `~/.local/share/scli/history` by default). See the [Security](#data-storage) section regarding an encrypted storage.

#### Colors

Messages' text can be colorized using the `--color` option:

- `--color` (no additional value)
   Use contacts' colors from the primary signal device.

- `--color=high`
	 Same as above, but use 256 colors instead of the terminal's standard 8. Colors look closer to those on official clients, but not necessarily legible on all terminals' color schemes.

- `--color='{"<signal_color>": "<urwid_color>", ..., "<phone_number>": "<urwid_color>", ...}'`
   Override colors for particular contacts or redefine signal-assigned colors; use signal-assigned colors for the rest, as above. If any of the `<urwid_color>`s is specified as a 256-color, the "high-color mode" will be turned on (like `--color=high`).

- `--color='["<urwid_color_sent>", "<urwid_color_recv>"]'`
   Use one color for sent messages and another for received messages (from any contact).

The list of available `<signal_color>` names is in the [source code](https://github.com/isamert/scli/blob/9a5a49d/scli#L2925-L2939) (first column).
An `<urwid_color>` is one of urwid's [16 standard foreground colors](https://urwid.readthedocs.io/en/latest/manual/displayattributes.html#standard-foreground-colors) (`dark green`, `yellow`, `default`, etc), or [256 foreground colors](https://urwid.readthedocs.io/en/latest/manual/displayattributes.html#color-foreground-and-background-colors) (`#f8d`, `h123`, etc).
To see the available colors rendered in your terminal, run [palette_test.py](https://github.com/urwid/urwid/blob/master/examples/palette_test.py) from urwid's examples.
The single quotes in `--color='...'` above are just shell-escaping, and not needed in `sclirc`.

## Security
This is an independent project not audited or endorsed by the [Signal foundation](https://signal.org/). That is also true of [signal-cli](https://github.com/AsamK/signal-cli), which scli uses as a backend.

### Data storage
Scli stores its history (if enabled with `--save-history`) in plain text. Likewise, signal-cli stores its data (received attachments, contacts info, encryption keys) unencrypted. To secure this data at rest, it is recommended to use full-disk encryption or dedicated tools like [fscrypt](https://github.com/google/fscrypt).

To protect the data from potentially malicious programs running in user-space, one can run scli and signal-cli under a separate user.

For more detailed discussions, see: [[1]](https://github.com/AsamK/signal-cli/discussions/884), [[2]](https://github.com/isamert/scli/pull/169).

## Similar projects
- A list of [TUI clients](https://github.com/AsamK/signal-cli/wiki#user-content-terminal--tui-clients) on signal-cli wiki.
- [Another list](https://github.com/exquo/signal-soft/wiki/Software-list#user-content-tui--terminal-clients) of TUI clients.

## Screenshots
![scli](screenshots/1.png?raw=true)
![scli](screenshots/2.png?raw=true)
![scli](screenshots/3.png?raw=true)
