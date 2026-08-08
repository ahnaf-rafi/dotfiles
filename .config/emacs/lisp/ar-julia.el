;;; ar-julia.el --- -*- lexical-binding: t; -*-

;;; Code:

(defun ar/julia-mode-h ()
  (adaptive-wrap-prefix-mode)
  (setq-local adaptive-wrap-extra-indent 2)
  (setq-local evil-shift-width julia-indent-offset)
  (julia-repl-mode)
  (eglot-ensure))

(use-package julia-mode
  :hook (julia-mode . ar/julia-mode-h)
  :config
  (define-key julia-mode-map (kbd "TAB") 'julia-latexsub-or-indent)
  (ar/localleader julia-mode-map
    ("r" #'julia-repl)
    ("a" #'julia-repl-send-region-or-line)
    ("l" #'julia-repl-send-line)))

(use-package julia-ts-mode
  :mode "\\.jl$")

(use-package julia-repl
  :init
  (setq julia-repl-switches "--threads=auto --project=@.")
  :config
  (julia-repl-set-terminal-backend 'vterm))

(use-package eglot-jl
  :init
  (setq eglot-connect-timeout 600)
  ;; (setq eglot-jl-language-server-project "~/.julia/environments/eglot/")
  (eglot-jl-init))

(provide 'ar-julia)
;;; ar-julia.el ends here
