;;  ---  Font, Display and General Setttings   ---

(if (functionp 'tool-bar-mode) (tool-bar-mode 0)) ;; Do not display toolbar

(column-number-mode t)
(setq linum-format "%5d ")
(setq sgml-basic-offset 4)

;;disable splash screen and startup message
(setq inhibit-startup-message t) 
(setq initial-scratch-message nil)
(setq inhibit-splash-screen t)

(setq-default truncate-lines t)
(global-set-key [f12] 'toggle-truncate-lines)
(global-set-key [f5] 'revert-buffer)
(set-scroll-bar-mode 'right) 
(setq auto-revert-interval 0.5)

(setq Buffer-menu-name-width 30)
(setq Buffer-menu-mode-width 12)

(set-background-color "#FFFFFB")

(add-hook 'shell-mode-hook 'compilation-shell-minor-mode)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'shell-mode-hook (lambda ()
                            (setq buffer-face-mode-face '(:height 96))
                            (buffer-face-mode)))

(defun remove-shell-wrong-sequences (string)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "\\[0G\\|\\]2;" nil t)
      (replace-match "\n"))
    (goto-char (point-min))
    ))

(add-hook 'comint-output-filter-functions 'remove-shell-wrong-sequences)

(defun toggle-fold ()
  (interactive)
  (save-excursion
    (end-of-line)
    (hs-toggle-hiding)))

(global-set-key (kbd "C-M-=") 'hs-toggle-hiding)
(add-hook 'prog-mode-hook 'hs-minor-mode)

(setq ediff-diff-options "-w")
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(defvar after-load-theme-hook nil
    "Hook run after a color theme is loaded using `load-theme'.")
(defadvice load-theme (after run-after-load-theme-hook activate)
  "Run `after-load-theme-hook'."
  (run-hooks 'after-load-theme-hook))

(defun set-helm-hl-color()
  (set-face-background 'helm-selection "#336622"))

;;(add-hook 'after-load-theme-hook 'set-helm-hl-color)

;; (when (require 'so-long nil :noerror)
;;    (global-so-long-mode 1)
;;    (add-hook 'compilation-mode-hook 'so-long-minor-mode)
;;    )

(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (ansi-color-apply-on-region compilation-filter-start (point-max)))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

(provide 'init-display)
