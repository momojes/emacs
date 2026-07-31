# Momo's Emacs Configuration

A modular Emacs setup for writing in Org mode, managing Git repositories with
Magit, publishing posts to the `thingsabout` Hugo blog with `ox-hugo`, and doing
lightweight programming work.

This configuration is currently used on the Arch Linux ThinkPad named
`thinkTaro`, where Emacs runs as a user daemon and graphical frames are opened
through `emacsclient`.

## Main features

- Modular Emacs Lisp configuration
- Custom welcome screen
- Maple Mono interface
- Vertico, Orderless, Marginalia, Consult, and Which-Key
- Magit-based Git workflow
- Org agenda, capture, journal, ideas, and drafts
- Org-to-Hugo publishing with `ox-hugo`
- Spell checking with Aspell
- Centered, distraction-free writing with Olivetti
- Built-in programming support with Project, Eglot, Flymake, and Tree-sitter
- Basic Hare editing and run-current-file support
- Machine-specific settings kept outside Git

## Repository and workspace layout

| Path | Purpose |
|---|---|
| `~/.emacs.d/` | Git-synced Emacs configuration |
| `~/org/` | Local Org workspace |
| `~/org/drafts/` | Git-synced Org drafts repository |
| `~/org/drafts/posts/` | Individual Org blog drafts |
| `~/code/thingsabout/` | Hugo blog repository and exported Markdown |

The editable Org source and generated Hugo output live in separate repositories:

- `~/org/drafts/` contains writing ideas and editable Org source.
- `~/code/thingsabout/` contains the Hugo website and generated Markdown.
- `~/.emacs.d/` contains the configuration that connects the two.

## Configuration layout

```text
~/.emacs.d/
├── .gitignore
├── early-init.el
├── init.el
├── local.el
├── custom.el
└── lisp/
    ├── appearance.el
    ├── blog.el
    ├── core.el
    ├── keys.el
    ├── org-config.el
    ├── packages.el
    ├── programming.el
    ├── prose.el
    ├── welcome.el
    └── writing.el
```

### Module responsibilities

| Module | Purpose |
|---|---|
| `core.el` | General Emacs defaults and startup behavior |
| `appearance.el` | Theme, Maple Mono, and visual settings |
| `packages.el` | Package setup and package declarations |
| `programming.el` | Project, Eglot, Flymake, Tree-sitter, and programming defaults |
| `prose.el` | Spell checking, soft wrapping, and focused writing mode |
| `org-config.el` | Org directories, agenda files, capture templates, and Org behavior |
| `writing.el` | New-draft creation and writing helpers |
| `blog.el` | Hugo export, preview, publishing, and blog repository commands |
| `welcome.el` | Custom welcome screen and welcome-screen shortcuts |
| `keys.el` | Global prefix maps and keybindings |

`local.el` and `custom.el` are intentionally ignored by Git.

## Load order

The modules are loaded from `init.el` in this order:

```elisp
(require 'core)
(require 'appearance)
(require 'packages)
(require 'programming)
(require 'prose)
(require 'org-config)
(require 'writing)
(require 'blog)
(require 'welcome)
(require 'keys)
```

The order matters because later modules use functions, variables, and packages
defined by earlier modules.

## System dependencies

On Arch Linux:

```bash
sudo pacman -S --needed \
  emacs \
  git \
  ripgrep \
  aspell \
  aspell-en \
  hugo
```

Hare is only needed for Hare development:

```bash
sudo pacman -S --needed hare
```

The Emacs packages declared through `use-package` include:

- Magit
- Vertico
- Orderless
- Marginalia
- Consult
- Which-Key
- ox-hugo
- Olivetti
- hare-mode

Built-in packages such as Org, Project, Eglot, Flymake, and Tree-sitter do not
need to be installed separately.

## Machine-specific configuration

Create:

```text
~/.emacs.d/local.el
```

Example for `thinkTaro`:

```elisp
;;; local.el --- Machine-specific settings -*- lexical-binding: t; -*-

(setq my-machine-name "thinkTaro")

(setq my-hugo-directory
      (expand-file-name "~/code/thingsabout/"))

;;; local.el ends here
```

This file is local to each machine and should not be committed.

After changing it, restart the Emacs daemon:

```bash
systemctl --user restart emacs.service
```

## Emacs daemon

Enable and start the user service:

```bash
systemctl --user enable --now emacs.service
```

Check its status:

```bash
systemctl --user status emacs.service
```

Restart it after configuration changes:

```bash
systemctl --user restart emacs.service
```

