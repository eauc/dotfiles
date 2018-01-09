(use-package mc-extras
  :ensure t)

(use-package multiple-cursors
  :ensure t
  :bind (("C-c . >" . mc/mark-next-like-this)
         ("C-c . <" . mc/mark-previous-like-this)
         ("C-c . a" . mc/mark-all-like-this)
         ("C-c . f" . mc/mark-all-like-this-in-defun)
         ("C-c . <left>" . mc/cycle-backward)
         ("C-c . <right>" . mc/cycle-forward)
         ("C-c . [" . mc/edit-beginnings-of-lines)
         ("C-c . ]" . mc/edit-ends-of-lines)
         ("C-c . i" . mc/insert-numbers)
         ;; ("C-c . >" . mc/mark-all-like-this-dwim)
         ("C-c . u" . mc/remove-current-cursor))
  :config
  (cheatsheet-add-group 'Cursors
                        '(:key "C-c . u" :description "Remove current cursor")
                        '(:key "C-c . [" :description "Edit beginning of lines")
                        '(:key "C-c . ]" :description "Edit end of lines")
                        '(:key "C-c . right" :description "Cycle backward")
                        '(:key "C-c . left" :description "Cycle forward")
                        '(:key "C-c . f" :description "Mark all like this in defun")
                        '(:key "C-c . a" :description "Mark all like this")
                        '(:key "C-c . <" :description "Mark previous like this")
                        '(:key "C-c . >" :description "Mark next like this")))
