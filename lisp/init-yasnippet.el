(setq yas-snippet-dirs '("~/.emacs.d/conf_data/snippets" yas-installed-snippets-dir))      

(yas-global-mode 1)
(add-hook 'term-mode-hook (lambda()
			    (setq yas-dont-activate t)))

(provide 'init-yasnippet)
