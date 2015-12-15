;;; init --- init file
;;; Commentary:
;;; Code:
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives 
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)
(require 'dired-x)
(require 'dired-details)
(dired-details-install)
(require 'centered-cursor-mode)
(global-centered-cursor-mode +1)

;;(defun sudo ()
;;	"Use TRAMP to `sudo' the current buffer"
;;	(interactive)
;;	(when buffer-file-name
;;		(find-alternate-file
;;			(concat "/sudo:root@localhost:"
;;				buffer-file-name))))

(global-set-key "\C-z"    'advertised-undo)
(global-set-key "\C-l"    'goto-line)
(global-set-key (kbd "<C-prior>")  'previous-buffer)
(global-set-key (kbd "<C-next>")   'next-buffer)
(global-set-key (kbd "<s-SPC>")    'just-one-space)

(global-set-key (kbd "<f1>")    'find-file)
(global-set-key (kbd "<f2>")    'save-buffer)
(global-set-key (kbd "<C-f2>")  'write-file)
(global-set-key (kbd "<f3>")    'other-window)
(global-set-key (kbd "<C-f3>")  'buffer-menu-other-window)
(global-set-key (kbd "<f4>")    'comment-or-uncomment-region)
(global-set-key (kbd "<f10>")   'kill-this-buffer)
(global-set-key (kbd "<C-f10>") 'save-buffers-kill-terminal)

(global-set-key (kbd "<M-up>")    'windmove-up)
(global-set-key (kbd "<M-down>")  'windmove-down)
(global-set-key (kbd "<M-left>")  'windmove-left)
(global-set-key (kbd "<M-right>") 'windmove-right)

(ido-mode 1)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)
(global-set-key (kbd "<RET>") 'newline-and-indent)
(setq backup-directory-alist `(("." . "~/.saves")))
(global-linum-mode 1)
(defalias 'yes-or-no-p 'y-or-n-p)
;; (setq split-height-threshold nil)
;; (setq split-width-threshold 200)

(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                      '(javascript-jshint)))
(flycheck-add-mode 'javascript-eslint 'web-mode)
(flycheck-add-mode 'javascript-eslint 'js-mode)
(flycheck-add-mode 'javascript-eslint 'js2-mode)
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'"        . js2-mode))
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'"     . web-mode))
(require 'scss-mode)
(add-to-list 'auto-mode-alist '("\\.scss\\'"      . scss-mode))

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
 '(show-paren-mode t)
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
 '(js2-error ((t (:foreground "red"))))
 '(js2-external-variable ((t (:foreground "orchid"))))
 '(js2-function-param ((t (:foreground "lime green"))))
 '(js2-private-function-call ((t (:foreground "dark orange"))))
 '(show-paren-match ((t (:background "SpringGreen4")))))
