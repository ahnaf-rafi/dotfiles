;;; ar-tools.el --- -*- lexical-binding: t; -*-

;;; Code:

(use-package vterm
  :init
  (setq vterm-always-compile-module t)

  ;; Leader keybindings.
  (ar/leader
    ("a t" #'vterm-other-window)
    ("a T" #'vterm))
  :hook (vterm-mode . ar/vterm-h)
  :config
  (setq vterm-copy-exclude-prompt t)
  (setq vterm-kill-buffer-on-exit t)

  (defun ar/vterm-h ()
    "Hook function to run with vterm."
    (setq-local show-trailing-whitespace nil)))

(use-package pdf-tools
  :hook (pdf-view-mode . ar/pdf-h)
  :init
  (if (eq system-type 'darwin)
      (progn
        (setq pdf-view-use-scaling t)
        (setq pdf-view-use-imagemagick nil)))

  (pdf-loader-install)
  :config
  (evil-collection-pdf-setup)

  (evil-collection-define-key '(normal visual motion) 'pdf-view-mode-map
    (kbd "H")   #'image-bob
    (kbd "J")   #'pdf-view-next-page-command
    (kbd "K")   #'pdf-view-previous-page-command
    (kbd "a")   #'pdf-view-fit-height-to-window
    (kbd "s")   #'pdf-view-fit-width-to-window
    (kbd "y")   #'pdf-view-kill-ring-save
    (kbd "L")   #'image-eob
    (kbd "o")   #'pdf-outline
    (kbd "TAB") #'pdf-outline)

  ;; Changes to the usual doom-modeline.
  (when (fboundp 'doom-modeline-def-modeline)
    (doom-modeline-def-modeline 'pdf
      '(modals bar window-number matches pdf-pages buffer-info)
      '(misc-info major-mode process vcs)))

  (defun ar/pdf-h ()
    (display-line-numbers-mode 0)
    (turn-off-evil-snipe-mode)
    (setq-local evil-normal-state-cursor (list nil))
    (when (and (eq system-type 'darwin)
               (boundp 'mac-mouse-wheel-smooth-scroll))
      (setq-local mac-mouse-wheel-smooth-scroll nil))))

(use-package ebib
  :init
  (setq ebib-default-directory "~/Dropbox/bib/")
  (setq ebib-bibtex-dialect 'biblatex)
  (setq ebib-file-associations '())
  (setq ebib-save-indent-as-bibtex t)
  (setq ebib-bib-search-dirs '("~/Dropbox/bib/"))
  (setq ebib-preload-bib-files '("bibliography.bib"))
  (setq ebib-file-search-dirs '("~/Dropbox/bib/pdf/"))
  ;; Shorten file names since I always keep pdf files in the same location
  ;; relative to bibliography.bib.
  (setq ebib-truncate-file-names t)
  ;; Some layout tweaks
  (setq ebib-layout 'custom)
  (setq ebib-width 0.5)
  ;; Reading list
  (setq ebib-reading-list-file "~/Dropbox/org/readinglist.org")

  (ar/leader ("a b" #'ebib))

  :bind (:map ebib-index-mode-map
              ([remap save-buffer] . ebib-save-current-database))
  :hook ((ebib-entry-mode . ar/ebib-entry-mode-h)
         (ebib-index-mode . ar/ebib-index-mode-h))

  :config
  (ar/localleader ebib-index-mode-map
    ("." #'ebib-jump-to-entry)
    ("m" #'ebib-merge-bibtex-file))

  (defun ar/ebib-entry-mode-h ()
    (setq-local show-trailing-whitespace nil))

  (defun ar/ebib-index-mode-h ()
    (visual-line-mode -1)
    (setq-local word-wrap nil)
    (setq-local truncate-lines t)))

(use-package csv-mode)

(use-package nov
  :mode ("\\.epub\\'" . nov-mode))

(use-package olivetti
  :hook ((olivetti-mode-on  . ar/olivetti-mode-on-h)
         (olivetti-mode-off . ar/olivetti-mode-off-h))
  :config
  (setq olivetti-body-width 150)

  (defun ar/olivetti-mode-on-h ()
    (display-fill-column-indicator-mode -1)
    (auto-fill-mode -1))

  (defun ar/olivetti-mode-off-h ()
    (display-fill-column-indicator-mode 1)
    (auto-fill-mode 1)))

(provide 'ar-tools)
;;; ar--tools.el ends here
