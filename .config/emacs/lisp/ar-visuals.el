;;; ar-visuals.el --- -*- lexical-binding: t; -*-

;;; Code:

(add-to-list 'default-frame-alist '(font . "JuliaMono-12"))
(set-face-attribute 'default nil :font "JuliaMono-12")

(defvar ar/use-dark-theme t
  "Use dark theme if `t' otherwise, use light theme")

(mapc #'disable-theme custom-enabled-themes)
(require-theme 'modus-themes)
(setq modus-themes-org-blocks 'gray-background)
(setq modus-themes-disable-other-themes t)

(if ar/use-dark-theme
    (modus-themes-load-theme 'modus-vivendi-tinted)
  (modus-themes-load-theme 'modus-operandi-tinted))

(use-package hl-todo
  :init
  (dolist (hook '(prog-mode-hook tex-mode-hook markdown-mode-hook))
    (add-hook hook #'hl-todo-mode))

  ;; Stolen from doom-emacs: modules/ui/hl-todo/config.el
  (setq hl-todo-highlight-punctuation ":")
  (setq hl-todo-keyword-faces
        '(;; For reminders to change or add something at a later date.
          ("TODO" warning bold)
          ;; For code that has incomplete or is missing documentation.
          ("DOC" warning bold)
          ;; For code (or code paths) that are broken, unimplemented, or slow,
          ;; and may become bigger problems later.
          ("FIXME" error bold)
          ;; For code that needs to be revisited later, either to upstream it,
          ;; improve it, or address non-critical issues.
          ("REVIEW" font-lock-keyword-face bold)
          ;; For code smells where questionable practices are used
          ;; intentionally, and/or is likely to break in a future update.
          ("HACK" font-lock-constant-face bold)
          ;; For sections of code that just gotta go, and will be gone soon.
          ;; Specifically, this means the code is deprecated, not necessarily
          ;; the feature it enables.
          ("DEPRECATED" font-lock-doc-face bold)
          ;; Extra keywords commonly found in the wild, whose meaning may vary
          ;; from project to project.
          ("NOTE" success bold)
          ("BUG" error bold)
          ("XXX" font-lock-constant-face bold))))

(use-package nerd-icons)

(provide 'ar-visuals)
;;; ar-visuals.el ends here
