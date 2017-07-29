(use-package clojure-mode
  :ensure t
  :mode ("\\.clj\\'" . clojure-mode)
  :init
  (add-hook 'clojure-mode-hook
            (lambda ()
              (setq inferior-lisp-program "lein repl")
              (font-lock-add-keywords
               nil
               '(("(\\(facts?\\)"
                  (1 font-lock-keyword-face))
                 ("(\\(background?\\)"
                  (1 font-lock-keyword-face))))
              (define-clojure-indent (fact 1))
              (define-clojure-indent (facts 1))))
  :config
  (cheatsheet-add-group 'Clojure
                        '(:key "C-c RET" :description "Refactor")
                        '(:key "C-c M-J" :description "Cider Jack-in CLJS")
                        '(:key "C-c C-k" :description "Cider load & compile file")
                        '(:key "C-c C-c" :description "Cider execute top sexp")
                        '(:key "C-x C-e" :description "Cider execute last sexp")))

(use-package clojurescript-mode
  :ensure t
  :pin marmalade
  :mode ("\\.cljs\\'" . clojurescript-mode))

(use-package clojure-mode-extra-font-locking
  :ensure t)

(use-package clj-refactor
  :ensure t
  :defer t
  :init
  (add-hook 'clojure-mode-hook
            (lambda ()
              (clj-refactor-mode 1)
              (cljr-add-keybindings-with-prefix "C-c RET")))
  :config
  (setq cljr-auto-sort-ns nil)
  (setq cljr-favor-prefix-notation nil))

(use-package flycheck-clojure
  :ensure t)

(use-package cider
  :pin melpa-stable
  :ensure t
  :defer t
  :init
  (add-hook 'clojure-mode-hook 'cider-mode)
  :config
  (flycheck-clojure-setup)
  (setq cider-repl-pop-to-buffer-on-connect t)
  ;; REPL history file
  (setq cider-repl-history-file "~/.emacs.d/cider-history")
  ;; nice pretty printing
  (setq cider-repl-use-pretty-printing t)
  ;; nicer font lock in REPL
  (setq cider-repl-use-clojure-font-lock t)
  ;; result prefix for the REPL
  (setq cider-repl-result-prefix ";; => ")
  ;; never ending REPL history
  (setq cider-repl-wrap-history t)
  ;; looong history
  (setq cider-repl-history-size 3000)
  ;; error buffer not popping up
  (setq cider-show-error-buffer t)
  (setq cider-auto-select-error-buffer nil)
  ;; eldoc for clojure
  (add-hook 'cider-mode-hook #'eldoc-mode))
