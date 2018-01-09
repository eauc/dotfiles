(use-package company
  :ensure t
  :init
  (add-hook 'cider-repl-mode-hook #'company-mode)
  (add-hook 'cider-mode-hook #'company-mode)
  :bind
  (("C-c c" . company-complete))
  :config
  (setq company-idle-delay nil))
