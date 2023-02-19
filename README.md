# scli
`scli` is a simple terminal user interface for [Signal](https://signal.org). It uses [signal-cli](https://github.com/AsamK/signal-cli) and [urwid](http://urwid.org/).

## Features

- vim-like navigation (`j`, `k`, `g`, `G`, etc), command entry with `:`
- optional emacs-like `readline` bindings for input
- external `$EDITOR` support

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
- `j`/`k` move the cursor down/up in a conversation and the contacts list.
- `g` focuses first contact/message.
- `G` focuses last contact/message.
- `enter` on a contact opens its conversation and focuses the input line.
- `l` on a contact opens its conversation without focusing input line.
- `enter` on a message opens attachment or URL if there is one.
- `o` on a message opens URL or attachment if there is one.
- `y` on a message puts it into system clipboard. (needs `xclip`).
- `e` or `R` on a message opens an emoji picker and sends it as a reaction. Sending an 'empty' reaction removes the previously set reaction.
- `d` deletes the message locally (from the current device's history).
- `D` remote-deletes the message (for everyone in the conversation).
- `i` shows a message info popup with the message's details.
- `U` in contacts list increments contact's unread count (can be used to mark conversation as unread).
- `Alt+Enter` inserts a newline in message composing input field.
- `Alt+J` / `Alt+K` (and `Alt+↓` / `Alt+↑`) open next / previous conversation.
- If [`urwid_readline`](https://github.com/rr-/urwid_readline/) is installed, all of its keybindings can be used in the message compose input field.

### Commands
Commands can be entered by typing `:` followed by one of the commands below.

- `:edit` or `:e` lets you edit your message in your `$EDITOR`.
- `:attach FILE_PATH` or `:a FILE_PATH` attaches given file to message.
- `:attachClip` or `:c` attaches clipboard content to message. This command tries to detect clipboard content. If clipboard contains something with the mime-type `image/png` or `image/jpg`, it simply attaches the image to message. If clipboard contains `text/uri-list` it attaches all the files in that URI list to the message. This command needs `xclip` installed.
- `:openUrl` or `:u` opens the last URL in conversation, if there is one.
- `:openAttach` or `:o` opens the last attachment in conversation, if there is one.
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
Filtering messages in a conversation is done by typing `/` followed by the match text. Hitting `enter` (or `l`) on a message shows it in the full conversation. Hitting `Esc` clears the search. Searching through the contacts is done similarly.

### Configuration
Configuration options can be passed to scli as command-line arguments or added to the configuration file in `~/.config/sclirc`. Run `scli --help` to show all available options.

In the configuration file the empty lines and lines starting with `#` are ignored. Other lines are `key = value` pairs. Optional arguments (flags) like `--debug` can be enabled in config file with any of: `true`, `t`, `yes`, `y` (with any capitalization, case insensitive).

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

Conversations history can be enabled with `--save-history` or `-s` flag. The file will be saved in plain text (to `~/.local/share/scli/history` by default). See the [Security](#data-storage) section regarding an encrypted storage.

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

## Security
This is an independent project not audited or endorsed by the [Signal foundation](https://signal.org/). That is also true of [signal-cli](https://github.com/AsamK/signal-cli) that scli uses as a backend.

### Data storage
Scli saves its history (when enabled, with `--save-history`) in plain text. Likewise, signal-cli stores its data (received attachments, contacts info, encryption keys) unencrypted. To secure this data at rest, it is recommended to use full-disk encryption or dedicated tools like [fscrypt](https://github.com/google/fscrypt).

To protect the data from potentially malicious programs running in user-space, one can run scli and signal-cli under a separate user.

For more detailed discussions, see: [[1]](https://github.com/AsamK/signal-cli/discussions/884), [[2]](https://github.com/isamert/scli/pull/169).

## Similar projects
See [TUI clients](https://github.com/AsamK/signal-cli/wiki#user-content-terminal--tui-clients) on signal-cli wiki.

## Screenshots
![scli](screenshots/1.png?raw=true)
![scli](screenshots/2.png?raw=true)
![scli](screenshots/3.png?raw=true)
