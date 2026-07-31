;;; early-init.el --- Early startup settings -*- lexical-binding: t; -*-

;; Prevent the package system from loading before init.el.
(setq package-enable-at-startup nil)

;; Reduce visual noise during startup.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Avoid resizing the frame after startup.
(setq frame-inhibit-implied-resize t)

(provide 'early-init)
;;; early-init.el ends here
