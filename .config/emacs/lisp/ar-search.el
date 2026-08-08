;;; ar-search.el --- -*- lexical-binding: t; -*-

;;; Code:

(use-package evil-snipe
  :demand t
  :init
  (setq evil-snipe-smart-case t)
  (setq evil-snipe-scope 'line)
  (setq evil-snipe-repeat-scope 'visible)
  (setq evil-snipe-char-fold t)

  (evil-snipe-mode 1)
	(evil-snipe-override-mode 1))

(use-package evil-traces
  :demand t
  :init
  (evil-traces-mode)
  (evil-traces-use-diff-faces))

(use-package anzu
  :init
  (global-anzu-mode 1)
  :bind (([remap query-replace]        . #'anzu-query-replace)
         ([remap query-replace-regexp] . #'anzu-query-replace-regexp)))

(use-package evil-anzu
  :init
  (with-eval-after-load 'evil
    (require 'evil-anzu)))

(ar/leader
  ("s"   nil "search")
  ("s c" #'evil-ex-nohighlight)
  ("s p" #'consult-ripgrep)
  ("s l" #'consult-line)
  ("s L" #'ar/goto-long-line))

(provide 'ar-search)
;;; ar-search.el ends here
