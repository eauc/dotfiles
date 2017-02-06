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

(use-package mocha
  :ensure t
  :commands (mocha-test-at-point
             mocha-test-file
             mocha-test-project)
  :init
  (setq mocha-command "./node_modules/.bin/mocha"))

(use-package realgud
	:ensure t)
