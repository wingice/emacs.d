(add-to-list 'load-path "~/.emacs.d/packages/autocomplete/lib/popup")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/conf_data/ac-dict")
(ac-config-default)
(setq ac-ignore-case 0)

(setq ac-comphist-file (concat emacs-cache-dir "auto-complete.dat"))
(define-key ac-complete-mode-map (kbd "C-c") 'ac-stop)
(define-key ac-complete-mode-map (kbd "ESC") 'ac-stop)
(define-key ac-complete-mode-map (kbd "TAB") 'ac-complete)

(defadvice ac-common-setup (after give-yasnippet-highest-priority activate)
  (setq ac-sources (delq 'ac-source-yasnippet ac-sources))
  (add-to-list 'ac-sources 'ac-source-yasnippet))


(provide 'init-auto-complete)
