;;; writing.el --- Writing and draft helpers -*- lexical-binding: t; -*-

(require 'subr-x)

(defun my-slugify-title (title)
  "Convert TITLE into a lowercase filename slug."
  (let ((slug (downcase (string-trim title))))
    (setq slug
          (replace-regexp-in-string "[^[:alnum:]]+" "-" slug))
    (replace-regexp-in-string "\\`-\\|-\\'" "" slug)))

(defun my-new-draft-post (title)
  "Create and open a new Org draft named from TITLE."
  (interactive "sPost title: ")
  (let* ((slug (my-slugify-title title))
         (filename (concat slug ".org"))
         (path (expand-file-name
                filename
                my-drafts-posts-directory)))

    (when (string-empty-p slug)
      (user-error "The title cannot be empty"))

    (make-directory my-drafts-posts-directory t)

    (when (file-exists-p path)
      (user-error "A draft already exists at %s" path))

    (find-file path)

    (insert
     (format
      "#+title: %s
#+date: %s
#+options: toc:nil num:nil
#+filetags: :draft:

* Summary

%?

* Draft

"
      title
      (format-time-string "%Y-%m-%d")))

    ;; Remove the template cursor marker and place point there.
    (goto-char (point-min))
    (search-forward "%?")
    (replace-match "")
    (save-buffer)))

(provide 'writing)
;;; writing.el ends here
