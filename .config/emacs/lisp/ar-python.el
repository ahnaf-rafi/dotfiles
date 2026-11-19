;;; ar-python.el --- -*- lexical-binding: t; -*-

;;; Code:

(use-package py-vterm-interaction
  :ensure t
  :hook (python-base-mode . ar/python-vterm-setup)
  :init
  (defun ar/python-vterm-setup ()
    (when-let* ((root (locate-dominating-file default-directory "pyproject.toml"))
                (project-dir (directory-file-name (expand-file-name root))))
      (setq-local py-vterm-interaction-repl-program
                  (format "uv run --directory %s python"
                          (shell-quote-argument project-dir))
                  py-vterm-interaction-session project-dir)
      (py-vterm-interaction-mode 1))))

(provide 'ar-python)
;;; ar-python.el ends here
