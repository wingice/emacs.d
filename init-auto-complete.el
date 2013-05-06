(add-to-list 'load-path "~/.emacs.d/packages/autocomplete/lib/popup")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/conf_data/ac-dict")
(ac-config-default)
(setq ac-ignore-case 0)

;; to fix the conflict issue between yasnippet and auto-complete
(ac-set-trigger-key "TAB")

(setq ac-comphist-file (concat emacs-cache-dir "auto-complete.dat"))
(define-key ac-complete-mode-map [tab] 'ac-expand)


(provide 'init-auto-complete)
