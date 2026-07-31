;;; keys.el --- Shared keybindings -*- lexical-binding: t; -*-

(global-set-key (kbd "C-c g") #'magit-status)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(global-set-key
 (kbd "C-c e")
 (lambda ()
   (interactive)
   (find-file user-init-file)))

;;; Drafts repository shortcuts

(define-prefix-command 'my-drafts-map)
(global-set-key (kbd "C-c d") 'my-drafts-map)

(defun my-open-drafts-ideas ()
  "Open the writing ideas file."
  (interactive)
  (find-file my-drafts-ideas-file))

(defun my-open-drafts-directory ()
  "Open the drafts repository in Dired."
  (interactive)
  (dired my-drafts-directory))

(defun my-open-drafts-posts ()
  "Open the drafts posts directory in Dired."
  (interactive)
  (dired my-drafts-posts-directory))

(defun my-drafts-magit-status ()
  "Open Magit for the drafts repository."
  (interactive)
  (magit-status my-drafts-directory))

(define-key my-drafts-map (kbd "i") #'my-open-drafts-ideas)
(define-key my-drafts-map (kbd "d") #'my-open-drafts-directory)
(define-key my-drafts-map (kbd "p") #'my-open-drafts-posts)
(define-key my-drafts-map (kbd "g") #'my-drafts-magit-status)
(define-key my-drafts-map (kbd "n") #'my-new-draft-post)

;;; Git

(global-set-key (kbd "C-c g") #'magit-status)
(global-unset-key (kbd "C-x g"))

;;; Hugo blog shortcuts

(define-prefix-command 'my-blog-map)
(global-set-key (kbd "C-c b") #'my-blog-map)

(define-key my-blog-map (kbd "e")
            #'my-hugo-export-current-post)

(define-key my-blog-map (kbd "s")
            #'my-hugo-start-server)

(define-key my-blog-map (kbd "k")
            #'my-hugo-stop-server)

(define-key my-blog-map (kbd "v")
            #'my-hugo-open-preview)

(define-key my-blog-map (kbd "g")
            #'my-hugo-magit-status)

(define-key my-blog-map (kbd "p")
            #'my-hugo-publish-current-post)

;;; Welcome screen

(global-set-key (kbd "C-c w") #'my-open-welcome)

;;; Spelling

(define-prefix-command 'my-spelling-map)
(global-set-key (kbd "C-c s") #'my-spelling-map)

(define-key my-spelling-map (kbd "b")
  #'my-check-buffer-spelling)

(define-key my-spelling-map (kbd "t")
  #'my-toggle-spell-checking)

(provide 'keys)
;;; keys.el ends here
