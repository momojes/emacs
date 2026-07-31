;;; packages.el --- Package configuration -*- lexical-binding: t; -*-

(require 'package)

(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))

(package-initialize)

(require 'use-package)

(setq use-package-always-ensure t
      use-package-expand-minimally t)

;;; Discoverability

(use-package which-key
  :init
  (which-key-mode 1))

;;; Git

(use-package magit
  :commands magit-status)

;;; Minibuffer completion

(use-package vertico
  :init
  (vertico-mode 1))

(use-package orderless
  :custom
  ;; Match space-separated components in any order.
  (completion-styles '(orderless basic))

  ;; Let our configuration control category behavior.
  (completion-category-defaults nil)

  ;; Retain convenient partial paths and wildcards for file names.
  (completion-category-overrides
   '((file (styles partial-completion)))))

(use-package marginalia
  :bind
  (:map minibuffer-local-map
        ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode 1))

;;; Search and navigation

(use-package consult
  :bind
  (("C-x b"   . consult-buffer)
   ("M-y"     . consult-yank-pop)
   ("M-g g"   . consult-goto-line)
   ("M-g M-g" . consult-goto-line)
   ("M-s l"   . consult-line)
   ("M-s r"   . consult-ripgrep)))

;;; Hugo exporting

(use-package ox-hugo
  :after ox)

(provide 'packages)
;;; packages.el ends here


