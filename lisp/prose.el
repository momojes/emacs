;;; prose.el --- Prose writing settings -*- lexical-binding: t; -*-

;;; Spell checking

(setq ispell-program-name "aspell"
      ispell-dictionary "en_US"
      ispell-extra-args '("--sug-mode=ultra"))

(defun my-prose-mode-setup ()
  "Enable comfortable settings for prose buffers."
  ;; Wrap visually without inserting hard line breaks.
  (visual-line-mode 1)

  ;; Check spelling while writing.
  (flyspell-mode 1)

  ;; Prose buffers do not need line numbers.
  (display-line-numbers-mode -1)

  (setq-local fill-column 80))

(add-hook 'text-mode-hook #'my-prose-mode-setup)

;;; Useful commands

(defun my-check-buffer-spelling ()
  "Check the spelling of the current buffer."
  (interactive)
  (ispell-buffer))

(defun my-toggle-spell-checking ()
  "Toggle automatic spell checking in the current buffer."
  (interactive)
  (flyspell-mode 'toggle))

(provide 'prose)
;;; prose.el ends here
