(use-package mc-extras
  :ensure t
  )
(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C-. >") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-. <") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-. a") 'mc/mark-all-like-this)
  (global-set-key (kbd "C-. f") 'mc/mark-all-like-this-in-defun)
  (global-set-key (kbd "C-. <left>") 'mc/cycle-backward)
  (global-set-key (kbd "C-. <right>") 'mc/cycle-forward)
  (global-set-key (kbd "C-. [") 'mc/edit-beginnings-of-lines)
  (global-set-key (kbd "C-. ]") 'mc/edit-ends-of-lines)
  (global-set-key (kbd "C-. i") 'mc/insert-numbers)
  ;; (global-set-key (kbd "C-. >") 'mc/mark-all-like-this-dwim)
  (global-set-key (kbd "C-. u") 'mc/remove-current-cursor)
  )
