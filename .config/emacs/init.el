;;; init.el --- -*- no-byte-compile: t; lexical-binding: t; -*-

;;; Code:

;; Personal details
(setq user-full-name "Ahnaf Rafi")
(setq user-mail-address "ahnaf.al.rafi@gmail.com")

;; UTF-8
(when (fboundp 'set-charset-priority)
  (set-charset-priority 'unicode))
(prefer-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(setq selection-coding-system 'utf-8)

;; Disable the alarm bell
(setq ring-bell-function 'ignore)

;; Don't add duplicates to clipboard/kill-ring.
(setq kill-do-not-save-duplicates t)

;; Disable backups and lockfiles.
(setq make-backup-files nil)
(setq create-lockfiles nil)

;; Enable auto-saves.
(setq auto-save-default t)
(setq auto-save-file-name-transforms
      `((,"\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'"
         ;; Prefix tramp auto-saves to prevent conflicts.
         ,(concat auto-save-list-file-prefix "tramp-\\2") t)
        (".*" ,auto-save-list-file-prefix t)))

;; Set file for custom.el to use --- I use this for temporary customizations.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;; Load the custom file.
(load custom-file 'noerror 'nomessage)

(require 'ar-packages)
(require 'ar-visuals)
(require 'ar-leader)

(ar/leader-override-mode 1)
(require 'ar-keybind)
(require 'ar-ui)
(require 'ar-editor)
(require 'ar-completion)
(require 'ar-bufwinframes)
(require 'ar-files)
(require 'ar-help)
(require 'ar-projects-vc)
(require 'ar-search)
(require 'ar-coding-tools)
(require 'ar-tools)
(require 'ar-julia)
(require 'ar-nix)
(require 'ar-lua)
(require 'ar-latex)
(require 'ar-bibtex)
(require 'ar-org)

(provide 'init)
;;; init.el ends here
