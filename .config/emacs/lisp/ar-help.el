;;; ar-help.el --- -*- lexical-binding: t; -*-

;;; Code:

(ar/leader ("h" help-map "Help"))

;; helpful
(use-package helpful
  :hook ((helpful-mode . display-line-numbers-mode))
  :bind (([remap describe-key]      . helpful-key)
         ([remap describe-command]  . helpful-command)
         ([remap describe-function] . helpful-callable)
         ([remap describe-variable] . helpful-variable)
         ([remap describe-symbol]   . helpful-symbol)))

(use-package elisp-demos
  :init
  (advice-add 'describe-function-1
              :after #'elisp-demos-advice-describe-function-1)
  (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update))

(dolist (hook '(Info-mode-hook help-mode-hook))
  (add-hook hook #'ar/help-mode-h))

(provide 'ar-help)
;;; ar-help.el ends here
