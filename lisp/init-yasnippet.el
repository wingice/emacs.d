(setq yas-snippet-dirs (append yas-snippet-dirs
			       '("~/.emacs.d/conf_data/snippets")
			       ))

(yas-global-mode 1)
(add-hook 'term-mode-hook (lambda()
			    (setq yas-dont-activate t)))

(provide 'init-yasnippet)
