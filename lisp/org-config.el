;;; org-config.el --- Org mode configuration -*- lexical-binding: t; -*-

(require 'org)

;;; Directories

(defconst my-org-directory
  (expand-file-name "~/org/")
  "Directory containing local Org files.")

(defconst my-drafts-directory
  (expand-file-name "drafts/" my-org-directory)
  "Git-synced drafts repository.")

(defconst my-drafts-ideas-file
  (expand-file-name "ideas.org" my-drafts-directory)
  "Ideas file inside the drafts repository.")

(defconst my-drafts-posts-directory
  (expand-file-name "posts/" my-drafts-directory)
  "Directory containing draft posts.")

(defconst my-org-inbox-file
  (expand-file-name "inbox.org" my-org-directory)
  "Default inbox for captured tasks.")

(defconst my-org-agenda-file
  (expand-file-name "agenda.org" my-org-directory)
  "File for scheduled tasks and appointments.")

(defconst my-org-someday-file
  (expand-file-name "someday.org" my-org-directory)
  "File for non-current tasks and ideas.")

(defconst my-org-journal-file
  (expand-file-name "journal/journal.org" my-org-directory)
  "Main journal file.")

;;; Create the local Org structure

(make-directory my-org-directory t)
(make-directory
 (file-name-directory my-org-journal-file)
 t)

;; Create local files when they do not already exist.
(dolist (file (list my-org-inbox-file
                    my-org-agenda-file
                    my-org-someday-file
                    my-org-journal-file))
  (unless (file-exists-p file)
    (with-temp-buffer
      (write-file file))))

;; Do not create `my-drafts-directory` here. It should be created by
;; cloning the drafts Git repository.

;;; General Org settings

(setq org-directory my-org-directory
      org-default-notes-file my-org-inbox-file

      org-log-done 'time
      org-startup-indented t
      org-hide-emphasis-markers t
      org-return-follows-link t
      org-use-speed-commands t

      org-todo-keywords
      '((sequence
         "TODO(t)"
         "NEXT(n)"
         "WAIT(w@/!)"
         "|"
         "DONE(d!)"
         "CANCELLED(c@)")))

;;; Agenda

(setq org-agenda-files
      (append
       (list my-org-inbox-file
             my-org-agenda-file
             my-org-someday-file)

       ;; Include the shared ideas file only after the repository
       ;; has been cloned.
       (when (file-exists-p my-drafts-ideas-file)
         (list my-drafts-ideas-file))))

;;; Capture templates

(setq org-capture-templates
      `(("t" "Todo" entry
         (file ,my-org-inbox-file)
         "* TODO %?\n  %U\n"
         :empty-lines 1)

        ("a" "Agenda item" entry
         (file ,my-org-agenda-file)
         "* TODO %?\n  %U\n"
         :empty-lines 1)

        ("s" "Someday item" entry
         (file ,my-org-someday-file)
         "* TODO %?\n  %U\n"
         :empty-lines 1)

        ("j" "Journal entry" entry
         (file+datetree ,my-org-journal-file)
         "* %U %?\n"
         :empty-lines 1)))

;; Add the writing-idea template only when the drafts repository exists.
(when (file-directory-p my-drafts-directory)
  (add-to-list
   'org-capture-templates
   `("i" "Writing idea" entry
     (file ,my-drafts-ideas-file)
     "* TODO %?\n  %U\n"
     :empty-lines 1)
   t))

(provide 'org-config)
;;; org-config.el ends here
