(use-package let-alist
  :ensure t)
(use-package flycheck-clojure
  :ensure t)
(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode)
  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers
                        '(javascript-jshint)))
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (flycheck-add-mode 'javascript-eslint 'js-mode)
  (flycheck-add-mode 'javascript-eslint 'js2-mode)
  (flycheck-clojure-setup)
  )

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize)
  )
