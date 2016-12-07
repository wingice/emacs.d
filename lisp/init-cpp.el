(projectile-global-mode)

(setq projectile-known-projects-file
      (expand-file-name "projectile-bookmarks.eld" emacs-cache-dir))
(setq projectile-cache-file
      (expand-file-name "projectile.cache" emacs-cache-dir))
(provide 'init-cpp)
