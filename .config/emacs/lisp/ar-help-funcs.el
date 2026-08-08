;;; ar-help-funcs.el --- -*- lexical-binding: t; -*-

;;; Code:

;;;###autoload
(defun ar/help-mode-h ()
  (setq-local show-trailing-whitespace nil)
  ;; (visual-line-mode)
  (display-line-numbers-mode))

(provide 'ar-help-funcs)
;;; ar-help-funcs.el ends here
