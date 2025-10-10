;;----------------------------------------------------------------------------
;; Misc config - yet to be placed in separate files
;;----------------------------------------------------------------------------

(setopt use-short-answers t)

;;  ---  Global Key Bindings   ---
(global-set-key (kbd "M-[")    'pop-global-mark)
(global-set-key (kbd "<menu>") 'buffer-menu)
(global-set-key (kbd "<apps>") 'buffer-menu)
(global-set-key (kbd "<C-268632080>") 'buffer-menu)
(global-set-key (kbd "M-p")    'consult-projectile)
(global-set-key (kbd "M-j")    'fd-name-dired)
(global-set-key (kbd "<home>") 'move-beginning-of-line)
(global-set-key (kbd "<end>")  'move-end-of-line)
(global-set-key (kbd "<end>")  'move-end-of-line)
;;(add-hook 'dired-after-readin-hook 'hl-line-mode)
(global-set-key [f10] 'toggle-menu-bar-mode-from-frame)

(define-key context-menu-mode-map (kbd "<apps>") 'buffer-menu)
(define-key context-menu-mode-map (kbd "<menu>") 'buffer-menu)

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

(add-hook 'json-mode-hook #'flycheck-mode)

(setq read-process-output-max (* 1024 1024))

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

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

;; (use-package dired-ranger
;;   :bind (:map dired-mode-map
;;               ("W" . dired-ranger-copy)
;;               ("X" . dired-ranger-move)
;;               ("Y" . dired-ranger-paste)))

;;(global-set-key (kbd "s-d")  (lambda ()(interactive)(dired (file-name-directory buffer-file-name))))

(defun insert-uuid()
  "Insert a UUID. This commands calls “uuidgen” on MacOS, Linux, and calls PowelShell on Microsoft Windows."
  (interactive)
  (cond
   ((string-equal system-type "windows-nt")
    (shell-command "pwsh.exe -Command [guid]::NewGuid().toString()" t))
   ((string-equal system-type "darwin") ; Mac
    (shell-command "uuidgen" t))
   ((string-equal system-type "gnu/linux")
    (shell-command "uuidgen" t))
   (t
    ;; code here by Christopher Wellons, 2011-11-18.
    ;; and editted Hideki Saito further to generate all valid variants for "N" in xxxxxxxx-xxxx-Mxxx-Nxxx-xxxxxxxxxxxx format.
    (let ((myStr (md5 (format "%s%s%s%s%s%s%s%s%s%s"
                              (user-uid)
                              (emacs-pid)
                              (system-name)
                              (user-full-name)
                              (current-time)
                              (emacs-uptime)
                              (garbage-collect)
                              (buffer-string)
                              (random)
                              (recent-keys)))))
      (insert (format "%s-%s-4%s-%s%s-%s"
                      (substring myStr 0 8)
                      (substring myStr 8 12)
                      (substring myStr 13 16)
                      (format "%x" (+ 8 (random 4)))
                      (substring myStr 17 20)
                      (substring myStr 20 32)))))))

    (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
    (global-set-key (kbd "C-+") 'mc/mark-next-like-this)
    (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
    (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)



(use-package dirvish
  :defer t
  :ensure t
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-preview-disabled-exts '("bin" "exe" "gpg" "elc" "eln" "dll" "so" "docx" "pptx" "xlsx"))
  (dirvish-quick-access-entries ; It's a custom option, `setq' won't work
   '(("h" "~/"                          "Home")
     ("/" "/"                "/")
     ("d" "~/Downloads/"                "Downloads")
     ("w" "~/../../workspace"           "Drives")))
  :config
  ;; (dirvish-peek-mode)             ; Preview files in minibuffer
  ;; (dirvish-side-follow-mode)      ; similar to `treemacs-follow-mode'
  ;; open large directory (over 20000 files) asynchronously with `fd' command
  (setq dirvish-large-directory-threshold 20000)
   (setq dirvish-mode-line-format
         '(:left (sort symlink) :right (omit yank index)))
  :bind ; Bind `dirvish-fd|dirvish-side|dirvish-dwim' as you see fit
  (
   :map dirvish-mode-map               ; Dirvish inherits `dired-mode-map'
   (";"   . dired-up-directory)        ; So you can adjust `dired' bindings here
   ("?"   . dirvish-dispatch)          ; [?] a helpful cheatsheet
   ("a"   . dirvish-setup-menu)        ; [a]ttributes settings:`t' toggles mtime, `f' toggles fullframe, etc.
   ("f"   . dirvish-file-info-menu)    ; [f]ile info
   ("o"   . dirvish-quick-access)      ; [o]pen `dirvish-quick-access-entries'
   ("r"   . dirvish-history-jump)      ; [r]ecent visited
   ("*"   . dirvish-mark-menu)
   ("y"   . dirvish-yank-menu)
   ("N"   . dirvish-narrow)
   ("^"   . dirvish-history-last)
   ("TAB" . dirvish-subtree-toggle)
   ("M-f" . dirvish-history-go-forward)
   ("M-b" . dirvish-history-go-backward)
   ("M-e" . dirvish-emerge-menu)))

(setq mouse-1-click-follows-link nil)
(define-key dirvish-mode-map (kbd "<mouse-1>") 'dirvish-subtree-toggle-or-open)
(define-key dirvish-mode-map (kbd "<mouse-2>") 'dired-mouse-find-file-other-window)
(define-key dirvish-mode-map (kbd "<mouse-3>") 'dired-mouse-find-file)
(setq delete-by-moving-to-trash t)
;; Short guide for Dirvish/Dired
;; - Open file externally in dired, press "W",  Which runs (browse-url-of-dired-file) and seems to open the file or directory in the default application.
;; - Want to run in a shell,        press "&", then "start ""
;; - Open favorite folders,         press "o"
;; - Open Recent folder/history     press "r"
;; - Open a folder                  press "C+x d"


(defvar my-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M-p") 'consult-projectile)
    map)
  "my-keys-minor-mode keymap.")

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  :global t
  :init-value t
  :lighter " mykeys")

(my-keys-minor-mode 1) ; Enable the minor mode globally


(provide 'init-misc)
