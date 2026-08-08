;;; ar-keybind-funcs.el --- -*- lexical-binding: t; -*-

;;; Code:

;; Visual indent/dedent
;;;###autoload
(defun ar/evil-visual-dedent ()
  "Equivalent to vnoremap < <gv."
  (interactive)
  (evil-shift-left (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))

;;;###autoload
(defun ar/evil-visual-indent ()
  "Equivalent to vnoremap > >gv."
  (interactive)
  (evil-shift-right (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))

;;;###autoload
(defun ar/next-beginning-of-method (count)
  "Jump to the beginning of the COUNT-th method/function after point."
  (interactive "p")
  (beginning-of-defun (- count)))

;;;###autoload
(defun ar/previous-beginning-of-method (count)
  "Jump to the beginning of the COUNT-th method/function before point."
  (interactive "p")
  (beginning-of-defun count))

;;;###autoload
(defalias #'ar/next-end-of-method #'end-of-defun
  "Jump to the end of the COUNT-th method/function after point.")

;;;###autoload
(defun ar/previous-end-of-method (count)
  "Jump to the end of the COUNT-th method/function before point."
  (interactive "p")
  (end-of-defun (- count)))

(provide 'ar-keybind-funcs)
;;; ar-keybind-funcs.el ends here
