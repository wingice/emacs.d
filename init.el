;;  Key Bindings
;;  M+d     -> Kill word
;;  M+b M+d -> Select whole word and kill word
;;  M+\     -> Kill space

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
(require 'package)

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

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

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
