(use-package git-timemachine
  :ensure t
  :bind (("s-<f7>" . git-timemachine-toggle))
  :init
  (cheatsheet-add-group 'GitTimemachine
                        '(:key "q" :description "Quit")
                        '(:key "w" :description "Copy short hash of current version")
                        '(:key "p" :description "Previous revision")
                        '(:key "n" :description "Next revision")
                        '(:key "Spe-F7" :description "Toggle timemachine mode")))

(use-package gitconfig-mode
  :ensure t)

(use-package magit
  :ensure t
  :bind (("<f7>" . magit-status)
         ("<S-f7>" . magit-blame)))

(use-package git-complete
	:load-path "~/.emacs.d/git-complete/"
	:bind (("C-<f7>" . git-complete)))
