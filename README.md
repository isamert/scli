# scli
`scli` is a simple terminal user interface for [Signal](https://signal.org). It uses [signal-cli](https://github.com/AsamK/signal-cli) and [urwid](http://urwid.org/).

## Features

- vim-like navigation (`j`, `k`, `g`, `G`, etc), command entry with `:`
- optional emacs-like `readline` bindings for input
- external `$EDITOR` support

### Limitations

- Not yet supported by [signal-cli](https://github.com/AsamK/signal-cli/issues):
	- *Sending* read receipts for received messages ([#231](https://github.com/AsamK/signal-cli/issues/231), [#305](https://github.com/AsamK/signal-cli/issues/305))
	- Quoting a message ([#213](https://github.com/AsamK/signal-cli/issues/213))
	- Adding @-mentions in sent messages ([#584](https://github.com/AsamK/signal-cli/issues/584))
	- Voice calls ([#80](https://github.com/AsamK/signal-cli/issues/80))

- "View once" and "expiring" messages.
- See also: open [issues](https://github.com/isamert/scli/issues).

## Installation
### Automatic
The following methods are supported by community and may be outdated.

- Arch Linux: [AUR](https://aur.archlinux.org/packages/scli-git/)
- FreeBSD: [FreshPorts](https://www.freshports.org/net-im/scli/)

### Manual

Clone the repo

```
git clone https://github.com/isamert/scli
```

or download a [release](https://github.com/isamert/scli/releases).

#### Dependencies

- [`signal-cli`](https://github.com/AsamK/signal-cli) `>=v0.6.8`. (Latest tested: `v0.8.4`)

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

	Pre-installed on most linux distributions and BSDs with desktop environments. On macOS, the `dbus` package is available from homebrew, see signal-cli's [wiki](https://github.com/AsamK/signal-cli/wiki/DBus-service#user-content-dbus-on-macos). See also, wiki's [troubleshooting](https://github.com/AsamK/signal-cli/wiki/DBus-service#user-content-troubleshooting) section.

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

where `USERNAME` is the phone number you have used (starting with the "+" sign and including your country calling code). Kill the latter process after verifying that it starts successfully and does not throw any errors.

Now you can start

```
scli
```

if you have put it on your system's `$PATH`, or specify the full `/path/to/executable/scli`.


## Usage
A simple two-paned interface is provided. Left pane contains the contact list and right pane contains current conversation. You can switch focus between panes with `Tab` (or `Shift + Tab`). Hitting tab for the first time focuses the conversation, hitting it again focuses to input line. So the focus order is `Contacts -> Conversation -> Input`. You can use `Shift + Tab` for cycling backwards.

### Keys
- Use `j`/`k` to go down/up in contacts list or in messages.
- Hitting `enter` on a contact opens the conversation and focuses to input line.
- Hitting `l` on a contact only opens the conversation.
- Hitting `o` on a message opens the URL if there is one, if not it opens the attachment if there is one.
- Hitting `enter` on a message opens the attachment if there is one, if not it opens the URL if there is one.
- Hitting `y` on a message puts it into system clipboard. (needs `xclip`)
- `g` focuses first contact/message.
- `G` focuses last contact/message.
- `d` deletes the message from your screen (and from your history, if history is enabled).
- `i` show a popup that contains detailed information about the message.
- `Alt+Enter` inserts a newline in message composing input field.
- `Alt+J` / `Alt+K` (and `Alt+↓` / `Alt+↑`) open next / previous conversation.

### Commands
There are some basic commands that you can use. Hit `:` to enter command mode (or simply focus the input line and type `:`).

- `:edit` or `:e` lets you edit your message in your `$EDITOR`.
- `:attach FILE_PATH` or `:a FILE_PATH` attaches given file to message.
- `:attachClip` or `:c` attaches clipboard content to message. This command tries to detect clipboard content. If clipboard contains something with the mime-type `image/png` or `image/jpg`, simply attaches the image to message. If clipboard contains `text/uri-list` it attaches all the files in that URI list to your message. This command needs `xclip` installed.
- `:openUrl` or `:u` opens last URL in messages, if there is one.
- `:openAttach` or `:o` opens last attachment in messages, if there is one.
- `:toggleNotifications` or `:n` toggles desktop notifications.
- `:toggleContactsSort` or `:s` toggles between sorting contacts alphabetically and by the most recent message.
- `:toggleAutohide` or `:h` hides the contacts pane when it's not in focus.
- `:addContact NUMBER [NAME]` adds a new contact to the contact list. Added contacts' names are local (not synced with signal servers).  
	_Note_: This command works only with signal-cli accounts registered as "master" (_not_ those linked with the phone app).
- `:renameContact [ID] NEW_NAME` renames contact `ID` to `NEW_NAME`. `ID` can be either contact's phone number or contact's name. If `ID` is skipped, the contact from the currently opened conversation is used. If `ID` is a name that contains spaces, they need to be escaped or the whole name put in quotes. `NEW_NAME` can contain spaces without quotes or escaping. 'Contact' can be a group as well as an individual. Individual contacts' renames are local (not synced with the signal servers).  
	See _Note_ for `:addContact` command above.
- `:reload` re-reads the `signal-cli`s data file. (Updates contacts list etc.)
- `:quit` or `:q` quits the program.

Examples:
```
:attach ~/cute_dog.png check out this cute dog!
:attachclip here is another picture.
```
**Note**: Commands are case insensitive, `:quit` and `:qUiT` do the same thing.

### Searching
There is a built-in search feature. Simply hit `/` while you are on the chat window (or focus the input line then type `/`) and start typing, the chat will be filtered out based on your input. You can focus any of the search results and hit `enter` (or `l`) to open that result in full conversation.

For searching through contacts, you need to hit `/` while you are on the contacts window and start typing, contacts will be filtered out while you are typing. Hit `enter` to focus the results. Hitting `Esc` will clear the search.

### Configuration
There are some simple configuration options. You can either pass them as command-line arguments or add them to your configuration file `~/.config/sclirc`. Run `scli --help` to see all options.

Configuration file syntax is also pretty easy. Lines starting with `#` and empty lines are ignored, other lines are `key = value` pairs. Optional arguments (flags) like `--debug`, can be enabled in config file with any of: `true`, `t`, `yes`, `y` (with any capitalization, case insensitive).

#### Example
```sh
scli -w 80 --enable-notifications
```
Configuration file equivalent of this command is:
```ini
## Long option forms are used in config file. (w = 80 is not valid.)
wrap-at = 80
enable-notifications = true
```

#### History

Conversations history can be enabled with `--save-history` or `-s` flag. If enabled, the file is saved in plain text (to `~/.local/share/scli/history` by default).

#### Colors

Messages' text can be colorized using the `--color` option:

- `--color` (no additional value)
   Use contacts' colors from the master signal device.

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


## Similar projects
See [TUI clients](https://github.com/AsamK/signal-cli/wiki#user-content-terminal--tui-clients) on signal-cli wiki.

## Screenshots
![scli](screenshots/1.png?raw=true)
![scli](screenshots/2.png?raw=true)
![scli](screenshots/3.png?raw=true)
