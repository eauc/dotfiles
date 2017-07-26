(defun tangle-on-save-org-mode-file()
  (when (string= (message "%s" major-mode) "org-mode")
    (org-babel-tangle)))

(use-package org
  :pin org
  :ensure org-plus-contrib
  :init
  (add-hook 'after-save-hook 'tangle-on-save-org-mode-file)
  :config
  (setq org-confirm-babel-evaluate nil
        org-src-fontify-natively t
        org-src-tab-acts-natively t)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((sh . t)
     (js . t)
     (emacs-lisp . t)
     (calc . t)
     ;; (perl . t)
     ;; (scala . t)
     (clojure . t)
     (python . t)
     (ruby . t)
     (dot . t)
     (css . t)
     (plantuml . t)))
  (cheatsheet-add-group 'Org

												'(:key "M-left/right" :description "Decrease/Increase header level")
												'(:key "C-c C-u" :description "Back to top level header")
												'(:key "C-c C-n" :description "Next header (any level)")
												'(:key "C-c C-p" :description "Previous header (any level)")
												'(:key "C-c C-f" :description "Next header (same level)")
												'(:key "C-c C-b" :description "Previous header (same level)")

												'(:key "M-<RET>" :description "List: insert new item at same level")
												'(:key "S-<up>" :description "List: previous item")
												'(:key "S-<down>" :description "List: next item")
												'(:key "S-<left/right>" :description "List: cycle bullet type")
												'(:key "M-<up>" :description "List: move item up")
												'(:key "M-<down>" :description "List: move item down")
												'(:key "M-<left>" :description "List: decrease item indentation")
												'(:key "M-<right>" :description "List: increase item indentation")
												'(:key "M-S-<left>" :description "List: decrease item+children indentation")
												'(:key "M-S-<right>" :description "List: increase item+children indentation")

                        '(:key "<s-tab" :description "Insert source code block")
												'(:key "C-c '" :description "Edit code block")
                        '(:key "C-c C-c" :description "Evaluate code block")
                        '(:key "C-c C-e" :description "Export file")
                        '(:key "C-c C-v t" :description "Tangle file")

                        '(:key "C-c C-x C-v" :description "Toggle inline images")
                        '(:key "C-c C-x C-M-v" :description "Refresh inline images")))
;; (use-package org-plus-contrib
;;   :pin org
;;   :ensure t)

;; (use-package ox-bbcode
;; 	:load-path "~/.emacs.d/org-ox-bbcode/")
(use-package ox-confluence
	:load-path "~/.emacs.d/org-ox-confluence/")
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
