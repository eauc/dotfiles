(use-package lispy
  :ensure t
	:init
  (add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))
  (add-hook 'clojure-mode-hook (lambda () (lispy-mode 1)))
  (add-hook 'clojurescript-mode-hook (lambda () (lispy-mode 1)))
  :bind (:map lispy-mode-map
							("M-[" . lispy-backward)
							("M-]" . lispy-forward)
							(")" . self-insert-command)
							("[" . self-insert-command)
							("]" . self-insert-command)
							(";" . self-insert-command)
							("DEL" . backward-delete-char-untabify)
							("M-DEL" . lispy-delete-backward)))
