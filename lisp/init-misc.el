;;; init-misc.el --- Miscellaneous config  -*- lexical-binding: t; -*-
;;----------------------------------------------------------------------------
;; Misc config - yet to be placed in separate files
;;----------------------------------------------------------------------------

(setopt use-short-answers t)

;; Emacs 30: disable ispell in text-mode completion (interferes with company)
(setq text-mode-ispell-word-completion nil)

;;  ---  Global Key Bindings   ---
(global-set-key (kbd "M-[")    'pop-global-mark)
(global-set-key (kbd "<menu>") 'buffer-menu)
(global-set-key (kbd "<apps>") 'buffer-menu)
(global-set-key (kbd "<C-268632080>") 'buffer-menu)
(global-set-key (kbd "M-p")    'consult-projectile)
(global-set-key (kbd "M-j")    'fd-name-dired)
(global-set-key (kbd "<home>") 'move-beginning-of-line)
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

;; When called interactively with no active region, copy current line instead.
(put 'kill-ring-save 'interactive-form
     '(interactive
       (if (use-region-p)
           (list (region-beginning) (region-end))
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


(defun split-window-vertically-and-switch ()
  (interactive)
  (split-window-vertically)
  (previous-code-buffer))

(defun split-window-horizontally-and-switch ()
  (interactive)
  (split-window-horizontally)
  (previous-code-buffer))

(global-set-key "\C-x2" 'split-window-vertically-and-switch)
(global-set-key "\C-x3" 'split-window-horizontally-and-switch)

(global-set-key [(control ?.)] 'goto-last-change)
(global-set-key [(control ?,)] 'goto-last-change-reverse)

(setq read-process-output-max (* 4 1024 1024)) ; 4MB

;; Disable adaptive read buffering - proven pessimization (Emacs bug#75574)
;; Causes 8x perf regression in mixed read flows; will be nil by default in Emacs 31
(setq process-adaptive-read-buffering nil)

;; Prevent font cache compaction - reduces GC pauses (most impactful on Windows)
(setq inhibit-compacting-font-caches t)

;; Don't ping things that look like domain names (slows find-file-at-point)
(setq ffap-machine-p-known 'reject)

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(defun force-writable()
  (interactive)
  (change-file-to-writable)
  (revert-buffer nil t))

(defun change-file-to-writable()
  (let ((file (buffer-file-name)))
    (cond ((eq system-type 'windows-nt)
           (shell-command-to-string (concat "attrib -R " file)))
          ((memq system-type '(gnu/linux darwin))
           (shell-command-to-string (concat "chmod u+w " file)))
          (t (message "file permission change not handled for OS %s" system-type)))))

(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)
(setq save-interprogram-paste-before-kill t)
(setq kill-do-not-save-duplicates t)
(setq window-combination-resize t)
;; (add-hook 'compilation-mode-hook (lambda() (font-lock-mode -1)))
(setq compilation-scroll-output nil)

;; (use-package dired-ranger
;;   :bind (:map dired-mode-map
;;               ("W" . dired-ranger-copy)
;;               ("X" . dired-ranger-move)
;;               ("Y" . dired-ranger-paste)))

;;(global-set-key (kbd "s-d")  (lambda ()(interactive)(dired (file-name-directory buffer-file-name))))

(defun insert-uuid()
  "Insert a UUID using platform-appropriate tools."
  (interactive)
  (cond
   ((eq system-type 'windows-nt)
    (shell-command "pwsh.exe -Command [guid]::NewGuid().toString()" t))
   ((memq system-type '(darwin gnu/linux))
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
  :hook (dired-mode . dirvish-override-dired-mode)
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
  (setq dirvish-default-layout '(0 0.4 0.6))
  (setq dirvish-mode-line-format
         '(:left (sort symlink) :right (omit yank index)))
  (setq mouse-1-click-follows-link nil)
  (define-key dirvish-mode-map (kbd "<mouse-1>") 'dirvish-subtree-toggle-or-open)
  (define-key dirvish-mode-map (kbd "<mouse-2>") 'dired-mouse-find-file-other-window)
  (define-key dirvish-mode-map (kbd "<mouse-3>") 'dired-mouse-find-file)
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
  :lighter "keym")

(my-keys-minor-mode 1) ; Enable the minor mode globally


;;; --- Git Review: scan workspace dirs for uncommitted repos ---

(defvar git-review-workspace-dirs
  (if *is-a-mac*
      '("~/sapdevelop" "~/workspace")
    '("c:/workspace" "c:/sapdevelop"))
  "Directories to scan for git repositories.")

(defvar git-review-max-depth 3
  "Maximum directory depth to recurse when scanning for git repos.")

(defvar git-review--fd-path (executable-find "fd")
  "Cached path to fd executable, or nil.")

(defun git-review--find-repos (dir)
  "Find git repos under DIR using fd, falling back to manual walk."
  (when (file-directory-p dir)
    (let ((dir (file-name-as-directory (expand-file-name dir))))
      (if git-review--fd-path
          (let ((default-directory dir))
            (mapcar (lambda (p)
                      (file-name-directory
                       (expand-file-name (directory-file-name (string-trim p)) dir)))
                    (split-string
                     (shell-command-to-string
                      (format "%s -td --hidden --no-ignore --max-depth %d -g .git ."
                              (shell-quote-argument git-review--fd-path)
                              git-review-max-depth))
                     "\n" t)))
        (let (repos)
          (cl-labels ((walk (d depth)
                        (cond
                         ((file-directory-p (expand-file-name ".git" d)) (push d repos))
                         ((< depth git-review-max-depth)
                          (dolist (sub (directory-files d t "\\`[^.]" t))
                            (when (file-directory-p sub)
                              (walk sub (1+ depth))))))))
            (walk dir 0))
          (nreverse repos))))))

(defun git-review--dirty-status (repo)
  "Return porcelain status string for REPO if dirty, nil if clean."
  (let* ((default-directory (file-name-as-directory repo))
         (out (with-output-to-string
                (with-current-buffer standard-output
                  (call-process "git" nil t nil "status" "--porcelain")))))
    (let ((trimmed (string-trim out)))
      (unless (string-empty-p trimmed) trimmed))))

(defun git-review--scan-all ()
  "Return (dirty . clean) cons: dirty is alist of (repo . status), clean is list of repos."
  (let (all-repos dirty clean (home (expand-file-name "~")))
    ;; Collect repos from workspace dirs
    (dolist (dir git-review-workspace-dirs)
      (setq all-repos (nconc all-repos (git-review--find-repos dir))))
    ;; Collect dotfile repos under ~
    (dolist (f (directory-files home t "\\`\\." t))
      (when (and (file-directory-p f)
                 (file-directory-p (expand-file-name ".git" f)))
        (push f all-repos)))
    ;; Check each repo
    (dolist (repo all-repos)
      (let ((s (git-review--dirty-status repo)))
        (if s (push (cons repo s) dirty)
          (push repo clean))))
    (cons (nreverse dirty) (nreverse clean))))

(defun git-review--repo-at-point ()
  "Return repo path for section at point."
  (or (get-text-property (line-beginning-position) 'git-review-repo)
      (save-excursion
        (while (and (not (get-text-property (point) 'git-review-repo))
                    (not (bobp)))
          (forward-line -1))
        (get-text-property (point) 'git-review-repo))))

(defun git-review-commit ()
  "Stage all and commit the repo at point."
  (interactive)
  (if-let ((repo (git-review--repo-at-point)))
      (let ((default-directory (file-name-as-directory repo))
            (name (file-name-nondirectory (directory-file-name repo))))
        (when (yes-or-no-p (format "Stage+commit all in %s?" name))
          (shell-command-to-string "git add -A")
          (let ((msg (read-string (format "Commit [%s]: " name))))
            (if (string-empty-p msg)
                (message "Aborted.")
              (message "%s" (string-trim
                             (shell-command-to-string
                              (format "git commit -m %s" (shell-quote-argument msg)))))
              (git-review)))))
    (message "No repo at point.")))

(defun git-review-shell ()
  "Open shell in the repo at point on the right half."
  (interactive)
  (if-let ((repo (git-review--repo-at-point)))
      (let ((default-directory (file-name-as-directory repo)))
        (select-window (split-window-right))
        (shell (generate-new-buffer-name "*git-shell*")))
    (message "No repo at point.")))

(defun git-review-dired ()
  "Open dired for repo at point."
  (interactive)
  (if-let ((repo (git-review--repo-at-point)))
      (dired repo)
    (message "No repo at point.")))

(defun git-review-next ()
  "Move to next repo."
  (interactive)
  (when-let ((pos (next-single-property-change (line-end-position) 'git-review-repo)))
    (goto-char pos) (beginning-of-line)))

(defun git-review-prev ()
  "Move to previous repo."
  (interactive)
  (when-let ((pos (previous-single-property-change (line-beginning-position) 'git-review-repo)))
    (goto-char (1- pos))
    (goto-char (or (previous-single-property-change (point) 'git-review-repo) (point-min)))
    (beginning-of-line)))

(defvar git-review-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "c" #'git-review-commit)
    (define-key map "s" #'git-review-shell)
    (define-key map "d" #'git-review-dired)
    (define-key map "n" #'git-review-next)
    (define-key map "p" #'git-review-prev)
    (define-key map "q" #'quit-window)
    map))

(define-derived-mode git-review-mode special-mode "GitReview"
  "Mode for reviewing dirty git repos.\\{git-review-mode-map}")

(defun git-review ()
  "Scan workspace dirs for git repos with uncommitted changes."
  (interactive)
  (message "Scanning...")
  (let* ((scan (git-review--scan-all))
         (dirty (car scan))
         (clean (cdr scan))
         (buf (get-buffer-create "*Git Review*")))
    (with-current-buffer buf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (git-review-mode)
        (if (null dirty)
            (insert "All clean.\n\n")
          (insert (format "%d dirty repo(s):\n\n" (length dirty)))
          (pcase-dolist (`(,repo . ,status) dirty)
            (insert (propertize (format "▶ %s\n" repo)
                                'face 'font-lock-keyword-face
                                'git-review-repo repo))
            (dolist (line (split-string status "\n" t))
              (insert (format "    %s\n" line)))
            (insert "\n")))
        ;; Clean repos at bottom
        (when clean
          (insert (propertize (format "--- %d clean repo(s) ---\n" (length clean))
                              'face 'font-lock-comment-face))
          (dolist (repo clean)
            (insert (format "  %s\n" repo))))))
    (switch-to-buffer buf)
    (goto-char (point-min))
    (message "c=commit s=shell d=dired n/p=nav q=quit")))

(provide 'init-misc)
