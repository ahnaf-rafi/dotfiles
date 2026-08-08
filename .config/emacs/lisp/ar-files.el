;;; ar-files.el --- -*- lexical-binding: t; -*-

;;; Code:

(setq insert-directory-program "ls"
      dired-use-ls-dired nil)
(setq dired-kill-when-opening-new-dired-buffer t)
(setq dired-listing-switches "-alh --group-directories-first  --no-group")
;; Force ASCII collation so that '.' sorts before alphanumeric characters.
(setenv "LC_COLLATE" "C")

(add-hook 'dired-mode-hook #'display-line-numbers-mode)
(add-hook 'dired-mode-hook #'display-fill-column-indicator-mode)
(put 'dired-find-alternate-file 'disabled nil)

;; TODO: Refactor please.
(use-package dirvish
  :custom
  (dirvish-quick-access-entries ; It's a custom option, `setq' won't work
   '(("h" "~/"                          "Home")
     ("d" "~/Downloads/"                "Downloads")
     ("m" "/mnt/"                       "Drives")
     ("s" "/ssh:my-remote-server")      "SSH server"
     ("e" "/sudo:root@localhost:/etc")  "Modify program settings"
     ("t" "~/.local/share/Trash/files/" "TrashCan")))
  :init
  (dirvish-override-dired-mode)
  :config
  ;; (dirvish-peek-mode)             ; Preview files in minibuffer
  ;; (dirvish-side-follow-mode)      ; similar to `treemacs-follow-mode'
  (setq dirvish-mode-line-format
        '(:left (sort symlink) :right (omit yank index)))
  (setq dirvish-attributes           ; The order *MATTERS* for some attributes
        '(vc-state subtree-state nerd-icons collapse file-time file-size)
        dirvish-side-attributes
        '(vc-state nerd-icons collapse file-size))
  ;; open large directory (over 20000 files) asynchronously with `fd' command
  (setq dirvish-large-directory-threshold 20000)
  (with-eval-after-load 'evil
    (evil-define-key '(normal visual motion) dired-mode-map
      (kbd "h") #'dired-up-directory
      (kbd "l") #'dired-find-file))
  ;; :bind ; Bind `dirvish-fd|dirvish-side|dirvish-dwim' as you see fit
  ;; (("C-c f" . dirvish)
  ;;  :map dirvish-mode-map               ; Dirvish inherits `dired-mode-map'
  ;;  (";"   . dired-up-directory)        ; So you can adjust `dired' bindings here
  ;;  ("?"   . dirvish-dispatch)          ; [?] a helpful cheatsheet
  ;;  ("a"   . dirvish-setup-menu)        ; [a]ttributes settings:`t' toggles mtime, `f' toggles fullframe, etc.
  ;;  ("f"   . dirvish-file-info-menu)    ; [f]ile info
  ;;  ("o"   . dirvish-quick-access)      ; [o]pen `dirvish-quick-access-entries'
  ;;  ("s"   . dirvish-quicksort)         ; [s]ort flie list
  ;;  ("r"   . dirvish-history-jump)      ; [r]ecent visited
  ;;  ;; ("l"   . dirvish-ls-switches-menu)  ; [l]s command flags
  ;;  ("l"   . dired-find-file)  ; [l]s command flags
  ;;  ("v"   . dirvish-vc-menu)           ; [v]ersion control commands
  ;;  ("*"   . dirvish-mark-menu)
  ;;  ("y"   . dirvish-yank-menu)
  ;;  ("N"   . dirvish-narrow)
  ;;  ("^"   . dirvish-history-last)
  ;;  ("TAB" . dirvish-subtree-toggle)
  ;;  ("M-f" . dirvish-history-go-forward)
  ;;  ("M-b" . dirvish-history-go-backward)
  ;;  ("M-e" . dirvish-emerge-menu))
  )

(require 'recentf)
(setq recentf-max-saved-items 500)
(setq recentf-max-menu-items 15)
(setq recentf-exclude
      '("^/\\(?:ssh\\|su\\|sudo\\)?:" ;; Remote files.
        "COMMIT_EDITMSG\\'"           ;; Git commits.
        "~\\'"                        ;; Backup files.
        "/elpaca/.*"                  ;; Installed packages.
        "/eln-cache/.*"               ;; Installed packages.
        "/elpa/.*"                    ;; Installed packages.
        "/itsalltext/.*"))            ;; Browser temp files.

;; Auto-cleanup for `recentf'.
(setq recentf-auto-cleanup 300)

;; Silence the cleanup and saving activities of `recentf'.
(dolist (func '(recentf-cleanup recentf-save-list))
  (advice-add func :around
              (lambda (orig-fun &rest args)
                (let ((inhibit-message t))
                  (apply orig-fun args)))))

(recentf-mode 1)

;; Save the recentf list whenever Emacs loses focus.
(add-hook 'focus-out-hook #'recentf-save-list)

;; Open certain files in external processes.
(defvar ar/external-open-filetypes '("\\.xlsx?\\'" "\\.docx?\\'")) ;; "\\.csv\\'"

(defvar ar/external-open-command
  (cond
   ((eq system-type 'darwin) "open")
   ((eq system-type 'gnu/linux) "xdg-open")))

(defun ar/external-open (filename)
  "Open FILENAME in external application using `ar/external-open-command'."
  (interactive "fFilename: ")
  (let ((process-connection-type nil))
    (call-process
     ar/external-open-command nil 0 nil (expand-file-name filename))))

(defun ar/find-file-auto (orig-fun &rest args)
  "Advice for `find-file': open in external application using `ar/external-open'
if file has extension in `ar/external-open-filetypes'.
then open in . Otherwise, go with
default behavior."
  (let ((filename (car args)))
    (if (cl-find-if
         (lambda (regexp) (string-match regexp filename))
         ar/external-open-filetypes)
        (ar/external-open filename)
      (apply orig-fun args))))

;; Add advice.
(advice-add 'find-file :around #'ar/find-file-auto)

(ar/leader
  ("."     #'find-file)
  ("f"     nil "files")
  ("f f"   #'find-file)
  ("f n"   #'rename-file)
  ("f s"   #'save-buffer)
  ("f d"   #'dired)
  ("f j"   #'dired-jump)
  ("f i"   #'ar/insert-file-name)
  ("f r"   #'recentf-open-files)
  ("f R"   #'ar/recentf-cleanup-silent)
  ("f p"   #'ar/find-file-in-config)
  ("f y y" #'ar/yank-buffer-file-path)
  ("f y d" #'ar/yank-buffer-dir-path)
  ("f y n" #'ar/yank-buffer-file-name))

(with-eval-after-load 'evil
  (with-eval-after-load 'wdired
    (evil-define-key nil wdired-mode-map
      [remap save-buffer] #'wdired-finish-edit)))

(provide 'ar-files)
;;; ar-files.el ends here
