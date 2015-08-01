;;; Set load path

(defconst emacs-dir "~/.emacs.d/" "The top-level emacs-configure directory.")
(defconst emacs-cache-dir (concat emacs-dir "tmp/cache/") "cache file directory.")
(defconst emacs-backup-dir (concat emacs-dir "tmp/backup/") "directory to backup files.")
(defconst emacs-bookmark-file (concat emacs-cache-dir "bookmarks") "File to save bookmarks")

(setq auto-save-list-file-prefix (concat emacs-backup-dir "auto-save-list/"))
(setq backup-directory-alist `(("." . "~/.emacs.d/tmp/backup/auto-save-list")))

;; overrride the default function....
(defun emacs-session-filename (SESSION-ID)
  (concat emacs-cache-dir SESSION-ID))


(eval-when-compile (require 'cl))
(defun add-subdirs-to-load-path (parent-dir)
  "Adds every non-hidden subdir of PARENT-DIR to `load-path'."
  (let* ((default-directory parent-dir))
    (progn
      (setq load-path
            (append
             (loop for dir in (directory-files parent-dir)
                   unless (string-match "^\\." dir)
                   collecting (expand-file-name dir))
             load-path)))))

(provide 'init-site-lisp)
