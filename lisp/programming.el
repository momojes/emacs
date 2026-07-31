;;; programming.el --- Programming tools and defaults -*- lexical-binding: t; -*-

;;; General programming behavior

(defun my-programming-mode-setup ()
  "Apply shared settings to programming buffers."
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 4)
  (setq-local fill-column 80)
  (setq-local show-trailing-whitespace t)

  ;; Ensure programming buffers display line numbers.
  (display-line-numbers-mode 1))

(add-hook 'prog-mode-hook #'my-programming-mode-setup)

;;; Projects

(use-package project
  :ensure nil
  :bind-keymap
  ("C-c p" . project-prefix-map))

;;; Language Server Protocol

(use-package eglot
  :ensure nil
  :commands
  (eglot
   eglot-ensure
   eglot-shutdown)

  :custom
  ;; Shut down a language server after its last managed buffer closes.
  (eglot-autoshutdown t)

  ;; Avoid retaining a large event log during ordinary use.
  (eglot-events-buffer-size 0)

  :bind
  (:map eglot-mode-map
        ("C-c l a" . eglot-code-actions)
        ("C-c l r" . eglot-rename)
        ("C-c l f" . eglot-format-buffer)
        ("C-c l q" . eglot-shutdown)))

;;; Diagnostics

(use-package flymake
  :ensure nil
  :bind
  (("M-g n"   . flymake-goto-next-error)
   ("M-g p"   . flymake-goto-prev-error)
   ("C-c ! l" . flymake-show-buffer-diagnostics)))

;;; Tree-sitter

(use-package treesit
  :ensure nil
  :custom
  ;; Use the fullest available syntax highlighting.
  (treesit-font-lock-level 4))

;;; Hare

(defun my-hare-mode-setup ()
  "Configure editing behavior for Hare source files."
  ;; Hare's canonical style uses hard tabs displayed at eight columns.
  (setq-local indent-tabs-mode t
              tab-width 8
              fill-column 80))

(defun my-hare-run-current-file ()
  "Save and run the current Hare source file."
  (interactive)

  (unless buffer-file-name
    (user-error "Save this Hare buffer to a file first"))

  (save-buffer)

  (compile
   (format
    "hare run %s"
    (shell-quote-argument buffer-file-name))))

(use-package hare-mode
  :mode "\\.ha\\'"

  :hook
  ((hare-mode . my-hare-mode-setup)
   (hare-mode . eglot-ensure))

  :bind
  (:map hare-mode-map
        ("C-c C-r" . my-hare-run-current-file))

  :config
  (with-eval-after-load 'eglot
    (add-to-list
     'eglot-server-programs
     '(hare-mode . ("hare-lsp")))))

(provide 'programming)
;;; programming.el ends here
