;;; blog.el --- Hugo blog workflow -*- lexical-binding: t; -*-

(require 'subr-x)

(defconst my-hugo-preview-url
  "http://localhost:1313/"
  "Local address used by the Hugo development server.")

(defun my-hugo-root ()
  "Return the configured Hugo site directory.

Signal a helpful error when `my-hugo-directory' has not been
configured or does not exist."
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
  "Export the current one-post-per-file Org document to Hugo Markdown."
  (interactive)

  (unless (derived-mode-p 'org-mode)
    (user-error "This command must be run from an Org buffer"))

  (require 'ox-hugo)

  (let ((output-file (org-hugo-export-to-md)))
    (when output-file
      (message "Exported Hugo post: %s" output-file))))

(defun my-hugo-start-server ()
  "Start Hugo's development server in the blog repository."
  (interactive)

  (let ((existing-buffer (get-buffer "*hugo-server*")))
    (if (and existing-buffer
             (process-live-p
              (get-buffer-process existing-buffer)))
        (pop-to-buffer existing-buffer)

      (let ((default-directory (my-hugo-root)))
        (compilation-start
         "hugo server --buildDrafts --navigateToChanged"
         'compilation-mode
         (lambda (_mode-name)
           "*hugo-server*"))))))

(defun my-hugo-stop-server ()
  "Stop the running Hugo development server."
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
  "Open the local Hugo preview in the default browser."
  (interactive)
  (browse-url my-hugo-preview-url))

(defun my-hugo-magit-status ()
  "Open Magit for the Hugo blog repository."
  (interactive)
  (require 'magit)
  (magit-status (my-hugo-root)))

(provide 'blog)
;;; blog.el ends here
