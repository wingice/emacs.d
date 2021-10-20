(use-package helm
  :config
  (require 'helm-config)
  (helm-mode 1))


(use-package projectile
  :ensure
  :config
  (setq projectile-known-projects-file
      (expand-file-name "projectile-bookmarks.eld" emacs-cache-dir))
  (setq projectile-cache-file
      (expand-file-name "projectile.cache" emacs-cache-dir))
  (setq projectile-mode-line nil)
  (setq projectile-indexing-method 'alien)
  (setq projectile-require-project-root t)
  (add-to-list 'projectile-globally-ignored-directories "node_modules")
  (setq projectile-generic-command "fd . -0")
  (setq projectile-ignored-projects '("~/" "c://windows" "c://"))
  (setq projectile-project-root-files
   '("dune-project" "pubspec.yaml" "info.rkt" "Cargo.toml" "stack.yaml" "DESCRIPTION" "Eldev" "Cask" "shard.yml" "Gemfile" ".bloop" "deps.edn" "build.boot" "project.clj" "build.sc" "build.sbt" "application.properties" "gradlew" "build.gradle" "pom.xml" "poetry.lock" "Pipfile" "tox.ini" "setup.py" "requirements.txt" "manage.py" "angular.json" "package.json" "gulpfile.js" "Gruntfile.js" "mix.exs" "rebar.config" "composer.json" "CMakeLists.txt" "Makefile" "debian/control" "flake.nix" "default.nix" "meson.build" "SConstruct" "GTAGS" "TAGS" "configure.ac" "configure.in" "cscope.out"))
  (projectile-mode +1))

;; ----------- Golang ----------------
(setq gofmt-command "goimports")
;;(require 'go-flymake)

(add-hook 'go-mode-hook (lambda ()
  (set (make-local-variable 'company-backends) '(company-go))
  (company-mode)
  (projectile-mode)
  (add-hook 'before-save-hook 'gofmt-before-save)
  ))


(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

(add-hook 'typescript-mode-hook
	  '(lambda ()
	     (define-key typescript-mode-map (kbd "s-.") 'tide-fix)))

(provide 'init-cpp)
