;;; appearance.el --- Emacs appearance -*- lexical-binding: t; -*-

(blink-cursor-mode -1)

(load-theme 'modus-vivendi t)

(defun my-apply-font (&optional frame)
  "Apply Maple Mono to FRAME, or the selected frame."
  (with-selected-frame (or frame (selected-frame))
    (when (display-graphic-p)
      (set-face-attribute
       'default nil
       :family "Maple Mono"
       :height 120))))

(my-apply-font)

(add-hook 'after-make-frame-functions #'my-apply-font)

(provide 'appearance)
;;; appearance.el ends here
