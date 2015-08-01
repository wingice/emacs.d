;;  ---  Font, Display and General Setttings   ---

(if (functionp 'tool-bar-mode) (tool-bar-mode 0)) ;; Do not display toolbar

(column-number-mode t)
(setq linum-format "%5d ")
(setq ediff-split-window-function 'split-window-horizontally)
(setq sgml-basic-offset 4)

;;disable splash screen and startup message
(setq inhibit-startup-message t) 
(setq initial-scratch-message nil)
(setq inhibit-splash-screen t)

(setq-default truncate-lines t)
(global-set-key [f12] 'toggle-truncate-lines)
(global-set-key [f5] 'revert-buffer)
(set-scroll-bar-mode 'right) 

(setq Buffer-menu-name-width 30)
(setq Buffer-menu-mode-width 12)

(set-background-color "#FFFFFB")

(add-hook 'shell-mode-hook 'compilation-shell-minor-mode)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'shell-mode-hook (lambda ()
                            (setq buffer-face-mode-face '(:height 120))
                            (buffer-face-mode)))

(defun remove-shell-wrong-sequences (string)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "\\[0G\\|\\]2;" nil t)
      (replace-match "\n"))
    (goto-char (point-min))
    ))

(add-hook 'comint-output-filter-functions 'remove-shell-wrong-sequences)

(provide 'init-display)
