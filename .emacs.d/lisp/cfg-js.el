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
              ("C-c m p" . mocha-test-project)))

(use-package json-mode
  :ensure t
  :mode "\\.json\\'")

(use-package js2-refactor
  :ensure t
  :config
  (add-hook 'js2-mode-hook #'js2-refactor-mode)
  (js2r-add-keybindings-with-prefix "C-c")
  (cheatsheet-add-group 'Javascript
                        '(:key "C-c ..." :description "Refactor")))

(use-package mocha
  :ensure t
  :commands (mocha-test-at-point
             mocha-test-file
             mocha-test-project)
  :init
  (setq mocha-command "./node_modules/.bin/mocha")
  :config
  (cheatsheet-add-group 'Javascript
                        '(:key "C-c m i" :description "Mocha test at point")
                        '(:key "C-c m f" :description "Mocha test file")
                        '(:key "C-c m p" :description "Mocha test project")))
