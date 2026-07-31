;;; org-config.el --- Org mode configuration -*- lexical-binding: t; -*-

(require 'org)

(setq org-directory (expand-file-name "~/org/")
      org-default-notes-file
      (expand-file-name "inbox.org" org-directory)
      org-agenda-files
      (list org-directory))

(make-directory org-directory t)

(setq org-log-done 'time
      org-startup-indented t
      org-hide-emphasis-markers t)

(setq org-capture-templates
      '(("t" "Todo" entry
         (file "inbox.org")
         "* TODO %?\n  %U\n")
        ("n" "Note" entry
         (file "inbox.org")
         "* %?\n  %U\n")))

(provide 'org-config)
;;; org-config.el ends here
