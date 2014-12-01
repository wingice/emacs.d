;; Markdown mode
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(add-hook 'markdown-mode-hook (lambda () (visual-line-mode)))

;; OrgMode
(define-key global-map "\C-cr" 'org-remember)
(add-to-list 'auto-mode-alist '("\\.\\(org\\ |org_archive\\|txt\\)$" . org-mode))
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)

(add-hook 'org-mode-hook
	  (lambda()
	    (add-hook 'before-save-hook 'org-agenda-to-appt t t)
	    ))

(setq org-clock-into-drawer 1)
(setq system-time-locale "C")



(provide 'init-authoring)
