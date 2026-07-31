;;; keys.el --- Shared keybindings -*- lexical-binding: t; -*-

(global-set-key (kbd "C-c g") #'magit-status)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(global-set-key
 (kbd "C-c e")
 (lambda ()
   (interactive)
   (find-file user-init-file)))

(provide 'keys)
;;; keys.el ends here
