;;; Set load path

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

(add-subdirs-to-load-path "~/.emacs.d/packages/")

(provide 'init-site-lisp)
