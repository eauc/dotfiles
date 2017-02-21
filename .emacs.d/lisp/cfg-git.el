(use-package git-timemachine
	:ensure t
	:bind (("s-<f7>" . git-timemachine-toggle))
	:config
	(cheatsheet-add-group 'GitTimemachine
												'(:key "Spe-F7" :description "Toggle timemachine mode")
												'(:key "n" :description "Next revision")
												'(:key "p" :description "Previous revision")
												'(:key "w" :description "Copy short hash of current version")
												'(:key "q" :description "Quit")))

(use-package gitconfig-mode
	:ensure t)

(use-package magit
	:ensure t
	:bind (("<f7>" . magit-status)
				 ("<S-f7>" . magit-blame)))

(use-package git-gutter
	:ensure t
	:bind (("C-<f7>" . git-gutter-mode)
				 ("C-x v =" . git-gutter:popup-hunk)
				 ("C-x v n" . git-gutter:next-hunk)
				 ("C-x v p" . git-gutter:previous-hunk)
				 ("C-x v s" . git-gutter:stage-hunk)
				 ("C-x v r" . git-gutter:revert-hunk))
	:config
	(git-gutter:linum-setup)
	(cheatsheet-add-group 'GitGutter
												'(:key "C-F7" :description "Toggle gutter mode")
												'(:key "C-x v =" :description "Hunk popup")
												'(:key "C-x v n" :description "Next hunk")
												'(:key "C-x v p" :description "Previous hunk")
												'(:key "C-x v s" :description "Stage hunk")
												'(:key "C-x v r" :description "Revert hunk"))
	:init
	(custom-set-variables
	 '(git-gutter:diff-option "-w"))
	(custom-set-variables
	 '(git-gutter:update-interval 1)))
