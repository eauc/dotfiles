(fset 'other-window-end      [?\C-x ?o C-end])
(fset 'switch-to-buffer-list [?\C-x ?\C-b ?\C-x ?o])
(fset 'kill-current-buffer   [?\C-x ?k return])

(fset 'find-current-tag   [?\M-x ?f ?i ?n ?d ?- ?t ?a ?g return return])
(fset 'selected-tag-search   [?\M-w ?\M-x ?t ?a ?g ?s ?- ?s ?e ?a ?r ?c ?h return ?\C-y return])
(fset 'find-next-tag   [?\C-u ?\M-x ?f ?i ?n ?d ?- ?t ?a ?g return])

(defun google ()
  "Googles a query or region if any."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (if mark-active
        (buffer-substring (region-beginning) (region-end))
      (read-string "Google: ")))))

(global-set-key (kbd "<f1>")   'find-file)
(global-set-key (kbd "<C-f1>") 'multi-term)
(global-set-key (kbd "<f2>")   'save-buffer)
(global-set-key (kbd "<C-f2>") 'write-file)
(global-set-key (kbd "<f3>")   'other-window)
(global-set-key (kbd "<C-f3>") 'switch-to-buffer-list)
(global-set-key (kbd "<s-f3>") 'other-window-end)

(global-set-key (kbd "<f4>")   'comment-or-uncomment-region)
(global-set-key (kbd "<C-f4>") 'google)

(global-set-key (kbd "<s-f5>") 'visit-tags-table)
(global-set-key (kbd "<f5>")   'find-current-tag)
(global-set-key (kbd "<C-f5>") 'find-next-tag)
(global-set-key (kbd "<f6>")   'selected-tag-search)
(global-set-key (kbd "<C-f6>") 'pop-tag-mark)
(global-set-key (kbd "<s-f6>") 'tags-loop-continue)
(global-set-key (kbd "<f7>")   'complete-tag)

(global-set-key (kbd "<f8>")    'compile)
(global-set-key (kbd "<C-f8>")  'gdb)

(global-set-key (kbd "<f10>")   'kill-current-buffer)
(global-set-key (kbd "<C-f10>") 'save-buffers-kill-terminal)

(global-set-key "\C-z"    'advertised-undo)
(global-set-key "\C-l"    'goto-line)
(global-set-key "\M-m"    'kmacro-end-and-call-macro)

(global-set-key [C-left]  'backward-word)
(global-set-key [C-right] 'forward-word)
(global-set-key [C-up]    'beginning-of-line)
(global-set-key [C-down]  'end-of-line)
(global-set-key [M-left]  'c-beginning-of-statement)
(global-set-key [M-right] 'c-end-of-statement)
(global-set-key [M-up]    'beginning-of-defun)
(global-set-key [M-down]  'end-of-defun)
(global-set-key [C-home]  'beginning-of-buffer)
(global-set-key [C-end]   'end-of-buffer)
(global-set-key [C-prior] 'previous-buffer)
(global-set-key [C-next]  'next-buffer)

(tool-bar-mode -1)
(global-linum-mode 1)
(setq make-backup-files nil)
(setq tags-revert-without-query t)
(setq compile-command "make -k -j 4 -C /home/auclair/code")
(defalias 'yes-or-no-p 'y-or-n-p)
(eldoc-mode 1)
(setenv "PAGER" "/bin/cat")
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(setq show-paren-style 'expression)

(add-to-list 'load-path "/home/auclair/.emacs.d/")
;; (when
;;     (load
;;      (expand-file-name "~/.emacs.d/elpa/package.el"))
;;   (package-initialize))
;; (set 'package-archives '("marmalade" . "http://vagrant-centos-62.vagrantup.com/packages/"))
;;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

;;(add-to-list 'load-path "~/.emacs.d/elpa/centered-cursor-mode-0.5.1/")
(require 'centered-cursor-mode)
(global-centered-cursor-mode +1)

;;(add-to-list 'load-path "~/.emacs.d/elpa/dired-details-1.3.1/")
(require 'dired-details)
(dired-details-install)

(require 'multi-term)
(setq multi-term-program "/bin/bash")

(eval-after-load 'diff-mode
  '(progn
     (set-face-foreground 'diff-added "green4")
     (set-face-foreground 'diff-removed "red3")
     (set-face-foreground 'diff-changed "#00CCCC")))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(current-language-environment "UTF-8")
 '(custom-enabled-themes (quote (tango-dark)))
 '(custom-safe-themes (quote ("1f392dc4316da3e648c6dc0f4aad1a87d4be556c" default)))
 '(global-subword-mode t)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(js-indent-level 2)
 '(show-paren-mode t)
 '(tool-bar-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "#181a26" :foreground "gray80" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 83 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(show-paren-match ((t (:background "SpringGreen4")))))

