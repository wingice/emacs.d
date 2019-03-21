(yas-global-mode 1)
(setq yas-snippet-dirs (cons "~/.emacs.d/conf_data/snippets" yas-snippet-dirs))
(setq yas-prompt-functions '(yas-x-prompt yas-dropdown-prompt))

(add-hook 'term-mode-hook (lambda()
			    (setq yas-dont-activate t)))

(provide 'init-yasnippet)
