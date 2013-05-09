(ido-mode t)
(ido-everywhere t)
;;(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point nil)

;; Can use alt+s to retrigger the searching, this feature is very nice, :-)
;;(setq ido-auto-merge-work-directories-length 0)
(setq ido-use-virtual-buffers t)

;; Allow the same buffer to be open in different frames
(setq ido-default-buffer-method 'selected-window)
(setq ido-save-directory-list-file "~/.emacs.d/tmp/ido.last")

(provide 'init-ido)
