# Emacs Configuration

A modular Emacs setup for writing in Org mode, managing Git repositories with
Magit, and publishing posts to the `thingsabout` Hugo blog with `ox-hugo`.

## Repository layout

| Path | Purpose |
|---|---|
| `~/.emacs.d/` | Shared Emacs configuration |
| `~/org/` | Local Org workspace |
| `~/org/drafts/` | Git-synced Org drafts repository |
| `~/org/drafts/posts/` | Individual Org blog drafts |
| `~/code/thingsabout/` | Hugo blog repository and exported Markdown |

The Org source and Hugo output live in separate repositories:

- `~/org/drafts/` contains the editable Org source.
- `~/code/thingsabout/` contains the Hugo site and generated Markdown.
- `~/.emacs.d/` contains the commands and configuration that connect them.

## Emacs configuration layout

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
    └── writing.el
```

`local.el` and `custom.el` are intentionally ignored by Git.

## Machine-specific configuration

The local Hugo repository path must be defined in:

```text
~/.emacs.d/local.el
```

Example:

```elisp
;;; local.el --- Machine-specific settings -*- lexical-binding: t; -*-

(setq my-machine-name "thinkTaro")

(setq my-hugo-directory
      (expand-file-name "~/code/thingsabout/"))

;;; local.el ends here
```

After changing `local.el`, restart the Emacs service:

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

Open a graphical client frame:

```bash
/usr/bin/emacsclient -c -n
```

The Window Maker Dock launcher uses:

```text
/usr/bin/emacsclient -c -n
```

## Main Emacs commands

| Binding | Action |
|---|---|
| `C-c g` | Open Magit for the current repository |
| `C-c a` | Open the Org agenda |
| `C-c c` | Open Org capture |
| `C-c e` | Open the active Emacs init file |
| `C-x C-f` | Open a file |
| `C-x C-s` | Save the current file |
| `M-x` | Run an Emacs command |

## Completion and navigation

This configuration uses:

- Vertico
- Orderless
- Marginalia
- Consult
- Which-Key

Useful bindings:

| Binding | Action |
|---|---|
| `C-x b` | Consult buffer switcher |
| `M-y` | Consult kill-ring history |
| `M-g g` | Go to line |
| `M-s l` | Search the current buffer |
| `M-s r` | Search files with Ripgrep |

## Org capture commands

| Binding | Destination |
|---|---|
| `C-c c t` | Local inbox task |
| `C-c c a` | Agenda item |
| `C-c c s` | Someday item |
| `C-c c j` | Journal entry |
| `C-c c i` | Writing idea in the drafts repository |

The local Org workspace uses:

```text
~/org/
├── inbox.org
├── agenda.org
├── someday.org
├── journal/
│   └── journal.org
└── drafts/
```

## Draft repository commands

| Binding | Action |
|---|---|
| `C-c d n` | Create a new Org blog draft |
| `C-c d i` | Open `ideas.org` |
| `C-c d d` | Open the drafts repository in Dired |
| `C-c d p` | Open the drafts posts directory |
| `C-c d g` | Open Magit for the drafts repository |

New drafts are created under:

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

## Hugo commands

| Binding | Action |
|---|---|
| `C-c b e` | Export the current Org post to Hugo Markdown |
| `C-c b s` | Start the Hugo development server |
| `C-c b k` | Stop the Hugo development server |
| `C-c b v` | Open the local Hugo preview |
| `C-c b g` | Open Magit for the `thingsabout` repository |
| `C-c b p` | Publish the current post |

The local preview normally opens at:

```text
http://localhost:1313/
```

The Hugo server command used by Emacs is:

```bash
hugo server -D --navigateToChanged
```

## Draft metadata

Every Org post should begin with a metadata block like this:

```org
#+title: Example Post
#+date: 2026-07-31
#+author: Momo
#+hugo_base_dir: ~/code/thingsabout/
#+hugo_section: posts
#+hugo_slug: example-post
#+hugo_tags: example
#+hugo_categories: notes
#+hugo_draft: true
#+options: toc:nil num:nil
```

A complete draft can begin like this:

```org
#+title: Example Post
#+date: 2026-07-31
#+author: Momo
#+hugo_base_dir: ~/code/thingsabout/
#+hugo_section: posts
#+hugo_slug: example-post
#+hugo_tags: example
#+hugo_categories: notes
#+hugo_draft: true
#+options: toc:nil num:nil

* Summary

A short description of the post.