Inspect startup errors:

```bash
journalctl --user -u emacs.service -b -n 80 --no-pager
```

Open a graphical frame:

```bash
/usr/bin/emacsclient -c -n
```

The Window Maker Dock launcher uses the same command:

```text
/usr/bin/emacsclient -c -n
```

## Welcome screen

The custom welcome screen opens automatically only once per Emacs daemon
session. Opening additional frames or buffers does not replace them with the
welcome screen.

Open it manually at any time:

```text
C-c w
```

Welcome-screen keys include:

| Key | Action |
|---|---|
| `f` | Find a file |
| `b` | Switch buffers |
| `a` | Open Org agenda |
| `c` | Start Org capture |
| `g` | Open Magit |
| `d` | Create a new blog draft |
| `i` | Open writing ideas |
| `p` | Open draft posts |
| `s` | Start the Hugo server |
| `h` | Open the Hugo preview |
| `m` | Open the blog repository in Magit |
| `q` | Close the welcome screen |

## Main commands

| Binding | Action |
|---|---|
| `C-c w` | Open the welcome screen |
| `C-c g` | Open Magit for the current repository |
| `C-c a` | Open the Org agenda |
| `C-c c` | Open Org capture |
| `C-c e` | Open the active Emacs init file |
| `C-x C-f` | Open a file |
| `C-x C-s` | Save the current file |
| `M-x` | Run an Emacs command |

## Completion and navigation

This configuration uses Vertico, Orderless, Marginalia, Consult, and Which-Key.

| Binding | Action |
|---|---|
| `C-x b` | Consult buffer switcher |
| `M-y` | Browse kill-ring history |
| `M-g g` | Go to a line |
| `M-s l` | Search the current buffer |
| `M-s r` | Search the current project or directory with Ripgrep |

## Prose and spell checking

Text buffers use:

- visual line wrapping without inserting hard line breaks;
- automatic Flyspell checking;
- an 80-column fill target;
- no line numbers.

Aspell is configured with the `en_US` dictionary.

| Binding | Action |
|---|---|
| `M-$` | Check or correct the word at point |
| `C-c s b` | Check the entire buffer |
| `C-c s t` | Toggle automatic spell checking |

## Focused writing mode

Focused writing mode uses Olivetti to center the text area and temporarily hide
the mode line and line numbers. It does not modify the file contents.

Toggle it in an Org or text buffer:

```text
C-c z
```

Press the same binding again to restore the normal layout.

While Olivetti is active:

| Binding | Action |
|---|---|
| `C-c {` | Narrow the writing area |
| `C-c }` | Widen the writing area |
| `C-c \|` | Set an exact writing width |

## Org workspace

```text
~/org/
├── inbox.org
├── agenda.org
├── someday.org
├── journal/
│   └── journal.org
└── drafts/
    ├── ideas.org
    └── posts/
```

### Capture commands

| Binding | Destination |
|---|---|
| `C-c c t` | Local inbox task |
| `C-c c a` | Agenda item |
| `C-c c s` | Someday item |
| `C-c c j` | Journal entry |
| `C-c c i` | Writing idea in the drafts repository |

## Draft repository commands

| Binding | Action |
|---|---|
| `C-c d n` | Create a new Org blog draft |
| `C-c d i` | Open `ideas.org` |
| `C-c d d` | Open the drafts repository in Dired |
| `C-c d p` | Open the drafts posts directory |
| `C-c d g` | Open Magit for the drafts repository |

New posts are created under:

```text
~/org/drafts/posts/
```

A title such as:

```text
Why I Like Window Maker
```

becomes:

```text
~/org/drafts/posts/why-i-like-window-maker.org
```

## New draft template

New drafts use this structure:

```org
#+title: Example Post
#+date: 2026-07-31
#+author: Momo
#+hugo_base_dir: ~/code/thingsabout/
#+hugo_section: posts
#+hugo_slug: example-post
#+hugo_tags:
#+hugo_categories:
#+hugo_draft: true
#+options: toc:nil num:nil

* Summary

* Draft
```

### Metadata reference

| Keyword | Purpose |
|---|---|
| `#+title` | Post title |
| `#+date` | Publication date |
| `#+author` | Author name |
| `#+hugo_base_dir` | Local Hugo repository |
| `#+hugo_section` | Hugo content section |
| `#+hugo_slug` | Output filename and URL slug |
| `#+hugo_tags` | Hugo tags |
| `#+hugo_categories` | Hugo categories |
| `#+hugo_draft` | `true` while drafting and `false` when published |
| `#+options` | Org export options |

