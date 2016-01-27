(require-package 'let-alist)
(require-package 'flycheck-clojure)
(require-package 'flycheck)
(defun flycheck-setup ()
       (progn (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers
                        '(javascript-jshint)))
              (flycheck-add-mode 'javascript-eslint 'web-mode)
              (flycheck-add-mode 'javascript-eslint 'js-mode)
              (flycheck-add-mode 'javascript-eslint 'js2-mode)
              (flycheck-clojure-setup)
              )
       )

(eval-after-load 'flycheck '(flycheck-setup))
(add-hook 'after-init-hook #'global-flycheck-mode)

