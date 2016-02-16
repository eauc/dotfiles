(use-package web-mode
  :ensure t
  :mode "\\.jsx\\'"
  :init
  (add-hook 'web-mode-hook 'js2-minor-mode)
  )
