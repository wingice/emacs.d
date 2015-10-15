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

(provide 'init-ido)
