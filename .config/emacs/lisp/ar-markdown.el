;;; ar-markdown.el --- -*- lexical-binding: t; -*-

;;; Code:

(use-package markdown-ts-mode
  :ensure nil
  :mode ("\\.md\\'" "\\.mdx\\'" "\\.markdown\\'")
  :config
  (require 'markdown-ts-mode-x))

(provide 'ar-markdown)
;;; ar-markdown.el ends here
