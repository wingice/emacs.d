(autoload 'gtags-mode "gtags-mode" "Loading GNU Global")
(require 'gtags)

(setq srecode-map-save-file (concat emacs-dir "tmp/srecode-map.el"))

(load-file "~/.emacs.d/packages/cedet-bzr/cedet-devel-load.el")

(setq ede-project-placeholder-cache-file (concat emacs-dir "tmp/ede-projects.el"))
(setq semanticdb-default-save-directory 
     (expand-file-name "~/.emacs.d/tmp/semanticdb")) 

(semantic-mode 1)
(global-ede-mode t)

(require 'semantic/ia)
(setq-mode-local c-mode semanticdb-find-default-throttle
                 '(project unloaded system recursive))



(global-set-key [f12] 'semantic-ia-fast-jump)  
(global-set-key [S-f12]  
                (lambda ()  
                  (interactive)  
                  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))  
                      (error "Semantic Bookmark ring is currently empty"))  
                  (let* ((ring (oref semantic-mru-bookmark-ring ring))  
                         (alist (semantic-mrub-ring-to-assoc-list ring))  
                         (first (cdr (car alist))))  
                    (if (semantic-equivalent-tag-p (oref first tag)  
                                                   (semantic-current-tag))  
                        (setq first (cdr (car (cdr alist)))))  
                    (semantic-mrub-switch-tags first))))  

(setq stack-trace-on-error t)

(defun my-c-mode-common-hook ()
 ;; my customizations for all of c-mode, c++-mode, objc-mode, java-mode
 (c-set-offset 'substatement-open 0)
 ;; other customizations can go here

 (setq c++-tab-always-indent t)
 (setq c-basic-offset 4)                  ;; Default is 2
 (setq c-indent-level 4)                  ;; Default is 2

 (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
 (setq tab-width 4)
 (setq indent-tabs-mode t)  ; use spaces only if nil
 )

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; if you want to enable support for gnu global
(when (cedet-gnu-global-version-check t)
  (semanticdb-enable-gnu-global-databases 'c-mode)
  (semanticdb-enable-gnu-global-databases 'c++-mode))


(add-hook 'gtags-mode-hook 
  (lambda()
    (local-set-key (kbd "M-.") 'gtags-find-tag)   ; find a tag, also M-.
    (local-set-key (kbd "M-,") 'gtags-find-rtag)))  ; reverse tag

(add-hook 'c-mode-common-hook
  (lambda ()
    (require 'gtags)
    (gtags-mode t)))

(projectile-global-mode)

(setq projectile-known-projects-file
       (expand-file-name "projectile-bookmarks.eld" (concat emacs-dir "tmp")))

(provide 'init-cpp)
