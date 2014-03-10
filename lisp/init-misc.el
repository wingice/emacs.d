;;----------------------------------------------------------------------------
;; Misc config - yet to be placed in separate files
;;----------------------------------------------------------------------------
(fset 'yes-or-no-p 'y-or-n-p)

;;  ---  Global Key Bindings   ---
(global-set-key (kbd "M-[")   'pop-global-mark)
(global-set-key (kbd "<menu>") 'buffer-menu)

;;(setq make-backup-files nil)

(setq
   backup-by-copying t      ; don't clobber symlinks
   delete-old-versions t
   kept-new-versions 3
   kept-old-versions 2
   version-control t)       ; use versioned backups

(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive (if mark-active (list (region-beginning) (region-end))
                (list (line-beginning-position) (line-beginning-position 2)))))

(provide 'init-misc)