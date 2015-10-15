(setq cedet-root-path (file-name-as-directory "~/.emacs.d/packages/cedet/"))
(when (file-exists-p cedet-root-path)
  (setq srecode-map-save-file (concat emacs-dir "tmp/srecode-map.el"))
  (load-file (concat cedet-root-path "cedet-devel-load.el"))
  (add-to-list 'load-path (concat cedet-root-path "contrib"))

  (setq ede-project-placeholder-cache-file (concat emacs-dir "tmp/ede-projects.el"))
  (setq semanticdb-default-save-directory 
	(expand-file-name "~/.emacs.d/tmp/semanticdb")) 

  ;; select which submodes we want to activate 
  (add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode) 
  (add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode) 
  (add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode) 
  (add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode) 
  (add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode) 

  (require 'eassist)
  (require 'semantic/ia)

  (setq-mode-local c-mode semanticdb-find-default-throttle
		   '(project unloaded system recursive))

  (defun alexott/cedet-hook () 
    (local-set-key [(control return)] 'semantic-ia-complete-symbol-menu) 
    ) 
  (add-hook 'c-mode-common-hook 'alexott/cedet-hook) 
  
  (defun alexott/c-mode-cedet-hook () 
    (local-set-key "\C-ct" 'eassist-switch-h-cpp) 
    (local-set-key "\C-xt" 'eassist-switch-h-cpp) 
    (local-set-key "\C-ce" 'eassist-list-methods) 
    (local-set-key "\C-c\C-r" 'semantic-symref) 
    ) 
  (add-hook 'c-mode-common-hook 'alexott/c-mode-cedet-hook) 

  (add-hook 'c-mode-hook '(lambda ()
			    (semantic-mode t)))

  (global-ede-mode t)
  (ede-enable-generic-projects)

  ;; SRecode 
  (global-srecode-minor-mode 0) 

  (global-set-key [f12] 'semantic-ia-fast-jump)  
  (global-set-key [S-f12] 'semantic-complete-jump)  
  (setq stack-trace-on-error t)

  (defadvice semantic-complete-jump-local (before push-mark-advice activate)
    "Before local tag jump remember current buffer position. Use `pop-tag-mark' to go back."
    (ring-insert find-tag-marker-ring (point-marker)))

  (defadvice semantic-complete-jump (before push-mark-advice activate)
    "Before global tag jump remember current buffer position. Use `pop-tag-mark' to go back."
    (ring-insert find-tag-marker-ring (point-marker)))

  (defadvice semantic-ia-fast-jump (before push-mark-advice activate)
    "Before global tag jump remember current buffer position. Use `pop-tag-mark' to go back."
    (ring-insert find-tag-marker-ring (point-marker)))
  (when (cedet-gnu-global-version-check t)
    (semanticdb-enable-gnu-global-databases 'c-mode)
    (semanticdb-enable-gnu-global-databases 'c++-mode))
  )

(defun my-c-mode-common-hook ()
  ;; my customizations for all of c-mode, c++-mode, objc-mode, java-mode
  (c-set-offset 'substatement-open 0)
  ;; other customizations can go here

  (setq c++-tab-always-indent t)
  (setq c-basic-offset 4)                  ;; Default is 2
  (setq c-indent-level 4)                  ;; Default is 2

  (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
  (setq tab-width 2)
  (setq indent-tabs-mode t)  ; use spaces only if nil
  )

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(add-hook 'gtags-mode-hook 
	  (lambda()
	    (local-set-key (kbd "M-.") 'gtags-find-tag)   ; find a tag, also M-.
	    (local-set-key (kbd "M-,") 'gtags-find-rtag)
	    (define-key gtags-mode-map "\M-*" nil)
	    )) 

(defadvice gtags-find-tag (before push-mark-advice activate)
  "Before global tag jump remember current buffer position. Use `pop-tag-mark' to go back."
  (ring-insert find-tag-marker-ring (point-marker)))


(add-hook 'c-mode-common-hook
	  (lambda ()
	    (require 'gtags)
	    (gtags-mode t)))

(projectile-global-mode)

(setq projectile-known-projects-file
      (expand-file-name "projectile-bookmarks.eld" emacs-cache-dir))
(setq projectile-cache-file
      (expand-file-name "projectile.cache" emacs-cache-dir))
(provide 'init-cpp)
