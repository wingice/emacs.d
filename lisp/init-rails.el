(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(defun my-web-mode-hook ()
  (set-face-attribute 'web-mode-symbol-face nil :foreground "darkgreen")
  (set-face-attribute 'web-mode-html-attr-value-face nil :foreground "darkgreen"))
(add-hook 'web-mode-hook  'my-web-mode-hook)

(advice-add 'inf-ruby-console-auto :before #'chruby-use-corresponding)

;;(add-hook 'ruby-mode-hook 'robe-mode)   ;; disable robe temporarily
;; (eval-after-load 'company
;;   '(progn
;;     (push 'company-robe company-backends)))

(projectile-rails-global-mode)
(define-key projectile-rails-mode-map (kbd "C-c f") 'projectile-rails-command-map)
(setq projectile-rails-add-keywords nil)

(global-set-key [f6] 'consult-ripgrep)
;;(define-key ruby-mode-map [f9] 'update-rails-ctags)

(defun update-rails-ctags ()
  "Update rails project tags"
  (interactive)
  (let ((default-directory (or (rinari-root) default-directory)))
    (shell-command "ripper-tags -R -e -f TAGS")))


;;(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook
	  #'(lambda ()
	     (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;;(require 'flymake-ruby)
;;(add-hook 'ruby-mode-hook 'flymake-ruby-load)


(require 'hideshow)
(require 'sgml-mode)
(require 'nxml-mode)

(setq nxml-child-indent 4 nxml-attribute-indent 4)

(add-to-list 'hs-special-modes-alist
             '(nxml-mode
               "<!--\\|<[^/>]*[^/]>"
               "-->\\|</[^/>]*[^/]>"

               "<!--"
               sgml-skip-tag-forward
               nil))

(add-hook 'nxml-mode-hook 'hs-minor-mode)

;; optional key bindings, easier than hs defaults
(global-set-key (kbd "<C-tab>") 'hs-toggle-hiding)

(smart-jump-setup-default-registers)

;;Temorpary fix the git slow-down emacs problem
(setq vc-handled-backends nil)

(require 'chruby)

(provide 'init-rails)
