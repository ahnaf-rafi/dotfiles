;;; ar-bufwinframes-funcs.el --- -*- lexical-binding: t; -*-

;;; Code:

;;;###autoload
(defun ar/revert-buffer-no-confirm ()
  "Revert the current buffer from its visited file without confirmation.
Ignores auto-save files and preserves the current major and minor modes."
  (interactive)
  (revert-buffer t t t))

;;;###autoload
(defun ar/delete-frame-or-kill-emacs ()
  "Delete current frame if it is non-unique in session. Otherwise, kill Emacs."
  (interactive)
  (if (cdr (frame-list))
      (delete-frame)
    (save-buffers-kill-emacs)))

;;;###autoload
(defun ar/toggle-frame-fullscreen ()
  "Toggle between maximized and fullboth (fullscreen) states."
  (interactive)
  (let ((current-state (frame-parameter nil 'fullscreen)))
    (set-frame-parameter
     nil 'fullscreen
     (if (eq current-state 'fullboth)
         'maximized
       'fullboth))))

(provide 'ar-bufwinframes-funcs)
;;; ar-bufwinframes-funcs.el ends here
