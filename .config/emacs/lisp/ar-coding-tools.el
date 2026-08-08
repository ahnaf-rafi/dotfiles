;;; ar-coding-tools.el --- -*- lexical-binding: t; -*-

;;; Code:

(ar/leader
  ("c"   nil "code")
  ("c i" #'imenu))

(use-package flymake
  :ensure nil ;; Built-in.
  :init
  (ar/leader
    ("c e"  nil "errors")
    ("c e l" #'flymake-show-buffer-diagnostics "list buffer errors")
    ("c e n" #'flymake-goto-next-error          "next error")
    ("c e p" #'flymake-goto-prev-error          "prev error"))
  :config
  (with-eval-after-load 'evil
    (evil-define-key '(normal visual motion) flymake-mode-map
      (kbd "] d") #'flymake-goto-next-error
      (kbd "[ d") #'flymake-goto-prev-error
      (kbd "g ?") #'flymake-show-diagnostic)))

(use-package eglot
  :ensure nil ;; Built-in.
  :init
  (setq eglot-connect-timeout 300)
  :config
  (add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1)))

  (ar/leader ("c r" #'eglot-rename "rename symbol"))

  (with-eval-after-load 'evil
    (evil-define-key '(normal visual motion) eglot-mode-map
      (kbd "g R") #'eglot-rename)))

(use-package consult-eglot
  :init
  (ar/leader ("c s" #'consult-eglot "search symbols")))

(use-package treesit-auto
  :demand t
  :config
  (setq treesit-auto-install 'prompt)

  ;; Add custom source for typst.
  (add-to-list 'treesit-language-source-alist
               '(typst "https://github.com/uben0/tree-sitter-typst"))
  (add-to-list 'treesit-language-source-alist
               '(yaml "https://github.com/tree-sitter-grammars/tree-sitter-yaml"))
  ;; Tell treesit-auto to recognize these as a known languages.
  (push 'typst treesit-auto-langs)
  (push 'yaml treesit-auto-langs)
  (global-treesit-auto-mode))

(use-package eldoc
  :ensure nil
  :init
  (setq max-mini-window-height 1)
  (setq eldoc-echo-area-use-multiline-p nil))

(provide 'ar-coding-tools)
;;; ar-coding-tools.el ends here
