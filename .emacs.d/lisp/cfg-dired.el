(use-package dired)

(use-package dired-subtree
  :ensure t
  :pin melpa
  :bind (:map dired-mode-map
              ("C-i" . dired-subtree-insert)
              ("C-k" . dired-subtree-remove)
              ("C-<up>" . dired-subtree-beginning)
              ("C-<down>" . dired-subtree-end))
  :config
  (cheatsheet-add-group 'Dired
                        '(:key "C-i" :description "Insert subtree")
                        '(:key "C-k" :description "Kill subtree")
                        '(:key "C-Up" :description "Beginning of subtree")
                        '(:key "C-Down" :description "End of subtree")))

(use-package dired-filter
  :ensure t
  :pin melpa
  :config
  (define-key dired-mode-map (kbd "C-/") dired-filter-map)
  (cheatsheet-add-group 'Dired
                        '(:key "C-/" :description "Filter")))
