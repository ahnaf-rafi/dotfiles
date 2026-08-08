;;; ar-bufwinframes.el --- -*- lexical-binding: t; -*-

;;; Code:

(use-package ibuffer
  :ensure nil
  :hook (ibuffer-mode . (lambda () (visual-line-mode -1))))

(use-package nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(ar/leader
 ("b"   nil "buffer")
 ("b b" #'switch-to-buffer)
 ("b i" #'ibuffer)
 ("b r" #'ar/revert-buffer-no-confirm)
 ("b d" #'kill-current-buffer)
 ("b k" #'kill-buffer)
 ("b p" #'previous-buffer)
 ("b n" #'next-buffer)
 ("b [" #'previous-buffer)
 ("b ]" #'next-buffer))

;; Favor vertical splits over horizontal ones. Screens are usually wide.
;; (setq split-width-threshold 160)
;; (setq split-height-threshold nil)

(with-eval-after-load 'evil-maps
  (ar/leader ("w" evil-window-map))
  (let ((bindings '(("C-h" . evil-window-left)
                    ("C-j" . evil-window-down)
                    ("C-k" . evil-window-up)
                    ("C-l" . evil-window-right)
                    ("C-q" . evil-quit)
                    ("d"   . evil-quit)
                    ("x"   . kill-buffer-and-window)
                    ("f"   . ffap-other-window)
                    ("C-f" . ffap-other-window))))
    (dolist (b bindings)
      (define-key evil-window-map (kbd (car b)) (cdr b)))))

(ar/leader
  ("F"   nil "frame")
  ("F F" #'ar/toggle-frame-fullscreen)
  ("F o" #'make-frame)
  ("F q" #'ar/delete-frame-or-kill-emacs))

(provide 'ar-bufwinframes)
;;; ar-bufwinframes.el ends here
