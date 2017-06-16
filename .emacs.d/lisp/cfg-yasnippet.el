(use-package yasnippet
  :ensure t
  :config
  (setq yas-snippet-dirs '("~/.emacs.d/mysnippets"))
  (setq yas-prompt-functions '(yas-ido-prompt))
  (yas-global-mode 1)
  (define-key yas-minor-mode-map (kbd "<tab>") nil)
  (define-key yas-minor-mode-map (kbd "TAB") nil)
  (define-key yas-minor-mode-map (kbd "M-<tab>") 'yas-expand)
  (cheatsheet-add-group 'Yasnippet
                        '(:key "M-TAB" :description "Insert yasnippet")))
