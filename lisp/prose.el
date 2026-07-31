;;; prose.el --- Prose writing settings -*- lexical-binding: t; -*-

;;; Spell checking

(setq ispell-program-name "aspell"
      ispell-dictionary "en_US"
      ispell-extra-args '("--sug-mode=ultra"))

(defun my-prose-mode-setup ()
  "Enable comfortable settings for prose buffers."
  ;; Wrap visually without modifying the file.
  (visual-line-mode 1)

  ;; Check spelling while writing.
  (flyspell-mode 1)

  ;; Line numbers are distracting in prose.
  (display-line-numbers-mode -1)

  (setq-local fill-column 80))

(add-hook 'text-mode-hook #'my-prose-mode-setup)

;;; Spell-checking commands

(defun my-check-buffer-spelling ()
  "Check spelling throughout the current buffer."
  (interactive)
  (ispell-buffer))

(defun my-toggle-spell-checking ()
  "Toggle automatic spell checking in the current buffer."
  (interactive)
  (flyspell-mode 'toggle))

;;; Focused writing mode

(defvar-local my-focus-writing--saved-mode-line-format nil
  "Mode-line format saved before entering focused writing mode.")

(defvar-local my-focus-writing--saved-line-numbers nil
  "Line-number setting saved before entering focused writing mode.")

(define-minor-mode my-focus-writing-mode
  "Toggle a centered, distraction-free writing environment.

This mode centers the text with Olivetti, enables visual wrapping,
hides line numbers, and temporarily hides the mode line."
  :init-value nil
  :lighter " Focus"

  (if my-focus-writing-mode
      (progn
        (setq my-focus-writing--saved-mode-line-format
              mode-line-format)

        (setq my-focus-writing--saved-line-numbers
              display-line-numbers)

        (setq-local mode-line-format nil)

        (display-line-numbers-mode -1)
        (visual-line-mode 1)
        (olivetti-mode 1))

    ;; Restore the ordinary buffer appearance.
    (olivetti-mode -1)

    (setq-local mode-line-format
                my-focus-writing--saved-mode-line-format)

    (when my-focus-writing--saved-line-numbers
      (display-line-numbers-mode 1)
      (setq-local display-line-numbers
                  my-focus-writing--saved-line-numbers))

    (force-mode-line-update)))

(provide 'prose)
;;; prose.el ends here
