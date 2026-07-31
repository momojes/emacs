;;; welcome.el --- Custom Emacs welcome screen -*- lexical-binding: t; -*-

(require 'button)

(defconst my-welcome-buffer-name
  "*Welcome*"
  "Name of the custom welcome buffer.")

(defconst my-welcome-banner
  '("┌────────────────────────────────────┐"
    "│               EMACS                │"
    "│                                    │"
    "│      Arch Linux + Window Maker     │"
    "│             thinkTaro              │"
    "└────────────────────────────────────┘")
  "Banner displayed on the welcome screen.")

(defun my-welcome--run-button (button)
  "Run the command attached to BUTTON."
  (let ((command (button-get button 'my-command)))
    (if (commandp command)
        (call-interactively command)
      (user-error "Command is unavailable: %s" command))))

(defun my-welcome--insert-heading (text)
  "Insert heading TEXT."
  (insert
   (propertize text
               'face 'font-lock-keyword-face))
  (insert "\n\n"))

(defun my-welcome--insert-button (key description command)
  "Insert a button for COMMAND.

KEY is the displayed shortcut and DESCRIPTION describes the action."
  (insert "  ")

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
  "Render the welcome screen in the current buffer."
  (let ((inhibit-read-only t))
    (erase-buffer)

    (insert "\n")

    (dolist (line my-welcome-banner)
      (insert
       (propertize line
                   'face 'font-lock-function-name-face))
      (insert "\n"))

    (insert "\n")

    (insert
     (propertize
      "A quiet place to write, organize, and build.\n\n"
      'face 'font-lock-comment-face))

    (my-welcome--insert-heading "QUICK ACTIONS")

    (my-welcome--insert-button
     "[f]" "Find a file" #'find-file)

    (my-welcome--insert-button
     "[b]" "Switch buffers" #'consult-buffer)

    (my-welcome--insert-button
     "[a]" "Open Org agenda" #'org-agenda)

    (my-welcome--insert-button
     "[c]" "Capture an Org entry" #'org-capture)

    (my-welcome--insert-button
     "[g]" "Open Magit" #'magit-status)

    (insert "\n")
    (my-welcome--insert-heading "WRITING")

    (my-welcome--insert-button
     "[d]" "Create a new blog draft" #'my-new-draft-post)

    (my-welcome--insert-button
     "[i]" "Open writing ideas" #'my-open-drafts-ideas)

    (my-welcome--insert-button
     "[p]" "Open draft posts" #'my-open-drafts-posts)

    (insert "\n")
    (my-welcome--insert-heading "HUGO")

    (my-welcome--insert-button
     "[s]" "Start Hugo preview server" #'my-hugo-start-server)

    (my-welcome--insert-button
     "[h]" "Open local Hugo preview" #'my-hugo-open-preview)

    (my-welcome--insert-button
     "[m]" "Open blog repository in Magit" #'my-hugo-magit-status)

    (insert "\n")
    (insert
     (propertize
      "Press q to close this screen.\n"
      'face 'shadow))

    (goto-char (point-min))))

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

(defun my-welcome-buffer ()
  "Create, render, and return the welcome buffer."
  (let ((buffer (get-buffer-create my-welcome-buffer-name)))
    (with-current-buffer buffer
      (my-welcome-mode)
      (my-welcome-render))
    buffer))

(defun my-open-welcome ()
  "Open the custom welcome screen."
  (interactive)
  (switch-to-buffer (my-welcome-buffer)))

(defun my-welcome--display-in-frame (frame)
  "Display the welcome screen in FRAME."
  (when (frame-live-p frame)
    (with-selected-frame frame
      (when (display-graphic-p)
        (let ((window (frame-selected-window frame)))
          (set-window-buffer window (my-welcome-buffer))
          (select-window window))))))

(defun my-welcome--schedule-client-frame ()
  "Schedule the welcome screen for a new client frame."
  (let ((frame (selected-frame)))
    (run-at-time
     0.2 nil
     #'my-welcome--display-in-frame
     frame)))

(defun my-welcome--install-server-hook ()
  "Install the hook used by graphical Emacs client frames."
  (add-hook
   'server-after-make-frame-hook
   #'my-welcome--schedule-client-frame))

;; Normal non-daemon startup.
(setq initial-buffer-choice #'my-welcome-buffer)

;; Daemon/client startup.
(if (featurep 'server)
    (my-welcome--install-server-hook)
  (with-eval-after-load 'server
    (my-welcome--install-server-hook)))

(provide 'welcome)
;;; welcome.el ends here
