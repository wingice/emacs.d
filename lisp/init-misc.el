;;----------------------------------------------------------------------------
;; Misc config - yet to be placed in separate files
;;----------------------------------------------------------------------------
(fset 'yes-or-no-p 'y-or-n-p)

;;  ---  Global Key Bindings   ---
(global-set-key (kbd "M-[")    'pop-global-mark)
(global-set-key (kbd "<menu>") 'buffer-menu)
(global-set-key (kbd "<apps>") 'buffer-menu)
(global-set-key (kbd "M-p")    'helm-projectile)

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

(global-set-key "\C-w" 'clipboard-kill-region)
(global-set-key "\M-w" 'clipboard-kill-ring-save)
(global-set-key "\C-y" 'clipboard-yank)


(defun next-code-buffer ()
  (interactive)
  (let (( bread-crumb (buffer-name) ))
    (bs-cycle-next)
    (while
        (and
         (string-match-p "^\*" (buffer-name))
         (not ( equal bread-crumb (buffer-name) )) )
      (next-buffer))))

(defun previous-code-buffer ()
  (interactive)
  (let (( bread-crumb (buffer-name) ))
    (bs-cycle-previous)
    (while
        (and
         (string-match-p "^\*" (buffer-name))
         (not ( equal bread-crumb (buffer-name) )) )
      (previous-buffer))))




(global-set-key (kbd "<s-left>")  'previous-code-buffer)
(global-set-key (kbd "<s-right>") 'next-code-buffer)


(global-set-key "\C-x2" (lambda () (interactive)(split-window-vertically) (previous-code-buffer)))
(global-set-key "\C-x3" (lambda () (interactive)(split-window-horizontally) (previous-code-buffer)))

(global-set-key [(control ?.)] 'goto-last-change)
(global-set-key [(control ?,)] 'goto-last-change-reverse)

(global-set-key (kbd "M-u") 'helm-bookmarks)

(add-hook 'json-mode-hook #'flycheck-mode)

(setq gc-cons-threshold 100000000)    ;; Performance enhancement
(setq read-process-output-max (* 1024 1024))

(provide 'init-misc)
