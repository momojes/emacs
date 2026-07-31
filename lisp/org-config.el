;;; org-config.el --- Org mode configuration -*- lexical-binding: t; -*-

(require 'org)

(defconst my-org-directory
  (expand-file-name "~/org/")
  "Main directory containing Org files.")

(setq org-directory my-org-directory
      org-default-notes-file
      (expand-file-name "inbox.org" my-org-directory)

      org-agenda-files
      (list
       (expand-file-name "inbox.org" my-org-directory)
       (expand-file-name "agenda.org" my-org-directory)
       (expand-file-name "ideas.org" my-org-directory)
       (expand-file-name "someday.org" my-org-directory))

      org-log-done 'time
      org-startup-indented t
      org-hide-emphasis-markers t
      org-return-follows-link t)

(make-directory my-org-directory t)

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)")))

(setq org-capture-templates
      `(("t" "Todo" entry
         (file ,(expand-file-name "inbox.org" my-org-directory))
         "* TODO %?\n  %U\n"
         :empty-lines 1)

        ("i" "Idea" entry
         (file ,(expand-file-name "ideas.org" my-org-directory))
         "* TODO %?\n  %U\n"
         :empty-lines 1)

        ("j" "Journal entry" entry
         (file+datetree
          ,(expand-file-name "journal/journal.org" my-org-directory))
         "* %U %?\n"
         :empty-lines 1)

        ("d" "Draft" entry
         (file ,(expand-file-name "drafts/drafts.org" my-org-directory))
         "* TODO %?\n  %U\n"
         :empty-lines 1)))

(provide 'org-config)
;;; org-config.el ends here
