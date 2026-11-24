;;; init-files.el --- File reload and conflict-saving behavior -*- lexical-binding: t; -*-

(require 'autorevert)

;; Storage paths are initialized by init-site-lisp before this module loads.
(setq backup-directory-alist
        `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
        `((".*" ,emacs-autosave-dir t)))
(setq auto-save-list-file-prefix
        emacs-autosave-dir)
(setq
   backup-by-copying t      ; don't clobber symlinks
   delete-old-versions t
   kept-new-versions 3
   kept-old-versions 2
   version-control t)       ; use versioned backups
(add-hook 'before-save-hook #'delete-trailing-whitespace)
;; Don't ping things that look like domain names (slows find-file-at-point)
(setq ffap-machine-p-known 'reject)
(setq delete-by-moving-to-trash t)
(global-set-key [f5] 'revert-buffer)
(setq auto-revert-interval 0.5)

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

(defun save-conflict-as ()
  "Save to a suggested timestamped filename; skip non-file buffers."
  (interactive)
  (with-current-buffer (or (buffer-base-buffer) (current-buffer))
    (when buffer-file-name
      (let* ((extension (file-name-extension buffer-file-name t))
             (suggestion (concat (file-name-sans-extension buffer-file-name)
                                 "_emacs_"
                                 (format-time-string "%Y%m%d_%H%M%S_%3N")
                                 extension))
             (destination (read-file-name "Save conflict as: "
                                          (file-name-directory suggestion)
                                          nil nil (file-name-nondirectory suggestion))))
        (write-file destination t)))))

(defun my-file-conflict--check-current ()
  "Recommend saving separately when the selected buffer conflicts with disk."
  (let ((selected (window-buffer (selected-window))))
    (when (and (not (active-minibuffer-window))
               (eq (current-buffer) (or (buffer-base-buffer selected) selected))
               buffer-file-name
               (buffer-modified-p)
               (not (file-remote-p buffer-file-name))
               (not (verify-visited-file-modtime (current-buffer))))
      (message "File changed on disk. Save your edits with M-x save-conflict-as."))))

;; Reuse both polling and file-notification dispatch; do not replace reload logic.
(advice-add 'auto-revert-handler :after #'my-file-conflict--check-current)
(global-auto-revert-mode 1)

(provide 'init-files)
;;; init-files.el ends here
