;;  ---  Font, Display and General Setttings   ---
(set-default-font "-*-Courier 10 Pitch-normal-normal-normal-*-17-*-*-*-m-0-*-*") 
(if (functionp 'tool-bar-mode) (tool-bar-mode 0)) ;; Do not display toolbar

(column-number-mode t)
(setq linum-format "%5d ")
(setq ediff-split-window-function 'split-window-horizontally)
(setq sgml-basic-offset 4)

;;disable splash screen and startup message
(setq inhibit-startup-message t) 
(setq initial-scratch-message nil)
(setq inhibit-splash-screen t)

(provide 'init-fonts)
