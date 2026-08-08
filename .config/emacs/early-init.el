;;; early-init.el --- -*- no-byte-compile: t; lexical-binding: t; -*-

;;; Code:

;; Disable unnecessary UI elements.
(when (featurep 'menu-bar)
  (push '(menu-bar-lines . 0) default-frame-alist)
  (setq menu-bar-mode nil))

(when (featurep 'tool-bar)
  (push '(tool-bar-lines . 0) default-frame-alist)
  (setq tool-bar-mode nil))

(when (featurep 'scroll-bar)
  (push '(horizontal-scroll-bars) default-frame-alist)
  (push '(vertical-scroll-bars) default-frame-alist)
  (setq scroll-bar-mode nil))

;; Start frames maximized.
(push '(fullscreen . maximized) default-frame-alist)

;; Frame title: tell me if I am in daemon mode.
(setq frame-title-format (if (daemonp)
			     '("AR Emacs Daemon - %b")
			   '("AR Emacs - %b")))

;; Inhibit frame resize - also has some performance benefit.
(setq frame-resize-pixelwise t)
(setq frame-inhibit-implied-resize t)

;; Don't use X resources, Windows Registry settings, and NS defaults.
(setq inhibit-x-resources t)

;; Get rid of startup/splash screen.
(setq inhibit-startup-screen t)
(setq inhibit-startup-buffer-menu t)
(setq inhibit-startup-echo-area-message user-login-name) ;; Read the docstring.
(advice-add #'display-startup-echo-area-message :override #'ignore)

;; Empty scratch message.
(setq initial-scratch-message nil)

;; Use y/n responses to yes/no prompts.
(setq use-short-answers t)
(fset 'yes-or-no-p 'y-or-n-p)

;; Store reasonable values for `gc-cons-threshold', `gc-cons-percentage',
;; `file-name-handler-alist' and `vc-handled-backends'.
(defvar ar/gc-cons-threshold (* 50 1024 1024)
  "Post-startup value for `gc-cons-threshold'.")

(defvar ar/gc-cons-percentage gc-cons-percentage
  "Post-startup value for `gc-cons-percentage'.")

(defvar ar/file-name-handler-alist file-name-handler-alist
  "Post-startup value for `file-name-handler-alist'.")

(defvar ar/vc-handled-backends vc-handled-backends
  "Post-startup value for `vc-handled-backends'.")

;; Set startup-speed-optimizing values for these variables.  NOTE: The
;; `most-positive-fixnum' is DANGEROUS AS A PERMANENT VALUE for
;; `gc-cons-threshold'.  Similarly, `file-name-handler-alist' needs to be set
;; properly for Emacs to work properly.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5
      file-name-handler-alist nil
      vc-handled-backends nil)

;; Set reasonable values for `gc-cons-threshold', `gc-cons-percentage',
;; `file-name-handler-alist' and `vc-handled-backends' after Emacs startup.
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold ar/gc-cons-threshold
                  gc-cons-percentage ar/gc-cons-percentage
                  file-name-handler-alist ar/file-name-handler-alist
                  vc-handled-backends ar/vc-handled-backends)))

;; Make native compilation silent.
(when (native-comp-available-p)
  (setq native-comp-async-report-warnings-errors 'silent))

(setq package-enable-at-startup nil)

(defconst ar/emacs-lisp-dir (expand-file-name "lisp" user-emacs-directory)
  "Directory to hold personal elisp modules and libraries.")

;; Add lisp directory to `load-path'.
(add-to-list 'load-path ar/emacs-lisp-dir)

(defconst ar/emacs-lisp-autoloads
  (expand-file-name "ar-autoloads.el" ar/emacs-lisp-dir)
  "Personal autoloads file.")

(defun ar/generate-autoloads-for-config-and-load ()
  "Generate autoloads from lisp files in `ar/emacs-lisp-dir' and put them in
  `ar/emacs-lisp-autoloads'."
  (interactive)
  (if (file-exists-p ar/emacs-lisp-autoloads)
      (progn
        (delete-file ar/emacs-lisp-autoloads)
        (message "Deleted existing autoload file: %s" ar/emacs-lisp-autoloads)))
  (loaddefs-generate ar/emacs-lisp-dir ar/emacs-lisp-autoloads)
  (message "Generated autoloads in %s" ar/emacs-lisp-autoloads)
  (load ar/emacs-lisp-autoloads)
  (message "Loaded autoloads in %s" ar/emacs-lisp-autoloads))

(if (file-exists-p ar/emacs-lisp-autoloads)
    (load ar/emacs-lisp-autoloads)
  (warn (concat "Autoloads file" ar/emacs-lisp-autoloads " not found."
                " Some keybindings/commands may not be well-defined."
                " Use ar/generate-autoloads-for-config-load to generate "
                ar/emacs-lisp-autoloads " and load it.")))

(defun ar/emacs-init-time ()
  "Return Emacs starting time in string including seconds ending."
  (if (fboundp 'elpaca--queued)
      (format "%s seconds"
              (float-time (time-subtract elpaca-after-init-time
                                         before-init-time)))
    (emacs-init-time)))

(defun ar/packages-count ()
  "Get the intalled package count depending on package manager.
Supported package managers are: package.el, straight.el and elpaca.el."
  (let* ((package-count (if (bound-and-true-p package-alist)
                            (length package-activated-list)
                          0))
         (straight-count (if (boundp 'straight--profile-cache)
                             (hash-table-count straight--profile-cache)
                           0))
         (elpaca-count (if (fboundp 'elpaca--queued)
                           (length (elpaca--queued))
                         0)))
    (+ package-count straight-count elpaca-count)))

(defun ar/init--info ()
  "Format init message.
Use `ar/emacs-init-time', `ar/package-count' and `gcs-done' to generate
init message."
  (let* ((msg-init (format "Emacs started in %s with %d garbage collections."
                           (ar/emacs-init-time) gcs-done))
         (packages-count (ar/packages-count))
         (msg (if (zerop packages-count)
                  msg-init
                (concat msg-init
                        (format " %d packages installed." packages-count)))))
    (message msg)))

(add-hook 'after-init-hook #'ar/init--info)

(provide 'early-init)
;;; early-init.el ends here
