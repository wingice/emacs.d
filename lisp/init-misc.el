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


;;; --- Repo Review: cross-repo dashboard for dirty git worktrees ---
;;
;; `M-x repo-review' scans `repo-review-workspace-dirs' (plus dotfile
;; repos under $HOME) and lists every repo with uncommitted changes.
;; From that buffer:
;;
;;   c    commit           d  diff (side window)   D  diff --staged
;;   f    dired            s  eshell               r  restore tracked
;;   DEL  clean untracked  n/p  next/prev repo     g  refresh   q  quit
;;
;; Every destructive action prompts.  `git clean' is scoped to a
;; single file — directories go through `f' + dired.

(defvar repo-review-workspace-dirs
  (if *is-a-mac*
      '("~/sapdevelop" "~/workspace")
    '("c:/workspace" "c:/sapdevelop"))
  "Directories to scan for git repositories.")

(defvar repo-review-max-depth 3
  "Maximum directory depth when scanning for git repos.")

(defvar repo-review-ignored-repos
  '("~/.orgfiles" "c:/workspace/orgfiles")
  "Repo paths excluded from `repo-review'.
Compared after `expand-file-name' + `file-name-as-directory' so `~',
backslashes, and trailing slashes all normalize.")

(defconst repo-review--fd (executable-find "fd")
  "Path to fd binary, or nil.  Cached at load time.")

;; Forward-declare — eshell.el `defvar's this as dynamic; without the
;; declaration our lexical-binding `let' would shadow it lexically and
;; the byte-compiler would warn about the mismatch.
(defvar eshell-buffer-name)

(defconst repo-review--keys
  (mapconcat (pcase-lambda (`(,k . ,label))
               (concat (propertize k 'face 'help-key-binding) "=" label))
             '(("c" . "commit") ("d" . "diff")    ("D" . "diff-staged")
               ("f" . "dired")  ("s" . "eshell")  ("r" . "restore")
               ("DEL" . "clean-file")
               ("n" . "next")   ("p" . "prev")
               ("g" . "refresh") ("q" . "quit"))
             "  ")
  "Propertized display string of key bindings for the header line.")

;; -------- Discovery --------

(defun repo-review--normalize (p)
  "Return P as an absolute directory path with trailing slash."
  (file-name-as-directory (expand-file-name p)))

(defun repo-review--find-repos (dir)
  "Find git repos under DIR using fd, falling back to a manual walk."
  (when (file-directory-p dir)
    (let ((dir (repo-review--normalize dir)))
      (if repo-review--fd
          (let* ((default-directory dir)
                 (out (with-output-to-string
                        (with-current-buffer standard-output
                          (call-process
                           repo-review--fd nil t nil
                           "-td" "--hidden" "--no-ignore"
                           "--max-depth" (number-to-string repo-review-max-depth)
                           "-g" ".git" ".")))))
            (mapcar (lambda (p)
                      (file-name-directory
                       (expand-file-name (directory-file-name p) dir)))
                    (split-string out "\n" t)))
        (let (repos)
          (cl-labels ((walk (d depth)
                        (cond
                         ((file-directory-p (expand-file-name ".git" d))
                          (push (file-name-as-directory d) repos))
                         ((< depth repo-review-max-depth)
                          (dolist (sub (directory-files d t "\\`[^.]" t))
                            (when (file-directory-p sub)
                              (walk sub (1+ depth))))))))
            (walk dir 0))
          (nreverse repos))))))

