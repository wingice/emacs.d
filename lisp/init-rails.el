;;; init-rails.el --- Rails and web development  -*- lexical-binding: t; -*-

(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(defun my-web-mode-hook ()
  (set-face-attribute 'web-mode-symbol-face nil :foreground "darkgreen")
  (set-face-attribute 'web-mode-html-attr-value-face nil :foreground "darkgreen"))
(add-hook 'web-mode-hook  'my-web-mode-hook)

(advice-add 'inf-ruby-console-auto :before #'chruby-use-corresponding)


(projectile-rails-global-mode)
(define-key projectile-rails-mode-map (kbd "C-c f") 'projectile-rails-command-map)
(setq projectile-rails-add-keywords nil)
(define-key projectile-rails-mode-map (kbd "C-c f m")   'projectile-rails-find-current-model)
(define-key projectile-rails-mode-map (kbd "C-c f M")   'projectile-rails-find-model)
(define-key projectile-rails-mode-map (kbd "C-c f c")   'projectile-rails-find-current-controller)
(define-key projectile-rails-mode-map (kbd "C-c f C")   'projectile-rails-find-controller)
(define-key projectile-rails-mode-map (kbd "C-c f v")   'projectile-rails-find-current-view)
(define-key projectile-rails-mode-map (kbd "C-c f V")   'projectile-rails-find-view)
(define-key projectile-rails-mode-map (kbd "C-c f m")   'projectile-rails-find-current-model)
(define-key projectile-rails-mode-map (kbd "C-c f M")   'projectile-rails-find-model)
(define-key projectile-rails-mode-map (kbd "C-c f f")   'projectile-rails-goto-file-at-point)


(defun consult-ripgrep-at-point ()
  "Ripgrep the current word from a specified directory."
  (interactive)
  (let* ((default-directory (or (projectile-project-root) default-directory))
         (thing (thing-at-point 'word)))
    (consult-ripgrep default-directory thing)))


(global-set-key [f6] 'consult-ripgrep-at-point)
;;(define-key ruby-mode-map [f9] 'update-rails-ctags)

(defun update-rails-ctags ()
  "Update rails project tags"
  (interactive)
  (let ((default-directory (or (rinari-root) default-directory)))
    (shell-command "ripper-tags -R -e -f TAGS")))


(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook
	  #'(lambda ()
	     (define-key yaml-mode-map "\C-m" 'newline-and-indent)))


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

;; Disable VC integration to avoid git slowdowns
(setq vc-handled-backends nil)

(require 'chruby)

(provide 'init-rails)
