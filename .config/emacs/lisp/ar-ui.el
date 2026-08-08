;;; ar-ui.el --- -*- lexical-binding: t; -*-

;;; Code:

;; No blinking cursors in GUI.
(when (fboundp 'blink-cursor-mode)
  (blink-cursor-mode -1))

;; No blinking cursors in terminal.
(setq visible-cursor nil)

;; (setq use-dialog-box nil)

(setq x-gtk-use-system-tooltips nil)
(when (fboundp 'tooltip-mode)
  (tooltip-mode -1))

(size-indication-mode t)
(line-number-mode t)
(column-number-mode t)

(use-package doom-modeline
  :init
  (setq doom-modeline-buffer-file-name-style 'file-name)
  (doom-modeline-mode 1))

(use-package hide-mode-line
  :hook (completion-list-mode . hide-mode-line-mode))

;; Don't require confirmation every time when quitting.
(setq confirm-kill-emacs nil)

(ar/leader
  ("q"   nil                       "Quit")
  ("q K" #'save-buffers-kill-emacs "Save buffers and kill emacs"))

(provide 'ar-ui)
;;; ar-ui.el ends here
