(use-package clj-refactor
  :ensure t
  :init
  (add-hook 'clojure-mode-hook
            (lambda ()
              (clj-refactor-mode 1)
              (cljr-add-keybindings-with-prefix "C-c RET")))
  (add-hook 'clojure-mode-hook #'yas-minor-mode)
  (setq cljr-auto-sort-ns nil)
  (setq cljr-favor-prefix-notation nil)
  )
