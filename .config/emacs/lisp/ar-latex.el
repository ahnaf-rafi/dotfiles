;;; ar-latex.el --- -*- lexical-binding: t; -*-

;;; Code:

;; Built-in tex-mode fallback: disable script fontification.
;; AUCTeX sets font-latex-fontify-script separately.
(setq tex-fontify-script nil)

(defcustom ar/LaTeX-indent-level-item-continuation 4
  "Indentation of continuation lines for items in itemize-like environments."
  :group 'LaTeX-indentation
  :type 'integer)

(defun ar/LaTeX-indent-item ()
  "Proper indentation for LaTeX itemize/enumerate/description environments."
  (save-match-data
    (let* ((offset LaTeX-indent-level)
           (contin (or (and (boundp 'ar/LaTeX-indent-level-item-continuation)
                            ar/LaTeX-indent-level-item-continuation)
                       (* 2 LaTeX-indent-level)))
           (re-beg "\\\\begin{")
           (re-end "\\\\end{")
           (re-env "\\(itemize\\|\\enumerate\\|description\\)")
           (indent (save-excursion
                     (when (looking-at (concat re-beg re-env "}"))
                       (end-of-line))
                     (LaTeX-find-matching-begin)
                     (current-column))))
      (cond ((looking-at (concat re-beg re-env "}"))
             (or (save-excursion
                   (beginning-of-line)
                   (ignore-errors
                     (LaTeX-find-matching-begin)
                     (+ (current-column)
                        (if (looking-at (concat re-beg re-env "}"))
                            contin
                          offset))))
                 indent))
            ((looking-at (concat re-end re-env "}"))
             indent)
            ((looking-at "\\\\item")
             (+ offset indent))
            (t
             (+ contin indent))))))

;; Remove LaTeX's built-in flymake backend; eglot/texlab handles diagnostics.
(defun ar/remove-LaTeX-flymake ()
  (remove-hook 'flymake-diagnostic-functions 'LaTeX-flymake t))
(advice-add 'TeX-latex-mode :after #'ar/remove-LaTeX-flymake)

(defun ar/latex-default-compile-on-master ()
  "Run `TeX-command-default' on `TeX-master' for current buffer."
  (interactive)
  (TeX-command TeX-command-default #'TeX-master-file))

(defun ar/save-and-latex-default-compile-on-master ()
  "Save current buffer and run `ar/latex-default-compile-on-master'."
  (interactive)
  (save-buffer)
  (ar/latex-default-compile-on-master))

(defun ar/latex-mode-h ()
  (setq-local fill-nobreak-predicate nil)
  (setq-local TeX-command-default "LaTeXMk")
  (visual-line-mode 1)
  (auto-fill-mode 1)
  (adaptive-wrap-prefix-mode 1)
  (reftex-mode 1)
  (eglot-ensure)
  (font-latex-add-keywords '(("bm" "{")) 'bold-command)
  (setq-local ispell-parser 'tex))

(use-package tex
  :ensure auctex
  :hook (TeX-mode . ar/latex-mode-h)
  :init
  (setq TeX-save-query nil)
  (setq TeX-source-correlate-mode t)
  (setq TeX-source-correlate-start-server t)
  (setq TeX-electric-sub-and-superscript t)
  (setq TeX-electric-math (cons "\\(" "\\)"))
  (setq TeX-brace-indent-level 0)
  (setq LaTeX-left-right-indent-level 0)
  (setq LaTeX-electric-left-right-brace t)
  (setq LaTeX-section-hook '(LaTeX-section-heading
                             LaTeX-section-title
                             LaTeX-section-toc
                             LaTeX-section-section
                             LaTeX-section-label))

  ;; preview settings
  (setq preview-locating-previews-message nil)
  (setq preview-protect-point t)
  (setq preview-leave-open-previews-visible t)
  (setq preview-auto-cache-preamble t)
  (setq preview-LaTeX-command-replacements '(preview-LaTeX-disable-pdfoutput))

  ;; Disable script height changes; clear sectioning colour handled separately.
  (setq font-latex-fontify-script nil)
  (setq font-latex-fontify-sectioning 'color)

  ;; Register texlab LSP server; must be deferred until eglot is available.
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '(latex-mode . ("texlab"))))
  :config
  (with-eval-after-load 'latex
    (ar/localleader LaTeX-mode-map
      ("a"  #'ar/save-and-latex-default-compile-on-master)
      ("v"  #'TeX-view)
      (";" #'reftex-toc)
      ("c"  #'TeX-clean)))

  ;; Revert the PDF buffer after compilation finishes.
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer)
  ;; SyncTeX support and latexmk integration.
  (require 'pdf-sync)
  ;; TODO: implement these locally.
  ;; (require 'auctex-latexmk)
  ;; (auctex-latexmk-setup)

  (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
  ;; Font-lock for BibLaTeX and common reference commands.
  (setq font-latex-match-reference-keywords
        '(("printbibliography" "[{")
          ("addbibresource" "[{")
          ("cite" "[{")
          ("citep" "[{")
          ("citet" "[{")
          ("Cite" "[{")
          ("parencite" "[{")
          ("Parencite" "[{")
          ("footcite" "[{")
          ("footcitetext" "[{")
          ("textcite" "[{")
          ("Textcite" "[{")
          ("smartcite" "[{")
          ("Smartcite" "[{")
          ("cite*" "[{")
          ("parencite*" "[{")
          ("supercite" "[{")
          ("cites" "[{")
          ("Cites" "[{")
          ("parencites" "[{")
          ("Parencites" "[{")
          ("footcites" "[{")
          ("footcitetexts" "[{")
          ("smartcites" "[{")
          ("Smartcites" "[{")
          ("textcites" "[{")
          ("Textcites" "[{")
          ("supercites" "[{")
          ("autocite" "[{")
          ("Autocite" "[{")
          ("autocite*" "[{")
          ("Autocite*" "[{")
          ("autocites" "[{")
          ("Autocites" "[{")
          ("citeauthor" "[{")
          ("Citeauthor" "[{")
          ("citetitle" "[{")
          ("citetitle*" "[{")
          ("citeyear" "[{")
          ("citedate" "[{")
          ("citeurl" "[{")
          ("fullcite" "[{")
          ("autoref" "[{")
          ("href" "[{")
          ("url" "[{")
          ("cref" "{")
          ("Cref" "{")
          ("cpageref" "{")
          ("Cpageref" "{")
          ("cpagerefrange" "{")
          ("Cpagerefrange" "{")
          ("crefrange" "{")
          ("Crefrange" "{")
          ("labelcref" "{")))
  (setq font-latex-match-textual-keywords
        '(("parentext" "{")
          ("brackettext" "{")
          ("hybridblockquote" "[{")
          ("textelp" "{")
          ("textelp*" "{")
          ("textins" "{")
          ("textins*" "{")
          ("subcaption" "[{")))
  (setq font-latex-match-variable-keywords
        '(("numberwithin" "{")
          ("setlist" "[{")
          ("setlist*" "[{")
          ("newlist" "{")
          ("renewlist" "{")
          ("setlistdepth" "{")
          ("restartlist" "{")
          ("crefname" "{")))
  ;; Reset and repopulate indentation rules for theorem-like environments.
  (setq LaTeX-indent-environment-list nil)
  (dolist (envpair '(("verbatim"      current-indentation)
                     ("verbatim*"     current-indentation)
                     ("filecontents"  current-indentation)
                     ("filecontents*" current-indentation)
                     ("frame"         current-indentation)
                     ("theorem"       current-indentation)
                     ("thm"           current-indentation)
                     ("corollary"     current-indentation)
                     ("cor"           current-indentation)
                     ("lemma"         current-indentation)
                     ("lem"           current-indentation)
                     ("definition"    current-indentation)
                     ("def"           current-indentation)
                     ("assumption"    current-indentation)
                     ("asm"           current-indentation)
                     ("remark"        current-indentation)
                     ("rem"           current-indentation)
                     ("example"       current-indentation)
                     ("eg"            current-indentation)
                     ("proof"         current-indentation)
                     ("problem"       current-indentation)
                     ("itemize"       ar/LaTeX-indent-item)
                     ("enumerate"     ar/LaTeX-indent-item)
                     ("description"   ar/LaTeX-indent-item)))
    (add-to-list 'LaTeX-indent-environment-list envpair)))

(use-package procress
  :hook (LaTeX-mode . procress-auctex-mode)
  :config
  (procress-load-default-svg-images))

(use-package evil-tex-ts
  :ensure t
  :after (evil)
  :hook ((LaTeX-mode . evil-tex-ts-mode)
         (latex-mode . evil-tex-ts-mode))
  :init
  (setq evil-tex-ts-toggle-override-m nil)
  (setq evil-tex-ts-toggle-override-t t)

  ;; NOTE: THIS NEEDS TO HAVE THE COMPILED LIB tree-sitter-latex.so!!!
  (add-to-list 'treesit-extra-load-path
               (expand-file-name "~/.config/emacs/treesitter/"))
  (add-to-list 'treesit-extra-load-path
               (expand-file-name "~/external-repos/tree-sitter-latex/"))
  :config
  ;; IMPORTANT: Set preferred inline math format
  ;; 'dollar for $...$ (default), 'paren for \(...\)
  (setq evil-tex-ts-preferred-inline-math 'paren))

(use-package preview-auto
  :hook (LaTeX-mode . preview-auto-setup))

(use-package reftex
  :ensure nil
  :init
  (setq reftex-cite-format
        '((?a . "\\autocite[]{%l}")
          (?b . "\\blockcquote[]{%l}{}")
          (?c . "\\cite[]{%l}")
          (?f . "\\footcite[]{%l}")
          (?n . "\\nocite{%l}")
          (?p . "\\parencite[]{%l}")
          (?s . "\\smartcite[]{%l}")
          (?t . "\\textcite[]{%l}")))
  (setq reftex-toc-split-windows-fraction 0.3)
  ;; Required when reftex-cite-format is set manually; see
  ;; https://superuser.com/a/1386206
  (setq LaTeX-reftex-cite-format-auto-activate nil)
  (setq reftex-plug-into-AUCTeX t)
  (add-hook 'reftex-mode-hook #'evil-normalize-keymaps))

(provide 'ar-latex)
;;; ar-latex.el ends here
