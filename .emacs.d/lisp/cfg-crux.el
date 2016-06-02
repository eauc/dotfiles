(use-package crux
  :ensure t
  :bind (("<s-return>" . crux-smart-open-line)
         ("<M-s-return>" . crux-smart-open-line-above)
         ("s-$" . crux-sudo-edit)
         ("s-<" . crux-move-beginning-of-line)
         ("s-i" . crux-find-user-init-file)
         ("s-I" . crux-recompile-init)
         ("s-j" . crux-top-join-line)
         ("s-k" . crux-kill-whole-line)))
