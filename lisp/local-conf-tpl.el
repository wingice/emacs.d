(let ((personal-settings "~/.emacs.d/lisp/local-conf-body.el"))
 (when (file-exists-p personal-settings)
   (load-file personal-settings))
)

(provide 'local-conf-tpl)
