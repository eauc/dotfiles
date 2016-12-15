(use-package dired)

(use-package dired-subtree
 :ensure t
 :pin melpa
 :bind (:map dired-mode-map
             ("C-i" . dired-subtree-insert)
             ("C-k" . dired-subtree-remove)
             ("C-<up>" . dired-subtree-beginning)
             ("C-<down>" . dired-subtree-end)))

(use-package dired-filter
  :ensure t
  :pin melpa
  :config (define-key dired-mode-map (kbd "C-/") dired-filter-map))
