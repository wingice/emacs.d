;;; init-auto-complete.el --- Auto-completion config  -*- lexical-binding: t; -*-

(use-package completion-preview
  :ensure nil
  :custom
  (completion-preview-idle-delay 0.2)
  :bind (:map completion-preview-active-mode-map
              ("M-n" . completion-preview-next-candidate)
              ("M-p" . completion-preview-prev-candidate))
  :hook (after-init . global-completion-preview-mode))

(provide 'init-auto-complete)
