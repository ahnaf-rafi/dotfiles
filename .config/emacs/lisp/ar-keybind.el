;;; ar-keybind.el --- -*- lexical-binding: t; -*-

;;; Code:

(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'option))

;; Better escape
(global-set-key (kbd "<escape>") #'keyboard-escape-quit)

(global-set-key (kbd "C-i") #'indent-for-tab-command)

;; Text scale and zoom
(global-set-key (kbd "C-+") #'text-scale-increase)
(global-set-key (kbd "C-_") #'text-scale-decrease)
(global-set-key (kbd "C-)") #'text-scale-adjust)

;; Universal arguments with evil
(global-set-key (kbd "C-M-u") #'universal-argument)

(use-package which-key
  :ensure nil ;; which-key is built-in.
  :init
  (setq which-key-idle-delay 0.3)
  (setq which-key-allow-evil-operators t)
  (which-key-setup-side-window-bottom)
  (which-key-mode))

(ar/leader
  (":" #'pp-eval-expression)
  (";" #'execute-extended-command "M-x")
  ("&" #'async-shell-command)
  ("u" #'universal-argument))

(use-package evil
  :demand t
  :init
  ;; Load evil-integration.el --- provides Evil integration for various
  ;; modes. Must be be set before Evil is loaded.
  (setq evil-want-integration t)

  ;; Don't load evil-keybindings.el.
  (setq evil-want-keybinding nil)

  ;; Keybinding behavior settings.
  ;; In Vim, <C-i> jumps forward in the jump list. I prefer the emacs default of
  ;; inserting a tab character.
  (setq evil-want-C-i-jump nil)
  ;; In insert, enable <C-u> deleting back to indentiation.
  (setq evil-want-C-u-delete t)
  ;; In normal, enable <C-u> scrolling up.
  (setq evil-want-C-u-scroll t)

  ;; Cursor movement.
  ;; Exclude newline with `v$'.
  (setq evil-v$-excludes-newline t)
  ;; Have movements respect `visual-line-mode' when it is on: motions such as j
  ;; and k navigate by visual lines (on the screen) rather than “physical” lines
  ;; (defined by newline characters). Must be set before Evil is loaded.
  (setq evil-respect-visual-line-mode t)
  ;; Vertical motions after $ should maintain the cursor at the end of the line,
  ;; even if the target line is longer.
  (setq evil-track-eol t)

  ;; Window management.
  ;; Split window created below.
  (setq evil-split-window-below t)
  ;; Vertical split window created to right.
  (setq evil-vsplit-window-right t)

  ;; Miscellaneous.
  ;; Look for completion matches only in current buffer.
  (setq evil-complete-all-buffers nil)
  ;; Don't signal errors on left/right motions in keyboard macros.
  (setq evil-kbd-macro-suppress-motion-error t)
  ;; No modeline tag: doom-modeline handles this.
  (setq evil-mode-line-format 'nil)

  ;; Additional.
  ;; Pass ex command region covering only the visual selection. Otherwise,
  ;; visual selection will be passed with extension to full lines.
  (setq evil-ex-visual-char-range t)
  ;; Show interactive highlighting in selected window.
  (setq evil-ex-interactive-search-highlight 'selected-window)
  ;; Search for symbols with * and #. That is, search for `my_variable_name' and
  ;; not `my' if cursor is on `my'.
  (setq evil-symbol-word-search t)

  ;; Initialize evil-mode.
  (evil-mode 1)
  ;; Make sure the *Messages* buffer starts in normal mode
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  :config
  ;; TODO: Document properly.
  (evil-define-key 'visual 'global
    (kbd "<") #'ar/evil-visual-dedent
    (kbd ">") #'ar/evil-visual-indent)

  (evil-define-key '(normal visual motion) 'global
    (kbd "] m") #'ar/next-beginning-of-method
    (kbd "[ m") #'ar/previous-beginning-of-method
    (kbd "] M") #'ar/next-end-of-method
    (kbd "[ M") #'ar/previous-end-of-method))

(use-package evil-collection
  :demand t
  :init
  ;; Preserve Emacs-state <tab> keys in org-mode.
  (setq evil-collection-outline-bind-tab-p nil)
  ;; Disable unimpaired.vim (https://github.com/tpope/vim-unimpaired) style
  ;; bindings.
  (setq evil-collection-want-unimpaired-p nil)
  ;; Use evil in minibuffer
  (setq evil-collection-setup-minibuffer t)

  :config
  ;; I like to tweak bindings after loading pdf-tools
  (delete '(pdf pdf-view) evil-collection-mode-list)
  (evil-collection-init))

(use-package evil-escape
  :demand t
  :init
  (evil-escape-mode))

(provide 'ar-keybind)
;;; ar-keybind.el ends here
