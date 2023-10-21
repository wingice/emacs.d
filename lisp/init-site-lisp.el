;;; Set load path

(defconst emacs-dir "~/.emacs.d/" "The top-level emacs-configure directory.")
(defconst emacs-tmp-dir (concat emacs-dir "tmp/") "cache file directory.")
(defconst emacs-cache-dir (concat emacs-dir "tmp/cache/") "cache file directory.")
(defconst emacs-backup-dir (concat emacs-dir "tmp/backup/") "directory to backup files.")
(defconst emacs-autosave-dir (concat emacs-dir "tmp/autosave/") "directory to backup files.")

(defun server-ensure-safe-dir (dir) "Noop" t)
(setq server-socket-dir emacs-tmp-dir)
(cond
 ((eq (server-running-p) nil)
  (progn
    (message "Starting new server.")
    (server-start)))
 ((eq (server-running-p) :other)
  (let ((my-status 0))
    (ignore-errors
      (setq my-status (server-eval-at server-name (+ 1 1))))
    (if (/= my-status 2)
	(progn
	  (message "Killing stale socket, starting server.")
	  (server-force-delete)
	  (server-start))
      (message "Other server works."))))
 (t (message "Server already started.")))

(setq bookmark-default-file (concat emacs-cache-dir "bookmarks"))
(setq backup-directory-alist
        `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
        `((".*" ,emacs-autosave-dir t)))
(setq auto-save-list-file-prefix
        emacs-autosave-dir)

;;(setq bookmark-default-file (concat emacs-dir "tmp/bookmarks")
;;      bookmark-save-flag nil)

;; Packages: flx-ido company rinari flymake-ruby yasnippet projectile


;; overrride the default function....
(defun emacs-session-filename (SESSION-ID)
  (concat emacs-cache-dir SESSION-ID))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; find refences: cd ~/.emacs.d/elpa rg "require 'cl\)"
(setq byte-compile-warnings '(cl-functions))

(provide 'init-site-lisp)
