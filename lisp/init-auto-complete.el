;;; init-auto-complete.el --- Auto-completion config  -*- lexical-binding: t; -*-

(use-package company
  :ensure t
  :hook (after-init . global-company-mode))

(provide 'init-auto-complete)
