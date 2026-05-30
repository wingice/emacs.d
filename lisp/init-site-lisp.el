;;; init-site-lisp.el --- Site lisp setup  -*- lexical-binding: t; -*-
;;; Set load path

(defconst emacs-dir "~/.emacs.d/" "The top-level emacs-configure directory.")
(defconst emacs-tmp-dir (concat emacs-dir "tmp/") "cache file directory.")
(defconst emacs-cache-dir (concat emacs-dir "tmp/cache/") "cache file directory.")
(defconst emacs-backup-dir (concat emacs-dir "tmp/backup/") "directory to backup files.")
(defconst emacs-autosave-dir (concat emacs-dir "tmp/autosave/") "directory to backup files.")

(defun home-path (relative-path)
  "Expand RELATIVE-PATH under the user's home directory.
Portable across Windows, macOS, and Linux."
  (expand-file-name relative-path "~"))

;; GC threshold is set in early-init.el (high during init, restored after startup)

(setq server-socket-dir emacs-tmp-dir)
(setq server-auth-dir emacs-tmp-dir)
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

;; emacsclient batch command ec.cmd
;; <home>\scoop\shims\emacsclientw.exe -f <home>\.emacs.d\tmp\server -n -a <home>\scoop\shims\runemacs.exe "%*"

(setq bookmark-default-file (concat emacs-cache-dir "bookmarks"))
(setq backup-directory-alist
        `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
        `((".*" ,emacs-autosave-dir t)))
(setq auto-save-list-file-prefix
        emacs-autosave-dir)

(defun refresh-package-quickstart ()
  "Refresh package quickstart cache after package changes."
  (interactive)
  (package-quickstart-refresh)
  (message "Refreshed package quickstart cache"))

;;(setq bookmark-default-file (concat emacs-dir "tmp/bookmarks")
;;      bookmark-save-flag nil)

;; overrride the default function....
(defun emacs-session-filename (SESSION-ID)
  (concat emacs-cache-dir SESSION-ID))

(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; find refences: cd ~/.emacs.d/elpa rg "require 'cl\)"
(setq byte-compile-warnings '(cl-functions))

;; Windows: larger pipe buffer for faster subprocess I/O (projectile, compilation, etc.)
(when (eq system-type 'windows-nt)
  (setq w32-pipe-buffer-size (* 64 1024)))

(provide 'init-site-lisp)