(defun repo-review--collect-repos ()
  "Return deduplicated, non-ignored, absolute repo paths in scan order."
  (let* ((home (expand-file-name "~"))
         (ignored (mapcar #'repo-review--normalize repo-review-ignored-repos))
         (workspaces (mapcan #'repo-review--find-repos
                             repo-review-workspace-dirs))
         (dotdirs
          (delq nil
                (mapcar (lambda (f)
                          (and (file-directory-p f)
                               (file-directory-p (expand-file-name ".git" f))
                               (file-name-as-directory f)))
                        (directory-files home t "\\`\\." t))))
         (seen (make-hash-table :test 'equal))
         result)
    (dolist (repo (append workspaces dotdirs))
      (let ((norm (repo-review--normalize repo)))
        (unless (or (gethash norm seen) (member norm ignored))
          (puthash norm t seen)
          (push norm result))))
    (nreverse result)))

;; -------- Git wrapper + serial scan --------

(defun repo-review--git (repo &rest args)
  "Run `git' in REPO with ARGS; return output with trailing newlines stripped.
Leading whitespace is preserved — `git status --porcelain' emits status
codes like \" M path\" whose leading space is part of the format.
Non-zero exit yields a string prefixed with `git error (CODE):'."
  (let ((default-directory (file-name-as-directory repo)))
    (with-temp-buffer
      (let* ((code (apply #'call-process "git" nil t nil args))
             (text (replace-regexp-in-string "\n+\\'" "" (buffer-string))))
        (if (zerop code) text
          (format "git error (%d): %s" code (string-trim text)))))))

(defun repo-review--scan-all ()
  "Return (DIRTY . CLEAN).  DIRTY is (REPO . porcelain) alist."
  (let (dirty clean)
    (dolist (repo (repo-review--collect-repos))
      (let ((status (repo-review--git repo "status" "--porcelain")))
        (if (string-empty-p status)
            (push repo clean)
          (push (cons repo status) dirty))))
    (cons (nreverse dirty) (nreverse clean))))

;; -------- Point / property helpers --------

(defun repo-review--repo-at-point ()
  "Return the repo path owning the section at point, or nil."
  (or (get-text-property (line-beginning-position) 'repo-review-repo)
      (save-excursion
        (while (and (not (get-text-property (point) 'repo-review-repo))
                    (not (bobp)))
          (forward-line -1))
        (get-text-property (point) 'repo-review-repo))))

(defun repo-review--file-at-point ()
  "Return (REPO FILE STATUS) for the status line at point, or nil.
STATUS is the 2-char porcelain code, e.g. \" M\", \"??\", \"R \"."
  (let ((bol (line-beginning-position)))
    (when-let ((repo (repo-review--repo-at-point))
               (file (get-text-property bol 'repo-review-file)))
      (list repo file (get-text-property bol 'repo-review-status)))))

(defun repo-review--parse-porcelain-path (line)
  "Return the pathname from a `git status --porcelain' LINE, or nil.
Format: `XY SP PATH' or `XY SP OLD -> NEW' (returns NEW).  Quoted
paths are unquoted."
  (when (and (stringp line) (>= (length line) 4))
    (let* ((rest   (substring line 3))
           (rename (string-match " -> " rest))
           (path   (string-trim (if rename (substring rest (+ rename 4)) rest))))
      (if (and (>= (length path) 2)
               (eq (aref path 0) ?\")
               (eq (aref path (1- (length path))) ?\"))
          (substring path 1 -1)
        path))))

;; -------- Actions --------

(defun repo-review-commit ()
  "Prompt for a message, then `git add -A' + `git commit'.
Aborts *before* staging when the message is empty.
Does not refresh; press \\`g' when you want an updated status."
  (interactive)
  (if-let ((repo (repo-review--repo-at-point)))
      (let* ((name (file-name-nondirectory (directory-file-name repo)))
             (msg  (string-trim
                    (read-string
                     (format "Commit [%s] (empty to abort): " name)))))
        (if (string-empty-p msg)
            (message "Aborted; nothing staged.")
          (repo-review--git repo "add" "-A")
          (message "%s" (repo-review--git repo "commit" "-m" msg))))
    (message "No repo at point.")))

(defun repo-review-diff (&optional staged)
  "Show `git diff' for the repo at point in a `diff-mode' side window.
With prefix ARG, show the staged diff.

In the resulting buffer: \\`q' buries + closes the window,
\\`k' also kills the buffer.  Other keys keep `diff-mode' behavior."
  (interactive "P")
  (if-let ((repo (repo-review--repo-at-point)))
      (let* ((name (file-name-nondirectory (directory-file-name repo)))
             (buf  (get-buffer-create
                    (format "*repo-diff: %s%s*"
                            name (if staged " [staged]" "")))))
        (with-current-buffer buf
          (setq default-directory (file-name-as-directory repo))
          (let ((inhibit-read-only t))
            (erase-buffer)
            (let ((code (apply #'call-process
                               "git" nil t nil
                               `("-c" "color.ui=never" "diff" "--no-ext-diff"
                                 ,@(and staged '("--staged"))))))
              (cond
               ((not (zerop code))
                (let ((out (buffer-string)))
                  (erase-buffer)
                  (insert (format "git exited with code %d\n\n%s" code out))))
               ((zerop (buffer-size))
                (insert (format "No %sstaged changes in %s.\n"
                                (if staged "" "un") name)))
               (t (diff-mode))))
            (goto-char (point-min)))
          ;; Quick-close keys layered on top of whatever mode we ended in.
          (let ((map (make-sparse-keymap)))
            (set-keymap-parent map (current-local-map))
            (define-key map (kbd "q") #'quit-window)
            (define-key map (kbd "k") #'kill-buffer-and-window)
            (use-local-map map)))
        (display-buffer buf '(display-buffer-in-side-window
                              (side . right) (window-width . 0.5))))
    (message "No repo at point.")))

(defun repo-review-diff-staged ()
  "Show `git diff --staged' for the repo at point."
  (interactive)
  (repo-review-diff t))

(defun repo-review-eshell ()
  "Open an eshell in the repo at point.

If a `*repo-eshell: NAME*' buffer is already visible, jump to its
window.  Otherwise split right and show the buffer there — creating
and initialising a fresh one if none exists.

Eshell's own display logic is sandboxed via `save-window-excursion',
so nothing else in this frame's layout gets disturbed."
  (interactive)
  (if-let ((repo (repo-review--repo-at-point)))
      (let* ((default-directory (file-name-as-directory repo))
             (name    (file-name-nondirectory (directory-file-name repo)))
             (bufname (format "*repo-eshell: %s*" name))
             (buf     (get-buffer bufname)))
        ;; Initialise a fresh eshell buffer off-layout, so its own
        ;; `pop-to-buffer-same-window' can't touch our windows.
        (unless buf
          (save-window-excursion
            (let ((eshell-buffer-name bufname))
              (eshell)))
          (setq buf (get-buffer bufname)))
        ;; Display: reuse the buffer's window if any, else split right.
        (if-let ((w (get-buffer-window buf)))
            (select-window w)
          (select-window (split-window-right))
          (switch-to-buffer buf)))
    (message "No repo at point.")))

(defun repo-review-dired ()
  "Open dired for the repo at point."
  (interactive)
  (if-let ((repo (repo-review--repo-at-point)))
      (dired repo)
    (message "No repo at point.")))

(defun repo-review-restore ()
  "Discard unstaged changes to the tracked FILE on the current line.
Refuses untracked entries — press <delete> to clean one of those.
Does not refresh; press \\`g' when you want an updated status."
  (interactive)
  (pcase (repo-review--file-at-point)
    (`(,repo ,file ,status)
     (if (and (stringp status) (string-prefix-p "??" status))
         (message "%s is untracked; press <delete> to remove it." file)
       (when (yes-or-no-p (format "Discard unstaged changes to %s? " file))
         (message "%s" (repo-review--git repo "restore" "--" file)))))
    (_ (message "Point is not on a file line."))))

(defun repo-review-clean-file ()
  "Delete the untracked FILE on the current line via `git clean -f'.
Refuses directories and tracked entries.  Irrecoverable; prompts first.
Does not refresh; press \\`g' when you want an updated status."
  (interactive)
  (pcase (repo-review--file-at-point)
    (`(,repo ,file ,status)
     (cond
      ((not (and (stringp status) (string-prefix-p "??" status)))
       (message "%s is tracked; press `r' to restore it." file))
      ((string-suffix-p "/" file)
       (message "%s is a directory; use dired to remove it." file))
      (t
       (when (yes-or-no-p (format "DELETE untracked file %s? " file))
         (message "%s" (repo-review--git repo "clean" "-f" "--" file))))))
    (_ (message "Point is not on a file line."))))

;; -------- Navigation --------

(defun repo-review--goto-header (step)
  "Move STEP repo headers forward (positive) or backward (negative)."
  (let ((count (abs step))
        (dir   (if (> step 0) 1 -1))
        (start (point)))
    (while (and (> count 0) (zerop (forward-line dir)))
      (when (get-text-property (point) 'repo-review-header)
        (setq count (1- count))))
    (unless (zerop count)
      (goto-char start)
      (message "No more repos."))))

(defun repo-review-next () "Move to the next repo header."
       (interactive) (repo-review--goto-header  1))
(defun repo-review-prev () "Move to the previous repo header."
       (interactive) (repo-review--goto-header -1))

;; -------- Mode / entry point --------

(defvar repo-review-mode-map
  (let ((map (make-sparse-keymap)))
    (dolist (b '(("c" . repo-review-commit)
                 ("d" . repo-review-diff)
                 ("f" . repo-review-dired)
                 ("s" . repo-review-eshell)
                 ("r" . repo-review-restore)
                 ("<delete>" . repo-review-clean-file)
                 ("DEL"      . repo-review-clean-file)
                 ("D" . repo-review-diff-staged)
                 ("n" . repo-review-next)
                 ("p" . repo-review-prev)
                 ("g" . repo-review)
                 ("q" . quit-window)))
      (define-key map (kbd (car b)) (cdr b)))
    map))

(define-derived-mode repo-review-mode special-mode "RepoReview"
  "Mode for reviewing dirty git repos.\\{repo-review-mode-map}"
  (setq header-line-format repo-review--keys))

(defun repo-review--render (dirty clean buf)
  "Populate BUF with DIRTY (alist) and CLEAN (list) sections."
  (with-current-buffer buf
    (let ((inhibit-read-only t))
      (erase-buffer)
      (repo-review-mode)
      (if (null dirty)
          (insert "All clean.\n\n")
        (insert (format "%d dirty repo(s):\n\n" (length dirty)))
        (pcase-dolist (`(,repo . ,status) dirty)
          (insert (propertize (format "▶ %s\n" repo)
                              'face 'font-lock-keyword-face
                              'repo-review-repo repo
                              'repo-review-header t))
          (dolist (line (split-string status "\n" t))
            (insert (propertize
                     (format "    %s\n" line)
                     'repo-review-repo repo
                     'repo-review-file (repo-review--parse-porcelain-path line)
                     'repo-review-status (and (>= (length line) 2)
                                              (substring line 0 2)))))
          (insert "\n")))
      (when clean
        (insert (propertize (format "--- %d clean repo(s) ---\n" (length clean))
                            'face 'font-lock-comment-face))
        (dolist (repo clean)
          (insert (propertize (format "  %s\n" repo)
                              'repo-review-repo repo)))))))

(defun repo-review--restore-point (prev)
  "Move point to the header for repo PREV in the current buffer, if present."
  (when prev
    (let ((pos (point-min)) match)
      (while (and (not match) pos)
        (if (equal prev (get-text-property pos 'repo-review-repo))
            (setq match pos)
          (setq pos (next-single-property-change pos 'repo-review-repo))))
      (when match (goto-char match)))))

(defun repo-review ()
  "Scan workspace dirs for git repos with uncommitted changes.
Preserves the repo under point when refreshed from the review buffer."
  (interactive)
  (message "Scanning %s and ~/.<dotdirs> ..."
           (mapconcat #'identity repo-review-workspace-dirs ", "))
  (let* ((t0    (float-time))
         (prev  (and (get-buffer "*Repo Review*")
                     (with-current-buffer "*Repo Review*"
                       (repo-review--repo-at-point))))
         (scan  (repo-review--scan-all))
         (dirty (car scan))
         (clean (cdr scan))
         (buf   (get-buffer-create "*Repo Review*")))
    (repo-review--render dirty clean buf)
    (switch-to-buffer buf)
    (goto-char (point-min))
    (repo-review--restore-point prev)
    (message "%s   (%d dirty, %d clean, %.2fs)"
             repo-review--keys
             (length dirty) (length clean) (- (float-time) t0))))

(provide 'init-misc)
