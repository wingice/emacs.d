(add-to-list 'load-path "~/.emacs.d/packages/yasnippet/")
(require 'yasnippet)
(yas-global-mode 1)
(setq yas-snippet-dirs
      '("~/.emacs.d/data/snippets"
	"~/.emacs.d/packages/yasnippet/snippets"))

(provide 'init-yasnippet)
