;;; init --- init file
;;; Commentary:
;;; Code:

(require 'package)

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-pin "melpa")
(setq use-package-verbose t)

(org-babel-load-file
 (expand-file-name "~/.emacs.d/myinit.org"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (org-bullets back-button visible-mark undo-tree tagedit smex scss-mode nyan-mode restclient rainbow-delimiters plantuml-mode toc-org htmlize inf-ruby ox-reveal which-key use-package try realgud pcre2el org-plus-contrib npm-mode mocha mc-extras magit lispy json-mode js2-refactor haskell-mode google-this gitconfig-mode git-timemachine git-messenger flycheck-clojure feature-mode expand-region exec-path-from-shell dumb-jump discover dired-subtree dired-filter cycle-quotes crux company clojurescript-mode clojure-mode-extra-font-locking clj-refactor cheatsheet browse-kill-ring)))
 '(safe-local-variable-values
   (quote
    ((cider-cljs-lein-repl . "(do (require 'figwheel-sidecar.repl-api) (figwheel-sidecar.repl-api/start-figwheel!) (figwheel-sidecar.repl-api/cljs-repl))")))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "#181a26" :foreground "gray80" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 83 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(highlight ((t (:background "#103050"))))
 '(region ((t (:background "DodgerBlue4"))))
 '(sh-heredoc ((t (:foreground "dark orange" :weight bold))))
 '(show-paren-match ((t (:background "SpringGreen4"))))
 '(trailing-whitespace ((t (:background "goldenrod1")))))

;; (set-face-attribute 'default nil :height 100)
;; (setq split-height-threshold nil)
;; (setq split-width-threshold 200)

(let ((current-prefix-arg 4))
  (call-interactively 'org-reload))
