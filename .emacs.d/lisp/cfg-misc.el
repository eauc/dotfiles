(defun eauc/align-array (s e)
  (interactive "r")
  (align-regexp s e "\\(\\s-*\\)\\(],\\|, \\)" 1 1 t))

(defun eauc/indent-buffer ()
  "Indents an entire buffer using the default intenting scheme."
  (interactive)
  (save-excursion
    (delete-trailing-whitespace)
    (indent-region (point-min) (point-max) nil)
    (untabify (point-min) (point-max))))

(defun eauc/sudo ()
  "Use TRAMP to `sudo' the current buffer"
  (interactive)
  (when buffer-file-name
    (find-alternate-file
     (concat "/sudo:root@localhost:"
             buffer-file-name))))

(use-package avy
  :ensure t
  :bind (("M-s a" . avy-goto-word-1)))

(use-package cheatsheet
  :pin melpa
  :ensure t
  :bind (("<f8>" . cheatsheet-show))
  :config
  (cheatsheet-add-group 'Commons
                        '(:key "Spe-i" :description "Edit config file")
                        '(:key "C-F10" :description "Kill emacs")
                        '(:key "F10" :description "Kill buffer")
                        '(:key "F8" :description "Cheatsheet")
                        '(:key "Spe-F7" :description "Git timemachine")
                        '(:key "S-F7" :description "MaGit blame")
                        '(:key "C-F7" :description "Git complete")
                        '(:key "F7" :description "MaGit status")
                        '(:key "C-F6" :description "Pop mark global")
                        '(:key "F6" :description "Pop mark")
                        '(:key "C-S-F5" :description "Jump to named bookmark")
                        '(:key "S-F5" :description "Set named bookmark")
                        '(:key "C-F5" :description "Jump to bookmark")
                        '(:key "F5" :description "Set bookmark")
                        '(:key "C-F4" :description "Indent Buffer")
												'(:key "F4" :description "Comment")
                        '(:key "S-F3" :description "Ido switch buffer")
                        '(:key "C-F3" :description "Buffer menu other window")
                        '(:key "F3" :description "Other window")
                        '(:key "C-F2" :description "Write file")
                        '(:key "F2" :description "Save buffer")
                        '(:key "F1" :description "Find file"))
  (cheatsheet-add-group 'Edition
                        '(:key "Spe-<" :description "Move beginning of line")
                        '(:key "M-s a" :description "Goto word")
                        '(:key "S-RET" :description "Open line below")
                        '(:key "Spe-RET" :description "Open line above")
                        '(:key "S-SPC" :description "Just one space")
                        '(:key "Spe-k" :description "Kill whole line")
                        '(:key "C-e a" :description "Align array")
                        '(:key "C-'" :description "Cycle quotes")
                        '(:key "C-S-z" :description "Undo tree")
                        '(:key "C-M-z" :description "Undo tree view")
                        '(:key "C-m" :description "Call macro")
                        '(:key "M-/" :description "Expand")))
(use-package crux
  :ensure t
  :bind (("<S-return>" . crux-smart-open-line)
         ("<s-return>" . crux-smart-open-line-above)
         ("s-$" . crux-sudo-edit)
         ("s-<" . crux-move-beginning-of-line)
         ("s-i" . crux-find-user-init-file)
         ("s-j" . crux-top-join-line)
         ("s-k" . crux-kill-whole-line)))

(use-package cycle-quotes
  :pin gnu
  :ensure t
  :bind (("C-'" . cycle-quotes)))

(use-package discover
  :ensure t)

(use-package dumb-jump
  :ensure t
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g b" . dumb-jump-back))
  :config
  (cheatsheet-add-group 'Jump
                        '(:key "M-g j" :description "Jump to definition")
                        '(:key "M-g o" :description "Jump (other window)")
                        '(:key "M-g b" :description "Jump back")))

(global-set-key (kbd "M-/") 'hippie-expand)
;; Lisp-friendly hippie expand
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

(use-package try
  :ensure t
  :pin melpa)

(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'forward))

(use-package which-key
  :ensure t
  :config (which-key-mode))
