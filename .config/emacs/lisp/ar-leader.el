;;; ar-leader.el --- Leader keybindings -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Ahnaf Rafi

;; Author: Ahnaf Rafi <ahnaf.al.rafi@gmail.com>
;; Maintainer: Ahnaf Rafi <ahnaf.al.rafi@gmail.com>
;; Created: 2026-02-20
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1"))
;; Keywords: convenience, keybindings, leader, evil
;; URL: https://github.com/ahnaf-rafi/dotfiles
;;
;; SPDX-License-Identifier: MIT

;; This file is not part of GNU Emacs.

;;; Commentary:

;;; Code:

(defgroup ar nil
  "Ahnaf Rafi's personal Emacs configuration."
  :group 'convenience)

(defun ar--string-to-list-coerce (val)
  "Return VAL as a list of strings, whether it is a string or list of strings."
  (if (stringp val) (list val) val))

(defvar ar/leader-override-mode-map (make-sparse-keymap)
  "Keymap for `ar/leader-override-mode', inserted via `emulation-mode-map-alists'.")

(defun ar/leader-override-mode--setup-buffer ()
  "Install `ar/leader-override-mode-map' in this buffer's emulation alist."
  ;; Set up buffer-local precedence
  (setq-local ar/maps-alist
              `((ar/leader-override-mode . ,ar/leader-override-mode-map)))
  (put 'ar/maps-alist 'permanent-local t))

;;;; High-precedence leader override mode (emulation-mode-map-alists).
(define-minor-mode ar/leader-override-mode
  "Global leader override mode using `emulation-mode-map-alists'.

When enabled, `ar/leader-override-mode-map' is inserted into Emacs’s key lookup
precedence via `emulation-mode-map-alists' which has high-precedence."
  :lighter ""
  :global t
  (if ar/leader-override-mode
      (progn
        (add-hook 'after-change-major-mode-hook
                  #'ar/leader-override-mode--setup-buffer)
        (add-to-list 'emulation-mode-map-alists 'ar/maps-alist)
        (dolist (prefix-key (ar--string-to-list-coerce ar/leader-prefix-emacs))
          (define-key ar/leader-override-mode-map
                      (kbd prefix-key)
                      (cons "<leader>" ar/leader-map)))
        (with-eval-after-load 'evil
          (dolist (prefix-key (ar--string-to-list-coerce ar/leader-prefix-evil))
            (evil-define-key '(normal visual motion) ar/leader-override-mode-map
              (kbd prefix-key) ar/leader-map)))
        ;; Cover the current buffer immediately.
        (ar/leader-override-mode--setup-buffer))
    (progn

      ;; (dolist (prefix-key ar/leader-prefix-evil)
      ;;   (define-key mode-specific-map
      ;;               (kbd prefix-key) nil))
      (remove-hook 'after-change-major-mode-hook
                   #'ar/leader-override-mode--setup-buffer)
      ;; Cleanup when toggled off
      (setq emulation-mode-map-alists (delq 'ar/maps-alist
                                            emulation-mode-map-alists)))))

;;;; Leader map
(defvar ar/leader-map (make-sparse-keymap)
  "Keymap for leader bindings.")

(defun ar--single-step-from-binding (map entry &optional key-transformer)
  "Return a single `define-key' or `which-key' form for ENTRY against MAP.
KEY-TRANSFORMER, if non-nil, is a function applied to the key string before
expansion. E.g. (lambda (k) (concat \"C-c l \" k)) prefixes every key."
  (let ((key-transform (or key-transformer #'identity)))
    (pcase entry
      ;; (KEY nil DESC) -- Prefix label only, no binding.
      ;; Registers a display name for a prefix key in which-key without
      ;; binding anything. E.g. ("f" nil "file") makes SPC f show
      ;; "file" in the which-key popup.
      (`(,(and key (pred stringp)) nil ,(and desc (pred stringp)))
       (let ((key (funcall key-transform key)))
         `(with-eval-after-load 'which-key
            (which-key-add-keymap-based-replacements ,map ,key ,desc))))
      ;; (KEY CMD DESC) -- Binding with a label.
      ;; Binds KEY to a cons of (DESC . CMD), which Emacs treats as a
      ;; menu item: CMD is what runs, DESC is what which-key and
      ;; describe-key show. E.g. ("b" #'switch-to-buffer "Switch buffer").
      (`(,(and key (pred stringp)) ,cmd ,(and desc (pred stringp)))
       (let ((key (funcall key-transform key)))
         `(define-key ,map ,(kbd key) (cons ,desc ,cmd))))
      ;; (KEY CMD) -- Plain binding, no label.
      ;; Binds KEY directly to CMD with no description attached.
      ;; E.g. (";" #'execute-extended-command).
      (`(,(and key (pred stringp)) ,cmd)
       (let ((key (funcall key-transform key)))
         `(define-key ,map ,(kbd key) ,cmd)))
      ;; Anything else is a malformed entry -- error at expansion time.
      (_ (error "ar--single-step-from-binding: malformed entry %S" entry)))))

(defun ar--steps-from-bindings (map bindings &optional key-transformer)
  "Expand BINDINGS into flat `define-key' or
`which-key-add-keymap-based-replacements' forms against MAP (a symbol).
BINDINGS is a literal list of entries. Each entry is one of:
  (KEY CMD)       -> (define-key MAP (kbd KEY) CMD)
  (KEY CMD DESC)  -> (define-key MAP (kbd KEY) (cons DESC CMD))
  (KEY nil DESC)  -> (with-eval-after-load 'which-key
                       (which-key-add-keymap-based-replacements MAP KEY DESC))
KEY must be a string literal. CMD is a command (quoted symbol or lambda).
DESC is a string label, used either for which-key or as a menu-item name.
KEY-TRANSFORMER, if non-nil, is a function applied to each key string before
expansion. E.g. (lambda (k) (concat \"C-c l \" k)) prefixes every key."
  (mapcar (lambda (entry)
            (ar--single-step-from-binding map entry key-transformer))
          bindings))

(defcustom ar/leader-prefix-emacs '("C-c l")
  "Emacs-style prefix keys bound to the leader map."
  :type '(choice string (repeat string))
  :group 'ar)

(defcustom ar/leader-prefix-evil '("SPC")
  "Evil-style prefix keys bound to the leader map."
  :type '(choice string (repeat string))
  :group 'ar)

(defmacro ar/leader (&rest bindings)
  "Define bindings in `ar/leader-map'.

Each binding is one of:
  (KEY CMD)       -> (define-key ar/leader-map (kbd KEY) CMD)
  (KEY CMD DESC)  -> (define-key ar/leader-map (kbd KEY) (cons DESC CMD))
  (KEY nil DESC)  -> which-key label for KEY in ar/leader-map"
  (declare (indent 0))
  (let ((steps (ar--steps-from-bindings 'ar/leader-map bindings)))
    `(progn ,@steps)))

;; <leader> key definitions, keymap and trigger bindings
;; (defconst ar/leader-key                "SPC")
;; (defconst ar/leader-key-C-c            "l")

;; Create keybinds in ar/leader-override-mode-map and in mode-specific-map.
;; (dolist (prefix-key ar/leader-prefix-emacs) a)

;; (define-key mode-specific-map
;;             (kbd ar/leader-prefix-emacs-C-c) (cons "<leader>" ar/leader-map))
;; (with-eval-after-load 'evil
;;   (evil-define-key '(normal visual motion) 'ar/leader-override-mode-map
;;     (kbd ar/leader-key) ar/leader-map)
;;   (evil-define-key '(insert emacs) 'ar/leader-override-mode-map
;;     (kbd ar/leader-key-alt) ar/leader-map))

(defcustom ar/localleader-prefix-emacs '("C-c m" "M-.")
  "Emacs-style prefix keys bound to the local leader map."
  :type '(choice string (repeat string))
  :group 'ar)

(defcustom ar/localleader-prefix-evil '("SPC m" ".")
  "Evil-style prefix keys bound to the local leader map."
  :type '(choice string (repeat string))
  :group 'ar)

(defun ar--localleader-prefix-command-sym (map)
  "Derive the local leader prefix command symbol for MAP.
E.g. Gives ar/localleader-julia-mode-map when input is julia-mode-map."
  (intern (concat "ar/localleader-" (symbol-name map))))

(defun ar/prefix-command-p (sym)
  "Return non-nil if SYM is a prefix command."
  (and (symbolp sym)
       (fboundp sym)
       (keymapp (symbol-function sym))))

(defun ar--localleader-ensure-prefix-command (map)
  "Create the prefix command for MAP if it doesn't exist yet. Return its symbol."
  (let ((prefix-cmd (ar--localleader-prefix-command-sym map)))
    (unless (ar/prefix-command-p prefix-cmd)
      (define-prefix-command prefix-cmd))
    prefix-cmd))

(defmacro ar/localleader (map &rest bindings)
  (declare (indent 1))
  (let* ((prefix-cmd (ar--localleader-ensure-prefix-command map))
         (steps (ar--steps-from-bindings prefix-cmd bindings)))
    `(progn
       ;; Emacs-style: bind prefix keys in the mode map once it's available.
       (when (boundp ',map)
         (dolist (keypref (ar--string-to-list-coerce ar/localleader-prefix-emacs))
           (define-key ,map (kbd keypref) ',prefix-cmd)))
       ;; Evil-style: deferred until evil is loaded.
       (with-eval-after-load 'evil
         (dolist (keypref (ar--string-to-list-coerce ar/localleader-prefix-evil))
           (evil-define-key* '(normal visual motion) ,map
             (kbd keypref) ',prefix-cmd)))
       ;; Individual key bindings into the prefix command's keymap.
       ,@steps)))

(provide 'ar-leader)
;;; ar-leader.el ends here
