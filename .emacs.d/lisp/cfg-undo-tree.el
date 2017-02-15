(use-package undo-tree
  :ensure t
  :pin melpa
  :diminish undo-tree-mode
  :bind (("C-S-z" . undo-tree-redo)
         ("C-M-z" . undo-tree-visualize))
  :config (progn
            (global-undo-tree-mode)
            (setq undo-tree-visualizer-timestamps t)
            (setq undo-tree-visualizer-diff t)))