## Hugo commands

| Binding | Action |
|---|---|
| `C-c b e` | Export the current Org post to Hugo Markdown |
| `C-c b s` | Start the Hugo development server |
| `C-c b k` | Stop the Hugo development server |
| `C-c b v` | Open the local Hugo preview |
| `C-c b g` | Open Magit for the `thingsabout` repository |
| `C-c b p` | Publish the current post |

The server runs with:

```bash
hugo server -D --navigateToChanged
```

The local preview normally opens at:

```text
http://localhost:1313/
```

## Blog-writing workflow

1. Create a draft with `C-c d n`.
2. Enter the post title.
3. Write in the generated Org file.
4. Toggle focused writing with `C-c z` when useful.
5. Check spelling with `C-c s b`.
6. Save with `C-x C-s`.
7. Export with `C-c b e`.
8. Start Hugo with `C-c b s`.
9. Open the preview with `C-c b v`.
10. Continue editing the Org source and export after each meaningful change.
11. Publish with `C-c b p`.

The publish command:

1. asks for confirmation;
2. changes `#+hugo_draft: true` to `false`;
3. offers to update `#+date`;
4. saves the Org source;
5. exports the Markdown;
6. opens Magit for the Hugo repository.

## Existing drafts

Older Org files can use the same workflow:

1. Open the existing file.
2. Add the Hugo metadata block at the top.
3. Leave the existing article content beneath it.
4. Save the Org file.
5. Export with `C-c b e`.
6. Preview with `C-c b s` and `C-c b v`.
7. Publish with `C-c b p`.

## Exported files

A draft containing:

```org
#+hugo_slug: example-post
#+hugo_section: posts
```

exports to:

```text
~/code/thingsabout/content/posts/example-post.md
```

The Org file remains the source of truth. Edit the Org source instead of the
generated Markdown whenever possible.

## Programming foundation

Programming buffers use:

- spaces instead of tabs by default;
- a four-column tab width;
- an 80-column fill target;
- visible trailing whitespace;
- line numbers.

The generic programming setup uses Emacs built-ins:

- `project.el` for project navigation;
- Eglot for language-server integration;
- Flymake for diagnostics;
- Tree-sitter font locking.

### Project commands

The built-in project command map is available under:

```text
C-c p
```

### Eglot commands

These bindings apply while Eglot is managing the current buffer:

| Binding | Action |
|---|---|
| `C-c l a` | Code actions |
| `C-c l r` | Rename symbol |
| `C-c l f` | Format the current buffer |
| `C-c l q` | Stop Eglot |

### Diagnostics

| Binding | Action |
|---|---|
| `M-g n` | Next diagnostic |
| `M-g p` | Previous diagnostic |
| `C-c ! l` | List diagnostics for the current buffer |

## Hare editing

Basic Hare support is included without tying the general programming module to
a specific Hare project.

Hare files use:

- `hare-mode` for syntax highlighting;
- hard tabs displayed at eight columns;
- a run-current-file command.

Run the current saved `.ha` file with:

```text
C-c C-r
```

This executes the equivalent of:

```bash
hare run /path/to/current-file.ha
```

Language-server configuration and project-specific Hare tooling are intentionally
handled separately from this general Emacs setup.

## Git workflow

There are three separate repositories.

### Emacs configuration

```text
~/.emacs.d/
```

Typical changes include:

- Emacs Lisp modules;
- package declarations;
- keybindings;
- Org and Hugo helper functions;
- welcome-screen and writing settings.

Open Magit with:

```text
C-c g
```

### Org drafts

```text
~/org/drafts/
```

Typical changes include:

- `ideas.org`;
- individual `.org` posts;
- post metadata;
- publication state.

Open its Magit status directly with:

```text
C-c d g
```

### Hugo blog

```text
~/code/thingsabout/
```

Typical changes include:

- exported Markdown;
- Hugo configuration;
- themes and templates;
- static assets.

Open its Magit status directly with:

```text
C-c b g
```

### Common Magit commands

| Key | Action |
|---|---|
| `s` | Stage the item at point |
| `u` | Unstage the item at point |
| `c c` | Create a commit |
| `C-c C-c` | Finish the commit message |
| `P p` | Push to the configured upstream |
| `F` | Open the fetch/pull menu |
| `g` | Refresh the status buffer |
| `RET` | Inspect the item at point |

Before editing a synced repository on another computer, pull first. After
editing, stage, commit, and push.

## Recommended commit order for a post

Commit the repositories independently:

