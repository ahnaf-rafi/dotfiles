;;; ar-org-funcs.el --- -*- lexical-binding: t; -*-

;;; Code:

;;;###autoload
(defun ar/find-file-in-org-directory ()
  (interactive)
  (let ((default-directory org-directory))
    (call-interactively #'find-file)))

;;;###autoload
(defun ar/jump-to-todo-file ()
  (interactive)
  (find-file (expand-file-name "todo.org" org-directory)))

;;;###autoload
(defun ar/jump-to-bookmarks-file ()
  (interactive)
  (find-file (expand-file-name "bookmarks.org" org-directory)))

;;;###autoload
(defun ar/jump-to-readinglist-file ()
  (interactive)
  (find-file (expand-file-name "readinglist.org" org-directory)))

(provide 'ar-org-funcs)
;;; ar-org-funcs.el ends here
