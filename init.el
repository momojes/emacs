;;; init.el --- Shared Emacs configuration -*- lexical-binding: t; -*-

;; Keep settings written by the Customize interface separate from
;; the hand-written configuration.
(setq custom-file
      (expand-file-name "custom.el" user-emacs-directory))

;; Load our configuration modules.
(add-to-list 'load-path
             (expand-file-name "lisp" user-emacs-directory))

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

;; Load settings written by the Customize interface.
(when (file-exists-p custom-file)
  (load custom-file nil 'nomessage))

;; Load optional machine-specific settings last.
(let ((local-file (expand-file-name "local.el" user-emacs-directory)))
  (when (file-exists-p local-file)
    (load local-file nil 'nomessage)))

(provide 'init)
