(let ((personal-settings "~/.emacs.d/lisp/local-conf-body.el"))
 (when (file-exists-p personal-settings)
   (load-file personal-settings))
)


(provide 'local-conf-tpl)

;;----------------- Reference for Per Computer Customization------------------------------
;;--- Windows ---
;; (add-to-list 'exec-path "c:/tools/msys64/usr/bin")
;; (setenv "PATH" (concat  "c:/tools/msys64/usr/bin;" (getenv "PATH")))
