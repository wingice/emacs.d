;;; Set load path

(defconst emacs-dir "~/.emacs.d/" "The top-level emacs-configure directory.")
(defconst emacs-tmp-dir (concat emacs-dir "tmp/") "cache file directory.")
(defconst emacs-cache-dir (concat emacs-dir "tmp/cache/") "cache file directory.")
(defconst emacs-backup-dir (concat emacs-dir "tmp/backup/") "directory to backup files.")

(setq bookmark-default-file (concat emacs-cache-dir "bookmarks"))
(setq auto-save-list-file-prefix (concat emacs-backup-dir "auto-save-list/"))
(setq backup-directory-alist `(("." . "~/.emacs.d/tmp/backup/auto-save-list")))

;; overrride the default function....
(defun emacs-session-filename (SESSION-ID)
  (concat emacs-cache-dir SESSION-ID))


;;(setq bookmark-default-file (concat emacs-dir "tmp/bookmarks")
;;      bookmark-save-flag nil)

;; Packages: flx-ido company rinari flymake-ruby yasnippet projectile

(provide 'init-site-lisp)
