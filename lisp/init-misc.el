;;----------------------------------------------------------------------------
;; Misc config - yet to be placed in separate files
;;----------------------------------------------------------------------------
(fset 'yes-or-no-p 'y-or-n-p)

;;  ---  Global Key Bindings   ---
(global-set-key (kbd "M-[")    'pop-global-mark)
(global-set-key (kbd "<menu>") 'buffer-menu)
(global-set-key (kbd "<apps>") 'buffer-menu)
(global-set-key (kbd "<C-268632080>") 'buffer-menu)
(global-set-key (kbd "M-p")    'helm-projectile)
(global-set-key (kbd "M-j")    'fd-name-dired)
(global-set-key (kbd "<home>") 'move-beginning-of-line)
(global-set-key (kbd "<end>")  'move-end-of-line)


(add-hook 'dired-after-readin-hook 'hl-line-mode)

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




(global-set-key (kbd "<s-right>")  'previous-code-buffer)
(global-set-key (kbd "<s-left>") 'next-code-buffer)


(global-set-key "\C-x2" (lambda () (interactive)(split-window-vertically) (previous-code-buffer)))
(global-set-key "\C-x3" (lambda () (interactive)(split-window-horizontally) (previous-code-buffer)))

(global-set-key [(control ?.)] 'goto-last-change)
(global-set-key [(control ?,)] 'goto-last-change-reverse)

(global-set-key (kbd "M-u") 'helm-bookmarks)

(add-hook 'json-mode-hook #'flycheck-mode)

(setq gc-cons-threshold 100000000)    ;; Performance enhancement
(setq read-process-output-max (* 1024 1024))

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(require 'p4) ;; C+x p e -> edit the file
;;export P4PORT=perforce3230:3230   set ENV in .bashrc
;;export P4CLIENT=pcode3230

(defun force-writable()
  (interactive)
  (change-file-to-writable)
  (revert-buffer))

(defun change-file-to-writable()
  (cond ((or (eq system-type 'ms-dos) (eq system-type 'windows-nt))
         (progn
           (shell-command-to-string (concat "attrib -R " (buffer-file-name (current-buffer))))
           ))
        ((or (eq system-type 'gnu/linux) (eq system-type 'darwin))
         (progn
           (shell-command-to-string (concat "chmod u+w " (buffer-file-name (current-buffer))))
           ))
        (t (message "file permission change not handle for OS %s" system-type))               
	)
  )

(setq bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)
;; (add-hook 'compilation-mode-hook (lambda() (font-lock-mode -1)))
(setq compilation-scroll-output nil)

(global-set-key (kbd "s-d")  (lambda ()(interactive)(dired (file-name-directory buffer-file-name))))

(provide 'init-misc)
