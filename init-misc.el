;;----------------------------------------------------------------------------
;; Misc config - yet to be placed in separate files
;;----------------------------------------------------------------------------
(fset 'yes-or-no-p 'y-or-n-p)

;;  ---  Global Key Bindings   ---
(global-set-key (kbd "M-[")   'pop-global-mark)
(global-set-key (kbd "<menu>") 'buffer-menu)

(setq make-backup-files nil)

(setq auto-save-list-file-prefix "~/.emacs.d/tmp/")
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '((".*" . "~/.emacs.d/tmp/backup"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 3
   kept-old-versions 2
   version-control t)       ; use versioned backups

(setq auto-save-file-name-transforms
          `((".*", "~/.emacs.d/tmp/backup" t)))







(provide 'init-misc)
