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
             '("marmalade" . "http://marmalade-repo.org/packages/"))

(package-initialize)

(require 'use-package)
(setq use-package-always-pin "melpa-stable")
(setq use-package-verbose t)

(dolist (file '("cfg-align-array.el"
                "cfg-center-cursor.el"
                "cfg-cider.el"
                "cfg-cljrefactor.el"
                "cfg-flycheck.el"
                ;; "cfg-hlsexp.el"
                "cfg-ido.el"
                "cfg-js2-mode.el"
                "cfg-json-mode.el"
                "cfg-scss-mode.el"
                "cfg-set-keys.el"
                "cfg-sudo.el"
                "cfg-web-mode.el"
                ))
  (load (concat dotfiles-lisp-dir file)))

(setq backup-directory-alist `(("." . "~/.saves")))
(global-linum-mode 1)
(show-paren-mode)
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
 '(column-number-mode t)
 '(custom-buffer-indent 2)
 '(custom-enabled-themes (quote (deeper-blue)))
 '(electric-indent-mode t)
 '(global-subword-mode t)
 '(indent-tabs-mode nil)
 '(js-indent-level 2)
 '(js2-basic-offset 2)
 '(jsx-indent-level 2)
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
 '(hl-sexp-face ((t (:background "gray20"))))
 '(js2-error ((t (:foreground "red"))))
 '(js2-external-variable ((t (:foreground "orchid"))))
 '(js2-function-param ((t (:foreground "lime green"))))
 '(js2-private-function-call ((t (:foreground "dark orange"))))
 '(show-paren-match ((t (:background "SpringGreen4"))))
 '(trailing-whitespace ((t (:background "goldenrod1")))))
