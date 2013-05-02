(add-to-list 'load-path "~/.emacs.d/packages/autocomplete/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
(setq ac-ignore-case 0)

;; to fix the conflict issue between yasnippet and auto-complete
(ac-set-trigger-key "TAB")

(provide 'init-auto-complete)
