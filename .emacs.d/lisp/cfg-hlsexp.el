(require-package 'hl-sexp)

(add-hook 'clojure-mode-hook #'hl-sexp-mode)
(add-hook 'lisp-mode-hook #'hl-sexp-mode)
(add-hook 'emacs-lisp-mode-hook #'hl-sexp-mode)
