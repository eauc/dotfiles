(defun eauc/align-array (s e)
  (interactive "r")
  (align-regexp s e "\\(\\s-*\\)\\(],\\|, \\)" 1 1 t))