1. Commit the Org source in `~/org/drafts/`.
2. Commit the exported Markdown in `~/code/thingsabout/`.
3. Commit `~/.emacs.d/` only when the configuration itself changed.

## Fresh-machine setup

Clone the Emacs configuration:

```bash
git clone git@github.com:momojes/emacs.git ~/.emacs.d
```

Create the required directories:

```bash
mkdir -p \
  ~/org/journal \
  ~/org/drafts/posts \
  ~/code
```

Clone the drafts and blog repositories into their expected locations.

Create `~/.emacs.d/local.el` with the correct machine name and Hugo path.

Install the system dependencies, then start Emacs once so `use-package` can
install the declared Emacs packages.

Enable the daemon:

```bash
systemctl --user enable --now emacs.service
```

Open Emacs:

```bash
emacsclient -c -n
```

## Safe configuration-editing workflow

When changing a module:

1. Save it with `C-x C-s`.
2. Run `M-x check-parens`.
3. Run `M-x eval-buffer`.
4. Fix any reported error before restarting the daemon.
5. Restart with:

   ```bash
   systemctl --user restart emacs.service
   ```

6. Check the service log if Emacs does not start.

Loading a recently changed file directly can isolate an error:

```text
M-x load-file
```

Then choose the relevant file under:

```text
~/.emacs.d/lisp/
```

## Troubleshooting

### The welcome screen does not appear

Confirm the module loaded:

```elisp
(featurep 'welcome)
```

Expected:

```elisp
t
```

Open it manually:

```text
C-c w
```

Inspect the daemon log for an earlier module error:

```bash
journalctl --user -u emacs.service -b -n 80 --no-pager
```

A startup error in `packages.el`, `prose.el`, or another earlier module can stop
Emacs before `welcome.el` is loaded.

### The welcome screen opens in every frame or buffer

Make sure `welcome.el` does not set:

```elisp
(setq initial-buffer-choice #'my-welcome-buffer)
```

The current setup uses a session flag and
`server-after-make-frame-hook` to show the screen once per daemon session.

### Focused writing mode fails to load

Confirm Olivetti is installed:

```text
M-x package-list-packages
```

Load the files individually:

```text
M-x load-file
~/.emacs.d/lisp/packages.el

M-x load-file
~/.emacs.d/lisp/prose.el
```

Then inspect the service log.

### Spell checking does not work

Confirm the dictionary is installed:

```bash
aspell dicts | grep en_US
```

Check Emacs's configured program:

```elisp
ispell-program-name
```

Expected:

```text
aspell
```

### `C-c b` is undefined

Check that the relevant modules loaded:

```elisp
(list
 (featurep 'blog)
 (featurep 'keys)
 (key-binding (kbd "C-c b")))
```

Expected:

```elisp
(t t my-blog-map)
```

### Hugo directory is not configured

Ensure `~/.emacs.d/local.el` contains:

```elisp
(setq my-hugo-directory
      (expand-file-name "~/code/thingsabout/"))
```

Load it immediately with:

```text
M-x load-file
~/.emacs.d/local.el
```

### Check the active init file

Evaluate:

```elisp
user-init-file
```

Expected on `thinkTaro`:

```text
/home/momo/.emacs.d/init.el
```

## Quick reference

```text
WELCOME
Open welcome screen       C-c w

WRITING
Focused writing mode      C-c z
Check buffer spelling     C-c s b
Toggle Flyspell           C-c s t
Correct word              M-$

ORG
Open agenda               C-c a
Start capture             C-c c
Inbox task                C-c c t
Agenda item               C-c c a
Someday item              C-c c s
Journal entry             C-c c j
Writing idea              C-c c i

DRAFTS
Create draft              C-c d n
Open ideas                C-c d i
Open drafts directory     C-c d d
Open posts directory      C-c d p
Open drafts Magit         C-c d g

HUGO
Export post               C-c b e
Start Hugo                C-c b s
Stop Hugo                 C-c b k
Open preview              C-c b v
Open blog Magit           C-c b g
Publish post              C-c b p

PROGRAMMING
Project commands          C-c p
Eglot code actions        C-c l a
Eglot rename              C-c l r
Eglot format buffer       C-c l f
Eglot shutdown            C-c l q
Next diagnostic           M-g n
Previous diagnostic       M-g p
List diagnostics          C-c ! l
Run current Hare file     C-c C-r

GENERAL
Open current repo Magit   C-c g
Open file                 C-x C-f
Save file                 C-x C-s
Search buffer             M-s l
Search with Ripgrep       M-s r
Switch buffers            C-x b
```
