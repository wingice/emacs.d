;;; Set load path

(defconst emacs-dir "~/.emacs.d/" "The top-level emacs-configure directory.")
(defconst emacs-tmp-dir (concat emacs-dir "tmp/") "cache file directory.")
(defconst emacs-cache-dir (concat emacs-dir "tmp/cache/") "cache file directory.")
(defconst emacs-backup-dir (concat emacs-dir "tmp/backup/") "directory to backup files.")
(defconst emacs-autosave-dir (concat emacs-dir "tmp/autosave/") "directory to backup files.")

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

(provide 'init-site-lisp)
