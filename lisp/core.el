;;; core.el --- Core Emacs behavior -*- lexical-binding: t; -*-

(setq inhibit-startup-screen t
      initial-scratch-message nil
      ring-bell-function #'ignore
      use-short-answers t)

(setq backup-directory-alist
      `(("." . ,(expand-file-name "var/backups/"
                                  user-emacs-directory)))
      auto-save-file-name-transforms
      `((".*" ,(expand-file-name "var/auto-save/"
                                 user-emacs-directory) t))
      create-lockfiles nil)

(make-directory
 (expand-file-name "var/backups/" user-emacs-directory)
 t)

(make-directory
 (expand-file-name "var/auto-save/" user-emacs-directory)
 t)

(setq-default indent-tabs-mode nil
              tab-width 4
              fill-column 80)

(delete-selection-mode 1)
(electric-pair-mode 1)
(show-paren-mode 1)
(save-place-mode 1)
(savehist-mode 1)
(recentf-mode 1)

(line-number-mode 1)
(column-number-mode 1)
(global-display-line-numbers-mode 1)

(dolist (hook '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                compilation-mode-hook))
  (add-hook hook
            (lambda ()
              (display-line-numbers-mode 0))))

(provide 'core)
;;; core.el ends here
