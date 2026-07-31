;;; blog.el --- Hugo blog workflow -*- lexical-binding: t; -*-

(require 'subr-x)

(defconst my-hugo-preview-url
  "http://localhost:1313/"
  "Local URL for the Hugo development server.")

(defun my-hugo-root ()
  "Return the configured Hugo site directory."
  (unless (boundp 'my-hugo-directory)
    (user-error
     "Set `my-hugo-directory' in ~/.emacs.d/local.el"))

  (let ((directory
         (file-name-as-directory
          (expand-file-name my-hugo-directory))))
    (unless (file-directory-p directory)
      (user-error "Hugo directory does not exist: %s" directory))
    directory))

(defun my-hugo-export-current-post ()
  "Export the current Org file to Hugo Markdown."
  (interactive)

  (unless (derived-mode-p 'org-mode)
    (user-error "This command must be run from an Org buffer"))

  (require 'ox-hugo)

  (let ((output-file (org-hugo-export-to-md)))
    (if output-file
        (message "Exported Hugo post: %s" output-file)
      (user-error "Ox-hugo did not return an exported file"))))

(defun my-hugo-start-server ()
  "Start Hugo's development server."
  (interactive)

  (let* ((buffer (get-buffer "*hugo-server*"))
         (process
          (and buffer
               (get-buffer-process buffer))))
    (if (and process (process-live-p process))
        (pop-to-buffer buffer)

      (let ((default-directory (my-hugo-root)))
        (compilation-start
         "hugo server -D --navigateToChanged"
         'compilation-mode
         (lambda (_mode-name)
           "*hugo-server*"))))))

(defun my-hugo-stop-server ()
  "Stop the Hugo development server."
  (interactive)

  (let* ((buffer (get-buffer "*hugo-server*"))
         (process
          (and buffer
               (get-buffer-process buffer))))
    (if (and process (process-live-p process))
        (progn
          (delete-process process)
          (message "Stopped Hugo server"))
      (message "The Hugo server is not running"))))

(defun my-hugo-open-preview ()
  "Open the local Hugo site in the default browser."
  (interactive)
  (browse-url my-hugo-preview-url))

(defun my-hugo-magit-status ()
  "Open Magit for the Hugo repository."
  (interactive)
  (require 'magit)
  (magit-status (my-hugo-root)))

(defun my-org-set-file-keyword (keyword value)
  "Set file-level Org KEYWORD to VALUE."
  (save-excursion
    (goto-char (point-min))

    (let ((case-fold-search t)
          (regexp
           (format "^#\\+%s:[ \t]*.*$"
                   (regexp-quote keyword))))
      (if (re-search-forward regexp nil t)
          (replace-match
           (format "#+%s: %s" keyword value)
           t t)

        (goto-char (point-min))

        ;; Insert after the initial block of #+ metadata lines.
        (while (looking-at-p "^#\\+")
          (forward-line 1))

        (insert
         (format "#+%s: %s\n" keyword value))))))

(defun my-hugo-publish-current-post ()
  "Mark the current Org post published, export it, and open Magit."
  (interactive)

  (unless (derived-mode-p 'org-mode)
    (user-error "This command must be run from an Org buffer"))

  (unless buffer-file-name
    (user-error "Save this Org buffer to a file first"))

  (unless
      (y-or-n-p
       (format "Publish %s? "
               (file-name-nondirectory buffer-file-name)))
    (user-error "Publishing cancelled"))

  (my-org-set-file-keyword "hugo_draft" "false")

  (when (y-or-n-p "Change #+date to today? ")
    (my-org-set-file-keyword
     "date"
     (format-time-string "%Y-%m-%d")))

  (save-buffer)
  (require 'ox-hugo)

  (let ((output-file (org-hugo-export-to-md)))
    (unless output-file
      (user-error "Ox-hugo did not return an exported file"))

    (message "Published Hugo post: %s" output-file))

  (my-hugo-magit-status))

(provide 'blog)
;;; blog.el ends here
