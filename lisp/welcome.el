;;; welcome.el --- Custom Emacs welcome screen -*- lexical-binding: t; -*-

(require 'button)

(defconst my-welcome-buffer-name
  "*Welcome*"
  "Name of the custom welcome buffer.")

(defvar my-welcome-banner
  '("┌────────────────────────────────────┐"
    "│               EMACS                │"
    "│                                    │"
    "│      Arch Linux + Window Maker     │"
    "│             thinkTaro              │"
    "└────────────────────────────────────┘")
  "Banner displayed on the welcome screen.")

(defvar my-welcome-shown nil
  "Non-nil after the welcome screen has appeared automatically.")

;;; Rendering helpers

(defun my-welcome--run-button (button)
  "Run the command attached to BUTTON."
  (let ((command (button-get button 'my-command)))
    (if (commandp command)
        (call-interactively command)
      (user-error "Command is unavailable: %s" command))))

(defun my-welcome--insert-centered-line (text &optional face)
  "Insert TEXT centered within the current window using FACE."
  (let* ((width (max 1 (window-body-width)))
         (padding
          (max 0
               (/ (- width (string-width text)) 2))))
    (insert (make-string padding ?\s))
    (insert (propertize text 'face face))
    (insert "\n")))

(defun my-welcome--insert-heading (text)
  "Insert section heading TEXT."
  (my-welcome--insert-centered-line
   text
   'font-lock-keyword-face)
  (insert "\n"))

(defun my-welcome--insert-button (key description command)
  "Insert a welcome-screen button.

KEY is the displayed shortcut, DESCRIPTION explains the action,
and COMMAND is called when the button is activated."
  (insert "    ")

  (insert-text-button
   key
   'face 'font-lock-function-name-face
   'follow-link t
   'help-echo description
   'my-command command
   'action #'my-welcome--run-button)

  (insert
   (propertize
    (format "  %s\n" description)
    'face 'font-lock-comment-face)))

(defun my-welcome-render ()
  "Render the custom welcome screen in the current buffer."
  (let ((inhibit-read-only t))
    (erase-buffer)

    (insert "\n")

    (dolist (line my-welcome-banner)
      (my-welcome--insert-centered-line
       line
       'font-lock-function-name-face))

    (insert "\n")

    (my-welcome--insert-centered-line
     "A quiet place to write, organize, and build."
     'font-lock-comment-face)

    (insert "\n")
    (my-welcome--insert-heading "QUICK ACTIONS")

    (my-welcome--insert-button
     "[f]"
     "Find a file"
     #'find-file)

    (my-welcome--insert-button
     "[b]"
     "Switch buffers"
     #'consult-buffer)

    (my-welcome--insert-button
     "[a]"
     "Open Org agenda"
     #'org-agenda)

    (my-welcome--insert-button
     "[c]"
     "Capture an Org entry"
     #'org-capture)

    (my-welcome--insert-button
     "[g]"
     "Open Magit"
     #'magit-status)

    (insert "\n")
    (my-welcome--insert-heading "WRITING")

    (my-welcome--insert-button
     "[d]"
     "Create a new blog draft"
     #'my-new-draft-post)

    (my-welcome--insert-button
     "[i]"
     "Open writing ideas"
     #'my-open-drafts-ideas)

    (my-welcome--insert-button
     "[p]"
     "Open draft posts"
     #'my-open-drafts-posts)

    (insert "\n")
    (my-welcome--insert-heading "HUGO")

    (my-welcome--insert-button
     "[s]"
     "Start Hugo preview server"
     #'my-hugo-start-server)

    (my-welcome--insert-button
     "[h]"
     "Open local Hugo preview"
     #'my-hugo-open-preview)

    (my-welcome--insert-button
     "[m]"
     "Open blog repository in Magit"
     #'my-hugo-magit-status)

    (insert "\n")

    (my-welcome--insert-centered-line
     "Press q to close this screen."
     'shadow)

    (goto-char (point-min))))

;;; Welcome major mode

(defvar my-welcome-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "f") #'find-file)
    (define-key map (kbd "b") #'consult-buffer)
    (define-key map (kbd "a") #'org-agenda)
    (define-key map (kbd "c") #'org-capture)
    (define-key map (kbd "g") #'magit-status)

    (define-key map (kbd "d") #'my-new-draft-post)
    (define-key map (kbd "i") #'my-open-drafts-ideas)
    (define-key map (kbd "p") #'my-open-drafts-posts)

    (define-key map (kbd "s") #'my-hugo-start-server)
    (define-key map (kbd "h") #'my-hugo-open-preview)
    (define-key map (kbd "m") #'my-hugo-magit-status)

    (define-key map (kbd "q") #'quit-window)
    map)
  "Keymap used by `my-welcome-mode'.")

(define-derived-mode my-welcome-mode special-mode "Welcome"
  "Major mode for the custom welcome screen."
  (setq-local cursor-type nil)
  (setq-local mode-line-format nil)
  (setq-local truncate-lines t)
  (display-line-numbers-mode -1))

;;; Opening the welcome screen

(defun my-welcome-buffer ()
  "Create, render, and return the welcome buffer."
  (let ((buffer
         (get-buffer-create my-welcome-buffer-name)))
    (with-current-buffer buffer
      (my-welcome-mode)
      (my-welcome-render))
    buffer))

(defun my-open-welcome ()
  "Open the custom welcome screen manually."
  (interactive)
  (switch-to-buffer (my-welcome-buffer)))

;;; Automatic startup behavior

(defun my-welcome--display-in-frame (frame)
  "Display the welcome screen in FRAME."
  (when (frame-live-p frame)
    (with-selected-frame frame
      (when (display-graphic-p)
        (switch-to-buffer
         (my-welcome-buffer))))))

(defun my-welcome--show-once-in-client-frame ()
  "Show the welcome screen in the first graphical client frame only."
  (when (and (display-graphic-p)
             (not my-welcome-shown))
    (setq my-welcome-shown t)

    ;; Give the new graphical frame a moment to finish opening.
    (let ((frame (selected-frame)))
      (run-at-time
       0.15 nil
       #'my-welcome--display-in-frame
       frame))))

(defun my-welcome--show-once-at-startup ()
  "Show the welcome screen once during ordinary Emacs startup."
  (when (and (display-graphic-p)
             (not my-welcome-shown))
    (setq my-welcome-shown t)
    (my-open-welcome)))

;; Ordinary Emacs startup.
(unless (daemonp)
  (add-hook
   'emacs-startup-hook
   #'my-welcome--show-once-at-startup))

;; First graphical frame created through emacsclient.
(if (featurep 'server)
    (add-hook
     'server-after-make-frame-hook
     #'my-welcome--show-once-in-client-frame)

  (with-eval-after-load 'server
    (add-hook
     'server-after-make-frame-hook
     #'my-welcome--show-once-in-client-frame)))

(provide 'welcome)
;;; welcome.el ends here
