(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/conf_data/snippets"
	"~/.emacs.d/packages/yasnippet/snippets"))

(yas-global-mode 1)
(add-hook 'term-mode-hook (lambda()
			    (setq yas-dont-activate t)))

(provide 'init-yasnippet)
