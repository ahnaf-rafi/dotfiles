;;; ar-files-funcs.el --- -*- lexical-binding: t; -*-

;;; Code:

;; Insert file names from minibuffer
;;;###autoload
(defun ar/insert-file-name (filename &optional args)
  "Insert name of file FILENAME into buffer after point.
Prefixed with \\[universal-argument], expand the file name to its fully
canocalized path.  See `expand-file-name'.

Prefixed with \\[negative-argument], use relative path to file name from current
directory, `default-directory'.  See `file-relative-name'.

The default with no prefix is to insert the file name exactly as it appears in
the minibuffer prompt."
  ;; Based on insert-file in Emacs -- ashawley 20080926
  (interactive "*fInsert file name: \nP")
  (cond ((eq '- args)
         (insert (file-relative-name filename)))
        ((not (null args))
         (insert (expand-file-name filename)))
        (t
         (insert filename))))

;; Find file in config
;;;###autoload
(defun ar/find-file-in-config ()
  "Find files in configuration directory using project.el"
  (interactive)
  (if (not (featurep 'project))
      (require 'project))
  (let* ((pr (project--find-in-directory (file-truename "~/dotfiles")))
         (dirs (list (project-root pr))))
    (project-find-file-in (thing-at-point 'filename) dirs pr)))

;; Copy file path
;;;###autoload
(defun ar/yank-buffer-file-path ()
  "Copy the current buffer's path to the kill ring."
  (interactive)
  (if-let (filename (or buffer-file-name
                        (bound-and-true-p list-buffers-directory)))
      (message (kill-new (abbreviate-file-name filename)))
    (error "Couldn't find file path in current buffer")))

;; Copy path to directory containing file
;;;###autoload
(defun ar/yank-buffer-dir-path ()
  "Copy the current buffer's directory path to the kill ring."
  (interactive)
  (if-let (dir-name (or default-directory
                        (bound-and-true-p list-buffers-directory)))
      (message (kill-new (abbreviate-file-name dir-name)))
    (error "Couldn't find directory path in current buffer")))

;; Copy file name
;; TODO: adjust for final child node of a directory path.
;;;###autoload
(defun ar/yank-buffer-file-name ()
  "Copy the current buffer's non-directory name to the kill ring."
  (interactive)
  (if-let (filename (or buffer-file-name
                        (bound-and-true-p list-buffers-directory)))
      (message (kill-new (file-name-nondirectory
                          (abbreviate-file-name filename))))
    (error "Couldn't find file name in current buffer")))

;;;###autoload
(defun ar/recentf-cleanup-silent ()
  "Run `recentf-cleanup' without any message output in echo area."
  (interactive)
  (let ((inhibit-message t)) ;; Stops message from appearing in echo area.
    (recentf-cleanup)))

(provide 'ar-files-funcs)
;;; ar-files-funcs.el ends here
