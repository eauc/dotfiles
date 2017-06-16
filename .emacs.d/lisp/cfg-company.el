(use-package company
  :ensure t
  :init
  (add-hook 'cider-repl-mode-hook #'company-mode)
  (add-hook 'cider-mode-hook #'company-mode)
	:bind (("C-<tab>" . company-complete))
	:config
	(setq company-idle-delay nil)
	(cheatsheet-add-group 'Company
                        '(:key "C-TAB" :description "Complete suggestions")))