* Draft

Write the article here.
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
| `#+hugo_draft` | `true` while drafting, `false` when published |
| `#+options` | Org export options |

## New-post workflow

1. Create a new Org draft:

   ```text
   C-c d n
   ```

2. Enter a title.

3. Write in the generated Org file.

4. Save:

   ```text
   C-x C-s
   ```

5. Export to Hugo Markdown:

   ```text
   C-c b e
   ```

6. Start the Hugo preview server:

   ```text
   C-c b s
   ```

7. Open the preview:

   ```text
   C-c b v
   ```

8. Continue editing the Org source.

9. Save and export again whenever the draft changes:

   ```text
   C-x C-s
   C-c b e
   ```

10. When the post is ready, publish it:

    ```text
    C-c b p
    ```

The publish command:

1. Confirms the publication.
2. Changes `#+hugo_draft: true` to `false`.
3. Offers to update `#+date`.
4. Saves the Org file.
5. Exports the Markdown again.
6. Opens Magit for the Hugo repository.

## Existing-draft workflow

Older drafts can use the same workflow.

1. Open the existing file:

   ```text
   C-x C-f ~/org/drafts/posts/example.org
   ```

2. Add the Hugo metadata block at the top.

3. Keep the existing article body underneath it.

4. Save:

   ```text
   C-x C-s
   ```

5. Export:

   ```text
   C-c b e
   ```

6. Preview:

   ```text
   C-c b s
   C-c b v
   ```

7. Publish when ready:

   ```text
   C-c b p
   ```

## Exported files

A draft with:

```org
#+hugo_slug: example-post
#+hugo_section: posts
```

exports to:

```text
~/code/thingsabout/content/posts/example-post.md
```

The Org file remains the source of truth. Edit the Org file rather than the
generated Markdown whenever possible.

## Git workflow

There are three separate repositories.

### Emacs configuration

```text
~/.emacs.d/
```

Typical changes:

- Emacs Lisp modules
- keybindings
- package configuration
- Org and Hugo helper functions

Suggested Magit flow:

```text
C-c g
s
c c
C-c C-c
P p
```

### Org drafts

```text
~/org/drafts/
```

Typical changes:

- `ideas.org`
- individual `.org` posts
- draft metadata
- publication state

Open directly with:

```text
C-c d g
```

### Hugo blog

```text
~/code/thingsabout/
```

Typical changes:

- exported Markdown
- Hugo configuration
- themes and templates
- static assets

Open directly with:

```text
C-c b g
```

## Magit command map

| Key | Action |
|---|---|
| `s` | Stage item at point |
| `u` | Unstage item at point |
| `c c` | Create a commit |
| `C-c C-c` | Finish the commit message |
| `P p` | Push to the configured upstream |
| `F` | Open the pull/fetch menu |
| `g` | Refresh the Magit status buffer |
| `RET` | Inspect the item at point |

Before working on a synced repository from another computer, pull first.
After editing, stage, commit, and push.

## Recommended commit order for a post

When publishing a post, commit the repositories independently.

1. Commit the Org source in:

   ```text
   ~/org/drafts/
   ```

2. Commit the exported Markdown in:

   ```text
   ~/code/thingsabout/
   ```

3. Commit Emacs configuration changes only when commands or settings changed:

   ```text
   ~/.emacs.d/
   ```

## Troubleshooting

### `C-c b` is undefined

Confirm that the blog and keys modules loaded:

```elisp
(list
 (featurep 'blog)
 (featurep 'keys)
 (key-binding (kbd "C-c b")))
```

Expected result:

```elisp
(t t my-blog-map)
```

Reload the files manually when needed:

```text
M-x load-file
~/.emacs.d/lisp/blog.el

M-x load-file
~/.emacs.d/lisp/keys.el
```

Then restart the daemon:

```bash
systemctl --user restart emacs.service
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

Expected result:

```text
/home/momo/.emacs.d/init.el
```

### Check the Emacs service log

```bash
journalctl --user -u emacs.service -b -n 80 --no-pager
```

## Quick reference

```text
Create draft              C-c d n
Open ideas                C-c d i
Open drafts Magit         C-c d g

Export post               C-c b e
Start Hugo                C-c b s
Stop Hugo                 C-c b k
Open preview              C-c b v
Open blog Magit           C-c b g
Publish post              C-c b p

Open current repo Magit   C-c g
Save file                 C-x C-s
Open file                 C-x C-f
```
