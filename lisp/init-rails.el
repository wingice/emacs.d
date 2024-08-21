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

;; All the rails related bindings
(global-set-key (kbd "C-c f f") 'rinari-find-file-in-project)
(global-set-key (kbd "C-c f m") 'rinari-find-model)
(global-set-key (kbd "C-c f v") 'rinari-find-view)
(global-set-key (kbd "C-c f c") 'rinari-find-controller)
;; (global-set-key (kbd "C-c f h") 'rinari-find-helper)
;; (global-set-key (kbd "C-c f i") 'rinari-find-migration)
;; (global-set-key (kbd "C-c f y") 'rinari-find-stylesheet)
;; (global-set-key (kbd "C-c f j") 'rinari-find-javascript)
(global-set-key (kbd "C-c f r") 'rinari-find-rspec)
;; (global-set-key (kbd "C-c f e") 'rinari-find-environment)
;; (global-set-key (kbd "C-c f l") 'rinari-find-plugin)
;; (global-set-key (kbd "C-c f n") 'rinari-find-configuration)
;; (global-set-key (kbd "C-c f o") 'rinari-find-log)
;; (global-set-key (kbd "C-c f p") 'rinari-find-public)
;; (global-set-key (kbd "C-c f s") 'rinari-find-script)
;; (global-set-key (kbd "C-c f w") 'rinari-find-worker)
;; (global-set-key (kbd "C-c f x") 'rinari-find-fixture)

(global-set-key [f6] 'projectile-ripgrep)
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

;; customize rianri to skip not wanted files when find-file-in-project
(setq findr-skip-directory-regexp "^\\.backups$\\|^_darcs$\\|/\\.git$\\|^CVS$\\|^\\.svn$\\|/node_modules$\\|/tmp$")

(setq findr-skip-file-regexp "^[#\\.]\\|\\.cache$")

(setq rinari-tags-file-name "TAGS")
(global-rinari-mode)

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
