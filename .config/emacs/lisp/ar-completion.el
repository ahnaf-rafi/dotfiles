;;; ar-completion.el --- -*- lexical-binding: t; -*-

;;; Code:

(setq savehist-save-minibuffer-history t)
(add-hook 'after-init-hook #'savehist-mode)

;; TODO: Configure properly
(use-package vertico
  :init
  (setq vertico-cycle t)
  (vertico-mode))

;; TODO: Configure properly
(use-package consult
  :init
  (setq consult-preview-key 'nil)

  :bind (([remap apropos]            . consult-apropos)
         ([remap bookmark-jump]      . consult-bookmark)
         ([remap evil-show-marks]    . consult-mark)
         ([remap imenu]              . consult-imenu)
         ([remap load-theme]         . consult-theme)
         ([remap locate]             . consult-locate)
         ([remap recentf-open-files] . consult-recent-file)
         ([remap yank-pop]           . consult-yank-pop)))

;; TODO: Configure properly
(use-package marginalia
  :init
  (setq marginalia-annotators '(marginalia-annotators-heavy
				                        marginalia-annotators-light))
  (marginalia-mode))

;; TODO: Configure properly
(use-package orderless
  :init
  (setq completion-styles '(orderless basic))
  (setq completion-category-defaults nil)
  (setq completion-category-overrides '((file (styles . (partial-completion))))))

;; TODO: Configure properly
(use-package corfu
  :custom
  (corfu-cycle t)                  ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                   ;; Enable auto completion
  (corfu-separator ?\s)            ;; Orderless field separator
  (corfu-quit-no-match 'separator) ;; Never quit, even if there is no match
  (corfu-preselect 'prompt)        ;; Preselect the prompt
  :init
  (setq tab-always-indent 'complete)
  (setq completion-cycle-threshold 3)
  (setopt text-mode-ispell-word-completion nil)
  (global-corfu-mode))

;; TODO: Configure properly
(use-package cape
  ;; Bind prefix keymap providing all Cape commands under a mnemonic key.
  ;; Press C-c p ? to for help.
  :bind ("C-c p" . cape-prefix-map)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (add-hook 'completion-at-point-functions #'cape-file))

(use-package nerd-icons-completion
  :init
  (nerd-icons-completion-mode)
  :config
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package yasnippet
  :init
  (setq yas-indent-line 'auto)
  (with-eval-after-load 'yasnippet
    (add-to-list 'yas-snippet-dirs (expand-file-name "snippets/"
                                                     user-emacs-directory))
    (defvaralias '% 'yas-selected-text))
  (yas-global-mode 1))

(provide 'ar-completion)
;;; ar-completion.el ends here
