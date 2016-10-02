(use-package js2-mode
  :ensure t
  :mode ("\\.js\\'" . js2-jsx-mode)
  :mode ("\\.jsx\\'" . js2-jsx-mode)
  :mode ("\\.es6\\'" . js2-jsx-mode)
  )

(use-package json-mode
  :ensure t
  :mode "\\.json\\'"
  )
