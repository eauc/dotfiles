(use-package restclient
  :ensure t
  :pin melpa
  :mode ("\\.http\\'" . restclient-mode)
  :config
  (cheatsheet-add-group 'Restclient
                        '(:key "C-c C-c" :description "Run query under point & switch focus")
                        '(:key "C-c C-v" :description "Run query under point")
                        '(:key "C-c C-p" :description "Previous query")
                        '(:key "C-c C-n" :description "Next query")
                        '(:key "C-c C-." :description "Mark query under point")
                        '(:key "C-c C-u" :description "Copy query under point as CURL")))
