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
(require 'org-config)
(require 'keys)

;; Load settings written by the Customize interface.
(when (file-exists-p custom-file)
  (load custom-file nil 'nomessage))

;; Load optional machine-specific settings last.
(let ((local-file (expand-file-name "local.el" user-emacs-directory)))
  (when (file-exists-p local-file)
    (load local-file nil 'nomessage)))

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(consult magit marginalia orderless vertico vterm)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
