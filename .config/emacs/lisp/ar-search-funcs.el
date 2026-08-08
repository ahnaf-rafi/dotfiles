;;; ar-search-funcs.el --- -*- lexical-binding: t; -*-

;;; Code:

;;;###autoload
(defun ar/goto-long-line (len &optional msgp)
  "Go to the first line that is greater than LEN characters long.
Use a prefix arg to provide LEN.
Plain `C-u' (no number) uses `fill-column' as LEN."
  (interactive "P\np")
  (setq len (if (consp len) fill-column (prefix-numeric-value len)))
  (let ((start-line                 (line-number-at-pos))
        (len-found                  0)
        (found                      nil)
        (inhibit-field-text-motion  t))
    (while (and (not found)  (not (eobp)))
      (forward-line 1)
      (setq found  (< len (setq len-found  (- (line-end-position) (point))))))
    (if found
        (when msgp (message "Line %d: %d chars" (line-number-at-pos) len-found))
      (goto-line start-line)
      (message "Not found"))))

(provide 'ar-search-funcs)
;;; ar-search-funcs.el ends here
