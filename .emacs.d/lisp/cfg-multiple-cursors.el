(use-package mc-extras
  :ensure t)
(use-package multiple-cursors
  :ensure t
  :bind (("C-. >" . mc/mark-next-like-this)
         ("C-. <" . mc/mark-previous-like-this)
         ("C-. a" . mc/mark-all-like-this)
         ("C-. f" . mc/mark-all-like-this-in-defun)
         ("C-. <left>" . mc/cycle-backward)
         ("C-. <right>" . mc/cycle-forward)
         ("C-. [" . mc/edit-beginnings-of-lines)
         ("C-. ]" . mc/edit-ends-of-lines)
         ("C-. i" . mc/insert-numbers)
         ;; ("C-. >" . mc/mark-all-like-this-dwim)
         ("C-. u" . mc/remove-current-cursor)))
