(use-package helm
  :config
  (require 'helm-config)
  (helm-mode 1)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (add-to-list 'helm-completing-read-handlers-alist '(find-file . ido)))

(defun li-create-file-in-dir(name)
  (interactive)
  (let* ((file (read-file-name "Create file: " default-directory name nil name nil))
	 (expanded (expand-file-name file)))
    (find-file expanded)))

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
  (with-eval-after-load 'helm-projectile
    (defvar helm-source-file-not-found
      (helm-build-dummy-source
         "Create file"
         :action (lambda (cand) (li-create-file-in-dir cand))))
    (add-to-list 'helm-projectile-sources-list helm-source-file-not-found t))
  
  (projectile-mode +1))

;; To improve the speed of ripgrep, .ignore or .rgignore file can be defined


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

(require 'smartparens-config)
(add-hook 'js-mode-hook #'smartparens-mode)

;; ---   javacript ---
(use-package js2-mode
  :ensure t
  :interpreter (("node" . js2-mode))
  :bind (:map js2-mode-map ("C-c C-p" . js2-print-json-path))
  :mode "\\.\\(js\\|jsonx\\)$"
  :config
  (add-hook 'js-mode-hook 'js2-minor-mode)
  (add-hook 'js2-mode-hook #'js2-imenu-extras-mode)
  (define-key js2-mode-map (kbd "C-k") #'js2r-kill)
  (setq js2-highlight-level 3
        js2-mode-show-parse-errors t
        js2-mode-show-strict-warnings nil))


(use-package js2-refactor
  :defer t
  :diminish js2-refactor-mode
  :commands js2-refactor-mode
  :ensure t
  :init
  (add-hook 'js2-mode-hook #'js2-refactor-mode)
  :config
  (js2r-add-keybindings-with-prefix "C-c C-r"))

(setq js2-skip-preprocessor-directives t)

(defun use-tab-width4()
  (interactive)
  (setq tab-width 4)
  (make-local-variable 'js-indent-level)
  (setq indent-tabs-mode nil)
  (setq js-indent-level 4))


(add-hook 'json-mode-hook 'use-tab-width4)
(add-hook 'js2-mode-hook 'use-tab-width4)
(add-hook 'javascript-mode-hook 'use-tab-width4)

(require 'p4) ;; C+x p e -> edit the file
;;export P4PORT=perforce3230:3230   set ENV in .bashrc
;;export P4CLIENT=pcode3230


(provide 'init-cpp)
