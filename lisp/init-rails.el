(require 'rhtml-mode)
(require 'rinari)

(setq rinari-tags-file-name "TAGS")
(global-rinari-mode)

;; All the rails related bindings
(global-set-key (kbd "C-c f f") 'rinari-find-file-in-project)
(global-set-key (kbd "C-c f m") 'rinari-find-model)
(global-set-key (kbd "C-c f v") 'rinari-find-view)
(global-set-key (kbd "C-c f c") 'rinari-find-controller)
(global-set-key (kbd "C-c f h") 'rinari-find-helper)
(global-set-key (kbd "C-c f i") 'rinari-find-migration)
(global-set-key (kbd "C-c f y") 'rinari-find-stylesheet)
(global-set-key (kbd "C-c f j") 'rinari-find-javascript)
(global-set-key (kbd "C-c f r") 'rinari-find-rspec)
(global-set-key (kbd "C-c f e") 'rinari-find-environment)
(global-set-key (kbd "C-c f l") 'rinari-find-plugin)
(global-set-key (kbd "C-c f n") 'rinari-find-configuration)
(global-set-key (kbd "C-c f o") 'rinari-find-log)
(global-set-key (kbd "C-c f p") 'rinari-find-public)
(global-set-key (kbd "C-c f s") 'rinari-find-script)
(global-set-key (kbd "C-c f w") 'rinari-find-worker)
(global-set-key (kbd "C-c f x") 'rinari-find-fixture)

(global-set-key [f6] 'rinari-rgrep)
(define-key ruby-mode-map [f9] 'update-rails-ctags)

(defun update-rails-ctags ()
  "Update rails project tags"
  (interactive)
  (let ((default-directory (or (rinari-root) default-directory)))
    (shell-command "ripper-tags -R -f TAGS")))

(provide 'init-rails)
