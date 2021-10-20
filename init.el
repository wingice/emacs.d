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

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(setq package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-verbose t)

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
   '(fd-dired projectile helm jetbrains-darcula-theme inf-ruby robe goto-chg transpose-frame helm org-roam smart-jump yaml-mode chruby projectile-ripgrep markdown-mode nimbus-theme helm-projectile json-mode web-mode yasnippet rinari flymake-ruby company flx-ido)))
