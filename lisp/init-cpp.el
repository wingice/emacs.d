(setq projectile-known-projects-file
      (expand-file-name "projectile-bookmarks.eld" emacs-cache-dir))
(setq projectile-cache-file
      (expand-file-name "projectile.cache" emacs-cache-dir))

;; ----------- Golang ----------------
(setq gofmt-command "goimports")
;;(require 'go-flymake)

(add-hook 'go-mode-hook (lambda ()
  (set (make-local-variable 'company-backends) '(company-go))
  (company-mode)
  (projectile-mode)
  (add-hook 'before-save-hook 'gofmt-before-save)  
  ))


(provide 'init-cpp)
