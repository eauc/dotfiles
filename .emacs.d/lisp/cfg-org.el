(defun tangle-on-save-org-mode-file()
	(when (string= (message "%s" major-mode) "org-mode")
		(org-babel-tangle)))

(use-package org
	:pin org
	:ensure t
	:init
	(add-hook 'after-save-hook 'tangle-on-save-org-mode-file)
	:config
	(setq org-confirm-babel-evaluate nil
				org-src-fontify-natively t
				org-src-tab-acts-natively t)
	(org-babel-do-load-languages
	 'org-babel-load-languages
	 '((sh				 . t)
		 (js				 . t)
		 (emacs-lisp . t)
		 (calc			 . t)
		 ;;		(perl				. t)
		 ;;		(scala			. t)
		 (clojure		 . t)
		 (python		 . t)
		 (ruby			 . t)
		 (dot				 . t)
		 (css				 . t)
		 (plantuml	 . t)
		 )))
(use-package org-plus-contrib
	:pin org
	:ensure t)

;; (use-package ox-bbcode
;;	:load-path "~/.emacs.d/org-ox-bbcode/")
(require 'ox-latex)
(add-to-list 'org-latex-classes
						 '("beamer"
							 "\\documentclass\[presentation\]\{beamer\}"
							 ("\\section\{%s\}" . "\\section*\{%s\}")
							 ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
							 ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

(use-package ox-reveal
	:pin melpa
	:ensure t)

(use-package inf-ruby
	:ensure t)
(use-package htmlize
	:ensure t)
