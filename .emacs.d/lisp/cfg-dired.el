(use-package dired)

(use-package dired-subtree
  :ensure t
  :pin melpa
  :bind (:map dired-mode-map
              ("C-i" . dired-subtree-insert)
              ("C-k" . dired-subtree-remove)
              ("C-<up>" . dired-subtree-beginning)
              ("C-<down>" . dired-subtree-end))
  :init
  (cheatsheet-add :group 'Dired :key "C-Down" :description "End of subtree")
  (cheatsheet-add :group 'Dired :key "C-Up" :description "Beginning of subtree")
  (cheatsheet-add :group 'Dired :key "C-k" :description "Kill subtree")
  (cheatsheet-add :group 'Dired :key "C-i" :description "Insert subtree"))

(use-package dired-filter
  :ensure t
  :pin melpa
  :init
  (cheatsheet-add :group 'Dired :key "C-/" :description "Filter")
  :config
  (define-key dired-mode-map (kbd "C-/") dired-filter-map))
