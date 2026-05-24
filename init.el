;;  Key Bindings
;;  M+d     -> Kill word
;;  M+b M+d -> Select whole word and kill word
;;  M+\     -> Kill space
;;  (force-writable)  -> to make the file writable

;;----------------------------------------------------------------------------
;; Which functionality to enable (use t or nil for true and false)
;;----------------------------------------------------------------------------
(defconst *is-a-mac* (eq system-type 'darwin))

;;----------------------------------------------------------------------------
;; Allow access from emacsclient
;;----------------------------------------------------------------------------
(require 'server)
(require 'package)

(setq package-quickstart t)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

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
(require 'init-media)
(require 'init-misc)
(require 'init-yasnippet)
(require 'init-osx)
(require 'init-authoring)
(require 'init-locales)
(require 'init-cpp)
(require 'init-linux)
(require 'init-microsoft-os)
(require 'local-conf-tpl)
