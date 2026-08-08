;;; ar-projects-vc.el --- -*- lexical-binding: t; -*-

;;; Code:

(use-package project
  :ensure nil ;; Built-in.
  :bind (("C-x p" . project-prefix-map))
  :init
  ;; Leader binds.
  (ar/leader
    ("p"   project-prefix-map)
    ("p P" #'project-remeber-projects-under "Discover subdirectory projects")
    ("SPC" #'project-find-file              "Find file in project"))

  :config
  ;; Anything here only runs AFTER project.el is loaded
  (setq project-vc-extra-root-markers
        '(".project" "Project.toml")))

(use-package vc
  :ensure nil
  :init
  (setq vc-follow-symlinks t)
  (setq vc-ignore-dir-regexp (format "\\(%s\\)\\|\\(%s\\)"
                                     vc-ignore-dir-regexp
                                     tramp-file-name-regexp))
  :config
  (ar/leader
    ("v" #'vc-prefix-map "vc"))

  :bind (:map vc-prefix-map
              ("c" . vc-create-repo)))

(use-package transient) ;; Magit dependency.
(use-package magit)

(use-package git-gutter
  :init
  (global-git-gutter-mode 1)
  :config
  (with-eval-after-load 'evil
    (evil-define-key '(normal visual motion) 'global
      (kbd "] g") #'git-gutter:next-hunk
      (kbd "[ g") #'git-gutter:previous-hunk)))

(ar/leader
  ("g"   nil "git")
  ("g g" #'magit-status)
  ("g c" #'magit-clone)
  ("g i" #'magit-init)
  ("g ]" #'git-gutter:next-hunk)
  ("g [" #'git-gutter:previous-hunk))

(provide 'ar-projects-vc)
;;; ar-projects-vc.el ends here
