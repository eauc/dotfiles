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

(use-package crux
  :ensure t
  :bind (("<S-return>" . crux-smart-open-line)
         ("<s-return>" . crux-smart-open-line-above)
         ("s-$" . crux-sudo-edit)
         ("s-<" . crux-move-beginning-of-line)
         ("s-i" . crux-find-user-init-file)
         ("s-j" . crux-top-join-line)
         ("s-k" . crux-kill-whole-line)))

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
