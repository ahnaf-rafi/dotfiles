;;; ar-latex.el --- -*- lexical-binding: t; -*-

;;; Code:

;; Built-in tex-mode fallback: disable script fontification.
;; AUCTeX sets font-latex-fontify-script separately.
(setq tex-fontify-script nil)

(use-package reftex
  :ensure nil
  :init
  (setq reftex-cite-format
        '((?a . "\\autocite[]{%l}")
          (?b . "\\blockcquote[]{%l}{}")
          (?c . "\\cite[]{%l}")
          (?f . "\\footcite[]{%l}")
          (?n . "\\nocite{%l}")
          (?p . "\\parencite[]{%l}")
          (?s . "\\smartcite[]{%l}")
          (?t . "\\textcite[]{%l}")))
  (setq reftex-toc-split-windows-fraction 0.3)
  ;; Required when reftex-cite-format is set manually; see
  ;; https://superuser.com/a/1386206
  (setq LaTeX-reftex-cite-format-auto-activate nil)
  (setq reftex-plug-into-AUCTeX t)
  (add-hook 'reftex-mode-hook #'evil-normalize-keymaps))

(provide 'ar-latex)
;;; ar-latex.el ends here
