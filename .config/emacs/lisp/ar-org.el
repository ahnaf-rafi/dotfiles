;;; ar-org.el --- -*- lexical-binding: t; -*-

;;; Code:

(use-package org
  :ensure nil ;; Use built-in org-mode.
  :init
  ;; Set directory for org files.
  (setq org-directory "~/Dropbox/org/")

  ;; Prevent adding leading whitespace in code blocks on RET/TAB.
  (setq org-src-preserve-indentation t)

  ;; Use code block language major-mode binding for TAB.
  (setq org-src-tab-acts-natively t)

  ;; Enable native syntax highlighting (fontification) in code blocks.
  (setq org-src-fontify-natively t)

  (ar/leader
    ("o"   nil "org")
    ("o o" #'ar/find-file-in-org-directory)
    ("o t" #'ar/jump-to-todo-file)
    ("o b" #'ar/jump-to-bookmarks-file)
    ("o r" #'ar/jump-to-readinglist-file))

  :config
  (with-eval-after-load 'evil
    (evil-define-motion ar/evil-org-top ()
      "Find the nearest one-star heading."
      :type exclusive
      :jump t
      (while (org-up-heading-safe)))

    (evil-define-key '(normal visual motion) org-mode-map
      (kbd "[ h") #'org-backward-heading-same-level
      (kbd "] h") #'org-forward-heading-same-level
      (kbd "[ [") #'org-previous-visible-heading
      (kbd "] ]") #'org-next-visible-heading
      (kbd "[ l") #'org-previous-link
      (kbd "] l") #'org-next-link
      (kbd "[ c") #'org-babel-previous-src-block
      (kbd "] c") #'org-babel-next-src-block
      (kbd "g h") #'org-up-element
      (kbd "g l") #'org-down-element
      (kbd "g k") #'org-backward-element
      (kbd "g j") #'org-forward-element
      (kbd "g H") #'ar/evil-org-top))

  ;; Currently non-evil localleader.
  (ar/localleader org-mode-map
    ("."   #'consult-org-heading)
    ("p"   #'org-preview-latex-fragment)
    ("e"   #'org-export-dispatch)
    ("a"   #'org-latex-export-to-pdf)
    ("t"   nil "toggle")
    ("t t" #'org-toggle-checkbox)
    ("t l" #'org-toggle-link-display)
    ("t i" #'org-toggle-inline-images))

  ;; evil localleader hack
  ;; (with-eval-after-load 'evil
  ;;   (dolist (kfpair '(("."   consult-org-heading)
  ;;                     ("p"   org-preview-latex-fragment)
  ;;                     ("e"   org-export-dispatch)
  ;;                     ("a"   org-latex-export-to-pdf)
  ;;                     ("t t" org-toggle-checkbox)
  ;;                     ("t l" org-toggle-link-display)
  ;;                     ("t i" org-toggle-inline-images)
  ;;                     ("p"   org-preview-latex-fragment)))
  ;;     (let ((key  (nth 0 kfpair))
  ;;           (func (nth 1 kfpair)))
  ;;       (evil-define-key '(normal visual motion) org-mode-map
  ;;         (kbd (concat "SPC m " key)) func))))
  )

(provide 'ar-org)
;;; ar-org.el ends here
