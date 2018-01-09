;;; init --- init file
;;; Commentary:
;;; Code:

(setq dotfiles-lisp-dir
      (file-name-as-directory
       (concat (file-name-directory
                (or (buffer-file-name) load-file-name))
               "lisp")))
(add-to-list 'load-path dotfiles-lisp-dir)

(require 'package)

(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("org" . "http://orgmode.org/elpa/") t)

(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-pin "melpa-stable")
(setq use-package-verbose t)

(dolist (file '("cfg-misc.el"
                "cfg-clojure.el"
                "cfg-company.el"
                "cfg-cucumber.el"
                "cfg-cursors.el"
                "cfg-dired.el"
                "cfg-flycheck.el"
                "cfg-git.el"
                "cfg-haskell.el"
                "cfg-ido.el"
                "cfg-js.el"
                "cfg-lisp.el"
                "cfg-mark.el"
                "cfg-org.el"
                ;; "cfg-paredit.el"
                "cfg-plantuml.el"
                "cfg-rainbow-delimiters-mode.el"
                "cfg-restclient.el"
                "cfg-scroll.el"
                "cfg-scss.el"
                "cfg-set-keys.el"
                ;; "cfg-smartparens.el"
                "cfg-smex.el"
                "cfg-tagedit.el"
                ;; "cfg-undo-tree.el"
                "cfg-yasnippet.el"))
  (load (concat dotfiles-lisp-dir file)))

(setq backup-directory-alist `(("." . "~/.saves")))
(global-linum-mode 1)
(global-auto-revert-mode)
(show-paren-mode)
(global-hl-line-mode 1)
(defalias 'yes-or-no-p 'y-or-n-p)
;; (setq split-height-threshold nil)
;; (setq split-width-threshold 200)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#ad7fa8" "#8cc4ff" "#eeeeec"])
 '(case-fold-search t)
 '(column-number-mode t)
 '(custom-buffer-indent 2)
 '(custom-enabled-themes (quote (deeper-blue)))
 '(display-time-mode t)
 '(electric-indent-mode t)
 '(fringe-mode 0 nil (fringe))
 '(global-subword-mode t)
 '(indent-tabs-mode nil)
 '(package-selected-packages
   (quote
    (org-bullets back-button visible-mark undo-tree tagedit smex scss-mode nyan-mode restclient rainbow-delimiters plantuml-mode toc-org htmlize inf-ruby ox-reveal which-key use-package try realgud pcre2el org-plus-contrib npm-mode mocha mc-extras magit lispy json-mode js2-refactor haskell-mode google-this gitconfig-mode git-timemachine git-messenger flycheck-clojure feature-mode expand-region exec-path-from-shell dumb-jump discover dired-subtree dired-filter cycle-quotes crux company clojurescript-mode clojure-mode-extra-font-locking clj-refactor cheatsheet browse-kill-ring)))
 '(safe-local-variable-values
   (quote
    ((cider-cljs-lein-repl . "(do (require 'figwheel-sidecar.repl-api) (figwheel-sidecar.repl-api/start-figwheel!) (figwheel-sidecar.repl-api/cljs-repl))"))))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(show-trailing-whitespace t)
 '(standard-indent 2)
 '(tool-bar-mode nil)
 '(web-mode-code-indent-offset 2)
 '(web-mode-css-indent-offset 2)
 '(web-mode-markup-indent-offset 2))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "#181a26" :foreground "gray80" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 83 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(highlight ((t (:background "#103050"))))
 '(hl-sexp-face ((t (:background "gray20"))))
 '(js2-error ((t (:foreground "red"))))
 '(js2-external-variable ((t (:foreground "orchid"))))
 '(js2-function-param ((t (:foreground "lime green"))))
 '(js2-private-function-call ((t (:foreground "dark orange"))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "green" :weight bold))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "magenta" :weight bold))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "yellow" :weight normal))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "dodger blue" :weight bold))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "chocolate" :weight bold))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "SpringGreen1" :weight bold))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "magenta" :weight bold))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "green" :weight bold))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "dodger blue" :weight bold))))
 '(rainbow-delimiters-unmatched-face ((t (:foreground "red" :weight bold))))
 '(region ((t (:background "DodgerBlue4"))))
 '(sh-heredoc ((t (:foreground "dark orange" :weight bold))))
 '(show-paren-match ((t (:background "SpringGreen4"))))
 '(trailing-whitespace ((t (:background "goldenrod1")))))
