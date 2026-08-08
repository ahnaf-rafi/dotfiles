;;; ar-editor.el --- -*- lexical-binding: t; -*-

;;; Code:

(setq display-line-numbers-type 'visual)

(setq-default fill-column 80)

(dolist (hook '(prog-mode-hook text-mode-hook))
  (add-hook hook #'display-line-numbers-mode)
  (add-hook hook #'display-fill-column-indicator-mode))

;; Long lines
(setq-default word-wrap t)
(add-hook 'after-init-hook #'global-visual-line-mode)

;; Make scrolling smooth; no jumps.
(setq-default scroll-margin 0)
(setq-default scroll-step 1)
(setq-default scroll-preserve-screen-position nil)
(setq-default scroll-conservatively 10000)
(setq-default auto-window-vscroll nil)

(with-eval-after-load 'evil
  (evil-set-undo-system 'undo-redo))

;; Indentation widths
(setq-default indent-tabs-mode nil)

;; Indentation widths
(setq-default standard-indent 2)
(setq-default tab-width 2)
(setq-default evil-shift-width standard-indent)

;; Disable electric-indent
(setq-default electric-indent-inhibit t)

;; Use adaptive-wrap to adapt indentation in wrapped lines
(use-package adaptive-wrap
  :init
  ;; Ensure no extra offset by default.
  (setq-default adaptive-wrap-extra-indent 0))

;; Show trailing whitespaces.
(setq-default show-trailing-whitespace t)

;; Delete trailing whitespaces before saving.
(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; New lines at EOF
(setq-default require-final-newline nil)
(setq-default mode-require-final-newline t)
(setq-default log-edit-require-final-newline nil)

;; Make parenthesis highlighting instantaneous.
(setq show-paren-delay 0)
;; Highlight opening parenthesis even when cursor is on closing one.
(setq show-paren-highlight-openparen t)
;; Highlight when cursor is inside the parenthesis as well as outside.
(setq show-paren-when-point-inside-paren t)
;; Highlight when the cursor is in the "periphery" (e.g., at the end of a line
;; that ends with a parenthesis).
(setq show-paren-when-point-in-periphery t)
(add-hook 'after-init-hook #'show-paren-mode)

;; Enable `electric-pair-mode'
(add-hook 'after-init-hook #'electric-pair-mode)

;; evil-surround
(use-package evil-surround
  :init
  ;; Enable evil-surround globally.
  (global-evil-surround-mode 1))

(provide 'ar-editor)
;;; ar-editor.el ends here
