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

(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-pin "melpa-stable")
(setq use-package-verbose t)

(dolist (file '("cfg-align-array.el"
                "cfg-avy.el"
                "cfg-center-cursor.el"
                "cfg-clojure.el"
                "cfg-company.el"
                "cfg-cucumber.el"
                "cfg-crux.el"
                "cfg-dired.el"
                "cfg-flycheck.el"
                "cfg-haskell.el"
                "cfg-hippie.el"
                "cfg-ido.el"
                "cfg-indent-buffer.el"
                "cfg-js.el"
                "cfg-multiple-cursors.el"
                "cfg-org.el"
                "cfg-rainbow-delimiters-mode.el"
                "cfg-scss.el"
                "cfg-set-keys.el"
                "cfg-smartparens.el"
                "cfg-smex.el"
                "cfg-tagedit.el"
                "cfg-try.el"
                "cfg-uniquify.el"
                "cfg-which-key.el"
                "cfg-yasnippet.el"
                ))
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
 '(dired-filter-saved-filters
   (quote
    (("es6"
      (not
       (or
        (extension . "map")
        (extension . "js")))))))
 '(dired-subtree-use-backgrounds nil)
 '(electric-indent-mode t)
 '(global-subword-mode t)
 '(indent-tabs-mode nil)
 '(js-indent-level 2)
 '(js2-basic-offset 2)
 '(js2-strict-trailing-comma-warning nil)
 '(jsx-indent-level 2)
 '(org-plantuml-jar-path "/usr/share/plantuml/plantuml.jar")
 '(scss-compile-at-save nil)
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
 '(show-paren-match ((t (:background "SpringGreen4"))))
 '(trailing-whitespace ((t (:background "goldenrod1")))))
