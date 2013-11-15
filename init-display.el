;;  ---  Font, Display and General Setttings   ---


(when (eq system-type 'gnu/linux)
  (set-default-font "-*-Courier 10 Pitch-normal-normal-normal-*-19-*-*-*-m-0-*-*"))

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
(global-set-key [F12] 'toggle-truncate-lines)
(set-scroll-bar-mode 'right) 

(provide 'init-display)
