(use-package realgud
  :ensure t)

(use-package js2-mode
  :ensure t
  :mode ("\\.js\\'"  . js2-jsx-mode)
  :mode ("\\.jsx\\'" . js2-jsx-mode)
  :mode ("\\.es6\\'" . js2-jsx-mode)
  :bind (:map js2-mode-map
              ("C-c m i" . mocha-test-at-point)
              ("C-c m f" . mocha-test-file)
              ("C-c m p" . mocha-test-project))
  :config
  (cheatsheet-add-group 'Javascript
                        '(:key "C-c m p" :description "Mocha test project")
                        '(:key "C-c m f" :description "Mocha test file")
                        '(:key "C-c m i" :description "Mocha test at point")
                        '(:key "C-c n v" :description "NPM visit project file")
                        '(:key "C-c n r" :description "NPM run")
                        '(:key "C-c n l" :description "NPM list")
                        '(:key "C-c n d" :description "NPM install save-dev")
                        '(:key "C-c n s" :description "NPM install save")
                        '(:key "C-c n n" :description "NPM init")
                        '(:key "C-c RET" :description "Refactor"))
  (setq js-indent-level 2)
  (setq js2-strict-trailing-comma-warning nil)
  (setq jsx-indent-level 2))

(use-package json-mode
  :ensure t
  :mode "\\.json\\'")

(use-package js2-refactor
  :ensure t
  :config
  (add-hook 'js2-mode-hook #'js2-refactor-mode)
  (js2r-add-keybindings-with-prefix "C-c <return>"))

(use-package mocha
  :ensure t
  :commands (mocha-test-at-point
             mocha-test-file
             mocha-test-project)
  :config
  (setq mocha-command "./node_modules/.bin/mocha"))


(use-package npm-mode
  :ensure t
  :config
  (add-hook 'js2-mode-hook #'npm-mode))
