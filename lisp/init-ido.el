(ido-mode t)
(ido-everywhere t)
;;(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)

;; Can use alt+s to retrigger the searching, this feature is very nice, :-)
;;(setq ido-auto-merge-work-directories-length 0)
(setq ido-use-virtual-buffers t)

;; Allow the same buffer to be open in different frames
(setq ido-default-buffer-method 'selected-window)
(setq ido-save-directory-list-file "~/.emacs.d/tmp/ido.last")

(flx-ido-mode 1)
(setq flx-ido-use-faces nil)
(setq recentf-save-file (expand-file-name "recentf" emacs-cache-dir))


(defun push-mark-no-activate ()
  "Pushes `point' to `mark-ring' and does not activate the region
   Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed mark to ring"))

(global-set-key (kbd "C-`") 'push-mark-no-activate)

(defun jump-to-mark ()
  "Jumps to the local mark, respecting the `mark-ring' order.
  This is the same as using \\[set-mark-command] with the prefix argument."
  (interactive)
  (set-mark-command 1))
(global-set-key (kbd "M-`") 'jump-to-mark)

(provide 'init-ido)
