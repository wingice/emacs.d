;;  Key Bindings
;;  M+d     -> Kill word
;;  M+b M+d ->Select whole word and kill word
;;


;;----------------------------------------------------------------------------
;; Which functionality to enable (use t or nil for true and false)
;;----------------------------------------------------------------------------
(defconst *is-a-mac* (eq system-type 'darwin))
(defconst *is-carbon-emacs* (eq window-system 'mac))
(defconst *is-cocoa-emacs* (and *is-a-mac* (eq window-system 'ns)))

;;----------------------------------------------------------------------------
;; Allow access from emacsclient
;;----------------------------------------------------------------------------
(require 'server)
(unless (server-running-p)
  (server-start))

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("melpa" . "http://melpa.org/packages/")))

(setq package-enable-at-startup nil)
(package-initialize)

;;----------------------------------------------------------------------------
;; Load configs for specific features and modes
;;----------------------------------------------------------------------------
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))
(require 'init-site-lisp)
(require 'init-ido)
(require 'init-display)
(require 'init-auto-complete)
(require 'init-rails)
(require 'init-misc)
(require 'init-yasnippet)
(require 'init-authoring)
(require 'init-locales)
(require 'init-cpp)
(require 'init-linux)
(require 'init-osx)
(require 'init-microsoft-os)
(require 'local-conf-tpl)



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-selection ((t (:background "dark green" :foreground "gray92"))))
 '(org-date ((t (:foreground "dim gray" :underline t))))
 '(org-special-keyword ((t (:inherit font-lock-keyword-face :foreground "dim gray"))))
 '(outline-3 ((t (:foreground "dark green"))))
 '(outline-4 ((t (:foreground "black")))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("41c8c11f649ba2832347fe16fe85cf66dafe5213ff4d659182e25378f9cfc183" "39ecc1e45ef87d610d0a8296701327010239ab70d2fc22d8e6254a30c80d497e" default))
 '(package-selected-packages
   '(helm jetbrains-darcula-theme inf-ruby robe goto-chg transpose-frame helm org-roam smart-jump yaml-mode chruby projectile-ripgrep markdown-mode nimbus-theme helm-projectile json-mode web-mode projectile yasnippet rinari flymake-ruby company flx-ido))
 '(projectile-project-root-files
   '("dune-project" "pubspec.yaml" "info.rkt" "Cargo.toml" "stack.yaml" "DESCRIPTION" "Eldev" "Cask" "shard.yml" "Gemfile" ".bloop" "deps.edn" "build.boot" "project.clj" "build.sc" "build.sbt" "application.properties" "gradlew" "build.gradle" "pom.xml" "poetry.lock" "Pipfile" "tox.ini" "setup.py" "requirements.txt" "manage.py" "angular.json" "package.json" "gulpfile.js" "Gruntfile.js" "mix.exs" "rebar.config" "composer.json" "CMakeLists.txt" "Makefile" "debian/control" "flake.nix" "default.nix" "meson.build" "SConstruct" "GTAGS" "TAGS" "configure.ac" "configure.in" "cscope.out"))
 '(projectile-require-project-root t))
