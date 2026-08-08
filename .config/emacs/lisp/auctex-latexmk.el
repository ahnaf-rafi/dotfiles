;;; auctex-latexmk.el --- -*- lexical-binding: t; -*-

;;; Code:

(require 'latex)

;; Only needed for backward compatibility.  Use quote to
;; hide this from tools used to maintain the Emacsmirror.
(require (quote tex-buf) nil t)

(defgroup auctex-latexmk nil
  "Add LatexMk support to AUCTeX."
  :group 'AUCTeX
  :prefix "auctex-latexmk")

(defcustom auctex-latexmk-encoding-alist
  '((japanese-iso-8bit      . "euc")
    (japanese-iso-8bit-unix . "euc")
    (euc-jp                 . "euc")
    (euc-jp-unix            . "euc")
    (utf-8                  . "utf8")
    (utf-8-unix             . "utf8")
    (japanese-shift-jis     . "sjis")
    (japanese-shift-jis-dos . "sjis"))
  "Encoding mapping for platex."
  :group 'auctex-latexmk)

(defcustom auctex-latexmk-inherit-TeX-PDF-mode nil
  "If non-nil add -pdf flag to latexmk when `TeX-PDF-mode' is active."
  :group 'auctex-latexmk)

(defun TeX-run-latexmk (name command file)
  (let ((TeX-sentinel-default-function 'Latexmk-sentinel)
        (pair (assq buffer-file-coding-system auctex-latexmk-encoding-alist)))
    (unless (null pair)
      (setenv "LATEXENC" (cdr pair)))
    (TeX-run-TeX name command file)
    (setenv "LATEXENC" nil)))

;;;###autoload
(defun auctex-latexmk-setup ()
  "Add LatexMk command to TeX-command-list."
  (add-to-list 'TeX-expand-list
               '("%(-PDF)"
                 (lambda ()
                   (cond
                    ((and (eq TeX-engine 'default)
                          TeX-PDF-mode
                          auctex-latexmk-inherit-TeX-PDF-mode)
                     "-pdf ")
                    ((and (eq TeX-engine 'xetex)
                          TeX-PDF-mode
                          auctex-latexmk-inherit-TeX-PDF-mode)
                     "-pdf -pdflatex=xelatex ")
                    ((eq TeX-engine 'xetex) "-xelatex ")
                    ((eq TeX-engine 'luatex) "-lualatex ")
                    (t "")))))
  (setq-default TeX-command-list
                (cons
                 '("LatexMk" "latexmk %(-PDF)%S%(mode) %(file-line-error) %(extraopts) %t" TeX-run-latexmk nil
                   (plain-tex-mode latex-mode doctex-mode) :help "Run LatexMk")
                 TeX-command-list)
                LaTeX-clean-intermediate-suffixes
                (append LaTeX-clean-intermediate-suffixes
                        '("\\.fdb_latexmk" "\\.aux.bak" "\\.fls"))))

(defun Latexmk-sentinel (process name)
  (save-excursion
    (goto-char (point-max))
    (cond
      ((re-search-backward (format "^%s finished at" mode-name) nil t)
       (if (re-search-backward "^Run number [0-9]+ of rule '\\(pdf\\|lua\\|xe\\)?latex'" nil t)
           (progn
             (forward-line 5)
             (let ((beg (point)))
               (when (string= (current-word) "Latexmk")
                 ;; Special treatment for MiKTeX
                 (forward-line))
               (re-search-forward "^Latexmk:" nil t)
               (beginning-of-line)
               (save-restriction
                 (narrow-to-region beg (point))
                 (goto-char (point-min))
                 (TeX-LaTeX-sentinel process name))))
         (message (format "%s: nothing to do" name))))
      ((re-search-backward (format "^%s exited abnormally with code" mode-name) nil t)
       (re-search-backward "^Collected error summary (may duplicate other messages):" nil t)
       (re-search-forward "^  \\([^:]+\\):" nil t)
       (let ((com (TeX-match-buffer 1)))
         (cond
           ((string-match "^\\(pdf\\|lua\\|xe\\)?latex" com)
            (goto-char (point-min))
            (TeX-LaTeX-sentinel process name)
            (when (string= TeX-command-next TeX-command-BibTeX)
              (setq TeX-command-default nil)))
           ((string-match "^bibtex " com)
            (forward-line -1)
            (re-search-backward com nil t)
            (forward-line 5)
            (let ((beg (point)))
              (re-search-forward "^Rule" nil t)
              (beginning-of-line)
              (save-restriction
                (narrow-to-region beg (point))
                (TeX-BibTeX-sentinel process name))))))))))

(defadvice TeX-recenter-output-buffer (around recenter-for-latexmk activate)
  (setq ad-return-value
        (let ((buffer (TeX-active-buffer)))
          (if buffer
              (if (with-current-buffer buffer
                    (goto-char (point-max))
                    (re-search-backward "^latexmk" nil t))
                  (let ((old-buffer (current-buffer)))
                    (TeX-pop-to-buffer buffer t t)
                    (bury-buffer buffer)
                    (goto-char (point-max))
                    (re-search-backward "^Run number [0-9]+ of rule 'bibtex .+'"
                                        nil t)
                    (re-search-forward "^Rule" nil t)
                    (forward-line -1)
                    (recenter (if line
                                  (prefix-numeric-value line)
                                  (/ (window-height) 2)))
                    (TeX-pop-to-buffer old-buffer nil t))
                  ad-do-it)
              (message "No process for this document.")))))

(provide 'auctex-latexmk)
;;; auctex-latexmk.el ends here
